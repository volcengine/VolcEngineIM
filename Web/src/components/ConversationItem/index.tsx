import React, { memo, useMemo } from 'react';
import classNames from 'classnames';
import { Avatar, Badge } from '@arco-design/web-react';
import { Conversation } from '@volcengine/im-web-sdk';
import { useRecoilValue } from 'recoil';

import ListItem from './Styles';

import { SpecialBotConvStickOnTop } from '../../store';
import { getLastTime, getConversationAvatar } from '../../utils';
import useBot from '../../hooks/useBot';
import { ReactComponent as MuteIcon } from '../../assets/svgs/Mute.svg';
import { ReactComponent as PinIcon } from '../../assets/svgs/Pin.svg';

interface ConversationItemPropsType {
  conversation?: Conversation;
  isActive?: boolean;
  onClick?: () => void;
  onTopConversation?: () => void;
  onMuteConversation?: () => void;
  title: string;
  description: string;
  isOnline?: boolean;
}

const ConversationItem: React.FC<ConversationItemPropsType> = memo(props => {
  const { conversation = {} as Conversation, isActive, onClick, title, description, isOnline = false } = props;
  const lastMessage = conversation?.lastVisibleMessage;

  const specialBotConvStickOnTop = useRecoilValue(SpecialBotConvStickOnTop);

  const { isSpecialBotConversionV2 } = useBot();

  const wrapClass = useMemo(() => {
    return classNames('conversation-item', {
      'is-active': isActive,
    });
  }, [isActive]);

  const showStickOnTopIcon = useMemo(() => {
    const isSpecialBotConv = isSpecialBotConversionV2(conversation.toParticipantUserId);
    if (isSpecialBotConv) {
      return specialBotConvStickOnTop;
    } else {
      return conversation.isStickOnTop;
    }
  }, [conversation.isStickOnTop, specialBotConvStickOnTop, isSpecialBotConversionV2, conversation.toParticipantUserId]);

  return (
    <ListItem className={wrapClass} onClick={onClick}>
      <div className="conversation-left">
        <Badge
          count={conversation.unreadCount}
          maxCount={99}
          dotClassName={classNames({
            'baged-number-gray': conversation.isMuted,
          })}
        >
          <Avatar size={30} shape="square">
            <img src={getConversationAvatar(conversation)} alt="avatar" />
          </Avatar>
        </Badge>
      </div>
      <div className="conversation-right">
        <div className="convesation-header">
          <div className="convesation-user">{title}</div>
          {showStickOnTopIcon && <PinIcon />}
          <div className="convesation-time">{getLastTime(lastMessage?.createdAt)}</div>
        </div>
        <div className="message-preview-container">
          <span className="message-preview-content">{description}</span>
          {conversation.isMuted && <MuteIcon />}
        </div>
      </div>
    </ListItem>
  );
});

export default ConversationItem;
