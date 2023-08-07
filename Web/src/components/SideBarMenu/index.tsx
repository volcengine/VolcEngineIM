import React, { FC, useCallback, memo } from 'react';
import classNames from 'classnames';
import { Tooltip } from '@arco-design/web-react';

import { IconSearchClose } from '../Icon';

interface SideBarMenuProps {
  selectedKey?: any;
  currentUser?: any;
  openSidebar?: (key: string) => void;
  closeSidebar?: () => void;
  items: MenuItem[];
}

interface MenuItem {
  className?: string;
  tipText?: string;
  showBadgeDot?: (args: any) => any | boolean;
  getBadgeCount?: (args: any) => any | number;
  icon?: React.ReactNode;
  key?: string | any;
  visible?: boolean;
  [key: string]: any;
}

interface SideBarMenuItemProps {
  item?: MenuItem;
  selected?: boolean;
  closeSidebar?: () => void;
  toggleSidebar?: (key?: string) => void;
}

const SideBarMenuItem: FC<SideBarMenuItemProps> = memo(props => {
  const { item = {}, selected, toggleSidebar } = props;
  const { icon: IconComponent, key } = item;

  const handleOpenSidebar = useCallback(() => {
    toggleSidebar?.(selected ? '' : key);
  }, [toggleSidebar, selected]);

  const renderIcon = () => {
    const Icon = selected ? <IconSearchClose /> : IconComponent;
    return Icon;
  };

  const itemClass = classNames('sidebar-menu-item', {
    'is-selected': selected,
  });

  return (
    <Tooltip content={item.tipText} position="left">
      <div className={itemClass} onClick={handleOpenSidebar}>
        {/* <Badge {...badgeProps} childCornerRadius={0} size="large"> */}
        {renderIcon()}
        {/* </Badge> */}
      </div>
    </Tooltip>
  );
});

const SideBarMenu: FC<SideBarMenuProps> = memo(props => {
  const { items, selectedKey, closeSidebar, openSidebar } = props;

  const wrapClass = classNames({
    'sideBar-menu': true,
  });

  const renderSidebarItem = (item: any, index: number) => {
    const selected = item.key === selectedKey;
    const toggleSidebar = selected ? closeSidebar : openSidebar;

    return (
      item.visible && (
        <SideBarMenuItem
          key={`SIDEBAR_ITEM_KEY_${item.key}`}
          item={item}
          selected={selected}
          toggleSidebar={toggleSidebar}
        />
      )
    );
  };

  return <div className={wrapClass}>{items.map((item, index) => renderSidebarItem(item, index))}</div>;
});

export default SideBarMenu;
