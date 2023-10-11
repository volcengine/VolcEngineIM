import { View, Text } from '@tarojs/components';

import { getTextMsgContent } from '../../../utils/message-preview';

import './index.scss';

interface ItemProps {
  message: any;
}

const Item: React.FC<ItemProps> = ({ message }) => {
  const content = getTextMsgContent(message);

  return (
    <View className='text-item-wrapper'>
      <Text className='text-content'>{content}</Text>
    </View>
  );
};

export default Item;
