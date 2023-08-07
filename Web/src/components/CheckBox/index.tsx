import React, { FC, useState } from 'react';
import classNames from 'classnames';

import IconChecked from '../Icon/IconChecked';
import CheckBoxWrap from './Styles';

interface CheckBoxProps extends React.InputHTMLAttributes<HTMLInputElement> {
  checked?: boolean;
  label?: string;
}

const CheckBox: FC<CheckBoxProps> = props => {
  const {
    style,
    checked,
    label,
    disabled,
    className,
    children,
    onChange,
  } = props;


  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    requestAnimationFrame(() => {
      onChange?.(event);
    });
  };

  const inputCls = classNames('im-checkbox__input');

  const wrapCls = classNames(
    'im-checkbox',
    {
      'is-disabled': disabled,
      'is-checked': checked,
    },
    className,
  );

  return (
    <CheckBoxWrap className={wrapCls} style={style}>
      <div className={inputCls}>
        <input
          type="checkbox"
          className="im-checkbox__original"
          checked={checked}
          disabled={disabled}
          onChange={handleChange}
        />
        <span className="im-checkbox__inner">
          {checked && <IconChecked />}
        </span>
      </div>
      <div className="im-checkbox__label">{children || label}</div>
    </CheckBoxWrap>
  );
};

export default CheckBox;
