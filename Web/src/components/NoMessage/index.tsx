import React from 'react';
import noMessageImage from '../../assets/images/noMessage.png';
import { IMAccountInfoTypes } from '../../types';

interface NoMessageProps {
  userInfo?: IMAccountInfoTypes;
}

const NoMessage: React.FC<NoMessageProps> = () => {
  return (
    <div
      style={{
        margin: 'auto',
      }}
    >
      <img style={{ width: 320, height: 224 }} src={noMessageImage}></img>
    </div>
  );
};

export default NoMessage;
