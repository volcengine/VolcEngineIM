import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconMessage(props: IconProps) {
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
      className={`im-icon im-icon-message ${className}`}
      width={width}
      height={height}
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M20 11C20 15.4183 15.7467 19 10.5 19C9.43474 19 8.41043 18.8524 7.45435 18.58C7.31789 18.5412 7.17112 18.5584 7.04946 18.6314L3.91274 20.5135C3.57947 20.7134 3.15549 20.4734 3.15549 20.0847V16.2781C3.15549 16.1476 3.10396 16.0228 3.01514 15.9272C1.75259 14.569 1 12.8585 1 11C1 6.58172 5.25329 3 10.5 3C15.7467 3 20 6.58172 20 11ZM14.1982 20.4157C13.6963 20.3142 13.7777 19.6593 14.2761 19.5415C18.3935 18.5685 21.4064 15.4444 21.4064 11.7408C21.4064 11.5267 21.6648 11.4112 21.8006 11.5766C22.4383 12.353 22.8432 13.2788 22.929 14.2944C23.0599 15.8431 22.4245 17.3106 21.2886 18.4371C21.1788 18.5459 21.1189 18.6965 21.132 18.8506L21.3238 21.1202C21.3566 21.5075 20.9543 21.7824 20.6054 21.6112L18.106 20.3851C17.9984 20.3323 17.8754 20.3205 17.7587 20.3482C17.361 20.4427 16.9486 20.5094 16.5246 20.5452C15.7184 20.6134 14.9349 20.5647 14.1982 20.4157Z"
      />
    </svg>
  );
}
