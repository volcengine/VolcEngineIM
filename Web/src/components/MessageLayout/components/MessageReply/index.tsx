import React, { FC, useCallback, memo } from 'react';
import { Message, im_proto } from '@volcengine/im-web-sdk';

import { getMessagePreview } from '../../../../utils/message';
import { ACCOUNTS_INFO } from '../../../../constant';

import MessageReplyBox from './Styles';

interface MessageReplyProps {
  isBurned?: boolean;
  message?: Message;
  messageStatus?: im_proto.MessageStatus;
}

const MessageReply: FC<MessageReplyProps> = props => {
  const { message, messageStatus } = props;
  const { sender } = message || {};

  const getReplyHeaderText = () => {
    return `回复${ACCOUNTS_INFO[sender]?.name}:`;
  };

  const getReplyContent = (msg: Message) => {
    if (messageStatus === im_proto.MessageStatus.RECALLED) {
      return '消息已被撤回';
    } else if (messageStatus === im_proto.MessageStatus.AVAILABLE) {
      return getMessagePreview(msg);
    } else {
      return '消息已被删除';
    }
  };

  return (
    <MessageReplyBox className="message-header reply-header">
      <div className="reply-title">
        <div className="reply-person">{getReplyHeaderText()}&nbsp;</div>
        <div className="reply-content">{getReplyContent(message)}</div>
      </div>
    </MessageReplyBox>
  );
};

export default memo(MessageReply);
