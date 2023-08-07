import React, { FC, memo } from 'react';
import { Message } from '@volcengine/im-web-sdk';

import RecalledMessageBox from './Styles';
import { getRecalledMsgDesc } from '../../../utils';

interface RecalledMessageProps {
  message: Message;
}

const RecalledMessage: FC<RecalledMessageProps> = ({ message }) => {
  const content = getRecalledMsgDesc(message);

  return (
    <RecalledMessageBox className="message-content">
      <div className="unknown-message">{content}</div>
    </RecalledMessageBox>
  );
};

export default memo(RecalledMessage);
