import React, { useCallback, useState } from 'react';
import { View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsButton, OsModal } from 'ossaui';

import { useAppDispatch, useAppSelector } from '../../store/hooks';
import { logout, selectUser } from '../../store/userReducers';
import { selectIm, clearAll } from '../../store/imReducers';

import './index.scss';

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
    Taro.redirectTo({
      url: '/pages/login/index'
    });
  }, [dispatch, imInstance]);

  return (
    <View className="user-wrapper">
      <View className="header">
        <OsIcon type="avatar" size={62}></OsIcon>
        <View className="name">{user.name}</View>
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
