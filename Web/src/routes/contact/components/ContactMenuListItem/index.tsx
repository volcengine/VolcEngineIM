import React, { memo, useMemo } from 'react';
import classNames from 'classnames';
import { Avatar, Badge } from '@arco-design/web-react';
import { Conversation } from '@volcengine/im-web-sdk';

import ListItem from './Styles';

import { getLastTime, getConversationAvatar } from '../../../../utils';
import { ReactComponent as MuteIcon } from '../../assets/svgs/Mute.svg';
import { ReactComponent as PinIcon } from '../../assets/svgs/Pin.svg';

interface ConversationItemPropsType {
  conversation?: Conversation;
  isActive?: boolean;
  onClick?: () => void;
  onTopConversation?: () => void;
  onMuteConversation?: () => void;
  title: React.ReactNode;
  description: string;
}

export const ContactMenuListItem: React.FC<ConversationItemPropsType> = memo(props => {
  const { conversation = {} as any, isActive, onClick, title, description } = props;

  const wrapClass = useMemo(() => {
    return classNames('conversation-item', {
      'is-active': isActive,
    });
  }, [isActive]);

  return (
    <ListItem className={wrapClass} onClick={onClick}>
      {/*<div className="conversation-left">*/}
      {/*  <Avatar size={30} shape="square">*/}
      {/*    <img src={getConversationAvatar(conversation)} alt="avatar" />*/}
      {/*  </Avatar>*/}
      {/*</div>*/}

      <div className="conversation-right">
        <div className="convesation-header">
          <div className="convesation-user">{title}</div>
        </div>
      </div>
    </ListItem>
  );
});
