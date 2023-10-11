import { useCallback, useEffect, useRef, useState } from 'react';
import Taro, { InnerAudioContext } from '@tarojs/taro';

export const useAudioContext = ({
  url,
  onEnded,
}: {
  url: string;
  onEnded: () => void;
}) => {
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);
  const audioContext = useRef<InnerAudioContext | null>();

  const playAudio = useCallback(() => {
    audioContext.current?.play();
  }, []);

  const pauseAudio = useCallback(() => {
    audioContext.current?.pause();
  }, []);

  useEffect(() => {
    let innerAudioContext: InnerAudioContext | null =
      Taro.createInnerAudioContext();
    audioContext.current = innerAudioContext;
    innerAudioContext.src = url;
    innerAudioContext.onCanplay(() => {
      const timer = setInterval(() => {
        const value = innerAudioContext?.duration || 0;
        if (value !== 0) {
          setDuration(innerAudioContext?.duration || 0);
          clearInterval(timer);
        }
      }, 500);
    });
    innerAudioContext.onTimeUpdate(() => {
      setCurrentTime(innerAudioContext?.currentTime || 0);
    });
    innerAudioContext.onEnded(() => {
      innerAudioContext?.seek(0);
      setCurrentTime(innerAudioContext?.duration || 0);
      onEnded();
    });

    return () => {
      innerAudioContext?.offCanplay();
      innerAudioContext?.offTimeUpdate();
      innerAudioContext?.offEnded();
      innerAudioContext = null;
      audioContext.current = null;
    };
  }, [onEnded, url]);

  return {
    duration,
    currentTime,
    playAudio,
    pauseAudio,
  };
};
