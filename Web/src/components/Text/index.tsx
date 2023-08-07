import React, { FC, forwardRef, CSSProperties } from 'react';
import classNames from 'classnames';
import TextBox from './Styles';

interface ITextProps extends React.HTMLAttributes<HTMLDivElement> {
  /**
   * 单行或多行显示
   */
  truncate?: boolean | number;
}

const prefixCls = 'im-text';

const Text: FC<ITextProps> = (props, ref) => {
  const { className, truncate, children, ...other } = props;

  const ellipsis = Number.isInteger(truncate);

  const style: CSSProperties = ellipsis
    ? { WebkitLineClamp: truncate as number }
    : {};

  const compCls = classNames(
    prefixCls,
    {
      [`${prefixCls}--truncate`]: truncate === true,
      [`${prefixCls}--ellipsis`]: ellipsis,
    },
    className,
  );

  return (
    <TextBox className={compCls} style={style} ref={ref} {...other}>
      {children}
    </TextBox>
  );
};

export default forwardRef<HTMLDivElement, ITextProps>(Text as any);
