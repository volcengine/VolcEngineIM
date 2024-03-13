import React, { FC, memo, useEffect, useRef } from 'react';
import classNames from 'classnames';

import { Time } from '../../..';

import MessageReadReceiptStateBox from './Styles';
import { useInViewport, useRequest, useUpdateEffect } from 'ahooks';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation, ReadReceiptVersion } from '../../../../store';
import { MessageItemType } from '../../../../types';
import { debounce, groupBy } from 'lodash';
import { Message, BytedIM, MessageReadReceipt, Conversation } from '@volcengine/im-web-sdk';

interface MessageReadReceiptStateProps {
  className?: string;
  message: MessageItemType;
}

type QueueItem = { message: Message; resolve: Function; promise: Promise<any> };

export class MessageReadBatchQuery {
  queue: QueueItem[] = [];
  bytedIMInstance: BytedIM;
  request = debounce(() => {
    this._request();
  }, 300);

  cached: { [key: string]: any } = {};

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

    let obj = {} as QueueItem;

    const promise: Promise<MessageReadReceipt> = new Promise(resolve => {
      obj.message = message;
      obj.resolve = resolve;
      this.queue.push(obj);
    });
    obj.promise = promise;

    void this.request();

    return promise;
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
  const version = useRecoilValue(ReadReceiptVersion);

  const { data, run, loading } = useRequest(
    async () => {
      const r = await messageReadQuery.get({
        bytedIMInstance,
        message: message,
      });
      return r;
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

  return (
    <MessageReadReceiptStateBox className={wrapClass} ref={messageItemRef} key={'read-receipt'}>
      {typeof data?.isRead === 'boolean' ? (data?.isRead ? '已读' : '未读') : ''}
    </MessageReadReceiptStateBox>
  );
};

export default memo(MessageReadReceiptState);
