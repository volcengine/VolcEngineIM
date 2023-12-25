import React, { useRef, memo, useMemo, useCallback, useEffect, useState } from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';

import ImEditor, { IRichText } from '../../../../components/MessageEditor';
import { IMAccountInfoTypes } from '../../../../types';
import { CurrentConversation, IsMuted, Participants, ReferenceMessage, SendMessagePriority } from '../../../../store';
import { EDITOR_TYPE } from '../../../../constant';
import { useAccountsInfo, useMessage } from '../../../../hooks';

import Styles from './Styles';
import { Select } from '@arco-design/web-react';
import { im_proto } from '@volcengine/im-web-sdk';

interface ChatOperationPropsType {
  userInfo?: IMAccountInfoTypes;
  scrollRef?: any;
}

export const ChatOperation: React.FC<ChatOperationPropsType> = memo(props => {
  const { userInfo, scrollRef } = props;
  const participants = useRecoilValue(Participants);
  const imEditorRef = useRef<any>(null);
  const { sendTextMessage, sendVolcMessage, sendImageMessage, sendVideoMessage, sendFileMessage, sendAudioMessage } =
    useMessage();
  const [referenceMessage, setReferenceMessage] = useRecoilState(ReferenceMessage);
  const ACCOUNTS_INFO = useAccountsInfo();

  const currentConversation = useRecoilValue(CurrentConversation);
  const { userInfo: convUserInfo, isBlocked } = currentConversation;

  const isMuted = useRecoilValue(IsMuted);
  const isChatMuted = isMuted ?? convUserInfo.blocked;

  const editorType = isChatMuted ? EDITOR_TYPE.CAN_NOT_EDIT : EDITOR_TYPE.SIMPLE;

  const getToolBarList = useCallback(
    (): any => [
      {
        key: 'Emoji',
        use: true,
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
        key: 'MorePanel',
        use: false,
      },
    ],
    [sendVolcMessage]
  );

  const suggestions = participants.map(item => {
    return {
      id: item.userId,
      username: ACCOUNTS_INFO[item.userId]?.name,
    };
  });

  // 获取 富文本内容
  const handleSendClick = () => {
    if (isChatMuted) {
      return;
    }
    imEditorRef.current?.submit();
  };

  const placeholderWithForid = useMemo(() => {
    return userInfo?.nickname ? `发送给 ${userInfo.nickname} 按Enter发送` : '可以向自己发送文件或转发消息';
  }, [userInfo?.nickname]);

  const [priority, setPriority] = useRecoilState(SendMessagePriority);

  
  const handleSubmit = useCallback(
    (richText: IRichText) => {
      sendTextMessage?.({ ...richText });
      scrollRef?.current?.scrollToBottom();
    },
    [sendTextMessage, scrollRef]
  );

  return (
    <Styles>
      <ImEditor
        placeholder={placeholderWithForid}
        onSubmit={handleSubmit}
        repliedMessage={referenceMessage}
        changeReplyMessage={setReferenceMessage}
        ref={imEditorRef}
        suggestions={suggestions}
        toolBarList={getToolBarList()}
        editorType={editorType}
      />

      <div className="input-footer">
        {isBlocked && <div style={{ wordBreak: 'keep-all', marginRight: '10px' }}>全体禁言中</div>}
        <Select
          style={{ minWidth: '30px', marginRight: '10px' }}
          value={priority}
          onChange={value => setPriority(value)}
        >
          <Select.Option value={im_proto.MessagePriority.HIGH}>消息优先级：高</Select.Option>
          <Select.Option value={im_proto.MessagePriority.NORMAL}>消息优先级：普通</Select.Option>
          <Select.Option value={im_proto.MessagePriority.LOW}>消息优先级：低</Select.Option>
        </Select>
        <button className="send-button" onClick={handleSendClick}>
          {isChatMuted ? '禁言' : '发送'}
        </button>
      </div>
    </Styles>
  );
});
