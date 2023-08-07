import React, { FC, useImperativeHandle, useRef, useState } from 'react';
import { Input } from '@arco-design/web-react';
import { RefInputType } from '@arco-design/web-react/es/Input/interface';

import GroupTransferModalBox from './Styles';

interface GroupTransferModalProps {
  ref: any;
}

export const GroupTransferModal: FC<GroupTransferModalProps> = React.forwardRef((prop, ref) => {
  const nameInputRef = useRef<RefInputType>();
  const [name, setName] = useState('');

  useImperativeHandle(ref, () => ({
    nameRef: nameInputRef,
  }));

  return (
    <GroupTransferModalBox>
      <div className="form-item">
        <Input
          className="input-wrapper"
          type="text"
          placeholder="请输入用户ID"
          ref={nameInputRef}
          value={name}
          showWordLimit
          onChange={value => {
            setName(value);
          }}
        />
      </div>
    </GroupTransferModalBox>
  );
});
