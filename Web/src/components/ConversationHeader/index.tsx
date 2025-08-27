import React, { FC, useCallback, useState } from 'react';
import { Portal } from '..';
import { GroupModal, OneOneModal, OneOneHiModal, BotGroupModal, BotOneOneModal } from '../ConversationModal';
import { IS_EXTERNAL_DEMO } from '../../constant';

import HeaderBox from './Styles';
import { Button, Message, Modal, Tooltip } from '@arco-design/web-react';
import { IconEmpty, IconUserAdd, IconUserGroup, IconRobotAdd } from '@arco-design/web-react/icon';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance } from '../../store';
import { useRequest } from 'ahooks';

interface ConversationHeaderProps {
  createGroupConversation?: any;
  createOneOneConversation?: any;
  createOneOneHiConversation?: any;
  createBotGroupConversation?: any;
  createBotOneOneConversation?: any;
}
const ModalMap = {
  GROUP: GroupModal,
  ONE_ONE: OneOneModal,
  ONE_ONE_HI: OneOneHiModal,
  BOT_GROUP: BotGroupModal,
  BOT_ONE_ONE: BotOneOneModal,
};

const ConversationHeader: FC<ConversationHeaderProps> = props => {
  const {
    createGroupConversation,
    createOneOneConversation,
    createOneOneHiConversation,
    createBotGroupConversation,
    createBotOneOneConversation,
  } = props;

  const [createModalVisible, setCreateModalVisible] = useState(false);
  const [createModal, setCreateModal] = useState<'GROUP' | 'ONE_ONE' | 'ONE_ONE_HI' | 'BOT_ONE_ONE' | 'BOT_GROUP'>();
  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  const handleCreateModalVisibleChange = useCallback(() => {
    setCreateModalVisible(pre => !pre);
  }, []);

  const handleGroupCreate = () => {
    setCreateModal('GROUP');
    handleCreateModalVisibleChange();
  };

  const handleSingleCreate = () => {
    setCreateModal('ONE_ONE');
    handleCreateModalVisibleChange();
  };
  const handleSingleHiCreate = () => {
    setCreateModal('ONE_ONE_HI');
    handleCreateModalVisibleChange();
  };

  const handleBotGroupCreate = () => {
    setCreateModal('BOT_GROUP');
    handleCreateModalVisibleChange();
  };

  const handleBotSingleCreate = () => {
    setCreateModal('BOT_ONE_ONE');
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
        case 'ONE_ONE':
          createFunc = createOneOneConversation;
          break;
        case 'ONE_ONE_HI':
          createFunc = createOneOneHiConversation;
          break;
        case 'BOT_GROUP':
          createFunc = createBotGroupConversation;
          break;
        case 'BOT_ONE_ONE':
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
        {!IS_EXTERNAL_DEMO && (
          <Tooltip content={'发起单聊，并打招呼'}>
            <Button type="primary" icon={<IconUserAdd />} onClick={handleSingleHiCreate}>
              单聊打招呼
            </Button>
          </Tooltip>
        )}
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
