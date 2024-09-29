import Taro from '@tarojs/taro';

export default (size: number): boolean => {
  const limitSize = 50 * 1024 * 1024;
  if (size > limitSize) {
    Taro.showToast({
      title: '文件超上限',
      icon: 'error',
      duration: 1000 // 持续时间为 2 秒
    });
    return false;
  }
  return true;
};
