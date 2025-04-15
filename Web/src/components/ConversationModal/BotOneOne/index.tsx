import React, { FC, useState } from 'react';
import { Button, Form, Input, Message, Modal, Select, Radio, Spin } from '@arco-design/web-react';

import { useBot } from '../../../hooks';
import { useRequest } from 'ahooks';
import Avatar from '../../Avatar';
import styles from './index.module.scss';

interface CreateConversationModelProps {
  onClose?: () => void;
  onCreate?: (value: any) => Promise<any>;
  title?: string;
  hint?: string;
  emptyUidMessage?: string;
  notExistUidMessage?: string;
}

const FormItem = Form.Item;
const { Option } = Select;

const CreateConversationModel: FC<CreateConversationModelProps> = props => {
  const [botId, setBotId] = useState('999880');
  const { getBotList } = useBot();

  const hanleCreate = async () => {
    if (!data?.length) {
      Message.error('机器人候选列表为空');
      return;
    }
    if (!botId) {
      Message.error(props.emptyUidMessage ?? '机器人 uid 不存在');
      return;
    }
    const result = await props.onCreate(botId);
    if (result !== false) props.onClose();
  };

  const handleCloseClick = () => {
    props.onClose();
  };

  const { data, loading } = useRequest(getBotList);
  const { run, loading: btnLoading } = useRequest(hanleCreate, { manual: true });

  return (
    <Modal
      title={props.title ?? '创建机器人单聊'}
      onOk={run}
      onCancel={handleCloseClick}
      visible={true}
      confirmLoading={btnLoading}
    >
      <Spin tip="loading Data..." loading={loading}>
        <Form autoComplete="off">
          <FormItem required={true}>
            <Radio.Group direction="vertical" className={styles['radio-group']} value={botId} onChange={setBotId}>
              {data?.map((item: any) => (
                <Radio value={item.uid} className={styles['radio-item']}>
                  <div className={styles['radio-item-content']}>
                    <Avatar url={item.portrait} size={36} />
                    {item.nick_name}
                  </div>
                </Radio>
              ))}
            </Radio.Group>
          </FormItem>
        </Form>
      </Spin>
    </Modal>
  );
};

// const CreateConversationModel: FC<CreateConversationModelProps> = props => {
//   const { run, loading } = useRequest(
//     async () => {
//       if (!inputUserId) {
//         Message.error(props.emptyUidMessage ?? '请输入机器人 ID');
//         return;
//       }
//       const result = await props.onCreate(inputUserId);
//       if (result !== false) props.onClose();
//     },
//     { manual: true }
//   );

//   const handleCloseClick = () => {
//     props.onClose();
//   };

//   const [inputUserId, setInputUserId] = useState('');

//   return (
//     <Modal
//       title={props.title ?? '创建机器人单聊'}
//       onOk={run}
//       onCancel={handleCloseClick}
//       visible={true}
//       confirmLoading={loading}
//     >
//       <Form autoComplete="off">
//         <FormItem label="机器人 ID" required={true}>
//           <Input
//             placeholder={props.hint ?? '请输入机器人 ID 发起单聊'}
//             value={inputUserId}
//             onChange={v => {
//               if (!v || /^\d+$/.test(v)) setInputUserId(v);
//             }}
//             maxLength={20}
//             showWordLimit
//             disabled={loading}
//           />
//         </FormItem>
//       </Form>
//     </Modal>
//   );
// };

export default CreateConversationModel;
