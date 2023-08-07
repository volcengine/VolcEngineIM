import React, { FC, useCallback, useRef, useState } from 'react';
import { Button, Message, Tooltip } from '@arco-design/web-react';
import { IconRight } from '@arco-design/web-react/icon';
import { useRecoilValue } from 'recoil';

import { Avatar, CheckBox, Dialog as Modal } from '../../../../components';
import { IconEdit } from '../../../../components/Icon';

import GroupInfoModal from './GroupInfoModal';
import { GroupMemberListModal } from './GroupMemberListModal';
import { GroupBlockListModal, GroupMuteListModal, GroupMuteWhiteListModal } from './GroupBlockListModal';
import { GroupTransferModal } from './GroupTransferModal';

import { useParticipant } from '../../../../hooks';
import {
  CurrentConversation,
  IsMuted,
  LiveConversationMemberCount,
  LiveConversationOwner,
  UserId,
} from '../../../../store';
import { getConversationAvatar, getConversationName } from '../../../../utils';

import ChatSettingBox from './Styles';
import { useLive } from '../../../../hooks/useLive';
import { useLiveConversation } from '../../../../hooks/useLiveConversation';
import { ROLE } from '../../../../constant';
import GroupQueryUserInfoModal from './GroupQueryUserInfoModal';

enum ModalType {
  Info = 1,
  MemberList = 2,
  MuteList = 3,
  BlockList = 4,
  Transfer = 5,
  MuteWhiteList = 6,
  QueryUserStatus = 7,
}

const ModalMap = {
  [ModalType.Info]: {
    title: '编辑群信息',
    width: 420,
    footer: false,
  },
  [ModalType.MemberList]: {
    title: '群成员',
    width: 420,
    wrapClassName: 'group-search-modal',
    footer: null,
  },
  [ModalType.Transfer]: {
    title: '转让群主',
    width: 420,
    footer: false,
  },
  [ModalType.MuteList]: {
    title: '禁言名单',
    width: 420,
    footer: null,
  },
  [ModalType.BlockList]: {
    title: '进群黑名单',
    width: 420,
    footer: null,
  },
  [ModalType.MuteWhiteList]: {
    title: '禁言白名单',
    width: 420,
    footer: null,
  },
  [ModalType.QueryUserStatus]: {
    title: '查询用户状态',
    width: 600,
    footer: null,
  },
};

interface ChatSettingProps {}

export const ChatSetting: FC<ChatSettingProps> = props => {
  const currentConversation = useRecoilValue(CurrentConversation);
  const { id, onlineMemberCount, coreInfo, isBlocked, userInfo } = currentConversation;
  const { name, desc, owner } = coreInfo || {};
  const userId = useRecoilValue(UserId);

  const liveConversationMemberCount = useRecoilValue(LiveConversationMemberCount);
  const liveConversationOwner = useRecoilValue(LiveConversationOwner);
  const memberCount = liveConversationMemberCount ?? onlineMemberCount;
  const isOwner = liveConversationOwner ? userId === liveConversationOwner : userId === owner;
  const isManageable = userInfo.role === ROLE.Owner || userInfo.role === ROLE.Manager;
  const [modalVisible, setModalVisible] = useState(false);
  const [modalInfo, setModalInfo] = useState<any>(null);

  const modalType = useRef<ModalType>();
  const childRef = useRef<any>();
  const { clearCurrentLiveConversationStatus } = useLive();

  const { updateGroupParticipant, removeLiveGroupParticipants } = useParticipant();
  const { configLiveConversationCoreInfo, dissolveLiveGroupConversation, setConversationMute } = useLiveConversation();

  const selectItemList = [
    {
      key: 'muteWhite',
      name: '禁言白名单',
      action: () => {
        showTypeModel(ModalType.MuteWhiteList);
      },
    },
    {
      key: 'mute',
      name: '禁言名单',
      action: () => {
        showTypeModel(ModalType.MuteList);
      },
    },
    {
      key: 'block',
      name: '进群黑名单',
      action: () => {
        showTypeModel(ModalType.BlockList);
      },
    },
    isOwner && {
      key: 'transfer',
      name: '转让群主',
      action: () => {
        showTypeModel(ModalType.Transfer);
      },
    },
  ].filter(Boolean);

  const showModal = useCallback(() => {
    setModalVisible(true);
  }, []);

  const showTypeModel = (type: ModalType) => {
    modalType.current = type;
    let modal = ModalMap[type];
    if (modal) {
      setModalInfo(modal);
    }
    showModal();
  };

  const handleModalOk = useCallback(
    async e => {
      switch (modalType.current) {
        case ModalType.Info:
          const name = childRef.current.nameRef.current.dom.value.trim() || '未命名群聊';
          const desc = childRef.current.descRef.current.dom.value;
          try {
            await configLiveConversationCoreInfo(currentConversation, { name, desc });
          } catch (err) {
            Message.error('保存失败');
          }
          break;
        case ModalType.Transfer:
          const userId = childRef.current.nameRef.current.dom.value; // 10001
          updateGroupParticipant('0', userId, {
            role: 1,
          });
          break;
        default:
          break;
      }
      setModalVisible(false);
    },
    [configLiveConversationCoreInfo, id]
  );

  const handleModalCancel = useCallback(() => {
    setModalVisible(false);
  }, []);

  const renderTypeModal = () => {
    let component = null;

    switch (modalType.current) {
      case ModalType.Info:
        component = <GroupInfoModal defaultName={name} defaultDesc={desc} ref={childRef} />;
        break;
      case ModalType.MemberList:
        component = <GroupMemberListModal />;
        break;
      case ModalType.Transfer:
        component = <GroupTransferModal ref={childRef} />;
        break;
      case ModalType.MuteList:
        component = <GroupMuteListModal />;
        break;
      case ModalType.MuteWhiteList:
        component = <GroupMuteWhiteListModal />;
        break;
      case ModalType.BlockList:
        component = <GroupBlockListModal />;
        break;
      case ModalType.QueryUserStatus:
        component = <GroupQueryUserInfoModal />;
        break;
      default:
        break;
    }

    return component;
  };

  const handleExitGroup = () => {
    removeLiveGroupParticipants(currentConversation, [userId]);
    clearCurrentLiveConversationStatus();
  };

  const handleDissolveGroup = () => {
    dissolveLiveGroupConversation(currentConversation);
    clearCurrentLiveConversationStatus();
  };

  return (
    <ChatSettingBox className="chat-setting">
      <div className="chat-setting-header">
        <div className="chat-setting-title">设置</div>
      </div>

      <div className="chat-setting-main">
        <div className="chat-setting-info">
          <div className="chat-avatar">
            <Avatar size={40} url={getConversationAvatar(currentConversation)} />
          </div>

          <div className="chat-user-detail">
            <div className="chat-user-name">
              {getConversationName(currentConversation)}
              {isManageable && (
                <Tooltip content="编辑群信息" position="top">
                  <span className="chat-edit-icon" onClick={() => showTypeModel(ModalType.Info)}>
                    <IconEdit />
                  </span>
                </Tooltip>
              )}
            </div>
            <div className="chat-user-desc">{desc || '暂无群描述'}</div>
          </div>
        </div>

        <div className="group-member-wrap">
          <div className="group-member-header" onClick={() => showTypeModel(ModalType.MemberList)}>
            <div className="group-member-header-left">群成员({memberCount})</div>
            <div className="group-member-header-right">
              <IconRight />
            </div>
          </div>
        </div>

        <div className="setting-content">
          <div
            className="select-item-wrapper"
            onClick={() => {
              showTypeModel(ModalType.QueryUserStatus);
            }}
          >
            <div className="item-name-wrapper">查询用户状态</div>

            <div className="item-icon-wrapper">
              <IconRight />
            </div>
          </div>

          {
            <CheckBox
              onChange={() => {
                setConversationMute({
                  conversation: currentConversation,
                  block: !isBlocked,
                });
              }}
              checked={isBlocked}
              disabled={!isManageable}
            >
              <p className="setting-item-title">全员禁言</p>
            </CheckBox>
          }

          {selectItemList.map(item => {
            return (
              ((item.key !== 'muteWhite' && isManageable) || (item.key === 'muteWhite' && isBlocked)) && (
                <div
                  className="select-item-wrapper"
                  key={item.key}
                  onClick={() => {
                    item.action();
                  }}
                >
                  <div className="item-name-wrapper">{item.name}</div>

                  <div className="item-icon-wrapper">
                    <IconRight />
                  </div>
                </div>
              )
            );
          })}
        </div>
      </div>

      <div className="chat-setting-footer">
        <Button className="chat-setting-btn " type="outline" onClick={handleExitGroup}>
          退出直播群
        </Button>

        {isOwner && (
          <Button className="chat-setting-btn " type="primary" status="danger" onClick={handleDissolveGroup}>
            解散直播群
          </Button>
        )}
      </div>

      <Modal
        title={modalInfo?.title}
        visible={modalVisible}
        modalStyle={{ width: modalInfo?.width }}
        wrapClassName={modalInfo?.wrapClassName}
        onOk={handleModalOk}
        onCancel={handleModalCancel}
        footer={modalInfo?.footer}
      >
        {modalVisible && renderTypeModal()}
      </Modal>
    </ChatSettingBox>
  );
};
