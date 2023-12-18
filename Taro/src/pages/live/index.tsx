import React, { useCallback, useEffect, useState } from 'react';
import { View } from '@tarojs/components';
import Taro from '@tarojs/taro';
import { OsToast } from 'ossaui';

import { useAppSelector } from '../../store/hooks';
import { selectIm, selectHasInit } from '../../store/imReducers';
import { selectUser } from '../../store/userReducers';
import { useLiveConversation } from '../../hooks/useLiveConversation';
import ConversationList from '../../components/convetsation-list';

import * as IMLib from '@volcengine/im-mp-sdk';

import './index.scss';

const { im_proto } = IMLib;
const { ConversationOperationStatus } = im_proto;

const Home: React.FC = () => {
  const { setCurrentConversation } = useLiveConversation();
  const bytedIMInstance = useAppSelector(selectIm);
  const user = useAppSelector(selectUser);
  const hasInit = useAppSelector(selectHasInit);
  const [conversationList, setConversationList] = useState([]);
  const [showToast, setShowToast] = useState(false);
  const [text, setText] = useState('');

  const handleClick = useCallback(
    async id => {
      // @ts-ignore
      const conv = conversationList.find(item => item.id === id);
      if (!conv) {
        return;
      }
      await setCurrentConversation({
        // @ts-ignore
        id: conv.id,
        // @ts-ignore
        shortId: conv.shortId,
        // @ts-ignore
        type: conv.type
      });
      const { statusCode, statusMsg } = await bytedIMInstance.joinLiveGroup({
        conversation: conv
      });

      if (
        [
          ConversationOperationStatus.MORE_THAN_USER_CONVERSATION_COUNT_LIMITS,
          ConversationOperationStatus.MASS_CONV_TOUCH_LIMIT
        ].includes(statusCode)
      ) {
        const info = JSON.parse(statusMsg);
        setText(`${info?.moreThanConversationCountLimitUserIds} 加群个数超过上限`);
        setShowToast(true);
        return;
      }

      if (statusCode === ConversationOperationStatus.MEMBER_IS_BLOCK) {
        setText('已被加入黑名单，无法进入直播群');
        setShowToast(true);
        return;
      }

      Taro.navigateTo({
        url: '/pages/live-chat/index'
      });
    },
    [conversationList, user, bytedIMInstance, setCurrentConversation]
  );

  const onClose = useCallback(() => {
    setShowToast(false);
  }, []);

  useEffect(() => {
    if (!bytedIMInstance || !hasInit) {
      return;
    }
    const init = async () => {
      let list = [];
      const result = await bytedIMInstance.getLiveConversationListOnline?.({
        limit: 100
      });

      list = list.concat(result.conversation);

      setConversationList(list);
    };
    init();
  }, [bytedIMInstance, hasInit]);

  return (
    <View className="home-wrapper">
      <ConversationList conversationList={conversationList} onItemClick={handleClick} />
      <OsToast isShow={showToast} text={text} duration={3000} onClose={onClose}></OsToast>
    </View>
  );
};

export default Home;
