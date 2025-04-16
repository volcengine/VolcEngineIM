import React, { memo, useCallback, useEffect, useMemo, useState } from 'react';
import { Modal, Tooltip } from '@arco-design/web-react';
import { Conversation, IMEvent, im_proto } from '@volcengine/im-web-sdk';
import { IconClose, IconUserAdd } from '@arco-design/web-react/icon';
import { useRecoilValue } from 'recoil';

import { Avatar, ProfilePopover } from '../index';
import { getConversationAvatar, getConversationName } from '../../utils/message';
import GroupMemberAddModal from '../GroupMemberAddModal';

import Styles from './Styles';
import { useParticipant } from '../../hooks/useParticipant';
import { BytedIMInstance, Participants, UserId } from '../../store';
import { ROLE } from '../../constant';
import { useAccountsInfo } from '../../hooks';
import { useDebounceFn, useThrottleFn } from 'ahooks';

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

  // const handleCloseConversation = useCallback(() => {
  //   onCloseConversation?.();
  // }, [onCloseConversation]);

  const { run: handleCloseConversation } = useThrottleFn(
    () => {
      console.log('onCloseConversation:', Date.now());
      onCloseConversation?.();
    },
    { wait: 1000 }
  );

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
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const [isInputtingText, setIsInputtingText] = useState(false);
  const [isInputtingVoice, setIsInputtingVoice] = useState(false);

  const { run: delaySetNoInputting } = useDebounceFn(
    () => {
      setIsInputtingText(false);
      setIsInputtingVoice(false);
    },
    {
      wait: 3000,
    }
  );

  useEffect(() => {
    const sub = bytedIMInstance.event.subscribe(IMEvent.ReceiveNewP2PMessage, msg => {
      if (
        msg.conversationId === conversation.id &&
        msg.sender !== userId &&
        msg.type === im_proto.MessageType.MESSAGE_TYPE_CUSTOM_P2P &&
        String(msg.contentJson.type) === '1000' &&
        msg.contentJson.message_type === im_proto.MessageType.MESSAGE_TYPE_TEXT
      ) {
        setIsInputtingText(true);
        delaySetNoInputting();
      }
      if (
        msg.conversationId === conversation.id &&
        msg.sender !== userId &&
        msg.type === im_proto.MessageType.MESSAGE_TYPE_CUSTOM_P2P &&
        String(msg.contentJson.type) === '1000' &&
        msg.contentJson.message_type === im_proto.MessageType.MESSAGE_TYPE_AUDIO
      ) {
        setIsInputtingVoice(true);
        delaySetNoInputting();
      }
    });

    const sub2 = bytedIMInstance.event.subscribe(IMEvent.ReceiveNewMessage, msg => {
      if (msg.conversationId === conversation.id) {
        setIsInputtingText(false);
        setIsInputtingVoice(false);
      }
    });

    return () => {
      bytedIMInstance?.event.unsubscribe(IMEvent.ReceiveNewP2PMessage, sub);
      bytedIMInstance?.event.unsubscribe(IMEvent.ReceiveNewMessage, sub2);

      setIsInputtingText(false);
      setIsInputtingVoice(false);
    };
  }, [conversation.id]);

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
          <div className="name">
            {isInputtingText ? '对方正在输入中' : isInputtingVoice ? '对方正在讲话' : getConversationName(conversation)}
          </div>
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
