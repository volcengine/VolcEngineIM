import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconLcation(props: IconProps) {
  const {
    className = '',
    prefix = '',
    width = '200',
    height = '200',
    useCurrentColor = false,
    ...rest
  } = props;

  return (
    <svg className={`im-icon im-icon-voice ${className}`}
      width={width}
      height={height}
      viewBox="0 0 1024 1024"
      version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2949">
      <path d="M537.9072 179.2c169.8304 0 307.5584 134.8608 306.8928 301.056 0 80.7936-32.2048 156.16-88.9344 212.3776l-164.4032 160.4608a76.8 76.8 0 0 1-107.1616 0.1536l-165.0688-160.1536A298.2912 298.2912 0 0 1 230.4 480.768C230.4 314.0096 368.0768 179.2 537.9072 179.2z m0 51.2C396.0832 230.4 281.6 342.528 281.6 480.768c0 66.7136 26.7776 129.536 73.472 175.7696l164.864 160a25.6 25.6 0 0 0 35.7376-0.0512l164.2496-160.3584A246.1184 246.1184 0 0 0 793.6 480.1024C794.112 342.528 679.68 230.4 537.9072 230.4z" p-id="2950"></path><path d="M609.3824 448.512c3.4816-40.3456-29.44-75.0592-70.8608-75.0592-39.3216 0-71.424 31.3856-71.424 69.376 0 40.0384 35.5328 72.3456 77.3632 68.8128 34.816-2.56 62.2592-29.4912 64.9216-63.1296z m-60.8768 114.176c-71.3216 5.9392-132.608-49.7152-132.608-119.8592 0-66.5088 55.2448-120.576 122.624-120.576 71.0656 0 128 59.9552 121.856 130.4064-4.608 58.88-52.3264 105.5744-111.872 110.08z" p-id="2951"></path>
    </svg>
  );
}
