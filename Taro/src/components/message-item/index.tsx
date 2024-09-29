import { View } from '@tarojs/components';
import { useEffect } from 'react';
import { im_proto } from '@volcengine/im-mp-sdk';
import { getCustomMsgContent, getMsgCreateTime } from '../../utils/message-preview';
import { CustomTypeEnum, MessageType } from '../../enums';
import { useAppSelector } from '../../store/hooks';
import { selectIm } from '../../store/imReducers';

import MessageCard from './message-card';

import TextItem from './text';
import ImageItem from './image';
import VideoItem from './video';
import AudioItem from './audio';

import './index.scss';
import VolcMessage from './volc';

const SUPPORT_MSG_TYPE = [
  MessageType.MESSAGE_TYPE_TEXT,
  MessageType.MESSAGE_TYPE_IMAGE,
  MessageType.MESSAGE_TYPE_VIDEO,
  MessageType.MESSAGE_TYPE_AUDIO
];

interface ItemProps {
  id: string;
  message: any;
  previewImage?: (url) => void;
  onOperate?: () => void;
}

const Item: React.FC<ItemProps> = ({ id, message, previewImage, onOperate }) => {
  const instance = useAppSelector(selectIm);
  const { type, isTimeVisible, isRecalled } = message;

  useEffect(() => {
    (async () => {
      const { MESSAGE_TYPE_AUDIO, MESSAGE_TYPE_IMAGE, MESSAGE_TYPE_VIDEO, MESSAGE_TYPE_FILE } = im_proto.MessageType;
      if ([MESSAGE_TYPE_AUDIO, MESSAGE_TYPE_IMAGE, MESSAGE_TYPE_VIDEO, MESSAGE_TYPE_FILE].includes(type)) {
        if (message?.content && !instance.validateFileUrl({ message })) {
          await instance.refreshFileUrl({ message });
        }
      }
    })();
  }, []);
  if (isRecalled) {
    return (
      <MessageCard id={id} message={message}>
        <View className="recall-text">撤回了一条消息</View>
      </MessageCard>
    );
  }

  if (MessageType.MESSAGE_TYPE_CUSTOM === type) {
    const { type: customType, text } = getCustomMsgContent(message);

    if (Number(customType) === CustomTypeEnum.notice) {
      const time = getMsgCreateTime(message);

      return (
        <View className="message-card-wrapper" id={id}>
          {/* 消息时间 */}
          {isTimeVisible && <View className="message-time">{time}</View>}

          <View className="system-message-wrapper">{text ?? ''}</View>
        </View>
      );
    }

    if (Number(customType) === CustomTypeEnum.volc) {
      return (
        <MessageCard id={id} message={message} onLongTap={onOperate}>
          <VolcMessage message={message}></VolcMessage>
        </MessageCard>
      );
    }

    return (
      <MessageCard id={id} message={message}>
        <View className="not-support-type">暂不支持该类型消息</View>
      </MessageCard>
    );
  }

  return (
    <MessageCard id={id} message={message} onLongTap={onOperate}>
      {MessageType.MESSAGE_TYPE_TEXT === type && <TextItem message={message} />}

      {MessageType.MESSAGE_TYPE_IMAGE === type && <ImageItem message={message} onClick={previewImage} />}

      {MessageType.MESSAGE_TYPE_VIDEO === type && <VideoItem message={message} />}

      {MessageType.MESSAGE_TYPE_AUDIO === type && <AudioItem message={message} />}

      {!SUPPORT_MSG_TYPE.includes(type) && <View className="not-support-type">暂不支持该类型消息</View>}
    </MessageCard>
  );
};

export default Item;
