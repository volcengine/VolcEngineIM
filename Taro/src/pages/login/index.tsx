import React, { useCallback, useEffect, useState } from 'react';
import { View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsIcon, OsInput, OsButton, OsPicker, OsRadio, OsRadioOption } from 'ossaui';

import { useAppDispatch, useAppSelector } from '../../store/hooks';
import { login, selectUser } from '../../store/userReducers';
import { APP_ID, USER_LIST } from '../../constants';
import { useIm } from '../..//hooks/useIm';

import './index.scss';

const range: string[] = Array.from(USER_LIST.values()).map(user => user.name);

const Index = () => {
  const user = useAppSelector(selectUser);
  const dispatch = useAppDispatch();
  const defaultIndex = range.indexOf(user.name);
  const [index, setIndex] = useState(defaultIndex);
  const [env, setEnv] = useState('prod');
  const { init } = useIm();

  const onChange = useCallback(
    newIndex => {
      if (index === newIndex) {
        return;
      }
      setIndex(newIndex);
      for (let item of USER_LIST.values()) {
        if (item.name === range[newIndex]) {
          dispatch(login(item));
          break;
        }
      }
    },
    [dispatch, index]
  );

  const onLogin = useCallback(() => {
    init(env);
    Taro.switchTab({
      url: '/pages/home/index'
    });
  }, [env, init]);

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
      <View className="label">请选择当前登录账号:</View>

      <OsPicker range={range} range-key="name" value={index} onConfirm={onChange}>
        <View className="input-wrapper">
          <OsInput className="input-value" type="text" placeholder="请选择" value={user.name} disabled />
          <OsIcon className="input-icon" type="arrows" size={30}></OsIcon>
        </View>
      </OsPicker>

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
    </View>
  );
};

export default Index;
