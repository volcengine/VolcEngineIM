import React, { FC, memo } from 'react';
import classNames from 'classnames';

import { Time } from '../../../../../../components';

import MessageTimeBox from './Styles';

interface MessageTimeProps {
  className?: string;
  showTime?: boolean;
  createAt?: Date;
  timeFormatType?: string;
}

const prefixCls = 'im-message-time';
const MessageTime: FC<MessageTimeProps> = props => {
  const { className, showTime = true, createAt } = props;

  if (!showTime || !createAt) {
    return null;
  }

  const wrapClass = classNames(prefixCls, className);

  return (
    <MessageTimeBox className={wrapClass}>
      <Time date={createAt} />
    </MessageTimeBox>
  );
};

export default memo(MessageTime);
