import React, { FC, useCallback, useState } from 'react';
import { Input } from '@arco-design/web-react';

import { Portal } from '../../../../components';

import HeaderBox from './Styles';
import { Button } from '@arco-design/web-react';
import { IconUserAdd, IconUserGroup } from '@arco-design/web-react/icon';
import { LiveModel } from '../../../../components/ConversationModal';

interface ConversationHeaderProps {
  disPlayAllLiveConversation?: boolean;
  createLiveConversation?: any;
  onSearchChange?: (text: string) => void;
  onDisplayAllChange?: () => void;
}

export const ConversationHeader: FC<ConversationHeaderProps> = props => {
  const { disPlayAllLiveConversation = false, createLiveConversation, onSearchChange, onDisplayAllChange } = props;

  const [createModalVisible, setCreateModalVisible] = useState(false);

  const handleCreateModalVisibleChange = useCallback(() => {
    setCreateModalVisible(pre => !pre);
  }, []);

  const handleInputChange = value => {
    onSearchChange?.(value);
  };

  const handleDisplayAllChange = () => {
    onDisplayAllChange?.();
  };

  return (
    <HeaderBox>
      {disPlayAllLiveConversation ? (
        <div className="search-wrapper">
          <div className="input-wrapper">
            <Input placeholder="输入直播群名称" allowClear onChange={handleInputChange} />
          </div>
          <span className="text" onClick={handleDisplayAllChange}>
            取消
          </span>
        </div>
      ) : (
        <Button.Group>
          <Button type="primary" icon={<IconUserGroup />} onClick={handleDisplayAllChange}>
            查看全部
          </Button>
          <Button type="primary" icon={<IconUserAdd />} onClick={handleCreateModalVisibleChange}>
            创建直播群
          </Button>
        </Button.Group>
      )}

      {createModalVisible && (
        <Portal>
          <LiveModel onClose={handleCreateModalVisibleChange} onCreate={createLiveConversation} />
        </Portal>
      )}
    </HeaderBox>
  );
};
