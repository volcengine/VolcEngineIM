import React, { FC, memo } from 'react';

import UnknownMessageBox from './Styles';

interface UnknownMessageProps {}

const UnknownMessage: FC<UnknownMessageProps> = () => {
  return (
    <UnknownMessageBox className="message-content">
      <p className="unknown-message">当前版本不支持查看这部分内容</p>
    </UnknownMessageBox>
  );
};

export default memo(UnknownMessage);
