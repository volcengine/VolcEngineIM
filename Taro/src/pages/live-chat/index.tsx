import React, { useState } from 'react';
import Taro, { useDidHide, useUnload } from '@tarojs/taro';
import { useDispatch } from 'react-redux';
import { Text, View } from '@tarojs/components';

import { selectConversation, selectMessageList, selectIm, setConversation } from '../../store/imReducers';
import { useAppSelector } from '../../store/hooks';
import { getBottomHeight } from '../../utils/dom';
import { useMessage } from '../../hooks/useMessage';
import { selectUser } from '../../store/userReducers';

import Edit from '../../components/edit';
import MessageList from '../../components/message-list';

import './index.scss';
import { OsNavBar } from 'ossaui';
import { getConversationName } from '../../utils/account';
import { useRequest } from 'taro-hooks';
import { useRecoilState } from 'recoil';
import { LiveMemberCount } from '../../store';

const paddingBottom = getBottomHeight();

const Chat: React.FC = () => {
  const conversation = useAppSelector(selectConversation);
  const messageList = useAppSelector(selectMessageList);
  const bytedIMInstance = useAppSelector(selectIm);
  const user = useAppSelector(selectUser);
  const dispatch = useDispatch();
  const { sendTextMessage, sendImageMessage, sendVideoMessage, sendAudioMessage, markConversationRead } = useMessage();
  const [liveConversationMemberCount, setLiveConversationMemberCount] = useRecoilState(LiveMemberCount);
  useUnload(async () => {
    await bytedIMInstance.leaveLiveGroup({
      conversation: conversation
    });
    dispatch(setConversation(null));
  });

  useRequest(
    async () => {
      const count = (
        await bytedIMInstance.getLiveParticipantCountOnline({
          conversation: conversation
        })
      )?.count;
      setLiveConversationMemberCount(count);
    },
    {
      refreshDeps: [conversation],
      debounceWait: 300,
      pollingInterval: 10000
    }
  );

  return (
    <View className="chat-wrapper" style={{ paddingBottom: paddingBottom + 'px' }}>
      <OsNavBar
        // @ts-ignore
        title={
          <Text
            onClick={() => {
              Taro.navigateTo({
                url: '/pages/live-chat-detail/index'
              });
            }}
          >
            {conversation.coreInfo.name} ({liveConversationMemberCount})
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
