import { useCallback, useEffect, useRef, useState } from 'react';
import Taro, { InnerAudioContext } from '@tarojs/taro';
import { Message } from '@volcengine/im-mp-sdk';

export const useAudioContext = ({ url, message, onEnded }: { url: string; message: Message; onEnded: () => void }) => {
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
    try {
      const content = JSON.parse(message.content);
      const duration = content.__files.media.ext['s:file_ext_key_audio_duration'];
      setDuration(duration);
    } catch (error) {
      setDuration(0);
    }
  }, []);

  useEffect(() => {
    let innerAudioContext: InnerAudioContext | null = Taro.createInnerAudioContext();
    audioContext.current = innerAudioContext;
    innerAudioContext.src = url;

    innerAudioContext.onCanplay(() => {
      const timer = setInterval(() => {
        const value = innerAudioContext?.duration || 0;
        if (value !== 0 && value !== Infinity) {
          // duration 不准确 为Infinity
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
    pauseAudio
  };
};
