import { Message, Popover, Space, Tooltip, Typography } from '@arco-design/web-react';
import { Avatar } from '../index';
import { IconEdit } from '@arco-design/web-react/icon';
import React from 'react';
import { ACCOUNTS_INFO } from '../../constant';
import { useAccountsInfo } from '../../hooks';
import { useRecoilValue } from 'recoil';

import { UserIdStr } from '../../store';
function ProfilePopover({
  onEdit,
  userId,
  other,
  userIdStr,
  children,
  position,
}: {
  onEdit?: () => void;
  userId: string;
  other?: boolean;
  userIdStr?: string;
  children?: React.ReactNode;
  position?: 'top' | 'tl' | 'tr' | 'bottom' | 'bl' | 'br' | 'left' | 'lt' | 'lb' | 'right' | 'rt' | 'rb';
}) {
  const ACCOUNTS_INFO = useAccountsInfo();
  const selfUserIdStr = useRecoilValue(UserIdStr);
  let userInfo = ACCOUNTS_INFO[userId];

  return (
    <Popover
      content={
        <Space>
          <div onClick={onEdit} style={{ cursor: 'pointer' }}>
            <Avatar size={36} url={userInfo?.url} className="avatar" />
          </div>
          <div style={{ maxWidth: 200 }}>
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <div
                style={{
                  whiteSpace: 'nowrap',
                  textOverflow: 'ellipsis',
                  overflow: 'hidden',
                  display: 'inline-block',
                  width: '100%',
                }}
              >
                {userInfo?.name}
              </div>
              {onEdit && (
                <Tooltip content={'修改昵称'}>
                  <IconEdit onClick={onEdit} style={{ cursor: 'pointer' }}></IconEdit>
                </Tooltip>
              )}
            </div>
            ID: <Typography.Text copyable>{userInfo.id}</Typography.Text>
            <div>
              strUserID: <Typography.Text copyable>{other ? userIdStr : selfUserIdStr}</Typography.Text>
            </div>
          </div>
        </Space>
      }
      position={position}
      trigger={'hover'}
      onVisibleChange={visible => {
        if (visible) {
          window.dispatchEvent(
            new CustomEvent('profileRequest', {
              detail: { userIds: [userId], force: true },
            })
          );
        }
      }}
    >
      <div>{children}</div>
    </Popover>
  );
}

export default ProfilePopover;
