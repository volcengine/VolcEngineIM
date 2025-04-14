import React, { memo, useState, useRef, useMemo, useCallback, useEffect } from 'react';
import { useRecoilValue } from 'recoil';
import { Message } from '@volcengine/im-web-sdk';

import MessageList from '../MessageList';
import { IconDown } from '../Icon';
import ChatHeaderBox from '../ChatHeaderBox';
import {
  AccountsInfo,
  CurrentConversation,
  CurrentConversationUnreadCount,
  ScrollRef,
  BytedIMInstance,
} from '../../store';
import { useMessage, useConversation } from '../../hooks';
import { Iui } from '../../types';
import Styles from './Styles';
import ChatOperation from '../ChatOperation';
import { isBotConversion } from '../../utils/bot';

interface ChatPanelPropsType extends Iui {}

export interface MessageListItem extends Message {
  isTimeVisible?: boolean;
}

const ChatPanel: React.FC<ChatPanelPropsType> = memo(props => {
  const { noMessage, chatHeader } = props;
  const currentConversation = useRecoilValue(CurrentConversation);

  const {
    messages,
    loadMoreMessage,
    recallMessage,
    deleteMessage,
    replyMessage,
    editMessage,
    modifyMessageProperty,
    markMessageRead,
    resendMessage,
  } = useMessage();

  const { removeConversation, configConversationSettingInfo } = useConversation();

  const accountsInfo = useRecoilValue(AccountsInfo);
  const scrollRef = useRecoilValue(ScrollRef);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const [showScrollIcon, setShowScrollIcon] = useState(false);
  const listRef = useRef<any>(null);
  const currentConversationUnreadCount = useRecoilValue(CurrentConversationUnreadCount);

  const shopAccountsInfo = accountsInfo.get(currentConversation?.toParticipantUserId);
  const readIndex = currentConversation?.readIndex?.toString();

  const handleLoadMore = async () => {
    await loadMoreMessage(messages?.[0]?.indexInConversation);
  };

  const handleCheckMoreList = async () => {
    try {
      return await loadMoreMessage(messages?.[0]?.indexInConversation);
    } catch (error) {}
  };

  // useEffect(() => {
  //   // todo 这样写删除会话的时候会立即发送开场白
  //   console.log('当前会话消息数量：', messages?.length, currentConversation?.id);
  //   if (currentConversation?.id && !messages?.length) {
  //     // 机器人会话发送开场白消息
  //     if (isBotConversion(currentConversation.id)) {
  //       console.log('当前会话没有历史消息，发送开场白消息');
  //       bytedIMInstance.markNewChat({ conversation: currentConversation, sendNotice: true });
  //     }
  //   }
  // }, [messages]);

  /** 滚动底部 */
  const handleScrollIconClick = useCallback(() => {
    listRef.current?.scrollToBottom();
  }, []);

  /** 内部控制是否显示 滚动底部icon */
  const handleTriggerBottom = useCallback((isShow: boolean) => {
    setShowScrollIcon(isShow);
  }, []);

  const handleAvatarClick = () => {};

  /** 关闭会话 */
  const handleCloseConversation = useCallback(() => {
    removeConversation(currentConversation?.id);
  }, [removeConversation, currentConversation?.id]);

  /** 置顶 */
  const handleTopConversation = useCallback(() => {
    configConversationSettingInfo(currentConversation.id, {
      stickOnTop: !currentConversation.isStickOnTop,
    });
  }, [configConversationSettingInfo, currentConversation?.id, currentConversation?.isStickOnTop]);

  /** 免打扰 */
  const handleMuteConversation = useCallback(() => {
    configConversationSettingInfo(currentConversation.id, {
      mute: !currentConversation.isMuted,
    });
  }, [configConversationSettingInfo, currentConversation?.id, currentConversation?.isMuted]);

  /** 无消息 */
  const renderNoMessage = useMemo(() => {
    if (!noMessage) {
      return null;
    }
    let curAccoutInfo = accountsInfo.get(currentConversation?.toParticipantUserId);

    let NoMessage = noMessage as any;

    return <NoMessage userInfo={curAccoutInfo} />;
  }, [accountsInfo, noMessage]);

  return (
    <Styles className="chat-panel-container">
      {currentConversation?.id ? (
        <>
          <div className="chat-info-container">
            <ChatHeaderBox
              Component={chatHeader}
              userInfo={shopAccountsInfo}
              conversation={currentConversation}
              onTopConversation={handleTopConversation}
              onCloseConversation={handleCloseConversation}
              onMuteConversation={handleMuteConversation}
            />
          </div>
          <div className="chat-content">
            <div className="message-container">
              <MessageList
                ref={listRef}
                dataSource={messages}
                loadMore={handleLoadMore}
                markMessageRead={markMessageRead}
                onAvatarClick={handleAvatarClick}
                checkMoreMessage={handleCheckMoreList}
                triggerBottom={handleTriggerBottom}
                recallMessage={recallMessage}
                deleteMessage={deleteMessage}
                replyMessage={replyMessage}
                editMessage={editMessage}
                modifyProperty={modifyMessageProperty}
                readIndex={readIndex}
                unReadCount={currentConversationUnreadCount}
                resendMessage={resendMessage}
              />
              {(showScrollIcon || currentConversationUnreadCount) && (
                <div className="scroll-bottom-icon-box" onClick={handleScrollIconClick}>
                  <div className="scroll-bottom-icon">
                    <IconDown />
                    {currentConversationUnreadCount ? `${currentConversationUnreadCount}条消息` : null}
                  </div>
                </div>
              )}
            </div>
          </div>

          <div className="input_container">
            <ChatOperation userInfo={shopAccountsInfo} scrollRef={scrollRef} />
          </div>
        </>
      ) : (
        renderNoMessage
      )}
    </Styles>
  );
});

export default ChatPanel;
