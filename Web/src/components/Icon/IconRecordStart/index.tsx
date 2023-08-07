import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconRecordStart(props: IconProps) {
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
      className={`im-icon im-icon-record-start ${className}`}
      width={width}
      height={height}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        clip-rule="evenodd"
        d="M24 6c9.941 0 18 8.059 18 18s-8.059 18-18 18S6 33.941 6 24 14.059 6 24 6z"
        stroke="#4E5969"
        strokeWidth="4"
      />
      <path d="M30 24a6 6 0 11-12 0 6 6 0 0112 0z" fill="#4E5969" />
      <path
        d="M30 24a6 6 0 11-12 0 6 6 0 0112 0z"
        stroke="#4E5969"
        strokeWidth="4"
      />
    </svg>
  );
}
