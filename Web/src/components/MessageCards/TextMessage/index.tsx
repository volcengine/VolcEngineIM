import React, { memo, useMemo } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import { Bubble, RichText } from '../..';
import { isObject } from '../../../utils/tools';
import { getMessageTimeFormat, isNumeric } from '../../../utils';
import { Emoji } from '../../../assets/emotion/emojify';

import { GlobalStyle } from './Styles';
import { IRichText } from '../../RichText/interface';

interface ITextMessage {
  message: Message;
}

function parseContent(message: string) {
  try {
    const content = JSON.parse(message).text;
    try {
      if (isNumeric(content)) {
        return content;
      }
      return content;
    } catch (error) {
      return content;
    }
  } catch (error) {
    return message;
  }
}

const TextMessage = memo((props: ITextMessage) => {
  const { message } = props;

  let content: IRichText = useMemo(() => {
    return parseContent(message.content);
  }, [message.content]);

  const suffix = useMemo(() => {
    return message.isEdited ? (
      <span style={{ fontSize: '0.8em', color: 'gray' }}>
        （已编辑; 用户: {message.editInfo.contentEditorUid}; 时间:{' '}
        {getMessageTimeFormat(message.editInfo.contentEditTime)}）
      </span>
    ) : null;
  }, [message.isEdited]);

  if (isObject(content)) {
    return (
      <Bubble>
        <RichText richText={content} suffix={suffix} />
      </Bubble>
    );
  }

  const richContent = Emoji.emojify({
    str: content,
    format: (text, source) => {
      return `<img class='emoji-img' src='${source}' alt='${text}'></img>`;
    },
  });

  return (
    <Bubble>
      <GlobalStyle />
      <div dangerouslySetInnerHTML={{ __html: richContent }}></div>
      {suffix}
    </Bubble>
  );
});

export default TextMessage;
