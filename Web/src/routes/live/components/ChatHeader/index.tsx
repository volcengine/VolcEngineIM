import React, { memo } from 'react';
import { Conversation } from '@volcengine/im-web-sdk';

import { Avatar } from '../../../../components';
import { getConversationAvatar, getConversationName } from '../../../../utils/message';

import Styles from './Styles';
import { useRecoilValue } from 'recoil';
import { LiveConversationMemberCount } from '../../../../store';

interface ChatInfoPropsTypes {
  conversation?: Conversation;
}

export const ChatHeader: React.FC<ChatInfoPropsTypes> = memo(props => {
  const { conversation } = props;
  const liveConversationMemberCount = useRecoilValue(LiveConversationMemberCount);

  return (
    <Styles>
      <div className="chat-info">
        <div className="avatar">
          <Avatar url={getConversationAvatar(conversation)} size={36} />
        </div>
        <div className="info">
          <div className="name">{getConversationName(conversation)}</div>
          <div className="count">{liveConversationMemberCount ?? conversation?.onlineMemberCount}人在线</div>
        </div>
      </div>
    </Styles>
  );
});
