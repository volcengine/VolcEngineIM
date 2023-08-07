import React, { FC, memo } from 'react';
import { Avatar } from '../../../../../../components';

interface MessageAvatarProps extends React.AllHTMLAttributes<HTMLDivElement> {
  className?: string;
  source?: string;
  desc?: string;
}

const noop = () => {};

const MessageAvatar: FC<MessageAvatarProps> = memo(
  props => {
    const { source, desc, className, onClick = noop, ...restProps } = props;

    return (
      <div className="message-avatar" onClick={onClick}>
        <Avatar size={24} url={source} desc={desc} />
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
