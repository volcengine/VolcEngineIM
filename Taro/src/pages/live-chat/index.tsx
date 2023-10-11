import React from 'react';
import { useUnload } from '@tarojs/taro';
import { useDispatch } from 'react-redux';
import { View } from '@tarojs/components';

import { selectConversation, selectMessageList, selectIm, setConversation } from '../../store/imReducers';
import { useAppSelector } from '../../store/hooks';
import { getBottomHeight } from '../../utils/dom';
import { useMessage } from '../../hooks/useMessage';
import { selectUser } from '../../store/userReducers';

import Edit from '../../components/edit';
import MessageList from '../../components/message-list';

import './index.scss';

const paddingBottom = getBottomHeight();

const Chat: React.FC = () => {
  const conversation = useAppSelector(selectConversation);
  const messageList = useAppSelector(selectMessageList);
  const bytedIMInstance = useAppSelector(selectIm);
  const user = useAppSelector(selectUser);
  const dispatch = useDispatch();
  const { sendTextMessage, sendImageMessage, sendVideoMessage, sendAudioMessage, markConversationRead } = useMessage();

  useUnload(async () => {
    await bytedIMInstance.removeParticipants({
      conversation: conversation,
      participant: [user.id]
    });
    dispatch(setConversation(null));
  });

  return (
    <View className="chat-wrapper" style={{ paddingBottom: paddingBottom + 'px' }}>
      {/* 消息列表 */}
      <MessageList
        messageList={messageList || []}
        markConversationRead={conversation.type == 100 ? () => {} : markConversationRead}
      />

      {/* 编辑区域 */}
      <Edit
        sendTextMessage={sendTextMessage}
        sendImageMessage={sendImageMessage}
        sendVideoMessage={sendVideoMessage}
        sendAudioMessage={sendAudioMessage}
        showFileSendIcon={conversation.isGeneralConversation}
      />
    </View>
  );
};

export default Chat;
