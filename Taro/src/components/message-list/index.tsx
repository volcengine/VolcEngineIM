import { useCallback, useEffect, useRef, useState } from 'react';
import { View, ScrollView, Text } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon } from 'ossaui';

import { debounce } from '../../utils/function';

import MessageItem from '../message-item';

import './index.scss';

const CRITICAL_VALUE = 10;

interface MessageListProps {
  messageList: any[];
  previewImage?: (url) => void;
  markConversationRead: (readIndex) => void;
  unreadCount?: number;
}

const MessageList: React.FC<MessageListProps> = ({
  messageList,
  previewImage,
  markConversationRead,
  unreadCount = 0
}) => {
  const [scrollIntoId, setScrollIntoId] = useState('');
  const [distanceToBottom, setDistanceToBottom] = useState(0);
  const containerHeight = useRef(0);
  const msgCache = useRef<any>([]);

  const reportMsgRead = useCallback(
    debounce(
      msgList => {
        let shouldMarkReadMsg;
        for (let msg of msgList) {
          if (!shouldMarkReadMsg) {
            shouldMarkReadMsg = msg;
            continue;
          }
          // @ts-ignore
          if (msg.indexInConversation.gt(shouldMarkReadMsg.indexInConversation)) {
            shouldMarkReadMsg = msg;
          }
        }
        msgList.length = 0;
        if (shouldMarkReadMsg) {
          // cmd: 2002
          markConversationRead(shouldMarkReadMsg.indexInConversation);
        }
      },
      {
        wait: 2000,
        immediate: true
      }
    ),
    [markConversationRead]
  );

  const markMsgRead = useCallback(
    newMsg => {
      msgCache.current.push(newMsg);
      reportMsgRead(msgCache.current);
    },
    [reportMsgRead]
  );

  const scrollIntoBottom = useCallback(() => {
    if (messageList.length === 0) {
      return;
    }
    const lastMsg = messageList[messageList.length - 1];
    const id = lastMsg.serverId || lastMsg.clientId;
    setScrollIntoId(`msg${id}`);
    markMsgRead(lastMsg);
  }, [markMsgRead, messageList]);

  const handleScroll = useCallback(
    debounce(() => {
      const query = Taro.createSelectorQuery();
      query.selectAll('.message-card-wrapper').boundingClientRect();
      query.select('#msg-scroll-view').scrollOffset();
      query.exec(res => {
        const [msgListElement, msgContainerElement] = res;
        // 计算消息是否进入可使区
        for (let endIndex = msgListElement.length - 1; endIndex >= 0; endIndex--) {
          const { id, top } = msgListElement[endIndex];
          if (top >= 0 && top <= containerHeight.current) {
            console.debug('enter visible area');
            console.debug('id', id, 'top', top);
            console.debug('containerHeight', containerHeight.current);
            const realId = id.replace('msg', '');
            const message = messageList.find(item => item.serverId === realId || item.clientId === realId);
            markMsgRead(message);
            break;
          }
        }
        // 计算消息列表底部离容器底部距离
        const { scrollHeight, scrollTop } = msgContainerElement;
        setDistanceToBottom(scrollHeight - scrollTop - containerHeight.current);
      });
    }),
    [markMsgRead, messageList]
  );

  useEffect(() => {
    // 获取容器高度
    Taro.createSelectorQuery()
      .select('#msg-scroll-view')
      .boundingClientRect(rect => {
        containerHeight.current = rect?.height || 0;
      })
      .exec();
    // 首次进入，滚动到最底部
    scrollIntoBottom();
  }, []);

  useEffect(() => {
    // 新消息进来，如果界面停留在底部，则自动滚动
    if (distanceToBottom <= CRITICAL_VALUE) {
      scrollIntoBottom();
    }
    // 不需要监听distanceToBottom
  }, [scrollIntoBottom]);

  return (
    <View className="message-list-wrapper">
      <ScrollView id="msg-scroll-view" scrollY scrollIntoView={scrollIntoId} onScroll={handleScroll}>
        {messageList?.map(item => {
          const id = item.serverId || item.clientId;
          return <MessageItem id={'msg' + id} key={id} message={item} previewImage={previewImage} />;
        })}
      </ScrollView>

      <View
        className="unread-count-wrapper"
        style={{
          opacity: distanceToBottom > CRITICAL_VALUE && unreadCount > 0 ? 1 : 0
        }}
        onClick={scrollIntoBottom}
      >
        <OsIcon type="pull-down-big" size={20} color="#4285f4"></OsIcon>
        <Text className="text">{unreadCount} 条未读消息</Text>
      </View>
    </View>
  );
};

export default MessageList;
