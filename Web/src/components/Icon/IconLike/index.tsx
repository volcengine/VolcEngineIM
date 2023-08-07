import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconLike(props: IconProps) {
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
      className={`im-icon im-icon-like ${className}`}
      width={width}
      height={height}
      fill="currentColor"
      viewBox="0 0 1024 1024"
      xmlns="http://www.w3.org/2000/svg">
      <path d="M128 938.666667H85.333333a21.333333 21.333333 0 0 1-21.333333-21.333334V362.666667a21.333333 21.333333 0 0 1 21.333333-21.333334h42.666667a21.333333 21.333333 0 0 1 21.333333 21.333334v554.666666a21.333333 21.333333 0 0 1-21.333333 21.333334z m511.936-597.397334h182.997333c127.317333 0 156.565333 112.384 127.317334 196.586667l-127.317334 335.146667c-10.752 38.976-46.570667 66.026667-87.466666 66.026666h-501.12a21.333333 21.333333 0 0 1-21.333334-21.333333v-555.093333a21.333333 21.333333 0 0 1 21.333334-21.333334h43.84a42.666667 42.666667 0 0 0 34.922666-18.133333l177.109334-251.968c11.989333-19.072 44.373333-33.706667 78.848-17.984 51.733333 23.552 113.685333 74.986667 113.685333 160.213333 0 32.128-14.293333 74.752-42.816 127.872z" />
    </svg>
  );
}
