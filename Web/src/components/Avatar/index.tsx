import React, { FC, memo, CSSProperties } from 'react';

interface IAvatarPropsType {
  size?: number;
  url?: string;
  desc?: string;
  className?: string;
  style?: CSSProperties;
}

const Avatar: FC<IAvatarPropsType> = memo(({ size = 24, url = '' }) => {
  return (
    <div
      style={{
        width: size,
        height: size,
        borderRadius: '50%',
        backgroundImage: url ? `url(${url})` : 'none',
        backgroundSize: '100% 100%',
        backgroundColor: url ? 'transparent' : 'rgba(201, 205, 211, 1)',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        overflow: 'hidden',
        color: 'rgba(255, 255, 255, 1)',
        fontSize: size / 2 - 4,
      }}
    ></div>
  );
});

export default Avatar;
