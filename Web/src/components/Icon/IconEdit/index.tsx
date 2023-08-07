import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconEdit(props: IconProps) {
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
      className={`im-icon im-icon-edit ${className}`}
      width={width}
      height={width}
      fill="currentColor"
      viewBox="0 0 1024 1024">
      <path d="M524.053333 239.701333l85.973334 85.973334 63.744-63.829334-86.314667-86.784-63.402667 64.64z m25.642667 146.346667l-85.397333-85.418667L172.053333 598.613333v0.128l82.56 82.56h0.128l294.954667-295.253333z m199.68-77.226667l0.277333 0.256L290.730667 768H128a42.666667 42.666667 0 0 1-42.666667-42.666667v-162.730666L528.618667 115.904l-0.426667-0.426667 30.08-30.08a42.666667 42.666667 0 0 1 60.352 0l0.085333 0.085334 146.517334 147.285333a42.666667 42.666667 0 0 1-0.085334 60.266667l-15.765333 15.786666zM106.666667 853.333333h810.666666a21.333333 21.333333 0 0 1 21.333334 21.333334v42.666666a21.333333 21.333333 0 0 1-21.333334 21.333334H106.666667a21.333333 21.333333 0 0 1-21.333334-21.333334v-42.666666a21.333333 21.333333 0 0 1 21.333334-21.333334z"></path>
    </svg>
  );
}
