import React, { FC, useCallback, useMemo, useRef, useState } from 'react';
import { Button, Message, Tooltip } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';

import { Avatar, CheckBox, Dialog as Modal } from '..';
import { IconEdit, IconRight } from '../Icon';

import GroupInfoModal from './GroupInfoModal';
import GroupMemberManageModal from './GroupMemberManageModal';
import ChatSettingBox from './Styles';
import { useAccountsInfo, useConversation } from '../../hooks';
import { CurrentConversation, Participants, UserId } from '../../store';
import { getConversationAvatar, getConversationName } from '../../utils';
import { useParticipant } from '../../hooks/useParticipant';
import { CheckCode } from '../../constant';

interface ChatSettingProps {
  messageItems?: any[];
  shouldRenderLoading?: boolean;
  doSearch?: (query: string) => void;
  clearSearch?: () => void;
  deletePin?: () => void;
  getMoreSearchMessage?: () => void;
  jumpToMessage?: () => void;
}

enum ModalType {
  Info = 1,
  Member = 2,
  WeakMuteUserSetting = 3,
  WeakMuteTypeSetting = 4,
}

enum Role {
  Normal = 0,
  Owner = 1,
  Manager = 2,
}

const ChatSetting: FC<ChatSettingProps> = props => {
  const currentConversation = useRecoilValue(CurrentConversation);
  const participants = useRecoilValue(Participants);
  const { removeGroupParticipants, updateGroupParticipantWithTips } = useParticipant();
  const {
    configConversationSettingInfo,
    leaveGroupConversation,
    dissolveGroupConversation,
    configGroupConversationCoreInfo,
  } = useConversation();

  const { id, isStickOnTop, coreInfo, isMuted } = currentConversation;

  const [modalVisible, setModalVisible] = useState(false);
  const [modalInfo, setModalInfo] = useState<any>(null);
  const userId = useRecoilValue(UserId);

  const modalType = useRef<ModalType>();
  const childRef = useRef<any>();

  const { desc, owner } = coreInfo || {};

  const role = useMemo(() => {
    return participants.find(item => item.userId === userId)?.role;
  }, [participants, userId]);

  const isOwner = useMemo(() => owner === userId, [owner, userId]);
  const isGroup = useMemo(() => !/\d:1:/.test(id), [id]);

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
        case ModalType.Info: {
          const name = childRef.current.nameRef.current.dom.value.trim() || '未命名群聊';
          const avatarUrl = childRef.current.avatarRef.current.dom.value.trim();
          const desc = childRef.current.descRef.current.dom.value;
          try {
            await configGroupConversationCoreInfo(id, { name, desc, icon: avatarUrl });
          } catch (err) {
            Message.error('保存失败');
          }
          break;
        }
        case ModalType.Member:
        default:
          break;
      }
      setModalVisible(false);
    },
    [configGroupConversationCoreInfo, id]
  );

  const handleModalCancel = useCallback(() => {
    setModalVisible(false);
  }, []);

  const handleExitGroup = useCallback(() => {
    leaveGroupConversation(id);
  }, [id, leaveGroupConversation]);

  const handleDissolveGroup = useCallback(() => {
    dissolveGroupConversation(id);
  }, [id, dissolveGroupConversation]);

  const ModalMap = {
    [ModalType.Info]: {
      title: '编辑群信息',
      width: 420,
    },
    [ModalType.Member]: {
      title: '群成员',
      width: 420,
      wrapClassName: 'group-search-modal',
    },
  };

  const renderTypeModal = () => {
    if (modalType.current === ModalType.Info) {
      return <GroupInfoModal ref={childRef} currentConversation={currentConversation} />;
    }
    if (modalType.current === ModalType.Member) {
      return (
        <GroupMemberManageModal
          removeGroupParticipants={removeGroupParticipants}
          updateGroupParticipant={updateGroupParticipantWithTips}
          role={role}
          ownUserId={userId}
        />
      );
    }
    return null;
  };
  useAccountsInfo();
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
              {role === Role.Owner && isGroup && (
                <Tooltip content="编辑群信息" position="top">
                  <span className="chat-edit-icon" onClick={() => showTypeModel(ModalType.Info)}>
                    <IconEdit />
                  </span>
                </Tooltip>
              )}
            </div>
            <div className="chat-user-desc">{isGroup ? desc || '暂无群描述' : ''}</div>
          </div>
        </div>

        {isGroup && (
          <div className="group-member-wrap">
            <div className="group-member-header" onClick={() => showTypeModel(ModalType.Member)}>
              <div className="group-member-header-left">群成员({participants.length})</div>
              <div className="group-member-header-right">
                <IconRight />
              </div>
            </div>
          </div>
        )}

        <div className="setting-content">
          <CheckBox
            onChange={() => {
              configConversationSettingInfo(id, { mute: !isMuted });
            }}
            checked={isMuted}
          >
            <p className="setting-item-title">消息免打扰</p>
          </CheckBox>

          <CheckBox
            onChange={() => {
              configConversationSettingInfo(id, { stickOnTop: !isStickOnTop });
            }}
            checked={isStickOnTop}
          >
            <p className="setting-item-title">置顶聊天</p>
          </CheckBox>
        </div>
      </div>

      {isGroup && (
        <div className="chat-setting-footer">
          <Button className="chat-setting-btn " type="outline" onClick={handleExitGroup}>
            退出群组
          </Button>

          {isOwner && (
            <Button className="chat-setting-btn " type="primary" status="danger" onClick={handleDissolveGroup}>
              解散群组
            </Button>
          )}
        </div>
      )}

      <Modal
        title={modalInfo?.title}
        visible={modalVisible}
        modalStyle={{ width: modalInfo?.width }}
        wrapClassName={modalInfo?.wrapClassName}
        onOk={handleModalOk}
        onCancel={handleModalCancel}
        footer={modalType.current === ModalType.Member ? null : false}
      >
        {modalVisible && renderTypeModal()}
      </Modal>
    </ChatSettingBox>
  );
};

export default ChatSetting;
