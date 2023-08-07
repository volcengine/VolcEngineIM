import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconEmoji(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-emoji ${className}`}
      width="20"
      height="20"
      viewBox="0 0 20 20"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M10 0.75C4.89137 0.75 0.75 4.89137 0.75 10C0.75 15.1086 4.89137 19.25 10 19.25C15.1086 19.25 19.25 15.1086 19.25 10C19.25 4.89137 15.1086 0.75 10 0.75ZM2.25 10C2.25 5.71979 5.71979 2.25 10 2.25C14.2802 2.25 17.75 5.71979 17.75 10C17.75 14.2802 14.2802 17.75 10 17.75C5.71979 17.75 2.25 14.2802 2.25 10ZM7 8.5C7.55228 8.5 8 8.05228 8 7.5C8 6.94772 7.55228 6.5 7 6.5C6.44772 6.5 6 6.94772 6 7.5C6 8.05228 6.44772 8.5 7 8.5ZM14 7.5C14 8.05228 13.5523 8.5 13 8.5C12.4477 8.5 12 8.05228 12 7.5C12 6.94772 12.4477 6.5 13 6.5C13.5523 6.5 14 6.94772 14 7.5ZM8.32277 12.4998C8.04653 12.1912 7.57238 12.1649 7.26374 12.4412C6.95509 12.7174 6.92883 13.1915 7.20507 13.5002C7.89065 14.2662 8.88933 14.75 10 14.75C11.1107 14.75 12.1094 14.2662 12.795 13.5002C13.0712 13.1915 13.045 12.7174 12.7363 12.4412C12.4277 12.1649 11.9535 12.1912 11.6773 12.4998C11.2642 12.9613 10.6663 13.25 10 13.25C9.33373 13.25 8.73584 12.9613 8.32277 12.4998Z"
        fill="#55585C"
      />
    </svg>
  );
}
