import React, { useCallback } from 'react';
import { View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsLoading } from 'ossaui';

import { useAppSelector } from '../../store/hooks';
import { selectConversationList } from '../../store/imReducers';
import { useConversation } from '../../hooks/useConversation';
import ConversationList from '../../components/convetsation-list';
import { useImEvent } from '../..//hooks/useImEvent';

import './index.scss';

const Home: React.FC = () => {
  // TODO: 替换为全局变量
  const loading = false;
  const conversationList = useAppSelector(selectConversationList);
  const { setCurrentConversation } = useConversation();

  useImEvent();

  const handleClick = useCallback(
    id => {
      setCurrentConversation({ id });
      Taro.navigateTo({
        url: '/pages/chat/index'
      });
    },
    [setCurrentConversation]
  );

  return (
    <View className="home-wrapper">
      {loading ? (
        <View className="loading-wrapper">
          <OsLoading size={60}></OsLoading>
        </View>
      ) : (
        <ConversationList conversationList={conversationList} onItemClick={handleClick} />
      )}
    </View>
  );
};

export default Home;
