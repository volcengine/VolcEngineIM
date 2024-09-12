import { useCallback } from 'react';
import { View } from '@tarojs/components';

import ImageOperator from './image-operator';
import VideoOperator from './video-operator';

import './index.scss';
import VolcOperator from './volc-operator';

interface MoreOperatorProps {
  sendImageMessage: (fileInfo: any) => void;
  sendVideoMessage: (fileInfo: any) => void;
  sendVolcMessage: () => void;
}

const MoreOperator: React.FC<MoreOperatorProps> = ({ sendImageMessage, sendVideoMessage, sendVolcMessage }) => {
  const handleImageMsg = useCallback(
    fileInfo => {
      sendImageMessage(fileInfo);
    },
    [sendImageMessage]
  );

  const handleVideoMsg = useCallback(
    fileInfo => {
      sendVideoMessage(fileInfo);
    },
    [sendVideoMessage]
  );
  const handleVolcMsg = useCallback(() => {
    sendVolcMessage();
  }, [sendVolcMessage]);
  return (
    <View className="more-operator-wrapper">
      <ImageOperator onClick={handleImageMsg} />

      <VideoOperator onClick={handleVideoMsg} />
      <VolcOperator onClick={handleVolcMsg} />
    </View>
  );
};

export default MoreOperator;
