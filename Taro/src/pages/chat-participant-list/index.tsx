import React, { useCallback, useState } from 'react';
import { Image, View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsButton, OsModal, OsSwitch } from 'ossaui';

import { useAppDispatch, useAppSelector } from '../../store/hooks';
import { logout, selectUser } from '../../store/userReducers';
import { selectIm, clearAll, selectConversation } from '../../store/imReducers';

import './index.scss';
import { getConversationAvatar, getConversationName } from '../../utils/account';
import { useAccountsInfo } from '../../hooks/useProfileUpdater';

const ChatDetail = () => {
  const conversation = useAppSelector(selectConversation);
  const imInstance = useAppSelector(selectIm);
  const ACCOUNTS_INFO = useAccountsInfo();

  return (
    <View>
      {imInstance
        .getParticipants({
          conversation: conversation
        })
        .map(i => {
          return (
            <View style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '4px 0' }} key={i.userId}>
              <Image className="image" src={ACCOUNTS_INFO[i.userId].url} style={{ width: '80rpx', height: '80rpx' }} />
              {ACCOUNTS_INFO[i.userId].name}
            </View>
          );
        })}
    </View>
  );
};

export default ChatDetail;
