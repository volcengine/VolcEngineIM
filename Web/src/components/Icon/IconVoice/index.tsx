import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconVoice(props: IconProps) {
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
      className={`im-icon im-icon-voice ${className}`}
      width={width}
      height={height}
      viewBox="0 0 48 48"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        d="M41 21v1c0 8.837-7.163 16-16 16h-2c-8.837 0-16-7.163-16-16v-1"
        stroke="#4E5969"
        strokeWidth="4"
      />
      <path
        d="M15 15a9 9 0 1118 0v6a9 9 0 11-18 0v-6zM24 38v6"
        stroke="#4E5969"
        strokeWidth="4"
      />
    </svg>
  );
}
