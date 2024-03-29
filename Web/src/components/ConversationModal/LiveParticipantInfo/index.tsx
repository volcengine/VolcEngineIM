import React, { FC, useState } from 'react';
import { Button, Form, Input, Message, Modal, Radio, Select } from '@arco-design/web-react';
import Avatar from '../../Avatar';
import { useAccountsInfo } from '../../../hooks';

interface LiveParticipantInfoModelProps {
  onClose?: () => void;
  onSubmit?: (value: { avatarUrl?: string; alias?: string }) => Promise<boolean>;
  userId?: string;
  initAlias?: string;
  initAvatarUrl?: string;
  title?: string;
}

const LiveParticipantInfoModel: FC<LiveParticipantInfoModelProps> = props => {
  const handleCreateClick = async () => {
    try {
      await form.validate();
    } catch (e) {
      Message.error(e);
    }
    if (
      await props.onSubmit({
        avatarUrl: form.getFieldValue('avatarUrl') || '',
        alias: form.getFieldValue('alias') || '',
      })
    )
      props.onClose();
  };

  const handleCloseClick = () => {
    props.onClose();
  };

  const [form] = Form.useForm();
  const ACCOUNTS_INFO = useAccountsInfo();

  return (
    <Modal
      title={props.title ?? '编辑直播群成员资料'}
      onOk={handleCreateClick}
      onCancel={handleCloseClick}
      visible={true}
    >
      <Form
        form={form}
        labelCol={{
          style: { flexBasis: 90 },
        }}
        wrapperCol={{
          style: { flexBasis: 'calc(100% - 90px)' },
        }}
        initialValues={{
          avatarUrl: props.initAvatarUrl ?? '',
          alias: props.initAlias ?? '',
        }}
      >
        <Form.Item label="我的群昵称" field="alias">
          <Input maxLength={10} showWordLimit autoComplete={'off'} />
        </Form.Item>
        <Form.Item label="我的群头像" field="avatarUrl">
          <Input maxLength={500} showWordLimit />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default LiveParticipantInfoModel;
