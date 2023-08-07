import React, { memo, useState, useRef, useMemo, useCallback, useEffect } from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';
import { Message } from '@volcengine/im-web-sdk';

import { AccountsInfo, CurrentConversation, ScrollRef } from '../../../../store';
import { useMessage } from '../../../../hooks';
import { ChatOperation } from '../ChatOperation';
import { ChatHeader } from '../ChatHeader';
import MessageList from '../MessageList';

import Styles from './Styles';
import { NoMessage } from '../../../../components';

interface ChatPanelPropsType {
  conversationHeader?: React.ReactNode;
  conversationItem?: React.ReactNode;
  messageItem?: React.ReactNode;
  chatOperation?: React.ReactNode;
  messageTip?: React.ReactNode;
  noPermission?: React.ReactNode;
  appNavbar?: React.ReactNode;
}

export interface MessageListItem extends Message {
  isTimeVisible?: boolean;
}

export const ChatPanel: React.FC<ChatPanelPropsType> = memo(props => {
  const currentConversation = useRecoilValue(CurrentConversation);
  const { messages } = useMessage();
  const accountsInfo = useRecoilValue(AccountsInfo);
  const scrollRef = useRecoilValue(ScrollRef);
  const listRef = useRef<any>(null);
  const shopAccountsInfo = accountsInfo.get(currentConversation?.toParticipantUserId);

  /** 无消息 */
  const renderNoMessage = useMemo(() => {
    let curAccoutInfo = accountsInfo.get(currentConversation?.toParticipantUserId);
    return <NoMessage userInfo={curAccoutInfo} />;
  }, [accountsInfo]);

  return (
    <Styles className="chat-panel-container">
      {currentConversation?.id ? (
        <>
          <div className="chat-info-container">
            <ChatHeader conversation={currentConversation} />
          </div>

          <div className="chat-content">
            <div className="message-container">
              <MessageList ref={listRef} dataSource={messages} />
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
