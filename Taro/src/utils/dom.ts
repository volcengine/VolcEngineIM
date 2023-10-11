import Taro from '@tarojs/taro';

export const getBottomHeight = () => {
  const { safeArea, screenHeight } = Taro.getSystemInfoSync();
  //@ts-ignore
  return screenHeight - safeArea.bottom;
};
