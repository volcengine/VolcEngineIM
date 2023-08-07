import React, { useMemo, FC, memo } from 'react';
import classNames from 'classnames';

import { transformTime } from '../../utils/formatTime';

type IDate = string | number | Date;

interface TimeProps {
  className?: string;
  /**
   * 时间
   */
  date: IDate;
  /**
   * 时间显示： 简短、长
   */
  type?: 'short' | 'long';
}

const prefixCls = 'im-time';

const Time: FC<TimeProps> = props => {
  const { date, className } = props;

  const fmtStr = useMemo(() => {
    return transformTime(date as Date);
  }, [date]);

  return <time className={classNames(prefixCls, className)}>{fmtStr}</time>;
};

export default memo(Time);
