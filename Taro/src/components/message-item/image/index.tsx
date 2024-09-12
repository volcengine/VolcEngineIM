import { View, Image, Text } from '@tarojs/components';
import { useCallback } from 'react';

import { getFileMsgContent } from '../../../utils/message-preview';

import './index.scss';

interface ItemProps {
  message: any;
  onClick?: (url) => void;
}

const Item: React.FC<ItemProps> = ({ message, onClick }) => {
  const url = getFileMsgContent(message);

  const handleClick = useCallback(() => {
    onClick && onClick(url);
  }, [onClick, url]);

  if (!url) {
    return <Text>图片获取失败</Text>;
  }

  return (
    <View className='image-item-wrapper' onClick={handleClick}>
      <Image className='image-item' src={url}></Image>
    </View>
  );
};

export default Item;
