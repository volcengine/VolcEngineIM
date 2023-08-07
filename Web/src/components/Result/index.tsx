import React, { memo, useMemo } from 'react';
import classNames from 'classnames';

import ResultBox from './Styles';

export interface ResultProps {
  icon?: React.ReactNode;
  title?: React.ReactNode;
  subTitle?: React.ReactNode;
  extra?: React.ReactNode;
  className?: string;
  style?: React.CSSProperties;
}

const prefixCls = 'im-result';

const Result: React.FC<ResultProps> = props => {
  const {
    icon,
    title,
    subTitle,
    extra,
    className,
    children,
    ...restProps
  } = props;

  const resultCls = useMemo(() => {
    return classNames(prefixCls, className);
  }, [className]);

  const iconCls = useMemo(() => {
    return classNames(`${prefixCls}-icon`, `${prefixCls}-image`);
  }, []);

  return (
    <ResultBox className={resultCls} {...restProps}>
      {icon && <div className={iconCls}>{icon}</div>}
      {title && <div className={`${prefixCls}-title`}>{title}</div>}
      {subTitle && <div className={`${prefixCls}-subtitle`}>{subTitle}</div>}
      {children && <div className={`${prefixCls}-content`}>{children}</div>}
      {extra && <div className={`${prefixCls}-extra`}>{extra}</div>}
    </ResultBox>
  );
};

export default memo(Result);
