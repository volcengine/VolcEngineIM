import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconRevocation(props: IconProps) {
  const {
    className = '',
    prefix = '',
    width = '1em',
    height = '1em',
    useCurrentColor = false,
  } = props;

  return (
    <svg
      className={`im-icon im-icon-revocation ${className}`}
      width={width}
      height={height}
      viewBox="0 0 1024 1024">
      <path d="M250.816 298.666667H661.333333c164.949333 0 298.666667 133.717333 298.666667 298.666666s-133.717333 298.666667-298.666667 298.666667h-186.197333a21.333333 21.333333 0 0 1-21.333333-21.333333v-41.813334a21.333333 21.333333 0 0 1 21.333333-21.333333h176.170667c82.474667 0 213.333333-85.354667 213.333333-214.186667 0-128.832-130.858667-213.333333-213.333333-213.333333H250.816l123.285333 123.264a21.333333 21.333333 0 0 1 0 30.165333l-30.186666 30.186667a21.333333 21.333333 0 0 1-30.165334 0l-196.096-196.117333A42.538667 42.538667 0 0 1 105.152 341.333333c0-10.922667 4.16-21.845333 12.501333-30.165333l196.096-196.117333a21.333333 21.333333 0 0 1 30.165334 0l30.186666 30.186666a21.333333 21.333333 0 0 1 0 30.165334L250.816 298.666667z"></path>
    </svg>
  );
}
