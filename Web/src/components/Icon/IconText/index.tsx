import React from 'react';
export interface IconProps extends React.SVGProps<SVGSVGElement> {
  className?: string;
  prefix?: string;
  width?: string;
  height?: string;
  useCurrentColor?: boolean;
}

export default function IconText(props: IconProps) {
  const {
    className = '',
    prefix = '',
    width = '1em',
    height = '1em',
    useCurrentColor = false,
  } = props;

  return (
    <svg
      className={`im-icon im-icon-delete ${className}`}
      width={width}
      height={height}
      fill="currentColor"
      viewBox="0 0 1024 1024">
      <path d="M32 0 972.651987 0 972.651987 316.651576 931.05337 316.651576C931.05337 316.651576 851.664627 123.301587 757.99696 106.426488 664.326945 89.551388 599.217138 101.163665 599.217138 101.163665L598.048275 908.460659C598.048275 908.460659 624.046382 963.027206 666.957181 966.897965L761.948781 966.897965 761.948781 1022.63337 242.777214 1022.63337 244.09057 965.511776 327.28898 964.19607C327.28898 964.19607 389.765027 944.689555 389.765027 899.258944 389.765027 853.896474 391.083083 107.668185 391.083083 107.668185 391.083083 107.668185 288.327649 93.496156 234.939369 106.496972 181.625097 119.427304 87.881073 197.297106 73.598618 311.462763L32 312.778468 32 0 32 0 32 0Z"></path>
    </svg>
  );
}
