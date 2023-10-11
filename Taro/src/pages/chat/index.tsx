import React, { useCallback, useState } from 'react';
import { View } from '@tarojs/components';
import { OsImagePreview } from 'ossaui';

import { selectConversation, selectMessageList } from '../../store/imReducers';
import { useAppSelector } from '../../store/hooks';
import { getBottomHeight } from '../../utils/dom';
import { useMessage } from '../../hooks/useMessage';

import Edit from '../../components/edit';
import MessageList from '../../components/message-list';

import './index.scss';

const paddingBottom = getBottomHeight();

const Chat: React.FC = () => {
  const conversation = useAppSelector(selectConversation);
  const messageList = useAppSelector(selectMessageList);
  const { sendTextMessage, sendImageMessage, sendVideoMessage, sendAudioMessage, markConversationRead } = useMessage();
  const [isShowImagePreview, setShowImagePreview] = useState(false);
  const [imagePreviewUrl, setImagePreviewUrl] = useState({ img: '' });

  const previewImage = useCallback(url => {
    setImagePreviewUrl({
      img: url
    });
    setShowImagePreview(true);
  }, []);

  return (
    <View className="chat-wrapper" style={{ paddingBottom: paddingBottom + 'px' }}>
      {/* 消息列表 */}
      <MessageList
        messageList={messageList}
        previewImage={previewImage}
        markConversationRead={markConversationRead}
        unreadCount={conversation.unreadCount}
      />

      {/* 编辑区域 */}
      <Edit
        sendTextMessage={sendTextMessage}
        sendImageMessage={sendImageMessage}
        sendVideoMessage={sendVideoMessage}
        sendAudioMessage={sendAudioMessage}
        showFileSendIcon={conversation.isGeneralConversation}
      />

      <OsImagePreview
        show={isShowImagePreview}
        onClose={() => {
          setShowImagePreview(false);
        }}
        imagesArr={[imagePreviewUrl]}
        showPagination={false}
        showBack={false}
      ></OsImagePreview>
    </View>
  );
};

export default Chat;
