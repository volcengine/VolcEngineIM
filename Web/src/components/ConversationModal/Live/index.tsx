import React, { FC, useState } from 'react';
import { Input, Modal } from '@arco-design/web-react';

interface CreateConversationModelProps {
  onClose?: () => void;
  onCreate?: (value: any) => boolean;
}

const CreateConversationModel: FC<CreateConversationModelProps> = props => {
  const [groupName, setGroupName] = useState<string>();

  const handleCreateClick = async () => {
    const params = {
      name: groupName?.trim() || '未命名群聊',
    };
    await props.onCreate(params);
    props.onClose();
  };

  const handleCloseClick = () => {
    props.onClose();
  };

  const handleInputChange = value => {
    setGroupName(value);
  };

  return (
    <Modal title="创建直播群" onOk={handleCreateClick} onCancel={handleCloseClick} visible={true}>
      <Input
        placeholder="请输入新群的群名称"
        value={groupName}
        onChange={handleInputChange}
        maxLength={10}
        showWordLimit
      />
    </Modal>
  );
};

export default CreateConversationModel;
