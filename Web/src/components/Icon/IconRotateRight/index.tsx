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
      className={`im-buyin-icon im-buyin-icon-rotate-right ${className}`}
      width="48"
      height="48"
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      stroke="currentColor"
      strokeWidth="4">
      <path
        d="M38 22C38 21.4477 37.5523 21 37 21H17C16.4477 21 16 21.4477 16 22V38C16 38.5523 16.4477 39 17 39H37C37.5523 39 38 38.5523 38 38V22Z"
        strokeLinecap="butt"
      />
      <path d="M25 11H14C10.6863 11 8 13.6863 8 17V23" strokeLinecap="butt" />
      <path
        d="M25.5 12.8933L28.4127 11L25.5 9.10672L25.5 12.8933Z"
        strokeLinecap="butt"
      />
    </svg>
  );
}
