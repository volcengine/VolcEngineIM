import { useCallback } from 'react';
import { View } from '@tarojs/components';

import ImageOperator from './image-operator';
import VideoOperator from './video-operator';

import './index.scss';

interface MoreOperatorProps {
  sendImageMessage: (fileInfo: any) => void;
  sendVideoMessage: (fileInfo: any) => void;
}

const MoreOperator: React.FC<MoreOperatorProps> = ({
  sendImageMessage,
  sendVideoMessage,
}) => {
  const handleImageMsg = useCallback(
    (fileInfo) => {
      sendImageMessage(fileInfo);
    },
    [sendImageMessage]
  );

  const handleVideoMsg = useCallback(
    (fileInfo) => {
      sendVideoMessage(fileInfo);
    },
    [sendVideoMessage]
  );

  return (
    <View className='more-operator-wrapper'>
      <ImageOperator onClick={handleImageMsg} />

      <VideoOperator onClick={handleVideoMsg} />
    </View>
  );
};

export default MoreOperator;
