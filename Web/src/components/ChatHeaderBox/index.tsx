import React, { FC, memo, ComponentType } from 'react';

interface ChatHeaderBoxProps {
  Component?: ComponentType<any> | any;
  userInfo?: any;
  imId?: string;
  conversation?: any;
  onStartVideoCall?: any;
  onTopConversation?: any;
  onCloseConversation?: any;
  onMuteConversation?: any;
}

const ChatHeaderBox: FC<ChatHeaderBoxProps> = memo(props => {
  const { Component, conversation, ...restProps } = props;

  if (!Component) {
    return null;
  }

  return <Component conversation={conversation} {...restProps} />;
});

export default ChatHeaderBox;
