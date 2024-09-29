import React, { useCallback, useEffect, useState } from 'react';
import { View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsInput, OsButton, OsPicker, OsToast, OsRadio, OsRadioOption } from 'ossaui';

import { useAppDispatch, useAppSelector } from '../../store/hooks';
import { login, selectUser } from '../../store/userReducers';
import { APP_ID, USER_LIST } from '../../constants';
import { useIm } from '../..//hooks/useIm';

import './index.scss';

const Index = () => {
  const dispatch = useAppDispatch();
  const [inputUserId, setInputUserId] = useState('10013');
  const [env, setEnv] = useState('prod');
  const [show, setShow] = useState(false);
  const { init } = useIm();

  useEffect(() => {
    dispatch(
      login({
        id: inputUserId,
        name: inputUserId
      })
    );
  }, [inputUserId]);

  const onLogin = useCallback(() => {
    init(env);
    if (!/^\d+$/.test(inputUserId)) {
      setShow(true);
      return;
    }
    Taro.switchTab({
      url: '/pages/home/index'
    });
  }, [env, init, inputUserId]);

  useEffect(() => {
    // @ts-ignore
    if (APP_ID === 0) {
      Taro.showModal({
        title: '未配置 APP_ID',
        content: '请参考 README.md 步骤，在 src/constants.ts 配置自己的 APP_ID'
      });
    }
  }, []);
  return (
    <View className="login-wrapper">
      <View className="label">请输入登录用户 ID:</View>
      <OsInput
        placeholder="用户 ID"
        placeholderStyle="color: #7f7f7f;"
        value={inputUserId}
        onChange={newId => {
          setInputUserId(newId);
        }}
        type={'number'}
      ></OsInput>

      <OsRadio type="row">
        <OsRadioOption value={env} optionValue="prod" onClick={setEnv} type="row">
          prod
        </OsRadioOption>
        { ''}
      </OsRadio>

      <View className="btn-wrapper" onClick={onLogin}>
        <OsButton type="primary" size="block" bdColor="transparent" startBgColor="#EB767A" endBgColor="#DD1A21">
          登录
        </OsButton>
      </View>
      <OsToast
        isShow={show}
        text={'请输入合法ID'}
        duration={1000}
        onClose={() => {
          setShow(false);
        }}
      ></OsToast>
    </View>
  );
};

export default Index;
