import React, { useCallback, memo, FC, useEffect, useRef, useMemo, useState } from 'react';
import { Spin } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';
import classNames from 'classnames';
import { Conversation, Message } from '@volcengine/im-web-sdk';

import { IconSetting, IconNotice } from '../Icon';
import {
  GroupNotice,
  ChatSetting,
  SideBarMenu,
  ConversationList,
  ChatPanel,
  AppNavbar,
  ConversationHeader,
  NoMessage,
  ChatHeader,
  ChatStatus,
  ReplyList,
} from '../index';
import { useConversation, useImSdK } from '../../hooks';
import { Conversations, CurrentConversation } from '../../store';
import { Iui } from '../../types';

import MainContainer, { PageLoading } from './Style';

interface PCFePropsType {
  ui?: Iui;
}

enum SidebarKey {
  notice = 1,
  search = 2,
  pin = 3,
  setting = 4,
  reply = 5, // 用来展示引用消息链
}

const SidebarMap = {
  [SidebarKey.notice]: GroupNotice,
  [SidebarKey.setting]: ChatSetting,
  [SidebarKey.reply]: ReplyList,
};

const PC: FC<PCFePropsType> = memo(() => {
  const { selectConversation, createOneOneConversation, createGroupConversation } = useConversation();
  const conversations = useRecoilValue(Conversations);
  const currentConversation = useRecoilValue(CurrentConversation);
  const mountRef = useRef(false);
  const [selectedKey, setSelectedKey] = useState<SidebarKey | string>('');
  const [selectedMessage, setSelectedMessage] = useState<Message>();

  const sidebarButtons = useMemo(() => {
    return [
      {
        key: SidebarKey.notice,
        icon: <IconNotice />,
        tipText: '群公告',
        visible: !currentConversation?.toParticipantUserId,
      },
      {
        key: SidebarKey.setting,
        icon: <IconSetting />,
        tipText: '设置',
        visible: true,
      },
    ];
  }, [currentConversation?.toParticipantUserId]);

  const handleCloseMenuSidebar = useCallback((key?: string) => {
    setSelectedKey('');
  }, []);

  const handleConversationItemClick = useCallback(
    (item: Conversation) => {
      handleCloseMenuSidebar();
      selectConversation?.(item.id);
    },
    [selectConversation, handleCloseMenuSidebar]
  );

  const handleOpenMenuSidebar = useCallback((key: SidebarKey | string) => {
    setSelectedKey(key);
  }, []);

  const renderSidebar = () => {
    if (!selectedKey) {
      return null;
    }

    const Cmp = SidebarMap[selectedKey] as any;

    return Cmp ? (
      <div className="slide-content-wrapper">
        <Cmp handleClose={handleCloseMenuSidebar} message={selectedMessage} />
      </div>
    ) : null;
  };

  useEffect(() => {
    if (conversations.length && !mountRef.current) {
      mountRef.current = true;
      const defaultConversation = conversations[0];
      selectConversation(defaultConversation.id);
    }
  }, [conversations, selectConversation]);

  useEffect(() => {
    if (currentConversation === null) {
      setSelectedKey('');
    }
  }, [currentConversation]);

  return (
    <>
      <AppNavbar />

      <MainContainer>
        <div className="chat-conversation-wrap">
          <ConversationHeader
            createGroupConversation={createGroupConversation}
            createOneOneConversation={createOneOneConversation}
          />

          <ConversationList
            curConversationId={currentConversation?.id}
            list={conversations}
            onItemClick={handleConversationItemClick}
          />
        </div>

        <div
          className={classNames({
            'chat-panel-wrap': true,
            'half-side-bar': selectedKey,
          })}
        >
          <ChatPanel noMessage={NoMessage} chatHeader={ChatHeader} chatStatus={ChatStatus} />

          {currentConversation && renderSidebar()}
        </div>

        {currentConversation && (
          <div className="chat-menu-wrap">
            <SideBarMenu
              items={sidebarButtons}
              selectedKey={selectedKey}
              openSidebar={handleOpenMenuSidebar}
              closeSidebar={handleCloseMenuSidebar}
            />
          </div>
        )}
      </MainContainer>
    </>
  );
});

const Home = () => {
  const { loading } = useImSdK();

  return loading ? (
    <PageLoading>
      <Spin dot />
    </PageLoading>
  ) : (
    <PC />
  );
};

export default Home;
