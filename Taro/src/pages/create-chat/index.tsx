import React, { useCallback, useState } from 'react';
import { View } from '@tarojs/components';
import { Friend, im_proto, UserProfile } from '@volcengine/im-mp-sdk';
import { OsButton, OsCol, OsImagePreview, OsInput, OsList, OsNavBar, OsRadio, OsRadioOption, OsRow } from 'ossaui';

import { selectConversation, selectIm, selectMessageList } from '../../store/imReducers';
import { useAppSelector } from '../../store/hooks';
import { getBottomHeight } from '../../utils/dom';

import './index.scss';
import Taro from '@tarojs/taro';
import { useConversation } from '../../hooks/useConversation';

const paddingBottom = getBottomHeight();

const Chat: React.FC = () => {
  const bytedIMInstance = useAppSelector(selectIm);
  const [chatType, setChatType] = useState(0);
  const [inputUserId, setInputUserId] = useState('');
  const [inputUserIdList, setInputUserIdList] = useState<string[]>([]);
  const { setCurrentConversation } = useConversation();
  const [inputChatName, setInputChatName] = useState('');

  return (
    <View className="chat-wrapper" style={{ paddingBottom: paddingBottom + 'px' }}>
      <OsRadio type="row">
        <OsRadioOption value={chatType} optionValue={0} onClick={setChatType} type="row">
          发起单聊
        </OsRadioOption>
        <OsRadioOption value={chatType} optionValue={1} onClick={setChatType} type="row">
          发起群聊
        </OsRadioOption>
      </OsRadio>
      {chatType === 0 ? (
        <OsInput
          label="用户 ID"
          placeholder="用户 ID"
          placeholderStyle="color: #7f7f7f;"
          value={inputUserId}
          onChange={v => {
            setInputUserId(v);
          }}
        ></OsInput>
      ) : (
        <>
          <OsInput
            label="群聊名称"
            placeholder="群聊名称"
            placeholderStyle="color: #7f7f7f;"
            value={inputChatName}
            onChange={v => {
              setInputChatName(v);
            }}
          ></OsInput>
          <View className="label">已选择 {inputUserIdList.length} 个用户</View>
          <OsRow>
            <OsCol span="18">
              <OsInput
                label="用户 ID"
                placeholder="用户 ID"
                placeholderStyle="color: #7f7f7f;"
                value={inputUserId}
                onChange={v => {
                  setInputUserId(v);
                }}
              ></OsInput>
            </OsCol>

            <OsCol span="6">
              <OsButton
                type="primary"
                size="block"
                bdColor="transparent"
                startBgColor="#EB767A"
                endBgColor="#DD1A21"
                onClick={() => {
                  if (inputUserId) {
                    if (inputUserIdList.includes(inputUserId)) {
                      Taro.showToast({
                        title: '已存在',
                        icon: 'none'
                      });
                      return;
                    }
                    setInputUserIdList(v => [...v, inputUserId]);
                  }
                  setInputUserId('');
                }}
              >
                添加
              </OsButton>
            </OsCol>
          </OsRow>
          {inputUserIdList.map(i => (
            <OsList title={i} onClick={e => setInputUserIdList(v => v.filter(j => i !== j))}></OsList>
          ))}
        </>
      )}
      <OsButton
        type="primary"
        size="block"
        bdColor="transparent"
        disabled={!inputUserId && !inputUserIdList.length}
        startBgColor="#EB767A"
        endBgColor="#DD1A21"
        onClick={async () => {
          const r = await bytedIMInstance.createConversation({
            participants: chatType === 0 ? [inputUserId] : inputUserIdList,
            type: chatType === 1 ? im_proto.ConversationType.GROUP_CHAT : im_proto.ConversationType.ONE_TO_ONE_CHAT,
            name: inputChatName
          });
          setCurrentConversation({ id: r.payload.id });
          Taro.redirectTo({
            url: '/pages/chat/index'
          });
        }}
      >
        创建聊天
      </OsButton>
    </View>
  );
};

export default Chat;
