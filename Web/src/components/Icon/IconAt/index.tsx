import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconAt(props: IconProps) {
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
      className={`im-icon im-icon-at ${className}`}
      width={width}
      height={height}
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <g clipPath="url(#clip0)">
        <path d="M24 0H0V24H24V0Z" fill="white" fillOpacity="0.01" />
        <g opacity="0.5">
          <path
            d="M19 12C19 8.134 15.866 5 12 5C8.134 5 5 8.134 5 12C5 15.866 8.134 19 12 19C13.746 19 15.3427 18.3607 16.5689 17.3035"
            stroke="#161823"
            strokeWidth="1.50293"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          <path
            d="M12.0005 14.8829C13.5924 14.8829 14.8829 13.5924 14.8829 12.0005C14.8829 10.4086 13.5924 9.11816 12.0005 9.11816C10.4086 9.11816 9.11816 10.4086 9.11816 12.0005C9.11816 13.5924 10.4086 14.8829 12.0005 14.8829Z"
            stroke="#161823"
            strokeWidth="1.50293"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          <path
            d="M14.8818 12.4121C14.8818 13.3218 15.8036 14.0592 16.9407 14.0592C18.0777 14.0592 18.9995 13.3218 18.9995 12.4121"
            stroke="#161823"
            strokeWidth="1.50293"
            strokeLinecap="square"
            strokeLinejoin="round"
          />
          <path
            d="M14.8818 12.4123V9.11816"
            stroke="#161823"
            strokeWidth="1.50293"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </g>
      </g>
      <defs>
        <clipPath id="clip0">
          <rect width="24" height="24" rx="4" fill="white" />
        </clipPath>
      </defs>
    </svg>
  );
}
