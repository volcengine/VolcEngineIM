import React, { FC, memo, useEffect, useRef } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import styles from './index.module.scss';
import { parseMessageContent } from '../../../../utils';
import { useInViewport } from 'ahooks';

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
  const [isInview] = useInViewport(messageItemRef, { threshold: 0.7 });

  useEffect(() => {
    if (isInview && document.visibilityState === 'visible') {
      markMessageRead?.(message, index);
    }
  }, [isInview, markMessageRead, index, message]);

  return (
    <div ref={messageItemRef} className={styles.container}>
      {text}
    </div>
  );
};

export default memo(GroupSystemMessage);
