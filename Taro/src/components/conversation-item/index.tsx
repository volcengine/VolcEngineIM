import { useCallback } from 'react';
import { View, Image, Text } from '@tarojs/components';
import { OsBadge } from 'ossaui';
import cls from 'classnames';

import { getMsgPreviewContent, getMsgCreateTime } from '../../utils/message-preview';
import { ConversationType, StickTopState } from '../../enums';

import PinSvg from '../../assets/svg/pin.svg';

import './index.scss';
import { getConversationAvatar, getConversationName } from '../../utils/account';
import { useAccountsInfo } from '../../hooks/useProfileUpdater';
import { Conversation } from '@volcengine/im-mp-sdk';

interface ConversationItemProps {
  conversation: any;
  selectConversation: (conversation: Conversation) => void;
  onItemClick: (id) => void;
}

const ConversationItem: React.FC<ConversationItemProps> = ({ conversation, onItemClick, selectConversation }) => {
  const { unreadCount, id, lastVisibleMessage: message, settingInfo, isMuted } = conversation;
  const { stickTop } = settingInfo;
  const content = message ? getMsgPreviewContent(message) : '';
  const time = message ? getMsgCreateTime(message) : '';

  const handleClick = useCallback(() => {
    onItemClick(id);
  }, [id, onItemClick]);
  useAccountsInfo();

  return (
    <View
      className="conversation-item-wrapper"
      onClick={handleClick}
      onLongPress={() => {
        selectConversation(conversation);
      }}
    >
      <OsBadge
        type="info"
        info={unreadCount}
        className={cls('conversation-icon-wrapper', {
          weak: isMuted
        })}
      >
        {conversation.type === ConversationType.ONE_TO_ONE_CHAT ? (
          <Image className="image" src={getConversationAvatar(conversation)} />
        ) : (
          <Image className="image" src={getConversationAvatar(conversation)} />
        )}
      </OsBadge>

      <View className="container">
        <View className="name-wrapper">
          <Text className="name" numberOfLines="1">
            {getConversationName(conversation)}
          </Text>

          {StickTopState.On === stickTop && <Image className="pin-icon" src={PinSvg}></Image>}

          <View className="time">{time}</View>
        </View>

        <Text className="content" numberOfLines="1">
          {content ?? '暂无新消息'}
        </Text>
      </View>
    </View>
  );
};

export default ConversationItem;
