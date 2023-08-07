import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconHistory(props: IconProps) {
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
      className={`im-icon im-icon-history ${className}`}
      width={width}
      height={height}
      viewBox="0 0 48 48"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg">
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M26 2c12.15 0 22 9.85 22 22s-9.85 22-22 22c-7.197 0-13.586-3.456-17.6-8.798l3.2-2.401C14.882 39.172 20.11 42 26 42c9.941 0 18-8.059 18-18S35.941 6 26 6C17.081 6 9.677 12.487 8.249 21H10a1 1 0 01.869 1.495l-.069.105-4 5.333a.999.999 0 01-1.518.096l-.082-.096-4-5.333a1 1 0 01.683-1.593L2 21h2.203C5.666 10.27 14.867 2 26 2zm1 13a1 1 0 011 1v7h7a1 1 0 011 1v2a1 1 0 01-1 1H25a1 1 0 01-1-1V16a1 1 0 011-1h2z"
      />
    </svg>
  );
}
