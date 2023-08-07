import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconForward(props: IconProps) {
  const {
    className = '',
    prefix = '',
    width = '1em',
    height = '1em',
    useCurrentColor = false,
  } = props;

  return (
    <svg
      className={`im-icon im-icon-forward ${className}`}
      width={width}
      height={height}
      viewBox="0 0 1024 1024">
      <path d="M533.333333 327.893333V149.717333c0-5.76 2.304-11.285333 6.421334-15.36a22.101333 22.101333 0 0 1 31.04 0L929.024 488.96a32.341333 32.341333 0 0 1 0 46.08L570.794667 889.642667a22.058667 22.058667 0 0 1-15.509334 6.357333A21.824 21.824 0 0 1 533.333333 874.282667v-191.466667h-43.776c-169.962667 0-298.709333 55.893333-376.853333 156.48-6.464 8.341333-14.4 19.968-23.808 34.901333a10.666667 10.666667 0 0 1-19.605333-4.309333C65.770667 842.304 64 820.352 64 804.010667 64 541.056 274.133333 327.893333 533.333333 327.893333z"></path>
    </svg>
  );
}
