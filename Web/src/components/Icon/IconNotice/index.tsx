import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconNotice(props: IconProps) {
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
      className={`im-icon im-icon-notice ${className}`}
      width={width}
      height={height}
      viewBox="0 0 48 48"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg">
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M25.657 3.69l.168.113L35.783 11H42a2 2 0 012 2v28a2 2 0 01-2 2H6a2 2 0 01-2-2V13a2 2 0 012-2h6.352l9.958-7.197a3 3 0 013.347-.114zM40 15H8v24h32V15zM25 30a1 1 0 00-1-1H13a1 1 0 00-1 1v2a1 1 0 001 1h11a1 1 0 001-1v-2zm10-9a1 1 0 011 1v2a1 1 0 01-1 1H13a1 1 0 01-1-1v-2a1 1 0 011-1h22zM19.18 11l4.888-3.532L28.954 11H19.18z"
      />
    </svg>
  );
}
