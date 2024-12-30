import React, { FC, useCallback, useState } from 'react';
import { Portal } from '..';
import { GroupModal, OneOneModal } from '../ConversationModal';

import HeaderBox from './Styles';
import { Button, Message, Modal, Tooltip } from '@arco-design/web-react';
import { IconEmpty, IconUserAdd, IconUserGroup } from '@arco-design/web-react/icon';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance } from '../../store';
import { useRequest } from 'ahooks';

interface ConversationHeaderProps {
  createGroupConversation?: any;
  createOneOneConversation?: any;
}
const ModalMap = {
  GROUP: GroupModal,
  ONEONE: OneOneModal,
};

const ConversationHeader: FC<ConversationHeaderProps> = props => {
  const { createGroupConversation, createOneOneConversation } = props;

  const [createModalVisible, setCreateModalVisible] = useState(false);
  const [createModal, setCreateModal] = useState<'GROUP' | 'ONEONE'>();
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const handleCreateModalVisibleChange = useCallback(() => {
    setCreateModalVisible(pre => !pre);
  }, []);

  const handleGroupCreate = () => {
    setCreateModal('GROUP');
    handleCreateModalVisibleChange();
  };

  const handleSingleCreate = () => {
    setCreateModal('ONEONE');
    handleCreateModalVisibleChange();
  };

  const { run: handleAllRead, loading: handleAllReadLoading } = useRequest(
    async () => {
      try {
        await bytedIMInstance.batchMarkConversationRead();
        Message.success('操作成功');
      } catch (e) {
        Message.error('操作失败');
      }
    },
    { manual: true }
  );

  const renderModal = () => {
    if (createModal) {
      const Cmp = ModalMap[createModal];
      const createFunc = createModal === 'GROUP' ? createGroupConversation : createOneOneConversation;
      return <Cmp onClose={handleCreateModalVisibleChange} onCreate={createFunc} />;
    }
  };

  return (
    <HeaderBox>
      <Button.Group>
        <Button type="primary" icon={<IconUserGroup />} onClick={handleGroupCreate}>
          发起群聊
        </Button>
        <Button type="primary" icon={<IconUserAdd />} onClick={handleSingleCreate}>
          发起单聊
        </Button>
        <Tooltip content={'清除未读'}>
          <Button
            type="primary"
            icon={<IconEmpty />}
            onClick={() => {
              Modal.confirm({
                title: '确定要清除所有未读提醒？',
                onConfirm: async () => {
                  return handleAllRead();
                },
              });
            }}
            loading={handleAllReadLoading}
          ></Button>
        </Tooltip>
      </Button.Group>

      {createModalVisible && <Portal>{renderModal()}</Portal>}
    </HeaderBox>
  );
};

export default ConversationHeader;
