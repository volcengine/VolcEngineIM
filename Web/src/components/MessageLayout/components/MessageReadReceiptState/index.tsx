import React, { FC, memo, useEffect, useRef } from 'react';
import classNames from 'classnames';

import { Time } from '../../..';

import styles from './index.module.scss';
import { useInViewport, useRequest, useUpdateEffect } from 'ahooks';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation, ReadReceiptVersion } from '../../../../store';
import { MessageItemType } from '../../../../types';
import { debounce, groupBy } from 'lodash';
import { Message, BytedIM, MessageReadReceipt, Conversation, im_proto } from '@volcengine/im-web-sdk';
import Long from 'long';
import { Trigger } from '@arco-design/web-react';
import Col from '@arco-design/web-react/es/Grid/col';
import Row from '@arco-design/web-react/es/Grid/row';
import { useAccountsInfo } from '../../../../hooks';

interface MessageReadReceiptStateProps {
  className?: string;
  message: MessageItemType;
}

type QueueItem<T> = { message: Message; resolve: Function; promise: Promise<T> };

export abstract class AbstractMessageReadBatchQuery<T extends { messageId: string }> {
  queue: QueueItem<T>[] = [];
  bytedIMInstance: BytedIM;
  request = debounce(() => {
    this._request();
  }, 300);

  cached: { [key: string]: T } = {};

  abstract callApi({ conversation, messages }: { conversation: Conversation; messages: Message[] }): Promise<T[]>;

  async _request() {
    // request 50 element in queue each request
    let tQueue = this.queue;
    this.queue = [];

    for (let [convId, currentQueue] of Object.entries(groupBy(tQueue, 'message.conversationId'))) {
      const conversation = this.bytedIMInstance.getConversation({ conversationId: convId });
      while (currentQueue.length) {
        const queue = currentQueue.splice(0, 50);
        const resp = await this.callApi({
          messages: queue.map(i => i.message),
          conversation,
        });
        for (let data of resp) {
          queue.filter(i => data.messageId === i.message.serverId)?.forEach(({ resolve }) => resolve(data));
        }
      }
    }
  }

  async get({ bytedIMInstance, message }) {
    if (this.bytedIMInstance !== bytedIMInstance) {
      this.bytedIMInstance = bytedIMInstance;
    }

    if (this.cached[message.serverId]) {
      return this.cached[message.serverId];
    }

    let find = this.queue.find(i => i.message.serverId === message.serverId);
    if (find) {
      return find.promise;
    }

    let obj = {} as QueueItem<T>;

    const promise: Promise<T> = new Promise(resolve => {
      obj.message = message;
      obj.resolve = resolve;
      this.queue.push(obj);
    });
    obj.promise = promise;

    void this.request();

    return promise;
  }
}

class MessageReadBatchQuery extends AbstractMessageReadBatchQuery<MessageReadReceipt> {
  async callApi({ conversation, messages }: { conversation: Conversation; messages: Message[] }) {
    const resp = await this.bytedIMInstance.getMessagesReadReceiptOnline({
      conversation: conversation,
      messages: messages,
    });
    for (let data of resp) {
      if (data.isRead) {
        this.cached[data.messageId] = data;
      }
    }
    return resp;
  }
}

const messageReadQuery = new MessageReadBatchQuery();

const prefixCls = 'im-message-read-status';
const MessageReadReceiptState: FC<MessageReadReceiptStateProps> = props => {
  const { className, message } = props;
  const wrapClass = classNames(prefixCls, className);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const messageItemRef = useRef();
  const [isInview] = useInViewport(messageItemRef, { threshold: 0.7 });
  const triggered = useRef(false);
  const version = useRecoilValue(ReadReceiptVersion); // 用于触发未读回执回调刷新

  const { data, run, loading } = useRequest(
    async () => {
      return await messageReadQuery.get({
        bytedIMInstance,
        message: message,
      });
    },
    { manual: true, cacheKey: `msg-read-${message.serverId}` }
  );

  useEffect(() => {
    if (isInview && !triggered.current) {
      triggered.current = true;
      run();
    }
  }, [isInview]);

  useUpdateEffect(() => {
    run();
  }, [version]);

  const getContent = () => {
    if (currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
      return typeof data?.isRead === 'boolean' ? (data?.isRead ? '已读' : '未读') : '';
    } else {
      let readCount = data?.readUids?.length;
      let unreadCount = data?.unreadUids?.length;
      if (typeof readCount === 'number' && typeof unreadCount === 'number')
        return (
          <Trigger
            popup={() => <ReadUserListPopup readUids={data?.readUids} unreadUids={data?.unreadUids} />}
            trigger="click"
            position="bottom"
            classNames="zoomInTop"
          >
            {`[${readCount}/${unreadCount}]`}
          </Trigger>
        );
    }
  };

  return (
    <div className={wrapClass} ref={messageItemRef} key={'read-receipt'}>
      {getContent()}
    </div>
  );
};

function ReadUserListPopup({ readUids, unreadUids }: { readUids: string[]; unreadUids: string[] }) {
  const ACCOUNTS_INFO = useAccountsInfo();

  return (
    <div className={styles.triggerPopup} style={{ width: 300, height: 150 }}>
      <Row style={{ height: '100%' }}>
        <Col
          span={12}
          className={styles.uidListCol}
          style={{ paddingRight: '10px', borderRight: '1px solid #f0f0f0', height: '100%' }}
        >
          <div className={styles.uidListTitle}>{readUids.length} 已读</div>
          {readUids.map(i => (
            <div className={styles.user} key={i}>
              {ACCOUNTS_INFO[i]?.name}
            </div>
          ))}
        </Col>
        <Col span={12} className={styles.uidListCol} style={{ height: '100%', paddingLeft: '10px' }}>
          <div className={styles.uidListTitle}>{unreadUids.length} 未读</div>
          {unreadUids.map(i => (
            <div className={styles.user} key={i}>
              {ACCOUNTS_INFO[i]?.name}
            </div>
          ))}
        </Col>
      </Row>
    </div>
  );
}

export default memo(MessageReadReceiptState);
