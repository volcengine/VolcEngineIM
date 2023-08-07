import React, { memo, useMemo } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import { Bubble } from '../..';

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
    <Bubble>
      {text ? `${text}，` : text}
      <a href={link} target="_blank" rel="noreferrer">
        查看详情
      </a>
    </Bubble>
  );
});

export default VolcMessage;
