import React, { useCallback, useEffect, useRef, useState } from 'react';
import { Message as MessageToast } from '@arco-design/web-react';
import { useRecoilState, useRecoilValue } from 'recoil';
import { Conversation, Message } from '@volcengine/im-web-sdk';
import classNames from 'classnames';

import { CurrentConversation, UserId, LiveConversations } from '../../store';
import { useParticipant, useLiveConversation, useLive } from '../../hooks';

import { Portal, SideBarMenu } from '../../components';
import { ConversationHeader, ConversationList, ChatSetting, ChatPanel, GroupNotice } from './components';
import { IconNotice, IconSetting } from '../../components/Icon';

import MainContainer from '../Style';
import LiveParticipantInfoModel from '../../components/ConversationModal/LiveParticipantInfo';

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
};

const sidebarButtons = [
  {
    key: SidebarKey.notice,
    icon: <IconNotice />,
    tipText: '群公告',
    visible: true,
  },
  {
    key: SidebarKey.setting,
    icon: <IconSetting />,
    tipText: '设置',
    visible: true,
  },
];

enum convListType {
  owner = 3,
  all = 1,
}

const Live = () => {
  const [liveConversations, setLiveConversations] = useRecoilState(LiveConversations);
  const [currentConversation, setCurrentConversation] = useRecoilState(CurrentConversation);
  const userId = useRecoilValue(UserId);

  const [selectedKey, setSelectedKey] = useState<SidebarKey | string>('');
  const [selectedMessage, setSelectedMessage] = useState<Message>();
  const [disPlayAllLiveConversation, setdisPlayAllLiveConversation] = useState(false);
  const originConvList = useRef([]);

  const { createLiveConversation, getLiveConversationList, selectLiveConversation } = useLiveConversation();
  const { addLiveGroupParticipants, removeLiveGroupParticipants } = useParticipant();
  const { clearCurrentLiveConversationStatus } = useLive();
  const [joinModalVisisble, setJoinModalVisisble] = useState(false);

  const handleJoinModalVisibleChange = useCallback(() => {
    setJoinModalVisisble(pre => !pre);
  }, []);

  const handleCloseMenuSidebar = useCallback((key?: string) => {
    setSelectedKey('');
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

  const handleOpenMenuSidebar = useCallback((key: SidebarKey | string) => {
    setSelectedKey(key);
  }, []);

  const handleConversationItemClick = async (item: Conversation, value) => {
    handleCloseMenuSidebar();

    if (currentConversation) {
      await removeLiveGroupParticipants(currentConversation, [userId]);
    }

    try {
      await selectLiveConversation(item);
      const result = await addLiveGroupParticipants({ conversation: item, participants: [userId], ...value });
      if (!result) {
        clearCurrentLiveConversationStatus();
        return false;
      }
      return true;
    } catch (err) {
      MessageToast.error('进入直播群失败');
      return false;
    }
  };

  const handleDisplayAllChange = useCallback(() => {
    if (disPlayAllLiveConversation) {
      init(convListType.owner);
    } else {
      init(convListType.all);
    }
    setdisPlayAllLiveConversation(!disPlayAllLiveConversation);
  }, [setdisPlayAllLiveConversation, disPlayAllLiveConversation]);

  const handleSearchChange = value => {
    const filterConvList = originConvList.current.filter(conv => conv.coreInfo.name.includes(value));
    setLiveConversations(filterConvList);
  };

  const clickedRef = useRef<Conversation>(null);
  const handleCreateLiveGroup = async params => {
    const { name } = params;
    const conv = await createLiveConversation({ name });
    if (!conv) {
      return;
    }
    try {
      await selectLiveConversation(conv);
      const result = await addLiveGroupParticipants({ conversation: conv, participants: [userId] });
      if (!result) {
        clearCurrentLiveConversationStatus();
        return;
      }
    } catch (err) {
      MessageToast.error('进入直播群失败');
      return;
    }
    init(convListType.owner);
  };

  const init = async policy => {
    let list = [];
    let hasMore = true;
    let cursor;
    while (hasMore) {
      const result = await getLiveConversationList({
        policy,
        cursor,
        limit: 100,
      });
      cursor = result.cursor;
      hasMore = false;
      list = list.concat(result.conversation);
    }

    originConvList.current = list;
    setLiveConversations(list);
  };

  useEffect(() => {
    init(convListType.owner);
  }, []);

  return (
    <MainContainer>
      <div className="chat-conversation-wrap">
        <ConversationHeader
          disPlayAllLiveConversation={disPlayAllLiveConversation}
          onDisplayAllChange={handleDisplayAllChange}
          onSearchChange={handleSearchChange}
          createLiveConversation={handleCreateLiveGroup}
        />

        <ConversationList
          curConversationId={currentConversation?.id}
          list={liveConversations}
          onItemClick={conv => {
            clickedRef.current = conv;
            setJoinModalVisisble(true);
          }}
        />
      </div>

      <div
        className={classNames({
          'chat-panel-wrap': true,
          'half-side-bar': selectedKey,
        })}
      >
        <ChatPanel />

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

      {joinModalVisisble && (
        <Portal>
          <LiveParticipantInfoModel
            title={'加入直播群'}
            userId={userId}
            onClose={handleJoinModalVisibleChange}
            onSubmit={async v => {
              return await handleConversationItemClick(clickedRef.current, v);
            }}
          ></LiveParticipantInfoModel>
        </Portal>
      )}
    </MainContainer>
  );
};

export default Live;
