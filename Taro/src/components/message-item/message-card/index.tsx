import { View, Image } from '@tarojs/components';
import cls from 'classnames';

import { getMsgCreateTime } from '../../../utils/message-preview';

import { ME_AVATAR, OTHER_AVATAR } from '../../../constants';

import './index.scss';

interface CardProps {
  id: string;
  message: any;
  children?: any;
}

const Card: React.FC<CardProps> = ({ id, message, children }) => {
  const { isTimeVisible, isFromMe } = message;
  const time = getMsgCreateTime(message);

  return (
    <View className='message-card-wrapper' id={id}>
      {/* 消息时间 */}
      {isTimeVisible && <View className='message-time'>{time}</View>}

      {/* 消息卡片 */}
      <View
        className={cls('general-message-wrapper', {
          reverse: isFromMe,
          positive: !isFromMe,
        })}
      >
        {/* 成员头像 */}
        <View className='avatar-wrapper'>
          <Image className='avatar' src={isFromMe ? ME_AVATAR : OTHER_AVATAR} />
        </View>

        {/* 具体消息内容 */}
        <View className='container'>
          <View className='content'>{children}</View>
        </View>
      </View>
    </View>
  );
};

export default Card;
