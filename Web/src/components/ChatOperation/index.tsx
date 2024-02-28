import React, { useRef, memo, useMemo, useCallback } from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';

import ImEditor, { IRichText } from '../MessageEditor';
import { IMAccountInfoTypes } from '../../types';
import Styles from './Styles';
import { EditMessage, Participants, ReferenceMessage } from '../../store';
import { useAccountsInfo, useMessage } from '../../hooks';

interface ChatOperationPropsType {
  userInfo?: IMAccountInfoTypes;
  scrollRef?: any;
  editingMessage?: any;
}

const ChatOperation: React.FC<ChatOperationPropsType> = memo(props => {
  const { userInfo, scrollRef } = props;
  const participants = useRecoilValue(Participants);
  const imEditorRef = useRef<any>(null);
  const { sendTextMessage } = useMessage();
  const [referenceMessage, setReferenceMessage] = useRecoilState(ReferenceMessage);
  const [editingMessage, setEditingMessage] = useRecoilState(EditMessage);

  const ACCOUNTS_INFO = useAccountsInfo();
  const suggestions = participants.map(item => {
    return {
      id: item.userId,
      username: ACCOUNTS_INFO[item.userId]?.name,
    };
  });

  // 获取 富文本内容
  const handleSendClick = () => {
    imEditorRef.current?.submit();
  };

  const placeholderWithForid = useMemo(() => {
    return userInfo?.nickname ? `发送给 ${userInfo.nickname} 按Enter发送` : '可以向自己发送文件或转发消息';
  }, [userInfo?.nickname]);

  
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
        changeReplyMessage={() => {
          setReferenceMessage(null);
          setEditingMessage(null);
        }}
        editingMessage={editingMessage}
        ref={imEditorRef}
        suggestions={suggestions}
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
