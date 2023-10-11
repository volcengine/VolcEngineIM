import { View } from '@tarojs/components';

import { getCustomMsgContent, getMsgCreateTime } from '../../utils/message-preview';
import { CustomTypeEnum, MessageType } from '../../enums';

import MessageCard from './message-card';

import TextItem from './text';
import ImageItem from './image';
import VideoItem from './video';
import AudioItem from './audio';

import './index.scss';

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
}

const Item: React.FC<ItemProps> = ({ id, message, previewImage }) => {
  const { type, isTimeVisible, isRecalled } = message;

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
        <MessageCard id={id} message={message}>
          <View className="not-support-type">暂不支持该类型消息</View>
        </MessageCard>
      );
    }
  }

  return (
    <MessageCard id={id} message={message}>
      {MessageType.MESSAGE_TYPE_TEXT === type && <TextItem message={message} />}

      {MessageType.MESSAGE_TYPE_IMAGE === type && <ImageItem message={message} onClick={previewImage} />}

      {MessageType.MESSAGE_TYPE_VIDEO === type && <VideoItem message={message} />}

      {MessageType.MESSAGE_TYPE_AUDIO === type && <AudioItem message={message} />}

      {!SUPPORT_MSG_TYPE.includes(type) && <View className="not-support-type">暂不支持该类型消息</View>}
    </MessageCard>
  );
};

export default Item;
