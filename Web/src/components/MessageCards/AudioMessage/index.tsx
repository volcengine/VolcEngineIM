import React, { useCallback, useEffect, memo, FC, useRef, useState, useMemo } from 'react';
import classNames from 'classnames';
import { FileExtKey } from '@volcengine/im-web-sdk';

import { IconPlay, IconPause } from '../../Icon';
import { parseMessageContent } from '../../../utils';

import AudioBox from './Styles';

type AudioMessageProps = React.HtmlHTMLAttributes<HTMLAudioElement> & {
  message: any;
};

interface AudioContentProps {
  duration?: number; // 源秒数
  currentSeconds?: number; // 当前秒数
  isPaused?: boolean;
  className?: string;
  message?: any;
  isShowText?: boolean;
  isOriginal?: boolean;
  onAudioClick?: (event: any, second?: any) => void;
  onAudioProcessChange?: (event?: any, process?: number) => void;
  extra?: React.ReactNode;
  /** Container 参数 */
}

const prefixCls = 'im-audio';

/** 根据时长获取内容宽度 */
const getWidthCls = function (duration) {
  const tenCnt = Math.ceil(duration / 10);
  switch (tenCnt) {
    case 1:
      return 'message-audio-width-lv1';
    case 2:
      return 'message-audio-width-lv2';
    case 3:
      return 'message-audio-width-lv3';
    case 4:
      return 'message-audio-width-lv4';
    case 5:
      return 'message-audio-width-lv5';
    case 6:
      return 'message-audio-width-lv6';
    default:
      return 'message-audio-width-lv7';
  }
};

const formatTime = function (seconds: number) {
  let min = Math.floor(seconds / 60);
  let sec = Math.floor(seconds % 60);

  if (sec === 60) {
    min += 1;
    sec = 0;
  }

  return `${min}:${`${sec}`.padStart(2, 0 as any)}`;
};

const AudioContent: FC<AudioContentProps> = memo(props => {
  const {
    onAudioClick,
    onAudioProcessChange,
    isOriginal,
    isPaused,
    duration,
    children,
    className,
    currentSeconds,
    ...other
  } = props;

  const [process, setProcess] = useState(0);
  const refBar = useRef<HTMLDivElement>(null);
  const dataTransfer = useRef({
    startX: 0,
    startOffsetX: 0,
    isDrag: false,
  });
  const refSlider = useRef<HTMLDivElement>(null);

  const getProcess = useCallback(offsetX => {
    const width = refBar.current.offsetWidth;
    return Math.min(Math.max(offsetX / width, 0), 1);
  }, []);

  const onBarClick = useCallback(
    event => {
      const process = getProcess(event.target.offsetX);
      onAudioProcessChange?.(event, process);
    },
    [onAudioProcessChange, getProcess]
  );

  const onCtrlClick = useCallback(
    event => {
      if (dataTransfer.current.isDrag) return;
      onAudioClick?.(event);
    },
    [onAudioClick]
  );

  const handleSliderClick = useCallback(e => {
    if (e) e.stopPropagation();
  }, []);

  const onSliderMouseDown = useCallback((event?: any) => {
    event.stopPropagation();

    dataTransfer.current = Object.assign(
      {},
      {
        startX: event.pageX,
        startOffsetX: event.target.offsetLeft + event.target.offsetWidth / 2,
        isDrag: true,
      }
    );
  }, []);

  const onSliderDragMove = useCallback(
    event => {
      const transfer = dataTransfer.current;
      if (!transfer.isDrag) return;
      const offsetX = event.pageX - transfer.startX + transfer.startOffsetX;
      const newProcess = getProcess(offsetX);
      setProcess(newProcess);
    },
    [setProcess, getProcess]
  );

  const onSliderDragEnd = useCallback(
    event => {
      const transfer = dataTransfer.current;
      if (!transfer.isDrag) return;
      transfer.isDrag = false;
      const offsetX = event.pageX - transfer.startX + transfer.startOffsetX;
      const process = getProcess(offsetX);

      onAudioProcessChange?.(event, process);
    },
    [onAudioProcessChange, getProcess]
  );

  useEffect(() => {
    document.addEventListener('mousemove', onSliderDragMove);
    document.addEventListener('mouseup', onSliderDragEnd);
    if (refSlider.current) {
      refSlider.current.addEventListener('dragend', onSliderDragEnd);
    }

    return () => {
      document.removeEventListener('mousemove', onSliderDragMove);
      document.removeEventListener('mouseup', onSliderDragEnd);
      if (refSlider.current) {
        refSlider.current.removeEventListener('dragend', onSliderDragEnd);
      }
    };
  }, [refSlider.current]);

  const contentClass = useMemo(() => {
    return classNames(
      {
        'message-audio': true,
        'message-audio-new': true,
        // 'message-audio-hasText': voice2text,
      },
      className
    );
  }, [className]);

  const timeTxt = formatTime(isOriginal ? duration : currentSeconds);

  let newProcess = process;
  if (!dataTransfer.current.isDrag) {
    newProcess = currentSeconds / duration;
  }
  newProcess = Math.min(newProcess * 100, 100);
  const styleProcess = `${newProcess.toFixed(2)}%`;

  return (
    <AudioBox className={contentClass}>
      <div className={classNames('message--audio__control', getWidthCls(duration))} draggable={'false' as any}>
        <div className="ctrl" onClick={onCtrlClick}>
          <span className="ctrl--normal__icon">{isPaused ? <IconPlay /> : <IconPause />}</span>
        </div>
        <div className="bar--normal__wrapper" onMouseDown={onBarClick} ref={refBar}>
          <div className="bar--normal__bg">
            <div className="process" style={{ width: styleProcess }} />
          </div>
          <div
            className="slider--normal__strip"
            style={{ left: styleProcess }}
            draggable={'false' as any}
            ref={refSlider}
            onMouseDown={onSliderMouseDown}
            onClick={handleSliderClick}
          />
        </div>
        <div className="audio--normal__time">{timeTxt}</div>
      </div>
    </AudioBox>
  );
});

const AudioMessage: FC<AudioMessageProps> = props => {
  const { message } = props;

  const [currentTime, setCurrentTime] = useState(0);
  const [isPaused, setPaused] = useState(true);
  const [isOriginal, setOriginal] = useState(true); // 初始状态下，audio时间显示总时长，否则显示当前播放时间。
  const audioRef = useRef<HTMLAudioElement>(null);
  const currentTimeIntervalId = useRef<any>(0);

  const content = message.content && parseMessageContent(message);

  const { remoteURL, duration } = useMemo(() => {
    let remoteURL = '';
    let duration = 0;
    const files = content?.__files;
    if (files) {
      const keys = Object.keys(files);
      const msgContent = files[keys?.[0]] || {};
      const { ext } = msgContent || {};

      if (ext) {
        duration = ext[FileExtKey.AudioDuration];
      }

      remoteURL = msgContent?.remoteURL || '';
    }

    return {
      remoteURL,
      duration: Number(duration),
    };
  }, [content?.__files]);

  const isAudioPaused = useCallback(() => {
    return audioRef.current ? audioRef.current.paused : true;
  }, []);

  const play = useCallback(
    seconds => {
      if (seconds != null) {
        audioRef.current.currentTime = seconds;
      }

      audioRef.current.play();
      clearInterval(currentTimeIntervalId.current);

      const intervalFn = () => {
        if (!audioRef.current || audioRef.current.ended) {
          stop();
        } else {
          setCurrentTime(audioRef.current.currentTime);
        }
      };

      intervalFn();
      currentTimeIntervalId.current = setInterval(intervalFn, 100);

      setOriginal(false);
      setPaused(isAudioPaused());
    },
    [setOriginal, setPaused, setCurrentTime]
  );

  const pause = useCallback(() => {
    clearInterval(currentTimeIntervalId.current);
    if (!audioRef.current) return;
    audioRef.current.pause();

    setCurrentTime(audioRef.current.currentTime);
    setPaused(isAudioPaused());
  }, [setCurrentTime, setPaused]);

  const stop = useCallback(() => {
    clearInterval(currentTimeIntervalId.current);
    if (!audioRef.current) return;
    audioRef.current.pause();
    audioRef.current.currentTime = 0;

    setCurrentTime(0);
    setPaused(isAudioPaused());
    setOriginal(true);
  }, [setCurrentTime, setPaused, setOriginal]);

  const onAudioClick = useCallback(
    (evt: any, seconds: any) => {
      evt.stopPropagation();

      // 传入seconds，代表该方法由onAudioProcessChange调用，则进入播放逻辑
      if (audioRef.current?.paused || seconds != null) {
        play(seconds);
      } else {
        try {
          // The play() request was interrupted by a call to pause(). https://goo.gl/LdLk22
          pause();
        } catch (err) {}
      }
    },
    [play, pause]
  );

  const onAudioProcessChange = useCallback(
    (e, process) => {
      const seconds = process * duration;
      onAudioClick(e, seconds);
    },
    [onAudioClick, duration]
  );

  return (
    <div className="im-audio-message">
      {remoteURL && <audio ref={audioRef} src={remoteURL}></audio>}
      <AudioContent
        duration={duration}
        currentSeconds={currentTime}
        onAudioProcessChange={onAudioProcessChange}
        isPaused={isPaused}
        isOriginal={isOriginal}
        onAudioClick={onAudioClick}
      />
    </div>
  );
};

export default AudioMessage;
