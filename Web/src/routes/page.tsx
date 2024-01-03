import React, { useCallback, memo, FC, useEffect, useRef, useMemo, useState } from 'react';
import { Spin } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';
import classNames from 'classnames';
import { Conversation, im_proto, Message } from '@volcengine/im-web-sdk';

import { IconSetting, IconNotice } from '../components/Icon';
import {
  GroupNotice,
  ChatSetting,
  SideBarMenu,
  ConversationList,
  ChatPanel,
  ConversationHeader,
  NoMessage,
  ChatHeader,
  ChatStatus,
  ReplyList,
  ConversationTab,
} from '../components/index';
import { useAccountsInfo, useConversation, useProfileUpdater } from '../hooks';
import { Conversations, CurrentConversation } from '../store';
import { Iui } from '../types';

import MainContainer from './Style';
import { FRIEND_INFO } from '../constant';

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

const Home: FC<PCFePropsType> = memo(() => {
  const { selectConversation, createGroupConversation, createOneOneConversation } = useConversation();

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
  const [filterType, setFilterType] = useState('all');

  const ACCOUNTS_INFO = useAccountsInfo(); // 订阅好友关系更新
  let friendConvList = conversations.filter(
    i => i.type === im_proto.ConversationType.ONE_TO_ONE_CHAT && FRIEND_INFO.value[i.toParticipantUserId]
  );

  return (
    <MainContainer>
      <div className="chat-conversation-wrap">
        <ConversationHeader
          createGroupConversation={createGroupConversation}
          createOneOneConversation={createOneOneConversation}
        />

        <ConversationTab
          onChange={setFilterType}
          allUnreadCount={conversations.reduce((a, c) => a + (c.isMuted ? 0 : c.unreadCount), 0)}
          friendUnreadCount={friendConvList.reduce((a, c) => a + (c.isMuted ? 0 : c.unreadCount), 0)}
        ></ConversationTab>
        <ConversationList
          curConversationId={currentConversation?.id}
          list={filterType === 'all' ? conversations : friendConvList}
          onItemClick={handleConversationItemClick}
          emptyText={filterType === 'friend' ? '暂无好友会话' : undefined}
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
  );
});

export default Home;
