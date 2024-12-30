import React, { useCallback, useState } from 'react';
import { View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsLoading, OsNavBar, OsModal, OsToast } from 'ossaui';

import { useAppSelector } from '../../store/hooks';
import { selectConversationList, selectIm } from '../../store/imReducers';
import { useConversation } from '../../hooks/useConversation';
import ConversationList from '../../components/convetsation-list';
import { useImEvent } from '../..//hooks/useImEvent';

import './index.scss';

const Home: React.FC = () => {
  // TODO: 替换为全局变量
  const loading = false;
  const conversationList = useAppSelector(selectConversationList);
  const { setCurrentConversation } = useConversation();
  const [showConfirm, setShowConfirm] = useState(false);
  const [toastMessage, setToastMessage] = useState('');
  const instance = useAppSelector(selectIm);

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
      <OsNavBar
        title="会话"
        leftIcons={['add', 'delete']}
        onLeftIconClick={item => {
          if (item === 'add') {
            Taro.navigateTo({
              url: '/pages/create-chat/index'
            });
          } else {
            setShowConfirm(true);
            return {};
          }
        }}
        customStyle={{ paddingTop: '60rpx', height: '160rpx' }}
      ></OsNavBar>
      {loading ? (
        <View className="loading-wrapper">
          <OsLoading size={60}></OsLoading>
        </View>
      ) : (
        <ConversationList conversationList={conversationList} onItemClick={handleClick} />
      )}

      <OsModal
        title="清除未读"
        cancelText="取消"
        confirmText="确定"
        content="确定要清除所有未读提醒？"
        isShow={showConfirm}
        onCancel={() => setShowConfirm(false)}
        onClose={() => setShowConfirm(false)}
        onConfirm={async () => {
          setShowConfirm(false);
          try {
            await instance.batchMarkConversationRead();
            setToastMessage('清除成功');
          } catch (e) {
            setToastMessage('清除失败');
          }
        }}
      ></OsModal>

      <OsToast
        isShow={!!toastMessage}
        text={toastMessage}
        duration={1000}
        onClose={() => {
          setToastMessage('');
        }}
      ></OsToast>
    </View>
  );
};

export default Home;
