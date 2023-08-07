import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconImage(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-image ${className}`}
      width={width}
      height={height}
      viewBox="0 0 18 18"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M0.75 3.5C0.75 1.98122 1.98122 0.75 3.5 0.75H14.5C16.0188 0.75 17.25 1.98122 17.25 3.5V14.5C17.25 16.0188 16.0188 17.25 14.5 17.25H3.5C1.98122 17.25 0.75 16.0188 0.75 14.5V3.5ZM3.5 2.25C2.80964 2.25 2.25 2.80964 2.25 3.5V14.5C2.25 15.1904 2.80964 15.75 3.5 15.75H14.5C15.1904 15.75 15.75 15.1904 15.75 14.5V3.5C15.75 2.80964 15.1904 2.25 14.5 2.25H3.5ZM14 6C14 6.55228 13.5523 7 13 7C12.4477 7 12 6.55228 12 6C12 5.44772 12.4477 5 13 5C13.5523 5 14 5.44772 14 6ZM7.84041 10.9905C8.30615 10.4782 9.0996 10.442 9.60999 10.9099L12.4932 13.5528C12.7986 13.8327 13.273 13.8121 13.5529 13.5068C13.8328 13.2014 13.8121 12.727 13.5068 12.4471L10.6236 9.80414C9.50072 8.77486 7.75513 8.85437 6.7305 9.98147L4.44505 12.4955C4.16642 12.802 4.18901 13.2763 4.4955 13.5549C4.80199 13.8335 5.27633 13.811 5.55496 13.5045L7.84041 10.9905Z"
        fill="#55585C"
      />
    </svg>
  );
}
