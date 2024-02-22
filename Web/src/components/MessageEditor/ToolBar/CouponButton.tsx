import React, { FC } from 'react';
import { Tooltip } from '@arco-design/web-react';
import { im_proto } from '@volcengine/im-web-sdk';

import { ReactComponent as Ticket } from '../../../assets/svgs/Ticket.svg';
import IconButtonMask from '../../IconButtonMask';

interface CouponButtonProps {
  sendMessage?: any;
}

const CouponButton: FC<CouponButtonProps> = props => {
  const { sendMessage } = props;

  const handleClick = () => {
    sendMessage?.();
  };

  return (
    <Tooltip position="top" content="优惠券(自定义消息)">
      <div className="toolbar-item" onClick={handleClick}>
        <IconButtonMask>
          <Ticket className={'arco-icon'} style={{ fontSize: 24 }} />
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default CouponButton;
