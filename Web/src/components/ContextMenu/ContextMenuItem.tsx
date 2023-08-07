import React, { FC, memo, useCallback, useRef } from 'react';
import { IMenuItem } from './interface';

interface ContextMenuItemProps {
  item?: IMenuItem;
  onClick?: (item?: IMenuItem) => void;
}

const ContextMenuItem: FC<ContextMenuItemProps> = props => {
  const { item = {}, onClick } = props;
  const hasClick = useRef(false);

  const handleClick = useCallback(() => {
    if (hasClick.current) {
      return;
    }
    hasClick.current = true;
    onClick?.(item);
  }, [onClick, item]);

  return (
    <div className="im-menu-item" onClick={handleClick}>
      {item.icon}
      <span className="im-menu-label">{item.label}</span>
    </div>
  );
};

export default memo(ContextMenuItem);
