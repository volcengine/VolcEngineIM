import React, { FC, memo, useEffect } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import styles from './index.module.scss';
import { parseMessageContent } from '../../../../../../utils';
import { useInView } from '../../../../../../hooks';

interface GroupSystemMessageProps {
  message?: Message;
  index?: number;
  markMessageRead?: (msg: Message, index?: number) => void;
}

const GroupSystemMessage: FC<GroupSystemMessageProps> = props => {
  const { message, markMessageRead, index } = props;
  const content = message.content && parseMessageContent(message);
  const { text } = content;
  const [messageItemRef, isInview] = useInView(null, { threshold: 0.7 }, [document.visibilityState]);

  useEffect(() => {
    // if (isInview && document.visibilityState === 'visible') {
    //   markMessageRead?.(message, index);
    // }
  }, [isInview, markMessageRead, index, message]);

  return (
    <div ref={messageItemRef} className={styles.container}>
      {text}
    </div>
  );
};

export default memo(GroupSystemMessage);
