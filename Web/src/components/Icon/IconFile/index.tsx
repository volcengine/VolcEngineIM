import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconFile(props: IconProps) {
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
      className={`im-icon im-icon-file ${className}`}
      viewBox="0 0 16 16"
      fill="#505357"
      xmlns="http://www.w3.org/2000/svg"
      width={width}
      height={height}>
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M12 3H4a1 1 0 00-1 1v8a1 1 0 001 1h8a1 1 0 001-1V4a1 1 0 00-1-1zM4 2a2 2 0 00-2 2v8a2 2 0 002 2h8a2 2 0 002-2V4a2 2 0 00-2-2H4z"
        fill="#505357"
      />
      <path
        d="M5.5 6a.5.5 0 010-1h5a.5.5 0 010 1h-5zM5.5 8a.5.5 0 010-1h3a.5.5 0 010 1h-3z"
        fill="#505357"
      />
    </svg>
  );
}
