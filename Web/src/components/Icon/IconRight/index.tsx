import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconRight(props: IconProps) {
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
      className={`im-icon im-icon-right ${className}`}
      width={width}
      height={width}
      fill="currentColor"
      viewBox="0 0 1024 1024">
      <path d="M694.528 512L347.584 165.056a21.333333 21.333333 0 0 1 0-30.186667l30.165333-30.165333a21.333333 21.333333 0 0 1 30.165334 0L785.066667 481.834667a42.666667 42.666667 0 0 1 0 60.330666L407.914667 919.296a21.333333 21.333333 0 0 1-30.165334 0l-30.165333-30.165333a21.333333 21.333333 0 0 1 0-30.186667L694.528 512z"></path>
    </svg>
  );
}
