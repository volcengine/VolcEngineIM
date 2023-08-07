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
  } = props;

  return (
    <svg
      className={`im-buyin-icon im-buyin-icon-down ${className}`}
      width={width}
      height={height}
      viewBox="0 0 24 24"
      xmlns="http://www.w3.org/2000/svg">
      <path d="M19.1317 2.8464L12 9.97812L4.86828 2.8464C4.67302 2.65114 4.35643 2.65114 4.16117 2.8464L3.45406 3.5535C3.2588 3.74877 3.2588 4.06535 3.45406 4.26061L11.2929 12.0994C11.6834 12.49 12.3166 12.49 12.7071 12.0994L20.5459 4.26061C20.7412 4.06535 20.7412 3.74877 20.5459 3.5535L19.8388 2.8464C19.6436 2.65114 19.327 2.65114 19.1317 2.8464Z"></path>
      <path d="M19.1317 11.7321L12 18.8639L4.86828 11.7321C4.67302 11.5369 4.35643 11.5369 4.16117 11.7321L3.45406 12.4392C3.2588 12.6345 3.2588 12.9511 3.45406 13.1464L11.2929 20.9852C11.6834 21.3757 12.3166 21.3757 12.7071 20.9852L20.5459 13.1464C20.7412 12.9511 20.7412 12.6345 20.5459 12.4392L19.8388 11.7321C19.6436 11.5369 19.327 11.5369 19.1317 11.7321Z"></path>
    </svg>
  );
}
