import React, { FC, useState } from 'react';
import { Button, Form, Input, Message, Modal, Select } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';

import { DefaultUserIds, UserId } from '../../../store';
import { ACCOUNTS_INFO } from '../../../constant';
import { useRequest } from 'ahooks';
import { checkAccount } from '../../../apis/app';

interface CreateConversationModelProps {
  onClose?: () => void;
  onCreate?: (value: any) => void;
}

const FormItem = Form.Item;
const { Option } = Select;

const CreateConversationModel: FC<CreateConversationModelProps> = props => {
  const { run, loading } = useRequest(
    async () => {
      if (!inputUserId) {
        Message.error('请输入用户 ID');
        return;
      }
      let data = await checkAccount({ uids: [inputUserId] });
      if (!data[inputUserId]) {
        Message.error('该用户不存在');
        return;
      }
      await props.onCreate(inputUserId);
      props.onClose();
    },
    { manual: true }
  );

  const handleCloseClick = () => {
    props.onClose();
  };

  const [inputUserId, setInputUserId] = useState('');

  return (
    <Modal title="发起单聊" onOk={run} onCancel={handleCloseClick} visible={true} confirmLoading={loading}>
      <Form autoComplete="off">
        <FormItem label="用户 ID" required={true}>
          <Input
            placeholder="请输入邀请的用户 ID"
            value={inputUserId}
            onChange={v => {
              if (!v || /^\d+$/.test(v)) setInputUserId(v);
            }}
            maxLength={20}
            showWordLimit
            disabled={loading}
          />
        </FormItem>
      </Form>
    </Modal>
  );
};

export default CreateConversationModel;
