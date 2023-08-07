import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconJumpTo(props: IconProps) {
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
      className={`im-icon im-icon-jump-to ${className}`}
      width={width}
      height={height}
      fill="currentColor"
      viewBox="0 0 1024 1024">
      <path d="M511.402667 469.333333l-63.253334-63.232a21.333333 21.333333 0 0 1 0-30.186666l30.165334-30.165334a21.333333 21.333333 0 0 1 30.186666 0l151.765334 151.765334a21.333333 21.333333 0 0 1 0 30.186666l-150.848 150.826667a21.333333 21.333333 0 0 1-30.186667 0l-30.165333-30.165333a21.333333 21.333333 0 0 1 0-30.165334L512.597333 554.666667H106.666667a21.333333 21.333333 0 0 1-21.333334-21.333334v-42.666666a21.333333 21.333333 0 0 1 21.333334-21.333334h404.736zM170.666667 170.666667v213.333333H85.333333V128c0-21.482667 20.096-42.666667 42.666667-42.666667h768c22.570667 0 42.666667 21.184 42.666667 42.666667v768c0 21.482667-20.096 42.666667-42.666667 42.666667H128c-22.570667 0-42.666667-21.184-42.666667-42.666667V640h85.333334v213.333333h682.666666V170.666667H170.666667z"></path>
    </svg>
  );
}
