import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconAddPlus(props: IconProps) {
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
      className={`im-icon im-icon-add-plus ${className}`}
      width={width}
      height={height}
      viewBox="0 0 1024 1024">
      <path d="M469.333333 469.333333V112.682667c0-9.514667 0.981333-12.949333 2.858667-16.426667a19.392 19.392 0 0 1 8.064-8.064c3.477333-1.877333 6.912-2.858667 16.426667-2.858667h30.634666c9.514667 0 12.949333 0.981333 16.426667 2.858667 3.477333 1.856 6.208 4.586667 8.064 8.064 1.877333 3.477333 2.858667 6.912 2.858667 16.426667V469.333333h356.650666c9.514667 0 12.949333 0.981333 16.426667 2.858667 3.477333 1.856 6.208 4.586667 8.064 8.064 1.877333 3.477333 2.858667 6.912 2.858667 16.426667v30.634666c0 9.514667-0.981333 12.949333-2.858667 16.426667a19.392 19.392 0 0 1-8.064 8.064c-3.477333 1.877333-6.912 2.858667-16.426667 2.858667H554.666667v356.650666c0 9.514667-0.981333 12.949333-2.858667 16.426667a19.392 19.392 0 0 1-8.064 8.064c-3.477333 1.877333-6.912 2.858667-16.426667 2.858667h-30.634666c-9.514667 0-12.949333-0.981333-16.426667-2.858667a19.392 19.392 0 0 1-8.064-8.064c-1.877333-3.477333-2.858667-6.912-2.858667-16.426667V554.666667H112.682667c-9.514667 0-12.949333-0.981333-16.426667-2.858667a19.392 19.392 0 0 1-8.064-8.064c-1.877333-3.477333-2.858667-6.912-2.858667-16.426667v-30.634666c0-9.514667 0.981333-12.949333 2.858667-16.426667a19.392 19.392 0 0 1 8.064-8.064c3.477333-1.877333 6.912-2.858667 16.426667-2.858667H469.333333z"></path>
    </svg>
  );
}