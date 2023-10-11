import { useCallback } from 'react';
import { View, Image, Text } from '@tarojs/components';
import { OsBadge } from 'ossaui';

import { getMsgPreviewContent, getMsgCreateTime } from '../../utils/message-preview';
import { CONVERSATION_GROUP_AVATAR, CONVERSATION_SINGLE_AVATAR } from '../../constants';
import { ConversationType, StickTopState } from '../../enums';

import PinSvg from '../../assets/svg/pin.svg';

import './index.scss';

interface ConversationItemProps {
  conversation: any;
  onItemClick: (id) => void;
}

const ConversationItem: React.FC<ConversationItemProps> = ({ conversation, onItemClick }) => {
  const { unreadCount, id, lastVisibleMessage: message, settingInfo } = conversation;
  const { stickTop } = settingInfo;
  const content = message ? getMsgPreviewContent(message) : '';
  const time = message ? getMsgCreateTime(message) : '';

  const handleClick = useCallback(() => {
    onItemClick(id);
  }, [id, onItemClick]);

  return (
    <View className="conversation-item-wrapper" onClick={handleClick}>
      <OsBadge type="info" info={unreadCount} className="conversation-icon-wrapper">
        {conversation.type === ConversationType.ONE_TO_ONE_CHAT ? (
          <Image className="image" src={CONVERSATION_SINGLE_AVATAR} />
        ) : (
          <Image className="image" src={CONVERSATION_GROUP_AVATAR} />
        )}
      </OsBadge>

      <View className="container">
        <View className="name-wrapper">
          <Text className="name" numberOfLines="1">
            {conversation.coreInfo?.name || conversation.id}
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
