import { View, Video, Text } from '@tarojs/components';

import { getFileMsgContent } from '../../../utils/message-preview';

import './index.scss';

interface ItemProps {
  message: any;
}

const Item: React.FC<ItemProps> = ({ message }) => {
  const url = getFileMsgContent(message);

  if (!url) {
    return <Text>视频获取失败</Text>;
  }

  return (
    <View className='video-item-wrapper'>
      <Video className='video-item' src={url} />
    </View>
  );
};

export default Item;
