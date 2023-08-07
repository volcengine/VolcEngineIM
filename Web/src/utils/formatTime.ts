import { MessageItemType } from '../types';

export default function formatTime(DateTime: Date, fmt: string) {
  if (!DateTime) return '';
  var o = {
    'M+': DateTime.getMonth() + 1, // 月份
    'd+': DateTime.getDate(), // 日
    'H+': DateTime.getHours(), // 小时
    'm+': DateTime.getMinutes(), // 分
    's+': DateTime.getSeconds(), // 秒
    'q+': Math.floor((DateTime?.getMonth() + 3) / 3), // 季度
    S: DateTime.getMilliseconds(), // 毫秒
  };
  if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (`${DateTime.getFullYear()  }`).substr(4 - RegExp.$1.length));
  for (var k in o)
    if (new RegExp(`(${  k  })`).test(fmt))
      fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : (`00${  o[k]}`).substr((`${  o[k]}`).length));
  return fmt;
}

export const getLastTime = (createdAt?: Date, mustIncludeTime = true) => {
  if (!createdAt) return '';

  const currentDate = new Date();
  var srcDate = createdAt;

  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth() + 1;
  const currentDateD = currentDate.getDate();

  const srcYear = srcDate.getFullYear();
  const srcMonth = srcDate.getMonth() + 1;
  const srcDateD = srcDate.getDate();

  let ret = '';

  // 要额外显示的时间分钟
  const timeExtraStr = mustIncludeTime ? formatTime(srcDate, 'HH:mm') : '';

  if (currentYear == srcYear) {
    if (currentMonth == srcMonth && currentDateD == srcDateD) {
      ret = timeExtraStr;
    } else {
      const yesterdayDate = new Date();
      yesterdayDate.setDate(yesterdayDate.getDate() - 1);

      if (srcMonth == yesterdayDate.getMonth() + 1 && srcDateD == yesterdayDate.getDate()) {
        ret = '昨天';
      } else {
        ret = formatTime(createdAt, 'MM/dd');
      }
    }
  } else {
    ret = formatTime(srcDate, 'yyyy/MM/dd');
  }

  return ret;
};

export const transformTime = (createdAt?: Date, mustIncludeTime = true) => {
  if (!createdAt) return '';

  const currentDate = new Date();

  const currentYear = currentDate.getFullYear();
  const currentMonth = currentDate.getMonth() + 1;
  const currentDateD = currentDate.getDate();

  const srcYear = createdAt.getFullYear();
  const srcMonth = createdAt.getMonth() + 1;
  const srcDateD = createdAt.getDate();

  let ret = '';

  // 要额外显示的时间分钟
  const timeExtraStr = mustIncludeTime ? formatTime(createdAt, 'HH:mm') : '';

  if (currentYear == srcYear) {
    if (currentMonth == srcMonth && currentDateD == srcDateD) {
      ret = timeExtraStr;
    } else {
      const yesterdayDate = new Date();
      yesterdayDate.setDate(yesterdayDate.getDate() - 1);

      if (srcMonth == yesterdayDate.getMonth() + 1 && srcDateD == yesterdayDate.getDate()) {
        ret = `昨天 ${  timeExtraStr}`;
      } else {
        ret = formatTime(createdAt, 'MM月dd日 ') + timeExtraStr;
      }
    }
  } else {
    ret = formatTime(createdAt, 'yyyy年MM月dd日 ') + timeExtraStr;
  }

  return ret;
};

const compareVisibelTime = (lastTime: Date, messageTime: Date) => {
  const lastTimeDate = new Date(lastTime);
  const messageTimeDate = new Date(messageTime);

  const lastTimeNum = lastTimeDate.getTime();
  const messageTimeNum = messageTimeDate.getTime();

  const lastTimeMinutes = lastTimeNum / (1000 * 60);
  const messageTimeMinutes = messageTimeNum / (1000 * 60);

  return messageTimeMinutes - lastTimeMinutes;
};

export function computedVisibleTime(messages: MessageItemType[]) {
  if (!messages.length) {
    return [];
  }

  let lastVisibleTime: Date;

  messages.forEach((message, index) => {
    // 注意 消息被缓存
    (message as any).isTimeVisible = false;

    if (index === 0) {
      lastVisibleTime = message.createdAt;
      (message as any).isTimeVisible = true;
    } else {
      let diffTime = compareVisibelTime(lastVisibleTime, message.createdAt);

      if (diffTime > 2) {
        lastVisibleTime = message.createdAt;
        (message as any).isTimeVisible = true;
      }
    }
  });

  return messages;
}

export function getMessageTimeFormat(createdAt: Date) {
  let messageTime: string;
  let curDate = new Date();

  if (createdAt.getFullYear() < curDate.getFullYear()) {
    messageTime = formatTime(createdAt, 'yyyy年MM月dd日 HH:mm');
  } else {
    // >= 当前年

    if (createdAt.getDate() !== curDate.getDate()) {
      messageTime = formatTime(createdAt, 'MM月dd日 HH:mm');
    } else {
      messageTime = formatTime(createdAt, 'HH:mm');
    }
  }

  return messageTime;
}
