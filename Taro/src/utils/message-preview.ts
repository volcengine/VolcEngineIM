import dayjs from 'dayjs';
import calendar from 'dayjs/plugin/calendar';
import 'dayjs/locale/zh-cn';

import { MessageType } from '../enums';

dayjs.locale('zh-cn');
dayjs.extend(calendar);

export const getMsgCreateTime = message => {
  return dayjs(message.createdAt).calendar(null, {
    sameDay: '[今天] h:mm A', // The same day ( Today at 2:30 AM )
    nextDay: '[明天]', // The next day ( Tomorrow at 2:30 AM )
    nextWeek: 'dddd', // The next week ( Sunday at 2:30 AM )
    lastDay: '[昨天]', // The day before ( Yesterday at 2:30 AM )
    lastWeek: '[上周] dddd', // Last week ( Last Monday at 2:30 AM )
    sameElse: 'DD/MM/YYYY' // Everything else ( 7/10/2011 )
  });
};

export const getMsgPreviewContent = message => {
  const { type, content, isRecalled } = message;
  if (isRecalled) {
    return '消息被撤回';
  }
  if (type === MessageType.MESSAGE_TYPE_TEXT) {
    return getTextMsgContent({ content });
  }
  if (type === MessageType.MESSAGE_TYPE_IMAGE) {
    return '[图片]';
  }
  if (type === MessageType.MESSAGE_TYPE_VIDEO) {
    return '[视频]';
  }
  if (type === MessageType.MESSAGE_TYPE_AUDIO) {
    return '[音频]';
  }
  if (type === MessageType.MESSAGE_TYPE_CUSTOM) {
    return '[自定义消息]';
  }
  return '[未知消息]';
};

export const getTextMsgContent = ({ content }) => {
  try {
    const contentObj = JSON.parse(content);
    try {
      const innerObj = JSON.parse(contentObj.text);
      return innerObj.innerText ?? contentObj.text;
    } catch (err) {
      return contentObj.text ?? content;
    }
  } catch (err) {
    return content;
  }
};

export const getCustomMsgContent = ({
  content
}): {
  type: number;
  text: string;
} => {
  try {
    const contentObj = JSON.parse(content);
    return {
      type: contentObj.type,
      text: contentObj.text
    };
  } catch (err) {
    return {
      type: 0,
      text: ''
    };
  }
};

export const getFileMsgContent = message => {
  try {
    if (!message.content) {
      return '';
    }
    const content = JSON.parse(message.content);
    const file = content.__files;
    const keys = Object.keys(file);
    const imgContent = file[keys[0]];
    return imgContent.remoteURL;
  } catch (err) {
    console.error('message content parse fail');
    return '';
  }
};

export function computedVisibleTime(messages: any[]) {
  if (!messages.length) {
    return [];
  }

  let lastVisibleTime: Date;

  messages.forEach((message, index) => {
    message.isTimeVisible = false;
    if (index === 0) {
      lastVisibleTime = message.createdAt;
      message.isTimeVisible = true;
    } else {
      if (dayjs(message.createdAt).diff(dayjs(lastVisibleTime), 'minute') > 2) {
        lastVisibleTime = message.createdAt;
        message.isTimeVisible = true;
      }
    }
  });

  return messages;
}
