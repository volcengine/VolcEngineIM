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
      className={`im-icon im-icon-has_read ${className}`}
      width={width}
      height={height}
      viewBox="0 0 16 16"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <g opacity="0.9">
        <path
          d="M1.5 8C1.5 4.41015 4.41015 1.5 8 1.5C11.5899 1.5 14.5 4.41015 14.5 8C14.5 11.5899 11.5899 14.5 8 14.5C4.41015 14.5 1.5 11.5899 1.5 8Z"
          stroke="#6647FF"
        />
        <path
          d="M7.32566 9.24912L10.6305 5.94434C10.8826 5.69223 11.2914 5.69223 11.5435 5.94434C11.7956 6.19644 11.7956 6.60518 11.5435 6.85728L7.78213 10.6185C7.53003 10.8706 7.12129 10.8706 6.86919 10.6185L4.67237 8.42172C4.42027 8.16962 4.42027 7.76088 4.67237 7.50878C4.92448 7.25667 5.33322 7.25667 5.58532 7.50878L7.32566 9.24912Z"
          fill="#6647FF"
        />
      </g>
    </svg>
  );
}
