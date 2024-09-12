import React, { useCallback, useState } from 'react';
import { View } from '@tarojs/components';
import { OsButton, OsCol, OsImagePreview, OsInput, OsList, OsNavBar, OsRadio, OsRadioOption, OsRow } from 'ossaui';

import { selectConversation, selectIm, selectMessageList } from '../../store/imReducers';
import { useAppSelector } from '../../store/hooks';
import { getBottomHeight } from '../../utils/dom';

import './index.scss';
import Taro from '@tarojs/taro';
import { useConversation } from '../../hooks/useConversation';
import { im_proto } from '@volcengine/im-mp-sdk';
import { useLiveConversation } from '../../hooks/useLiveConversation';

const paddingBottom = getBottomHeight();

const Chat: React.FC = () => {
  const bytedIMInstance = useAppSelector(selectIm);
  const { setCurrentConversation } = useLiveConversation();
  const [inputChatName, setInputChatName] = useState('');

  return (
    <View className="chat-wrapper" style={{ paddingBottom: paddingBottom + 'px' }}>
      <OsInput
        label="直播群名称"
        placeholder="直播群名称"
        placeholderStyle="color: #7f7f7f;"
        value={inputChatName}
        onChange={v => {
          setInputChatName(v);
        }}
      ></OsInput>

      <OsButton
        type="primary"
        size="block"
        bdColor="transparent"
        startBgColor="#EB767A"
        endBgColor="#DD1A21"
        onClick={async () => {
          const r = await bytedIMInstance.createConversation({
            type: im_proto.ConversationType.MASS_CHAT,
            participants: [],
            name: inputChatName
          });
          await bytedIMInstance.joinLiveGroup({ conversation: r.payload });
          await setCurrentConversation(r.payload);

          Taro.redirectTo({
            url: '/pages/live-chat/index'
          });
        }}
      >
        创建直播群
      </OsButton>
    </View>
  );
};

export default Chat;
