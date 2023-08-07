import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconSearch(props: IconProps) {
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
      className={`im-icon im-icon-search ${className}`}
      width={width}
      height={height}
      fill="currentColor"
      viewBox="0 0 1024 1024">
      <path d="M769.130667 673.493333l144.682666 144.682667a21.333333 21.333333 0 0 1 0 30.165333l-36.202666 36.202667a21.333333 21.333333 0 0 1-30.165334 0L706.56 743.68A361.258667 361.258667 0 0 1 469.333333 832c-200.298667 0-362.666667-162.368-362.666666-362.666667S269.034667 106.666667 469.333333 106.666667s362.666667 162.368 362.666667 362.666666c0 75.712-23.189333 146.005333-62.869333 204.16zM469.333333 742.4c150.826667 0 273.066667-122.24 273.066667-273.066667S620.16 196.266667 469.333333 196.266667 196.266667 318.506667 196.266667 469.333333 318.506667 742.4 469.333333 742.4z"></path>
    </svg>
  );
}
