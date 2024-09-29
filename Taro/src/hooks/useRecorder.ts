import Taro from '@tarojs/taro';
import { useCallback, useEffect } from 'react';

const recorderManager = Taro.getRecorderManager();

const options = {
  duration: 10000,
  sampleRate: 44100 as const,
  numberOfChannels: 1 as const,
  encodeBitRate: 192000,
  format: 'aac' as const,
  frameSize: 50,
};

export const useRecorder = ({ onRecordEnd }) => {
  useEffect(() => {
    recorderManager.onStart(() => {
      console.log('recorder start');
    });
    recorderManager.onPause(() => {
      console.log('recorder pause');
    });
    recorderManager.onStop((res) => {
      console.log('recorder stop', res);
      onRecordEnd(res);
    });
  });

  const startRecord = useCallback(() => {
    recorderManager.start(options);
  }, []);

  const stopRecord = useCallback(() => {
    recorderManager.stop();
  }, []);

  return {
    startRecord,
    stopRecord,
  };
};
