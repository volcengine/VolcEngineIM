import { View, Image, Text } from '@tarojs/components';
import cls from 'classnames';
import { Conversation, FlightStatus } from '@volcengine/im-mp-sdk';
import { getMsgCreateTime } from '../../../utils/message-preview';

import { ME_AVATAR, OTHER_AVATAR } from '../../../constants';

import './index.scss';
import { useAccountsInfo } from '../../../hooks/useProfileUpdater';

interface CardProps {
  id: string;
  message: any;
  children?: any;
  onLongTap?: () => void;
}

const Card: React.FC<CardProps> = ({ id, message, children, onLongTap }) => {
  const { isTimeVisible, isFromMe, sender } = message;
  const time = getMsgCreateTime(message);
  const ACCOUNTS_INFO = useAccountsInfo();
  const currentConversation = message?.conversation;

  return (
    <View className="message-card-wrapper" id={id}>
      {/* 消息时间 */}
      {isTimeVisible && <View className="message-time">{time}</View>}

      {/* 消息卡片 */}
      <View
        className={cls('general-message-wrapper', {
          reverse: isFromMe,
          positive: !isFromMe
        })}
      >
        {/* 成员头像 */}
        <View className="avatar-wrapper">
          <Image className="avatar" src={ACCOUNTS_INFO[sender].url} style={{ borderRadius: 100 }} />
        </View>

        {/* 具体消息内容 */}
        <View
          className="container"
          onLongPress={onLongTap}
          onClick={() => {
            console.log(message);
          }}
        >
          <View className="content">{children}</View>
        </View>
      </View>
    </View>
  );
};

export default Card;
