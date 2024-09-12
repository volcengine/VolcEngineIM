import { useCallback } from 'react';
import Taro from '@tarojs/taro';
import { View, Image } from '@tarojs/components';
import fileUploadLimit from '../../../utils/fileUploadLimit';

import PictureSvg from '../../../assets/svg/picture.svg';

interface ImageOperatorProps {
  onClick: (fileInfo) => void;
}

const ImageOperator: React.FC<ImageOperatorProps> = ({ onClick }) => {
  const handelClick = useCallback(() => {
    Taro.chooseImage({
      count: 1,
      sizeType: ['compressed'],
      sourceType: ['album'],
      async success(res) {
        const { tempFiles } = res;
        const { path, size } = tempFiles[0];
        if (!fileUploadLimit(size)) {
          return;
        }
        const fileInfo = {
          filePath: path,
          fileSize: size
        };
        try {
          await onClick(fileInfo);
        } catch (err) {
          console.error('send image message fail', err);
        }
      },
      fail(err) {
        console.log('img select fail', err);
      }
    });
  }, [onClick]);

  return (
    <View className="operator-wrapper" onClick={handelClick}>
      <View className="icon-wrapper">
        <Image className="icon" src={PictureSvg}></Image>
      </View>
      <View className="operator-desc">照片</View>
    </View>
  );
};

export default ImageOperator;
