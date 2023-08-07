import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconCallVideo(props: IconProps) {
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
      className={`im-icon im-icon-call-video ${className}`}
      width={width}
      height={height}
      viewBox="0 0 1024 1024">
      <path d="M64 170.666667h597.333333a42.666667 42.666667 0 0 1 42.666667 42.666666v597.333334a42.666667 42.666667 0 0 1-42.666667 42.666666H64a42.666667 42.666667 0 0 1-42.666667-42.666666V213.333333a42.666667 42.666667 0 0 1 42.666667-42.666666z m42.666667 85.333333v512h512V256H106.666667z m213.333333 85.333333v128H192v-128h128z m448 42.666667l163.584-89.237333c31.296-17.066667 71.082667 3.413333 71.082667 36.586666v361.301334c0 33.152-39.786667 53.632-71.082667 36.586666L768 640V384z m85.333333 207.68l64 25.6v-210.56l-64 25.6v159.36z"></path>
    </svg>
  );
}
