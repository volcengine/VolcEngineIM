import { useCallback } from 'react';
import Taro from '@tarojs/taro';
import { View, Image } from '@tarojs/components';

import VideoSvg from '../../../assets/svg/video.svg';

interface OperatorProps {
  onClick: (fileInfo) => void;
}

const Operator: React.FC<OperatorProps> = ({ onClick }) => {
  const handelClick = useCallback(() => {
    Taro.chooseVideo({
      sourceType: ['album'],
      async success(res) {
        const { tempFilePath: path, size } = res;
        const fileInfo = {
          filePath: path,
          fileSize: size,
        };
        try {
          await onClick(fileInfo);
        } catch (err) {
          console.error('send video message fail', err);
        }
      },
      fail(err) {
        console.log('video select fail', err);
      },
    });
  }, [onClick]);

  return (
    <View className='operator-wrapper' onClick={handelClick}>
      <View className='icon-wrapper'>
        <Image className='icon' src={VideoSvg}></Image>
      </View>
      <View className='operator-desc'>视频</View>
    </View>
  );
};

export default Operator;
