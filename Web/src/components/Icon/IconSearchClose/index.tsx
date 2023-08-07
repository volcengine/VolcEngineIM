import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconSearchClose(props: IconProps) {
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
      className={`im-icon im-icon-search-close ${className}`}
      width={width}
      height={width}
      fill="currentColor"
      viewBox="0 0 1024 1024">
      <path d="M512 981.333333C252.8 981.333333 42.666667 771.2 42.666667 512S252.8 42.666667 512 42.666667s469.333333 210.133333 469.333333 469.333333-210.133333 469.333333-469.333333 469.333333z m0-529.664l-126.933333-126.933333a21.333333 21.333333 0 0 0-30.165334 0l-30.165333 30.165333a21.333333 21.333333 0 0 0 0 30.165334l126.933333 126.933333-126.933333 126.933333a21.333333 21.333333 0 0 0 0 30.165334l30.165333 30.165333a21.333333 21.333333 0 0 0 30.165334 0l126.933333-126.933333 126.933333 126.933333a21.333333 21.333333 0 0 0 30.165334 0l30.165333-30.165333a21.333333 21.333333 0 0 0 0-30.165334L572.330667 512l126.933333-126.933333a21.333333 21.333333 0 0 0 0-30.165334l-30.165333-30.165333a21.333333 21.333333 0 0 0-30.165334 0L512 451.669333z"></path>
    </svg>
  );
}
