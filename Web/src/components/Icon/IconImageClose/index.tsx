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
      className={`im-buyin-icon im-buyin-icon-image-close ${className}`}
      width={width}
      height={width}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      stroke="currentColor"
      strokeWidth="4">
      <path
        d="M24 33L33 24.5V27C33 27 31 28 29.5 29.5C27.841 31.159 27 33 27 33H24ZM24 33L20.5 28.5L17 33H24ZM41 26V9C41 7.89543 40.1046 7 39 7H9C7.89543 7 7 7.89543 7 9V39C7 40.1046 7.89543 41 9 41H26M15 15H17V17H15V15Z"
        strokeLinecap="butt"></path>
      <path
        d="M20.5 28.5L17 33H24L20.5 28.5Z"
        fill="currentColor"
        stroke="none"
        strokeWidth="none"
        strokeLinecap="butt"></path>
      <path
        d="M33 24.5L24 33H27C27 33 27.841 31.159 29.5 29.5C31 28 33 27 33 27V24.5Z"
        fill="currentColor"
        stroke="none"
        strokeWidth="none"
        strokeLinecap="butt"></path>
      <rect
        x="15"
        y="15"
        width="2"
        height="2"
        fill="currentColor"
        stroke="none"
        strokeWidth="none"
        strokeLinecap="butt"></rect>
      <path
        d="M46 38C46 42.4183 42.4183 46 38 46C33.5817 46 30 42.4183 30 38C30 33.5817 33.5817 30 38 30C42.4183 30 46 33.5817 46 38Z"
        fill="currentColor"
        stroke="none"
        strokeWidth="none"
        strokeLinecap="butt"></path>
      <path
        d="M34.0879 34.0879L38.0042 38.0042M38.0042 38.0042L41.9205 41.9205M38.0042 38.0042L41.9205 34.0879M38.0042 38.0042L34.0879 41.9205"
        stroke="white"
        strokeWidth="2.46154"
        strokeLinecap="butt"></path>
    </svg>
  );
}
