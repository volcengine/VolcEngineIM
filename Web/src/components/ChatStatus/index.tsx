import React from 'react';
import { Tag } from '..';
import { IconSendFailed } from '../Icon';
import ChatStatusBox from './Styles';

interface ChatStatusTypes {
  chatStatus?: any; // 应该是由 demo 维护的状态现在耦合到 fe-sdk 里
}

// 0: 正常 非0:账号异常
export enum ImAccountStatus {
  Normal = 0,
  /** 百应账户异常 */
  ByAbnormal = 1,
  /** im账号异常 */
  ImAbnormal = 2,
  /** 达人电商权限异常 */
  PermissionsAbnormal = 3,
}

export const ImAccountStatusText = {
  [ImAccountStatus.Normal]: '',
  [ImAccountStatus.ByAbnormal]: '',
  [ImAccountStatus.ImAbnormal]: '',
  [ImAccountStatus.PermissionsAbnormal]: '',
};

const ChatStatus: React.FC<ChatStatusTypes> = props => {
  const { chatStatus = 0 } = props;

  return chatStatus !== 0 ? (
    <ChatStatusBox>
      <Tag icon={<IconSendFailed />}>对方账号状态异常，请稍后再试</Tag>
    </ChatStatusBox>
  ) : null;
};

export default ChatStatus;
