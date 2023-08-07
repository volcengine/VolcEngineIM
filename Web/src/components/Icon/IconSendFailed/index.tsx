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
      className={`im-buyin-icon im-buyin-icon-send_failed ${className}`}
      width="16"
      height="16"
      viewBox="0 0 16 16"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <g opacity="0.9">
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M1 8C1 4.13401 4.13401 1 8 1C11.866 1 15 4.13401 15 8C15 11.866 11.866 15 8 15C4.13401 15 1 11.866 1 8Z"
          fill="#FE2C55"
        />
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M8 11.7397C8.41421 11.7397 8.75 11.404 8.75 10.9897C8.75 10.5755 8.41421 10.2397 8 10.2397C7.58579 10.2397 7.25 10.5755 7.25 10.9897C7.25 11.404 7.58579 11.7397 8 11.7397Z"
          fill="white"
        />
        <path
          d="M8.01025 5L7.98944 8.59855"
          stroke="white"
          strokeWidth="1.5"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </g>
    </svg>
  );
}
