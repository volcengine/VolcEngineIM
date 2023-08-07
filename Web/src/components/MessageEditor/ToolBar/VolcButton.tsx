import React, { FC } from 'react';
import { Tooltip } from '@arco-design/web-react';
import { im_proto } from '@volcengine/im-web-sdk';

import { ReactComponent as Volcano } from '../../../assets/svgs/Volcano.svg';
import IconButtonMask from '../../IconButtonMask';

interface VolcButtonProps {
  sendMessage?: any;
}

const VolcButton: FC<VolcButtonProps> = props => {
  const { sendMessage } = props;

  const handleClick = () => {
    sendMessage?.();
  };

  return (
    <Tooltip position="top" content="自定义消息">
      <div className="toolbar-item" onClick={handleClick}>
        <IconButtonMask>
          <Volcano />
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default VolcButton;
