import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconVideo(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-video ${className}`}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      width={width}
      height={height}>
      <path
        stroke="#4E5969"
        strokeWidth="4"
        d="M37 42H11a2 2 0 01-2-2V8a2 2 0 012-2h21l7 7v27a2 2 0 01-2 2z"
      />
      <path d="M22 27.796v-6l5 3-5 3z" stroke="#4E5969" strokeWidth="4" />
    </svg>
  );
}
