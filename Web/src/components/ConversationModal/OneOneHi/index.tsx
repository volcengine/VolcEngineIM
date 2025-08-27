import React, { FC, useState } from 'react';
import { Form, Input, Message, Modal } from '@arco-design/web-react';

import { useRequest } from 'ahooks';
import { checkAccount } from '../../../apis/app';

interface CreateConversationModelProps {
  onClose?: () => void;
  onCreate?: (toUserId: string, messageText: string) => Promise<any>;
  title?: string;
  hint?: string;
  messagePlaceholder?: string;
  emptyUidMessage?: string;
  notExistUidMessage?: string;
}

const FormItem = Form.Item;

const CreateConversationModel: FC<CreateConversationModelProps> = props => {
  const { run, loading } = useRequest(
    async () => {
      if (!inputUserId) {
        Message.error(props.emptyUidMessage ?? '请输入用户 ID');
        return;
      }
      if (!inputMessage) {
        Message.error(props.messagePlaceholder ?? '请输入打招呼语');
        return;
      }
      let data = await checkAccount({ uids: [inputUserId] });
      if (!data[inputUserId]) {
        Message.error(props.notExistUidMessage ?? '该用户不存在');
        return;
      }
      const result = await props.onCreate(inputUserId, inputMessage);
      if (result !== false) props.onClose();
    },
    { manual: true }
  );

  const handleCloseClick = () => {
    props.onClose();
  };

  const [inputUserId, setInputUserId] = useState('');
  const [inputMessage, setInputMessage] = useState('你好！');

  return (
    <Modal
      title={props.title ?? '发起单聊，并打招呼'}
      onOk={run}
      onCancel={handleCloseClick}
      visible={true}
      confirmLoading={loading}
    >
      <Form autoComplete="off">
        <FormItem label="用户 ID" required={true}>
          <Input
            placeholder={props.hint ?? '请输入邀请的用户 ID'}
            value={inputUserId}
            onChange={v => {
              if (!v || /^\d+$/.test(v)) setInputUserId(v);
            }}
            maxLength={20}
            showWordLimit
            disabled={loading}
          />
        </FormItem>
        <FormItem label="招呼语" required={true}>
          <Input
            placeholder={props.messagePlaceholder ?? '请输入打招呼语'}
            value={inputMessage}
            onChange={v => {
              setInputMessage(v);
            }}
            maxLength={50}
            showWordLimit
            disabled={loading}
          />
        </FormItem>
      </Form>
    </Modal>
  );
};

export default CreateConversationModel;
