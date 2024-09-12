import React, { useCallback, useState } from 'react';
import { Text, View } from '@tarojs/components';
import { OsImagePreview, OsNavBar } from 'ossaui';

import { selectConversation, selectMessageList } from '../../store/imReducers';
import { useAppSelector } from '../../store/hooks';
import { getBottomHeight } from '../../utils/dom';
import { useMessage } from '../../hooks/useMessage';

import Edit from '../../components/edit';
import MessageList from '../../components/message-list';

import './index.scss';
import Taro from '@tarojs/taro';
import { getConversationName } from '../../utils/account';

const paddingBottom = getBottomHeight();

const Chat: React.FC = () => {
  const conversation = useAppSelector(selectConversation);
  const messageList = useAppSelector(selectMessageList);
  const {
    sendTextMessage,
    sendImageMessage,
    sendVideoMessage,
    sendAudioMessage,
    markConversationRead,
    sendVolcMessage
  } = useMessage();
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
      <OsNavBar
        // @ts-ignore
        title={
          <Text
            onClick={() => {
              console.log('click');
              Taro.navigateTo({
                url: '/pages/chat-detail/index'
              });
            }}
          >
            {getConversationName(conversation)}
          </Text>
        }
        leftIcons={['return']}
        onLeftIconClick={item => {
          Taro.navigateBack({});
          return {};
        }}
        customStyle={{ paddingTop: '60rpx', height: '160rpx' }}
      ></OsNavBar>
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
        sendVolcMessage={sendVolcMessage}
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
