import React, { FC, memo } from 'react';
import { Avatar, ProfilePopover } from '../../../../../../components';

interface MessageAvatarProps extends React.AllHTMLAttributes<HTMLDivElement> {
  className?: string;
  source?: string;
  desc?: string;
  strUserId?: string;
}

const noop = () => {};

const MessageAvatar: FC<MessageAvatarProps> = memo(
  props => {
    const { source, desc, className, strUserId, onClick = noop, ...restProps } = props;

    return (
      <div className="message-avatar" onClick={onClick}>
        <ProfilePopover userId={desc} userIdStr={strUserId} other={!!strUserId}>
          <Avatar size={24} url={source} desc={desc} />
        </ProfilePopover>
      </div>
    );
  },
  (pre: MessageAvatarProps, cur: MessageAvatarProps) => {
    if (pre?.source !== cur?.source) {
      return false;
    }
    return true;
  }
);

export default MessageAvatar;
