import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconPhoneCall(props: IconProps) {
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
      className={`im-buyin-icon im-buyin-icon-phone-call ${className}`}
      width="18"
      height="18"
      viewBox="0 0 18 18"
      fill="none"
      xmlns="http://www.w3.org/2000/svg">
      <path
        d="M6.90059 5.09642C6.9458 5.26597 6.89738 5.44609 6.7744 5.57127L5.29901 7.07303C5.15451 7.22011 5.1139 7.44092 5.20497 7.6259C6.20814 9.66361 8.11438 11.8388 10.328 12.7117C10.5045 12.7813 10.7037 12.7335 10.8381 12.5996L12.0896 11.3534C12.2048 11.2388 12.3679 11.1871 12.5278 11.2161C13.4109 11.3758 16.3292 11.921 17.0738 12.2813C17.8391 12.6508 18.0913 13.4723 17.9717 14.4852C17.8456 15.5741 16.4172 17.9737 13.8473 17.9997C11.2775 18.0258 7.49222 16.0892 4.78104 13.2354C2.06985 10.3773 -0.347827 6.75622 0.0413491 3.68289C0.426177 0.607389 3.10475 0.0574935 3.7744 0.00750301C4.45274 -0.0424875 4.98976 0.155301 5.3985 0.661727C5.84169 1.2128 6.6551 4.17576 6.90059 5.09642Z"
        fill="#AAABAF"
      />
    </svg>
  );
}
