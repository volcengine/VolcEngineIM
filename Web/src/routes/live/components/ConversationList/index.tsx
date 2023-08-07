import React, { FC, memo } from 'react';
import { Conversation, PushStatus } from '@volcengine/im-web-sdk';

import { ConversationItem } from '../ConversationItem';
import { getConversationLastMsgDesc, getConversationName } from '../../../../utils';

import Styles from './Styles';

interface ConversationListProps {
  currentUser?: any;
  hasMore?: boolean;
  list: Conversation[];
  curConversationId?: string;
  onItemClick?: (item: Conversation) => void;
  onLoadMore?: () => void;
}

export const ConversationList: FC<ConversationListProps> = props => {
  const { list = [], curConversationId, hasMore, onItemClick, onLoadMore, ...other } = props;

  if (!list.length) {
    return <div className="empty-conversation-wrap">直播群</div>;
  }

  return (
    <Styles>
      <div className="list">
        {list.map((item: Conversation, index, indexMax) => {
          return (
            <ConversationItem
              onClick={() => onItemClick(item)}
              title={getConversationName(item)}
              conversation={item}
              description=""
              isActive={curConversationId === item?.id}
            />
          );
        })}
      </div>
    </Styles>
  );
};
