import React from 'react';

export interface IMenuItem {
  id?: string;
  label?: string;
  icon?: React.ReactNode;
  click?: () => void;
}

export interface IMenuPosition {
  x?: number;
  y?: number;
}
