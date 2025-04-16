import React, { FC, useCallback, useMemo, useRef, useState } from 'react';
import { Button, Message, Tooltip, Modal } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';

import { Avatar, CheckBox, Dialog } from '..';
import { IconEdit, IconRight } from '../Icon';

import GroupInfoModal from './GroupInfoModal';
import GroupMemberManageModal from './GroupMemberManageModal';
import ChatSettingBox from './Styles';
import { useAccountsInfo, useConversation, useParticipant, useBot } from '../../hooks';
import { CurrentConversation, Participants, UserId, BytedIMInstance, SpecialBotConvStickOnTop } from '../../store';
import { getConversationAvatar, getConversationName } from '../../utils';

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
    configConversationStickOnTop,
    leaveGroupConversation,
    dissolveGroupConversation,
    configGroupConversationCoreInfo,
    clearConversationMessage,
    clearConversationContext,
  } = useConversation();
  // const { messages } = useMessage();

  const { id, isStickOnTop, coreInfo, isMuted, toParticipantUserId } = currentConversation;

  const [modalVisible, setModalVisible] = useState(false);
  const [modalInfo, setModalInfo] = useState<any>(null);
  const userId = useRecoilValue(UserId);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const specialBotConvStickOnTop = useRecoilValue(SpecialBotConvStickOnTop);

  const modalType = useRef<ModalType>();
  const childRef = useRef<any>();

  const { desc, owner } = coreInfo || {};

  const role = useMemo(() => {
    return participants.find(item => item.userId === userId)?.role;
  }, [participants, userId]);

  const isOwner = useMemo(() => owner === userId, [owner, userId]);
  const isGroup = useMemo(() => !/\d:1:/.test(id), [id]);
  const { isBotConversion, isSpecialBotConversion } = useBot();
  const isBotConv = useMemo(() => isBotConversion(toParticipantUserId), [isBotConversion, toParticipantUserId]);

  const __isStickOnTop = useMemo(() => {
    const isSpecialBotConv = isSpecialBotConversion(id);
    if (isSpecialBotConv) {
      return specialBotConvStickOnTop;
    } else {
      return isStickOnTop;
    }
  }, [isStickOnTop, specialBotConvStickOnTop, isSpecialBotConversion, id]);

  const handleClearContext = useCallback(() => {
    Modal.confirm({
      title: '清除上下文',
      content: '是否确认清除上下文内容，开始新的会话？',
      onOk: () => {
        clearConversationContext(id, true);
      },
    });
  }, [id]);

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
          const desc = childRef.current.descRef.current.dom.value;
          try {
            await configGroupConversationCoreInfo(id, { name, desc });
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
    // console.log('lllll isBot ', isBot, id),
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
              configConversationStickOnTop(id, !__isStickOnTop);
            }}
            checked={__isStickOnTop}
          >
            <p className="setting-item-title">置顶聊天</p>
          </CheckBox>

          <div
            className="select-item-wrapper"
            onClick={() => {
              clearConversationMessage(id);
            }}
          >
            <div className="item-name-wrapper">清空聊天记录</div>
            <div className="item-icon-wrapper">
              <IconRight />
            </div>
          </div>
          {isBotConv && (
            <div className="select-item-wrapper" onClick={handleClearContext}>
              <div className="item-name-wrapper">清除上下文</div>
              <div className="item-icon-wrapper">
                <IconRight />
              </div>
            </div>
          )}
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

      <Dialog
        title={modalInfo?.title}
        visible={modalVisible}
        modalStyle={{ width: modalInfo?.width }}
        wrapClassName={modalInfo?.wrapClassName}
        onOk={handleModalOk}
        onCancel={handleModalCancel}
        footer={modalType.current === ModalType.Member ? null : false}
      >
        {modalVisible && renderTypeModal()}
      </Dialog>
    </ChatSettingBox>
  );
};

export default ChatSetting;
