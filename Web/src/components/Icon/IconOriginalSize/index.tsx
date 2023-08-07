import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconHasRead(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-original-size ${className}`}
      width={width}
      height={width}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      stroke="currentColor"
      strokeWidth="4">
      <path
        d="M5.5 11.5L10.5 9H11.5V41M34 11.5L39 9H40V41"
        strokeLinecap="butt"
      />
      <path
        d="M24 17H25V18H24V17Z"
        fill="currentColor"
        stroke="none"
        strokeWidth="none"
        strokeLinecap="butt"
      />
      <path
        d="M24 30H25V31H24V30Z"
        fill="currentColor"
        stroke="none"
        strokeWidth="none"
        strokeLinecap="butt"
      />
      <path d="M24 17H25V18H24V17Z" strokeLinecap="butt" />
      <path d="M24 30H25V31H24V30Z" strokeLinecap="butt" />
    </svg>
  );
}
