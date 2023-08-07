import React, { FC, useMemo, memo } from 'react';
import classNames from 'classnames';

import { parseMessageContent } from '../../../utils';
import SystemMessageBox from './Styles';

interface SystemMessageProps {
  message?: any;
  className?: string;
  type?: 'stage' | 'weakHint' | 'strongHint';
}

function str2Template(str: string) {
  let newStr = `${'return ' + '`'}${str}\``;
  var func = new Function(newStr);
  return func();
}

const prefixCls = 'system-message';
const SystemMessage: FC<SystemMessageProps> = props => {
  const { className, type = 'weakHint', message, children, ...other } = props;

  const msgContent = useMemo(() => {
    if (!message.content) {
      return '';
    }
    return parseMessageContent(message);
  }, [message]);

  const wrapClass = useMemo(() => {
    return classNames(
      prefixCls,
      {
        [`is-${type}`]: type,
      },
      className
    );
  }, [className, type]);

  const isStage = useMemo(() => {
    return type === 'stage';
  }, [type]);

  return (
    <SystemMessageBox className={wrapClass} {...other}>
      {isStage ? (
        <div className="im-divider">{str2Template(msgContent?.default_message)}</div>
      ) : (
        <span className={`${prefixCls}-content`}>{str2Template(msgContent?.default_message)}</span>
      )}
    </SystemMessageBox>
  );
};

export default memo(SystemMessage);
