import React, { FC } from 'react';

import { IconAdd } from '../../Icon';
import { Tooltip } from '@arco-design/web-react';
import IconButtonMask from '../../IconButtonMask';

interface MorePanelButtonProps {}

const MorePanelButton: FC<MorePanelButtonProps> = props => {
  return (
    <Tooltip position="top" content="更多">
      <div className="toolbar-item more-item">
        <IconButtonMask>
          <IconAdd />
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default MorePanelButton;
