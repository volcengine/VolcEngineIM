import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';

import ContextMenu from './ContextMenu';
import { KeyCode } from '../../constant';

import { IMenuItem, IMenuPosition } from './interface';

const popTarget = document.createElement('div');
popTarget.className = `im-menu-portal`;

const handleMouseDown = (event: any) => {
  if (event.keyCode !== KeyCode.ESC) {
    return;
  }
  closeMenu();
};

const handleContextMenu = () => {
  closeMenu();
};

// 目前 ts 里面 MouseEvent 没有 path 属性报错
// https://juejin.im/post/5b7bc2a3f265da43606e943c
interface IMouseEventWithPath extends MouseEvent {
  path: HTMLElement[];
}

const handleGlobalClick = (event: IMouseEventWithPath) => {
  const path = event.path || event.composedPath?.();

  if (path.includes(popTarget)) {
    return;
  }

  closeMenu();
};

const openMenu = (menuItems: IMenuItem[], position: IMenuPosition) => {
  if (!document.body.contains(popTarget)) {
    document.body.appendChild(popTarget);
  }

  render(
    <ContextMenu
      menuItems={menuItems}
      position={position}
      closeMenu={closeMenu}
      popTarget={popTarget}
      // onCancel={option && option.onCancel}
    />,
    popTarget,
  );

  document.body.addEventListener('mousedown', handleMouseDown);
  document.body.addEventListener('click', handleGlobalClick as any);
  document.body.addEventListener('contextmenu', handleContextMenu);
};

export const closeMenu = () => {
  document.body.removeEventListener('mousedown', handleMouseDown);
  document.body.removeEventListener('click', handleGlobalClick as any);
  document.body.removeEventListener('contextmenu', handleContextMenu);
  unmountComponentAtNode(popTarget);

  if (document.body.contains(popTarget)) {
    document.body.removeChild(popTarget);
  }
};

export default openMenu;
