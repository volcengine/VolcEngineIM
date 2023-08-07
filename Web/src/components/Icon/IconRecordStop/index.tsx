import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconRecordStop(props: IconProps) {
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
      className={`im-icon im-icon-record-stop ${className}`}
      width={width}
      height={height}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        clip-rule="evenodd"
        d="M24 6c9.941 0 18 8.059 18 18s-8.059 18-18 18S6 33.941 6 24 14.059 6 24 6z"
        stroke="#4E5969"
        stroke-width="4"
      />
      <path
        d="M19 20a1 1 0 011-1h8a1 1 0 011 1v8a1 1 0 01-1 1h-8a1 1 0 01-1-1v-8z"
        fill="#4E5969"
      />
      <path
        d="M19 20a1 1 0 011-1h8a1 1 0 011 1v8a1 1 0 01-1 1h-8a1 1 0 01-1-1v-8z"
        stroke="#4E5969"
        stroke-width="4"
      />
    </svg>
  );
}
