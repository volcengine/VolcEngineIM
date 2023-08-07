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
      className={`im-buyin-icon im-buyin-icon-zoom-out ${className}`}
      width={width}
      height={width}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      stroke="currentColor"
      strokeWidth="4">
      <path
        d="M32.6066 32.6066C35.3211 29.8921 37 26.1421 37 22C37 13.7157 30.2843 7 22 7C13.7157 7 7 13.7157 7 22C7 30.2843 13.7157 37 22 37C26.1421 37 29.8921 35.3211 32.6066 32.6066ZM32.6066 32.6066L41.5 41.5M29 22H15"
        strokeLinecap="butt"
      />
    </svg>
  );
}
