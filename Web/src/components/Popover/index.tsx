import React, { FC, CSSProperties, ReactNode, ReactElement, forwardRef, useMemo } from 'react';
import { Tooltip } from '@arco-design/web-react';

type TooltipProps = typeof Tooltip.defaultProps;

interface PopoverProps extends TooltipProps {
  style?: CSSProperties;
  className?: string;
  title?: ReactNode;
  content?: ReactNode;
  overlayClassName?: string;
  mouseLeaveDelay?: number;
  children?: ReactElement;
}

const prefixCls = 'im-popover';
function Popover(props: PopoverProps, ref) {
  const { children, content, title, ...other } = props;

  const popupNode = useMemo(() => {
    if (!title && !content) {
      return null;
    }

    return (
      <>
        {title && <div className={`${prefixCls}-title`}>{title}</div>}
        {content && <div className={`${prefixCls}-content`}>{content}</div>}
      </>
    );
  }, [content, title]);

  return (
    <Tooltip content={popupNode} {...other} ref={ref}>
      {children}
    </Tooltip>
  );
}

export default forwardRef(Popover);
