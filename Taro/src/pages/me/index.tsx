import React, { useCallback, useState } from 'react';
import { Image, View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsButton, OsModal } from 'ossaui';

import { useAppDispatch, useAppSelector } from '../../store/hooks';
import { logout, selectUser } from '../../store/userReducers';
import { selectIm, clearAll } from '../../store/imReducers';

import './index.scss';
import { ACCOUNTS_INFO } from '../../utils/account';

const User = () => {
  const user = useAppSelector(selectUser);
  const imInstance = useAppSelector(selectIm);
  const dispatch = useAppDispatch();
  const [showBase, setShowBase] = useState(false);

  const onLogout = useCallback(() => {
    setShowBase(false);
    imInstance.dispose();
    dispatch(clearAll());
    dispatch(logout());

    Taro.reLaunch({
      url: '/pages/login/index'
    });
  }, [dispatch, imInstance]);

  return (
    <View className="user-wrapper">
      <View className="header">
        <Image
          className="avatar"
          src={ACCOUNTS_INFO[user.id].url}
          style={{ borderRadius: 100, width: '62rpx', height: '62rpx' }}
        />
        <View className="name">{ACCOUNTS_INFO[user.id]?.name}</View>
      </View>

      <View className="container" onClick={() => setShowBase(true)}>
        <OsButton type="primary" size="block" bdColor="transparent" startBgColor="#EB767A" endBgColor="#DD1A21">
          退出登录
        </OsButton>
      </View>

      <OsModal
        title="提示"
        cancelText="取消"
        confirmText="确定"
        content="确定退出登录？"
        isShow={showBase}
        showCloseIcon={false}
        onCancel={() => setShowBase(false)}
        onClose={() => setShowBase(false)}
        onConfirm={() => onLogout()}
      ></OsModal>
    </View>
  );
};

export default User;
