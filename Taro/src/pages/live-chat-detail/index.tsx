import React, { useCallback, useMemo, useState } from 'react';
import { Image, View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsButton, OsModal, OsSwitch } from 'ossaui';

import { useAppDispatch, useAppSelector } from '../../store/hooks';
import { logout, selectUser } from '../../store/userReducers';
import { selectIm, clearAll, selectConversation } from '../../store/imReducers';

import './index.scss';
import { ACCOUNTS_INFO, getConversationAvatar, getConversationName } from '../../utils/account';
import { useConversation } from '../../hooks/useConversation';
import { useRecoilState } from 'recoil';
import { LiveMemberCount } from '../../store';

const ChatDetail = () => {
  const conversation = useAppSelector(selectConversation);
  const imInstance = useAppSelector(selectIm);
  const user = useAppSelector(selectUser);
  const [liveConversationMemberCount, setLiveConversationMemberCount] = useRecoilState(LiveMemberCount);

  let id = conversation.id;
  let owner = conversation.coreInfo.owner;
  let userId = user.id;
  const isOwner = useMemo(() => owner === userId, [owner, userId]);
  const isGroup = useMemo(() => !/\d:1:/.test(id), [id]);
  const { leaveGroupConversation, dissolveGroupConversation } = useConversation();
  return (
    <View>
      <View style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
        <Image
          className="image"
          src={getConversationAvatar(conversation)}
          style={{ width: '80rpx', height: '80rpx' }}
        />
        {getConversationName(conversation)}
      </View>
      <View
        onClick={() => {
          Taro.navigateTo({
            url: '/pages/live-chat-participant-list/index'
          });
        }}
      >
        群成员({liveConversationMemberCount})
      </View>

      {isGroup && (
        <View>
          <OsButton
            type="primary"
            onClick={() => {
              imInstance.leaveConversation({ conversation });
              Taro.switchTab({ url: '/pages/live/index' });
            }}
          >
            退出群组
          </OsButton>
          {isOwner && (
            <OsButton
              type="primary"
              onClick={() => {
                imInstance.dissolveConversation({ conversation });
                Taro.switchTab({ url: '/pages/live/index' });
              }}
            >
              解散群组
            </OsButton>
          )}
        </View>
      )}
    </View>
  );
};

export default ChatDetail;
