import React, { ComponentType } from 'react';
import { im_proto } from '@volcengine/im-web-sdk';

import AudioMessage from './AudioMessage';
import ImageMessage from './ImageMessage';
import SystemMessage from './SystemMessage';
import TextMessage from './TextMessage';
import UnknownMessage from './UnknownMessage';
import VideoMessage from './VideoMessage';
import RecalledMessage from './RecalledMessage';
import FileMessage from './FileMessage';
import VolcMessage from './VolcMessage';
import CustomMessage from './CustomMessage';

export interface IMessageCardsMap {
  [key: string]: ComponentType<any>;
}

const MessageCardsMap: IMessageCardsMap = {
  [`${im_proto.MessageType.MESSAGE_TYPE_TEXT}`]: TextMessage,
  [`${im_proto.MessageType.MESSAGE_TYPE_IMAGE}`]: ImageMessage,
  [`${im_proto.MessageType.MESSAGE_TYPE_AUDIO}`]: AudioMessage,
  [`${im_proto.MessageType.MESSAGE_TYPE_VIDEO}`]: VideoMessage,
  [`${im_proto.MessageType.MESSAGE_TYPE_VIDEO_V2}`]: VideoMessage,
  [`${im_proto.MessageType.MESSAGE_TYPE_FILE}`]: FileMessage,
  [`${im_proto.MessageType.MESSAGE_TYPE_CUSTOM}`]: CustomMessage,
};

const getMessageComponent = (type: im_proto.MessageType, isRecalled: boolean) => {
  if (!type) {
    return;
  }
  let Cmp = MessageCardsMap[type];

  if (isRecalled) {
    Cmp = RecalledMessage;
  }

  return Cmp ?? (UnknownMessage as any);
};

export { getMessageComponent, SystemMessage };
