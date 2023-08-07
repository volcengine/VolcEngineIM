import React, { FC, useCallback, useState } from 'react';
import { Portal } from '..';
import { GroupModal, OneOneModal } from '../ConversationModal';

import HeaderBox from './Styles';
import { Button } from '@arco-design/web-react';
import { IconUserAdd, IconUserGroup } from '@arco-design/web-react/icon';

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
      </Button.Group>

      {createModalVisible && <Portal>{renderModal()}</Portal>}
    </HeaderBox>
  );
};

export default ConversationHeader;
