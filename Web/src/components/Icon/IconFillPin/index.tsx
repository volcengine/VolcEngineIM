import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconFillPin(props: IconProps) {
  const {
    className = '',
    prefix = '',
    width = '1em',
    height = '1em',
    useCurrentColor = false,
    ...rest
  } = props;

  return (
    <svg
      className={`im-icon im-icon-fill-pin ${className}`}
      width={width}
      height={width}
      viewBox="0 0 1024 1024">
      <path d="M213.610667 85.376c-0.064-11.989333 9.109333-17.536 21.12-17.472l554.325333-0.021333c12.010667 0.064 21.589333 5.653333 21.504 17.493333L810.666667 127.893333a21.738667 21.738667 0 0 1-21.610667 21.504L682.666667 149.504 682.666667 346.517333c0 5.738667 4.010667 11.264 7.936 15.168l178.24 203.52c4.053333 4.053333 6.378667 9.6 6.378666 15.317334l-0.042666 55.872a21.461333 21.461333 0 0 1-21.610667 21.610666L554.666667 658.133333v301.653334a21.845333 21.845333 0 0 1-21.610667 21.632l-42.176-0.128A21.546667 21.546667 0 0 1 469.333333 959.722667v-301.653334l-298.432-0.064A21.546667 21.546667 0 0 1 149.333333 636.458667l0.042667-55.872c0-5.738667 2.218667-11.285333 6.272-15.338667l176.96-203.498667c4.053333-4.053333 8.853333-9.6 8.853333-15.338666V149.418667h-106.730666c-11.861333 0.064-21.098667-9.408-21.162667-21.418667l0.042667-42.624z"></path>
    </svg>
  );
}