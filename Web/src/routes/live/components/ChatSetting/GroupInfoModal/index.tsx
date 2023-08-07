import React, { FC, useImperativeHandle, useRef } from 'react';
import { Input } from '@arco-design/web-react';
import { RefInputType } from '@arco-design/web-react/es/Input/interface';

import GroupInfoModalBox from './Styles';

const { TextArea } = Input;

interface GroupInfoModalProps {
  defaultName: string;
  defaultDesc: string;
  ref: any;
}

const GroupInfoModal: FC<GroupInfoModalProps> = React.forwardRef((props, ref) => {
  const { defaultName, defaultDesc } = props;
  const nameInputRef = useRef<RefInputType>();
  const descInputRef = useRef<HTMLTextAreaElement>();

  useImperativeHandle(ref, () => ({
    nameRef: nameInputRef,
    descRef: descInputRef,
  }));

  return (
    <GroupInfoModalBox>
      <div className="form-item">
        <div className="form-item-label">群名称</div>
        <Input
          className="input-wrapper"
          type="text"
          placeholder="请输入群名称"
          ref={nameInputRef}
          maxLength={10}
          showWordLimit
          defaultValue={defaultName}
        />
      </div>

      <div className="form-item ">
        <div className="form-item-label">群描述</div>
        <TextArea
          className="area-wrapper"
          placeholder="请输入群描述"
          maxLength={100}
          showWordLimit
          // @ts-ignore
          ref={descInputRef}
          defaultValue={defaultDesc}
        />
      </div>
    </GroupInfoModalBox>
  );
});

export default GroupInfoModal;
