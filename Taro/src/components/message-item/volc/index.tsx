import React, { memo, useMemo } from 'react';
import { Message } from '@volcengine/im-mp-sdk';
import { Text, View } from '@tarojs/components';
import Taro from '@tarojs/taro';

interface ITextMessage {
  message: Message;
}

function parseContent(message: string) {
  let content: any;
  try {
    content = JSON.parse(message);
  } catch (error) {
    content = message;
  }

  return content;
}

const VolcMessage = memo((props: ITextMessage) => {
  const { message } = props;

  const { link, text } = useMemo(() => {
    return parseContent(message.content);
  }, [message.content]);

  return (
    <View className="text-item-wrapper">
      <Text className="text-content">
        {text ? `${text}，` : text}
        <Text
          style={{ color: 'blue' }}
          onClick={() => {
            Taro.setClipboardData({
              data: link
            });
          }}
        >
          复制链接
        </Text>
      </Text>
    </View>
  );
});

export default VolcMessage;
