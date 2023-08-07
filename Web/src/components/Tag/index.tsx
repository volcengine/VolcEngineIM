import React, { forwardRef } from 'react';
import classNames from 'classnames';

import TagBox from './Styles';

const prefixCls = 'im-tag';

export interface TagProps extends React.HTMLAttributes<HTMLSpanElement> {
  className?: string;
  visible?: boolean;
  style?: React.CSSProperties;
  icon?: React.ReactNode;
}

const Tag: React.ForwardRefRenderFunction<HTMLSpanElement, TagProps> = (
  { className, visible, style, icon, children, ...props },
  ref,
) => {
  const tagClass = classNames(prefixCls, className);

  return (
    <TagBox className={tagClass} style={style} ref={ref} {...props}>
      {icon || null}
      <span className="im-tag-text">{children}</span>
    </TagBox>
  );
};

export default forwardRef<HTMLSpanElement, TagProps>(Tag);
