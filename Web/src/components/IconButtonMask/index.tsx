import React, {
  FC,
  CSSProperties,
  useCallback,
  useState,
  useMemo,
} from 'react';
import classNames from 'classnames';

import ButtonMaskBox from './Styles';

interface IconButtonMaskProps {
  maskStyle?: CSSProperties;
  withText?: boolean;
}

enum ActiveType {
  leave = 'leave',
  enter = 'enter',
  press = 'press',
}

const IconButtonMask: FC<IconButtonMaskProps> = props => {
  const { children, withText } = props;
  let { maskStyle = {} } = props;

  const [buttonActive, setButtonActive] = useState(ActiveType.leave);

  const handleMouseEnter = useCallback(() => {
    setButtonActive(ActiveType.enter);
  }, []);

  const handleMouseLeave = useCallback(() => {
    setButtonActive(ActiveType.leave);
  }, []);

  const handleMouseDown = useCallback(() => {
    setButtonActive(ActiveType.press);
  }, []);

  const maskClass = classNames({
    'button-hover-mask': true,
    'button-focus': buttonActive === ActiveType.enter,
    'button-press': buttonActive === ActiveType.press,
  });

  if (withText) {
    maskStyle = { width: '100%', height: '100%', padding: '4px', ...maskStyle };
  }

  return (
    <ButtonMaskBox
      className="button-hover-box"
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
      onMouseDown={handleMouseDown}>
      <div style={maskStyle} className={maskClass} />
      {children}
    </ButtonMaskBox>
  );
};

export default IconButtonMask;
