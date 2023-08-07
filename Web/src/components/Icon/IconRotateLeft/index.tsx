import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconSendFailed(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-rotate-left ${className}`}
      width="48"
      height="48"
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      stroke="currentColor"
      strokeWidth="4">
      <path
        d="M10 22C10 21.4477 10.4477 21 11 21H31C31.5523 21 32 21.4477 32 22V38C32 38.5523 31.5523 39 31 39H11C10.4477 39 10 38.5523 10 38V22Z"
        strokeLinecap="butt"
      />
      <path d="M23 11H34C37.3137 11 40 13.6863 40 17V23" strokeLinecap="butt" />
      <path
        d="M22.5 12.8933L19.5873 11L22.5 9.10672L22.5 12.8933Z"
        strokeLinecap="butt"
      />
    </svg>
  );
}
