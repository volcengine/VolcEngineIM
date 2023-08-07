import React, { useRef, useEffect, forwardRef, useImperativeHandle, useCallback, useState } from 'react';
import classNames from 'classnames';
import { useRecoilState } from 'recoil';
import { Message } from '@volcengine/im-web-sdk';
import BScroll from '@better-scroll/core';
import { useDebounceFn, useThrottleFn } from 'ahooks';

import { ScrollRef } from '../../../../store';
import { useScroll, useUpdate } from '../../../../hooks';
import { ACCOUNTS_INFO } from '../../../../constant';
import { isSystemMsgType } from '../../../../utils';

import { IconLoading } from '../../../../components/Icon';
import { ScrollView } from '../../../../components';
import { BsInstance } from '../../../../components/ScrollView/interface';
import { SystemMessage } from '../../../../components/MessageCards';
import { MessageSystem } from '../../../../components/MessageLayout/components';
import MessageLayout from '../MessageLayout';

import ListBox from './Styles';

export interface IScrollViewRef {
  instance?: BScroll;
  isInBottomCurrent(): boolean;
  scrollToBottom(): void;
}

export interface RefType {
  scrollToBottomOrPosition: () => void;
  refresh: () => void;
}

export interface MessageListProps<T> {
  id?: string;
  className?: string;
  style?: React.CSSProperties;

  listClassName?: string;
  containerClassName?: string;
  scrollDistance?: number;
  scrollThreshold?: number;
  overscanRowCount?: number;
  onAvatarClick?: (isFromMe: boolean) => void;
  // markMessageRead?: (msg: Message, index?: number | undefined) => void;
  recallMessage?: (msg: Message) => void;
  deleteMessage?: (msg: Message) => void;
  replyMessage?: (msg: Message) => void;
  modifyProperty?: (msg: Message, key: string, value: string) => void;
  resendMessage?: (msg: Message) => Message;
  triggerBottom?: (isShow: boolean) => void;
  // loadMore: () => Promise<any>;
  // checkMoreMessage?: () => Promise<any>;
  renderItem: (item: T, index: number) => React.ReactNode;
  children?: React.ReactNode;
  dataSource?: T[];
  readIndex?: string;
  unReadCount?: number;
  [key: string]: any;
}

interface IPosition {
  x: number;
  y: number;
}

const prefixCls = 'im-message';

const MessageList = (props: MessageListProps<any>, ref: any) => {
  const {
    id,
    dataSource = [],
    className,
    scrollThreshold = 100,
    scrollDistance = 100,
    renderItem,
    triggerBottom,
    children,
    recallMessage,
    deleteMessage,
    replyMessage,
    resendMessage,
    modifyProperty,
    readIndex,
    unReadCount,
    ...restProps
  } = props;

  const scrollRef = useRef<IScrollViewRef>(null);
  const isBottomOfPageRef = useRef<boolean>(false);
  const [loading, setLoading] = useState(false);
  const bottomRef = useRef(0);
  const [listRef, setListRef] = useRecoilState(ScrollRef);
  const { onScroll, showBackBottomBtn, autoScrollToBottom, handleScrollToBottom } = useScroll(scrollRef);

  const _getPositionY = useCallback((position: IPosition, bScroll: BsInstance) => {
    const maxScrollY = bScroll?.maxScrollY;
    const positionY = position?.y;

    if (maxScrollY == positionY) {
      isBottomOfPageRef.current = true;
    } else {
      isBottomOfPageRef.current = false;
    }
  }, []);

  const handleBottomRef = useCallback(() => {
    if (scrollRef.current?.instance) {
      bottomRef.current = scrollRef.current?.instance?.maxScrollY - scrollRef.current?.instance.y;
    }
  }, [scrollRef.current]);

  const { run: getPositionY } = useThrottleFn(_getPositionY, {
    wait: 200,
  });

  const handleRefresh = useCallback(() => {
    scrollRef.current?.instance?.refresh();
  }, []);

  const _handleRefreshed = useCallback(() => {
    // 是否在滚动动画中
    if (scrollRef.current?.instance?.pending) {
      return;
    }

    if (isBottomOfPageRef.current) {
      handleScrollToBottom();
      return;
    }

    scrollRef.current?.instance?.scrollTo(0, scrollRef.current?.instance?.maxScrollY - bottomRef.current);
  }, [handleScrollToBottom]);

  const { run: handleRefreshed } = useDebounceFn(_handleRefreshed, {
    wait: 200,
  });

  useEffect(() => {
    scrollRef?.current?.instance?.on('refresh', () => handleRefreshed());

    return () => {
      scrollRef?.current?.instance?.off('refresh');
    };
  }, [scrollRef.current, handleRefreshed]);

  // 拿到所有可见的消息
  const visibleDataSource = dataSource as Message[];
  const lastMessage = visibleDataSource.slice().pop();

  useEffect(() => {
    setListRef(scrollRef);
  }, []);

  useEffect(() => {
    if (dataSource.length) {
      if (unReadCount) {
        const div = document.createElement('div');
        div.id = 'new_message';
        div.innerText = '新消息';
        div.className = 'new-message-notice';
        let message;
        // 新会话没有readIndex, 为0
        if (readIndex !== '0') {
          const arrayIndex = dataSource.findIndex(item => item.indexInConversation.toString() === readIndex);
          let insertIndex = arrayIndex + 1;
          for (let i = arrayIndex + 1; i < dataSource.length; i++) {
            if (!dataSource[i].isFromMe) {
              insertIndex = i;
              break;
            }
          }

          message = document.querySelector(`#index${dataSource[insertIndex].indexInConversation.toString()}`);
          if (message) {
          }
        } else {
          let firstNotMeMessage;
          for (let i = 0; i < dataSource.length; i++) {
            if (dataSource[i]?.isFromMe) {
              continue;
            } else {
              firstNotMeMessage = dataSource[i];
              break;
            }
          }
          message = document.querySelector(`#index${firstNotMeMessage?.indexInConversation?.toString()}`);
        }
        const list = document.querySelector('.message-wrap');
        if (message) {
          list.insertBefore(div, message);
          scrollRef.current.instance.scrollToElement(div, 0, 0, -30);
        }
      } else {
        handleScrollToBottom();
      }
    }

    return () => {
      const div = document.querySelector('#new_message');
      const list = document.querySelector('.message-wrap');
      if (div) {
        list.removeChild(div);
      }
    };
  }, [lastMessage?.conversationId]);

  useImperativeHandle(
    ref,
    () => {
      return {
        scrollToBottom: handleScrollToBottom,
        refresh: handleRefresh,
      };
    },
    [scrollRef.current, handleScrollToBottom, handleRefresh]
  );

  return (
    <ListBox className={classNames(`${prefixCls}-list`, className)} key={id} {...restProps}>
      <ScrollView
        ref={scrollRef}
        scrollY
        onScroll={(position: IPosition, bScroll: BsInstance) => {
          handleBottomRef();
          getPositionY(position, bScroll);
          onScroll(position, bScroll);
        }}
        mouseWheel={true}
        bounce={false}
        style={{
          height: '100%',
          flex: '1',
        }}
      >
        <div className="message-wrap">
          {loading && dataSource.length > 0 && (
            <div className={`${prefixCls}-loader`}>
              <div className={`${prefixCls}-loader-spin`}>
                <IconLoading />
              </div>
            </div>
          )}
          {dataSource.map((messageItem: Message, index: number) => {
            const { ext = {}, sender } = messageItem || {};
            const messageId = ext['s:client_message_id'] || '';

            if (messageItem.type === 1999) {
              return <SystemMessage message={messageItem} />;
            }

            if (isSystemMsgType(messageItem)) {
              return <MessageSystem key={messageId} message={messageItem} index={index} />;
            }

            return (
              <MessageLayout
                key={String(messageId) + JSON.stringify(ext)}
                message={messageItem}
                index={index}
                isLast={dataSource.length - 1 === index}
                sender={sender}
                avatarUrl={ACCOUNTS_INFO[sender]?.url}
                deleteMessage={deleteMessage}
                recallMessage={recallMessage}
                resendMessage={resendMessage}
                replyMessage={replyMessage}
                modifyProperty={modifyProperty}
              />
            );
          })}
        </div>
      </ScrollView>
    </ListBox>
  );
};

export default forwardRef<RefType, MessageListProps<any>>(MessageList);
