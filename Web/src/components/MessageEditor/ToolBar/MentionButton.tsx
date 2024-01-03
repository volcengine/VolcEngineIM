import React, { FC, useCallback } from 'react';
import { Select, Tooltip } from '@arco-design/web-react';
import { IconAt } from '@arco-design/web-react/icon';

import IconButtonMask from '../../IconButtonMask';
import { useAccountsInfo } from '../../../hooks';

interface MentionButtonProps {
  isSimple: boolean;
  suggestions: any;
  editor?: HTMLTextAreaElement;
}

const MentionButton: FC<MentionButtonProps> = props => {
  const { isSimple, suggestions, editor } = props;
  const ACCOUNTS_INFO = useAccountsInfo();

  return (
    <Select
      value={''}
      defaultActiveFirstOption={false}
      onChange={value => {
        editor.value += '@' + ACCOUNTS_INFO[value].realName;
      }}
      triggerProps={{
        position: 'tl',
        autoAlignPopupWidth: false,
      }}
      triggerElement={
        <Tooltip
          position="top"
          content={
            <>
              <div>提及成员</div>
            </>
          }
        >
          <div className="toolbar-item">
            <IconButtonMask>
              <IconAt style={{ fontSize: '20px' }} />
            </IconButtonMask>
          </div>
        </Tooltip>
      }
    >
      {suggestions?.map(i => (
        <Select.Option value={i.id} key={i.id}>
          {i.username}
        </Select.Option>
      ))}
    </Select>
  );
};

export default MentionButton;
