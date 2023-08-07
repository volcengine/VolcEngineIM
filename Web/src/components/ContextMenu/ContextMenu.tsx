import React, {
  FC,
  useEffect,
  useCallback,
  useRef,
  useState,
  CSSProperties,
} from 'react';

import ContextMenuItem from './ContextMenuItem';
import { IMenuItem, IMenuPosition } from './interface';
import { GlobalStyle } from './Styles';

interface ContextMenuProps {
  menuItems?: IMenuItem[];
  position?: IMenuPosition;
  popTarget?: HTMLElement;
  closeMenu?: () => void;
}

const ContextMenu: FC<ContextMenuProps> = props => {
  const { menuItems, position, popTarget, closeMenu } = props;
  const contextMenuRef = useRef<HTMLDivElement>(null);
  const [contextStyle, setContextStyle] = useState<CSSProperties>({
    opacity: 0,
  });

  const handleClick = useCallback(
    (item?: IMenuItem) => {
      closeMenu();
      item.click?.();
    },
    [closeMenu],
  );

  useEffect(() => {
    if (!contextMenuRef.current) {
      return;
    }
    handlePopupPlace();
  }, [position, contextMenuRef.current]);

  const handlePopupPlace = () => {
    const currentCom = contextMenuRef.current;
    const result = { left: position.x, top: position.y };

    if (currentCom.clientHeight + result.top > popTarget.clientHeight) {
      result.top = result.top - currentCom.clientHeight;
      if (result.top < 0) {
        result.top = 0;
      }
    }
    if (currentCom.clientWidth + result.left > popTarget.clientWidth) {
      result.left = result.left - currentCom.clientWidth;
      if (result.left < 0) {
        result.left = 0;
      }
    }

    setContextStyle({
      left: result.left + 'px',
      top: result.top + 'px',
      opacity: 1,
    });
  };

  return (
    <>
      <GlobalStyle />
      <div
        className="im-menu-wrapper"
        ref={contextMenuRef}
        style={contextStyle}>
        {menuItems.map(item => {
          return (
            <ContextMenuItem key={item.id} item={item} onClick={handleClick} />
          );
        })}
      </div>
    </>
  );
};

export default ContextMenu;
