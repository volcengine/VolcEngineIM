import React, { FC, memo, useMemo } from 'react';
import classNames from 'classnames';

import { Tag } from '../../../../../../components';

export interface IMessageStatusProps {
  status?: 'pending' | 'read' | 'failed' | 'unread';
  showMessageStatus?: boolean;
  className?: string;
  icon?: React.ReactNode;
}

const prefixCls = 'im-message-status';

const MessageStatus: FC<IMessageStatusProps> = props => {
  const { icon, className, showMessageStatus } = props;
  const compCls = classNames(prefixCls, className);

  const node = useMemo(() => {
    return <Tag icon={icon} />;
  }, [icon]);

  if (!showMessageStatus) return null;

  return <span className={compCls}>{node}</span>;
};

export default memo(MessageStatus);
