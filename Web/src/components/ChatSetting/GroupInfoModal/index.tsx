import React, { FC, useImperativeHandle, useRef, useState } from 'react';
import { Input } from '@arco-design/web-react';
import { RefInputType } from '@arco-design/web-react/es/Input/interface';
import { Conversation } from '@volcengine/im-web-sdk';

import GroupInfoModalBox from './Styles';

const { TextArea } = Input;

interface GroupInfoModalProps {
  currentConversation: Conversation;
  ref: any;
}

const GroupInfoModal: FC<GroupInfoModalProps> = React.forwardRef(({ currentConversation }, ref) => {
  const nameInputRef = useRef<RefInputType>();
  const descInputRef = useRef<any>();

  const {
    coreInfo: { desc: defaultDesc, name: defaultName },
  } = currentConversation;

  const [name, setName] = useState(defaultName);
  const [desc, setDesc] = useState(defaultDesc);

  useImperativeHandle(ref, () => ({
    nameRef: nameInputRef,
    descRef: descInputRef,
  }));

  return (
    <GroupInfoModalBox>
      {/* <div className="form-item">
        <div className="form-item-label">群头像</div>
        <div className="form-item-content">
          <div className="group-avatar">
            <img src="" alt="" />
          </div>
        </div>
      </div> */}

      <div className="form-item">
        <div className="form-item-label">群名称</div>
        <Input
          className="input-wrapper"
          type="text"
          placeholder="请输入群名称"
          ref={nameInputRef}
          defaultValue={name}
          maxLength={10}
          showWordLimit
          onChange={value => {
            setName(value);
          }}
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
          defaultValue={desc}
          onChange={value => {
            setDesc(value);
          }}
        />
      </div>
    </GroupInfoModalBox>
  );
});

export default GroupInfoModal;
