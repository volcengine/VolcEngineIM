import React, { memo, useCallback, useMemo, useState } from 'react';
import { Modal, Tooltip } from '@arco-design/web-react';
import { Conversation, im_proto } from '@volcengine/im-web-sdk';
import { IconClose, IconUserAdd } from '@arco-design/web-react/icon';
import { useRecoilValue } from 'recoil';

import { Avatar, ProfilePopover } from '../index';
import { getConversationAvatar, getConversationName } from '../../utils/message';
import GroupMemberAddModal from '../GroupMemberAddModal';

import Styles from './Styles';
import { useParticipant } from '../../hooks/useParticipant';
import { Participants, UserId } from '../../store';
import { ROLE } from '../../constant';
import { useAccountsInfo } from '../../hooks';

interface ChatInfoPropsTypes {
  conversation?: Conversation;
  onStartVideoCall?: () => void;
  onTopConversation?: () => void;
  onCloseConversation?: () => void;
  userInfo?: any;
}

const ChatHeader: React.FC<ChatInfoPropsTypes> = memo(props => {
  const { conversation, onCloseConversation } = props;
  const [visible, setVisible] = useState(false);
  const [selectedParticipant, setSelectedParticipant] = useState<string[]>([]);
  const { getParticipantById, addGroupParticipants } = useParticipant();
  const userId = useRecoilValue(UserId);
  const participants = useRecoilValue(Participants);

  const participant = useMemo(() => {
    return getParticipantById(userId);
  }, [participants, userId]);

  const handleCloseConversation = useCallback(() => {
    onCloseConversation?.();
  }, [onCloseConversation]);

  const handleAddParticipant = useCallback(async () => {
    if (selectedParticipant.length) {
      const result = await addGroupParticipants(conversation.id, selectedParticipant);
      if (!result) {
        return;
      }
    }
    setVisible(false);
  }, [conversation.id, selectedParticipant]);

  useAccountsInfo();
  return (
    <Styles>
      <div className="chat-info">
        <div className="avatar">
          {conversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT ? (
            <ProfilePopover userId={conversation.toParticipantUserId}>
              <Avatar url={getConversationAvatar(conversation)} size={36} />
            </ProfilePopover>
          ) : (
            <Avatar url={getConversationAvatar(conversation)} size={36} />
          )}
        </div>
        <div className="info">
          <div className="name">{getConversationName(conversation)}</div>
        </div>
      </div>
      <div className="operate-button-group">
        {conversation.type === im_proto.ConversationType.GROUP_CHAT && ROLE.Owner === participant?.role && (
          <Tooltip position="bottom" content="添加群成员">
            <span
              className="toolbar-icon close-icon"
              onClick={() => {
                setVisible(true);
              }}
            >
              <IconUserAdd />
            </span>
          </Tooltip>
        )}

        <Tooltip position="bottom" content="删除会话">
          <span className="toolbar-icon close-icon" onClick={handleCloseConversation}>
            <IconClose />
          </span>
        </Tooltip>
      </div>

      {visible && (
        <Modal
          title="添加群成员"
          visible={true}
          onOk={handleAddParticipant}
          onCancel={() => setVisible(false)}
          autoFocus={false}
          focusLock={true}
        >
          <GroupMemberAddModal setSelectedParticipant={setSelectedParticipant}></GroupMemberAddModal>
        </Modal>
      )}
    </Styles>
  );
});

export default ChatHeader;
