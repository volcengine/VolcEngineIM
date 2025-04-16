import React, { FC, useCallback, useState } from 'react';
import { Portal } from '..';
import { GroupModal, OneOneModal, BotGroupModal, BotOneOneModal } from '../ConversationModal';

import HeaderBox from './Styles';
import { Button, Message, Modal, Tooltip } from '@arco-design/web-react';
import { IconEmpty, IconUserAdd, IconUserGroup, IconRobotAdd } from '@arco-design/web-react/icon';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance } from '../../store';
import { useRequest } from 'ahooks';

interface ConversationHeaderProps {
  createGroupConversation?: any;
  createOneOneConversation?: any;
  createBotGroupConversation?: any;
  createBotOneOneConversation?: any;
}
const ModalMap = {
  GROUP: GroupModal,
  ONEONE: OneOneModal,
  BOTGROUP: BotGroupModal,
  BOTONEONE: BotOneOneModal,
};

const ConversationHeader: FC<ConversationHeaderProps> = props => {
  const { createGroupConversation, createOneOneConversation, createBotGroupConversation, createBotOneOneConversation } =
    props;

  const [createModalVisible, setCreateModalVisible] = useState(false);
  const [createModal, setCreateModal] = useState<'GROUP' | 'ONEONE' | 'BOTONEONE' | 'BOTGROUP'>();
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

  const handleBotGroupCreate = () => {
    setCreateModal('BOTGROUP');
    handleCreateModalVisibleChange();
  };

  const handleBotSingleCreate = () => {
    setCreateModal('BOTONEONE');
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
      let createFunc = createOneOneConversation;
      switch (createModal) {
        case 'GROUP':
          createFunc = createGroupConversation;
          break;
        case 'ONEONE':
          createFunc = createOneOneConversation;
          break;
        case 'BOTGROUP':
          createFunc = createBotGroupConversation;
          break;
        case 'BOTONEONE':
          createFunc = createBotOneOneConversation;
          break;
        default:
          break;
      }
      return <Cmp onClose={handleCreateModalVisibleChange} onCreate={createFunc} />;
    }
  };

  return (
    <HeaderBox>
      <Button.Group className="btn-group">
        <Tooltip content={'发起群聊'}>
          <Button type="primary" icon={<IconUserGroup />} onClick={handleGroupCreate}>
            群聊
          </Button>
        </Tooltip>
        <Tooltip content={'发起单聊'}>
          <Button type="primary" icon={<IconUserAdd />} onClick={handleSingleCreate}>
            单聊
          </Button>
        </Tooltip>
        {/* <Tooltip content={'创建机器人群聊'}>
          <Button type="primary" icon={<IconRobotAdd />} onClick={handleBotGroupCreate}>
            群聊机器人
          </Button>
        </Tooltip> */}
        <Tooltip content={'创建机器人单聊'}>
          <Button type="primary" icon={<IconRobotAdd />} onClick={handleBotSingleCreate}>
            单聊机器人
          </Button>
        </Tooltip>
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
