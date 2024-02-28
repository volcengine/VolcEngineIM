import React, { memo, useMemo } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import { Bubble } from '../..';
import { IMessageCardsMap } from '../index';
import CouponMessage from '../CouponMessage';
import UnknownMessage from '../UnknownMessage';
import VolcMessage from '../VolcMessage';
import { customType } from '../../../utils';

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
const CustomMessageCardsMap: IMessageCardsMap = {
  [customType.volc]: VolcMessage,
  [customType.coupon]: CouponMessage,
};
const CustomMessage = memo((props: ITextMessage) => {
  const { message } = props;

  const { type } = useMemo(() => {
    return parseContent(message.content);
  }, [message.content]);

  const Cmp = CustomMessageCardsMap[type];
  if (Cmp) {
    return <Cmp message={message} />;
  } else {
    return <UnknownMessage />;
  }
});

export default CustomMessage;
