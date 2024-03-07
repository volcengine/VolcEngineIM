import React, { FC, memo, useEffect, useRef } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import styles from './index.module.scss';
import { parseMessageContent } from '../../../../../../utils';

interface GroupSystemMessageProps {
  message?: Message;
  index?: number;
  markMessageRead?: (msg: Message, index?: number) => void;
}

const GroupSystemMessage: FC<GroupSystemMessageProps> = props => {
  const { message, markMessageRead, index } = props;
  const content = message.content && parseMessageContent(message);
  const { text } = content;
  const messageItemRef = useRef();

  return (
    <div ref={messageItemRef} className={styles.container}>
      {text}
    </div>
  );
};

export default memo(GroupSystemMessage);
