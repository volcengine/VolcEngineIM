import React, { useRef, memo, useMemo, useCallback } from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';

import ImEditor, { IRichText } from '../MessageEditor';
import { IMAccountInfoTypes } from '../../types';
import Styles from './Styles';
import { BytedIMInstance, CurrentConversation, EditMessage, Participants, ReferenceMessage } from '../../store';
import { useAccountsInfo, useMessage, useBot } from '../../hooks';

import { im_proto } from '@volcengine/im-web-sdk';
import { Message as ArcoMessage } from '@arco-design/web-react';

interface ChatOperationPropsType {
  userInfo?: IMAccountInfoTypes;
  scrollRef?: any;
  editingMessage?: any;
}

const ChatOperation: React.FC<ChatOperationPropsType> = memo(props => {
  const { userInfo, scrollRef } = props;
  const participants = useRecoilValue(Participants);
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const imEditorRef = useRef<any>(null);
  const { sendTextMessage } = useMessage();
  const [referenceMessage, setReferenceMessage] = useRecoilState(ReferenceMessage);
  const [editingMessage, setEditingMessage] = useRecoilState(EditMessage);

  const { sendFileMessage, sendImageMessage, sendVideoMessage, sendAudioMessage, sendVolcMessage, sendCouponMessage } =
    useMessage();
  const ACCOUNTS_INFO = useAccountsInfo();
  const suggestions = participants.map(item => {
    return {
      id: item.userId,
      username: ACCOUNTS_INFO[item.userId]?.name,
    };
  });

  const { id, toParticipantUserId } = currentConversation;

  const { isBotConversion } = useBot();
  const isBotConv = useMemo(() => isBotConversion(toParticipantUserId), [isBotConversion, toParticipantUserId]);

  // 获取 富文本内容
  const handleSendClick = () => {
    imEditorRef.current?.submit();
  };

  const placeholderWithForid = useMemo(() => {
    return userInfo?.nickname ? `发送给 ${userInfo.nickname} 按Enter发送` : '可以向自己发送文件或转发消息';
  }, [userInfo?.nickname]);

  
  const handleSubmit = useCallback(
    (richText: IRichText) => {
      if (!richText.text?.trim()) {
        ArcoMessage.error('不能发送空白消息');
        return;
      }
      sendTextMessage?.({ ...richText });
      scrollRef?.current?.scrollToBottom();
    },
    [sendTextMessage, scrollRef]
  );

  const onMessageTyping = () => {
    if (currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
      bytedIMInstance.sendP2PMessage({
        conversation: currentConversation,
        sendType: im_proto.SendType.BY_CONVERSATION,
        msgType: im_proto.MessageType.MESSAGE_TYPE_CUSTOM_P2P,
        content: JSON.stringify({
          type: 1000,
          ext: '',
          message_type: im_proto.MessageType.MESSAGE_TYPE_TEXT,
        }),
      });
    }
  };

  const getToolBarList = useCallback((): any => {
    if (isBotConv) {
      return [
        {
          key: 'Emoji',
          use: true,
        },
      ];
    }
    return [
      {
        key: 'Emoji',
        use: true,
      },
      {
        key: 'Mention',
        use: true,
        params: {
          suggestions: suggestions,
        },
      },
      {
        key: 'Image',
        use: true,
        params: {
          sendMessage: sendImageMessage,
        },
      },
      {
        key: 'Video',
        use: true,
        params: {
          sendMessage: sendVideoMessage,
        },
      },
      {
        key: 'File',
        use: true,
        params: {
          sendMessage: sendFileMessage,
        },
      },
      {
        key: 'Audio',
        use: true,
        params: {
          sendMessage: sendAudioMessage,
        },
      },
      {
        key: 'Volc',
        use: true,
        params: {
          sendMessage: sendVolcMessage,
        },
      },
      {
        key: 'Coupon',
        use: true,
        params: {
          sendMessage: sendCouponMessage,
        },
      },
      {
        key: 'MorePanel',
        use: false,
      },
    ];
  }, [sendImageMessage, sendFileMessage, sendAudioMessage, sendVolcMessage]);

  return (
    <Styles>
      <ImEditor
        placeholder={placeholderWithForid}
        onSubmit={handleSubmit}
        repliedMessage={referenceMessage}
        changeReplyMessage={() => {
          setReferenceMessage(null);
          setEditingMessage(null);
        }}
        editingMessage={editingMessage}
        ref={imEditorRef}
        suggestions={suggestions}
        onMessageTyping={onMessageTyping}
        toolBarList={getToolBarList()}
      />

      <div className="input-footer">
        <button className="send-button" onClick={handleSendClick}>
          发送
        </button>
      </div>
    </Styles>
  );
});

export default ChatOperation;
