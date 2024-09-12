import { useCallback, useEffect, useRef, useState } from 'react';
import { View, ScrollView, Text } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsPicker } from 'ossaui';

import { debounce } from '../../utils/function';

import MessageItem from '../message-item';

import './index.scss';
import { AtActionSheet, AtActionSheetItem, AtFloatLayout, AtList, AtListItem, message } from 'taro-ui';
import { FlightStatus, im_proto, Message } from '@volcengine/im-mp-sdk';
import { useAppSelector } from '../../store/hooks';
import { selectConversation, selectIm } from '../../store/imReducers';

const CRITICAL_VALUE = 10;
const PRIORITY_STRING = {
  [im_proto.MessagePriority.HIGH]: '高',
  [im_proto.MessagePriority.NORMAL]: '普通',
  [im_proto.MessagePriority.LOW]: '低'
};
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
  const instance = useAppSelector(selectIm);
  const conversation = useAppSelector(selectConversation);

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
          if (msg?.indexInConversation.gt(shouldMarkReadMsg?.indexInConversation)) {
            shouldMarkReadMsg = msg;
          }
        }
        msgList.length = 0;
        if (shouldMarkReadMsg) {
          // cmd: 2002
          markConversationRead(shouldMarkReadMsg?.indexInConversation);
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
        if (!msgListElement || !msgContainerElement) {
          return;
        }
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

  /**
   * 发送消息 2 分钟内，可以撤回
   *
   * @param {Date} createdAt
   * @return {*}
   */
  const msgCanRecall = (createdAt: Date) => {
    const now = Date.now();
    const time = new Date(createdAt).getTime();
    if (now - time <= 2 * 60 * 1000) {
      return true;
    }
    return false;
  };

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
  console.log('messageList', messageList);
  const [messageOperating, setMessageOperating] = useState<Message>(null);
  return (
    <View className="message-list-wrapper">
      <ScrollView id="msg-scroll-view" scrollY scrollIntoView={scrollIntoId} onScroll={handleScroll}>
        {messageList?.map(item => {
          const id = item.serverId || item.clientId;
          return (
            <MessageItem
              id={'msg' + id}
              key={id}
              message={item}
              previewImage={previewImage}
              onOperate={() => {
                console.log('tapmessageItem');
                setMessageOperating(item);
              }}
            />
          );
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
      {conversation.type === im_proto.ConversationType.MASS_CHAT ? (
        <AtActionSheet isOpened={!!messageOperating} onClose={() => setMessageOperating(false)} cancelText={'取消'}>
          <AtActionSheetItem
            onClick={() => {
              setMessageOperating(null);
            }}
          >
            消息优先级：{PRIORITY_STRING[messageOperating?.messagePriority]}
          </AtActionSheetItem>
        </AtActionSheet>
      ) : (
        <AtActionSheet isOpened={!!messageOperating} onClose={() => setMessageOperating(false)} cancelText={'取消'}>
          <AtActionSheetItem
            onClick={() => {
              if (!messageOperating) {
                return;
              }
              instance.deleteMessage({
                message: messageOperating,
                localOnly: messageOperating.flightStatus === FlightStatus.Rejected
              });
              setMessageOperating(null);
            }}
          >
            删除
          </AtActionSheetItem>
          {messageOperating?.isFromMe &&
            msgCanRecall(messageOperating.createdAt) &&
            (messageOperating.flightStatus === FlightStatus.Succeeded || messageOperating.flightStatus === 4) && (
              <AtActionSheetItem
                onClick={() => {
                  instance.recallMessage({ message: messageOperating });
                  setMessageOperating(null);
                }}
              >
                撤回
              </AtActionSheetItem>
            )}
        </AtActionSheet>
      )}
    </View>
  );
};

export default MessageList;
