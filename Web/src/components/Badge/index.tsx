import React, { forwardRef, useMemo } from 'react';
import classNames from 'classnames';

import BadageBox from './Styles';

const prefixCls = 'im-badge';

export type StatusType =
  | 'success'
  | 'processing'
  | 'error'
  | 'default'
  | 'warning';

export interface BadgeProps {
  className?: string;
  count?: React.ReactNode;
  showZero?: boolean;
  overflowCount?: number;
  style?: React.CSSProperties;
  status?: StatusType;
  dot?: boolean;
  children?: React.ReactNode;
}

const Badge: React.ForwardRefRenderFunction<unknown, BadgeProps> = (
  props,
  ref,
) => {
  const {
    className,
    style,
    status,
    count = null,
    overflowCount = 99,
    dot = false,
    showZero = false,
    children,
    ...restProps
  } = props;

  const numberedDisplayCount = ((count as number) > (overflowCount as number)
    ? `${overflowCount}+`
    : count) as string | number | null;

  const hasStatus = status !== null && status !== undefined;

  const isZero = numberedDisplayCount === '0' || numberedDisplayCount === 0;

  const showAsDot = (dot && !isZero) || hasStatus;

  const mergedCount = showAsDot ? '' : numberedDisplayCount;

  const isHidden = useMemo(() => {
    return !showZero && isZero;
  }, [isZero, showZero]);

  const badgeClassName = classNames(
    prefixCls,
    {
      [`${prefixCls}-status`]: hasStatus,
      [`${prefixCls}-has-no-child`]: !children,
    },
    className,
  );

  const countClass = classNames({
    [`${prefixCls}-dot`]: showAsDot,
    [`${prefixCls}-count`]: !showAsDot,
    [`${prefixCls}-status-${status}`]: !!status,
  });

  const render = () => {
    return (
      <div className={countClass}>
        {!showAsDot && (
          <span className="im-badge-count-text">{mergedCount}</span>
        )}
      </div>
    );
  };

  return (
    <BadageBox
      className={badgeClassName}
      style={style}
      ref={ref as any}
      {...restProps}>
      {children}
      {!isHidden && render()}
    </BadageBox>
  );
};

export default forwardRef<unknown, BadgeProps>(Badge);
