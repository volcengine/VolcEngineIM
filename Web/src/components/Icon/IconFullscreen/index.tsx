import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconHasRead(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-fullscreen ${className}`}
      width={width}
      height={width}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      stroke="currentColor"
      strokeWidth="4">
      <path
        d="M42 17V9C42 8.44772 41.5523 8 41 8H33M6 17V9C6 8.44772 6.44772 8 7 8H15M42 31V39C42 39.5523 41.5523 40 41 40H33M6 31V39C6 39.5523 6.44772 40 7 40H15"
        strokeLinecap="butt"
      />
    </svg>
  );
}
