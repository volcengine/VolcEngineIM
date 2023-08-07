import React, { FC, memo } from 'react';
import { Conversation, PushStatus } from '@volcengine/im-web-sdk';

import Styles from './Styles';
import { getConversationLastMsgDesc, getConversationName } from '../../utils';
import ConversationItem from '../ConversationItem';

interface ConversationListProps {
  currentUser?: any;
  hasMore?: boolean;
  list: Conversation[];
  curConversationId?: string;
  onItemClick?: (item: Conversation) => void;
  onLoadMore?: () => void;
}

const ConversationList: FC<ConversationListProps> = props => {
  const { list = [], curConversationId, hasMore, onItemClick, onLoadMore, ...other } = props;

  if (!list.length) {
    return <div className="empty-conversation-wrap">暂无消息</div>;
  }

  return (
    <Styles>
      <div className="list">
        {list.map((item: Conversation) => {
          let { unreadCount } = item;
          let weak = item.pushStatus === PushStatus.Allow ? false : true;
          let watchPrefix = '';

          let isPartAllow = item.pushStatus === PushStatus.PartAllow;
          if (isPartAllow) {
            if (item.unreadCountWithWhiteList) {
              unreadCount = item.unreadCountWithWhiteList;
              weak = false;
              watchPrefix = '[关注的人]';
            }
          }

          return (
            <ConversationItem
              onClick={() => onItemClick(item)}
              title={getConversationName(item)}
              conversation={item}
              description={watchPrefix + getConversationLastMsgDesc(item)}
              isActive={curConversationId === item?.id}
            />
          );
        })}
      </div>
    </Styles>
  );
};

export default memo(ConversationList);
