import React, { FC, useState } from 'react';
import { Button, Form, Input, List, Message, Modal, Transfer } from '@arco-design/web-react';
import { useRecoilValue } from 'recoil';

import { DefaultUserIds, UserId } from '../../../store';

import styles from './index.module.scss';
import { useRequest } from 'ahooks';
import { checkAccount } from '../../../apis/app';

interface CreateConversationModelProps {
  onClose?: () => void;
  onSearch?: (value: any) => void;
  onCreate?: (value: any, bizExt) => Promise<boolean>;
}

export function UserIdsInput({
  groupIds,
  setGroupIds,
  placeholder,
  disabled,
  maxCount = 200,
}: {
  groupIds: string[];
  setGroupIds: (groupIds: string[]) => void;
  placeholder?: string;
  disabled?: boolean;
  maxCount?: number;
}) {
  const [inputUserId, setInputUserId] = useState('');
  let exceedMaxCount = groupIds.length >= maxCount;
  const { run, loading } = useRequest(
    async (useString?: boolean) => {
      let data = await checkAccount({ uids: [inputUserId], useString });
      if (!data[inputUserId]) {
        Message.error(`该用户不存在`);
        return;
      }
      setGroupIds([inputUserId, ...groupIds]);
      setInputUserId('');
    },
    { manual: true }
  );

  return (
    <div className={styles['user-input-wrapper']}>
      {/*<Transfer simple dataSource={dataSource} titleTexts={['全部好友', '已选择']} onChange={handleTransferData} />*/}
      <Input
        placeholder={exceedMaxCount ? '最多只能选择' + maxCount + '个用户' : placeholder ?? '请输入用户 ID'}
        value={inputUserId}
        onChange={v => {
          setInputUserId(v);
          // if (!v || /^\d+$/.test(v)) setInputUserId(v);
        }}
        maxLength={20}
        showWordLimit
        addAfter={
          <>
            <Button
              type="primary"
              onClick={() => {
                if (inputUserId) {
                  if (groupIds.includes(inputUserId)) {
                    Message.error('该 UserID 已添加');
                  } else {
                    run();
                  }
                }
              }}
              loading={loading}
              disabled={exceedMaxCount || disabled}
            >
              添加
            </Button>
            <Button
              type="primary"
              onClick={() => {
                if (inputUserId) {
                  if (groupIds.includes(inputUserId)) {
                    Message.error('该 UserID 已添加');
                  } else {
                    run(true);
                  }
                }
              }}
              loading={loading}
              disabled={exceedMaxCount || disabled}
            >
              string uid 添加
            </Button>
          </>
        }
        disabled={exceedMaxCount || disabled}
      />
      <List
        height={51 * 5 + 10}
        size="small"
        dataSource={groupIds}
        render={(item, index) => (
          <List.Item key={index}>
            <div className={styles['user-list-line']}>
              <div>{item}</div>
              <Button
                type={'text'}
                onClick={() => setGroupIds(groupIds.filter(id => id !== item))}
                disabled={loading || disabled}
              >
                移除
              </Button>
            </div>
          </List.Item>
        )}
      />
    </div>
  );
}

const CreateConversationModel: FC<CreateConversationModelProps> = props => {
  const [groupName, setGroupName] = useState<string>();
  const [groupIds, setGroupIds] = useState<string[]>([]);
  const [notExistIds, setNotExistIds] = useState([]);

  const userId = useRecoilValue(UserId);
  const { run, loading } = useRequest(
    async () => {
      if (groupIds.length <= 0) {
        Message.error('至少选择一个好友');
        return;
      }

      const bizExt = {
        userId,
        name: groupName?.trim() || '未命名群聊',
      };

      let data = await checkAccount({ uids: groupIds });
      const not = groupIds.filter(i => !data[i]);
      if (not.length) {
        setNotExistIds(not);
        Message.error('有不存在的用户11');
        return;
      }

      const result = await props.onCreate(groupIds, bizExt);
      if (!result) {
        return;
      }
      props.onClose();
    },
    { manual: true }
  );

  const handleCloseClick = () => {
    props.onClose();
  };

  const handleInputChange = value => {
    setGroupName(value);
  };

  return (
    <Modal title="创建群聊" onOk={run} onCancel={handleCloseClick} visible={true} confirmLoading={loading}>
      <Form>
        <Form.Item label={'群名称'}>
          <Input
            placeholder="请输入新群的群名称"
            value={groupName}
            onChange={handleInputChange}
            maxLength={10}
            showWordLimit
            disabled={loading}
          />
        </Form.Item>

        <Form.Item label={'添加群成员'}>
          <UserIdsInput groupIds={groupIds} setGroupIds={setGroupIds} maxCount={20} disabled={loading} />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default CreateConversationModel;
