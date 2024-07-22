import React, { memo, FC, useRef, useState, useMemo } from 'react';
import classNames from 'classnames';
import { FileExtKey } from '@volcengine/im-web-sdk';

import VideoBox from './Styles';
import { useUploadProcessText } from '../../../hooks';
import { parseMessageContent } from '../../../utils';
import { BytedIMInstance, CurrentConversation } from '../../../store';
import { useRecoilValue } from 'recoil';
import FileProgress from '../../FileProgress';

type VideoMessageContentProps = React.HtmlHTMLAttributes<HTMLVideoElement> & {
  className?: string;
  src?: string;
  cover?: string;
  duration?: string | number;
  style?: React.CSSProperties;
  videoRef?: React.RefObject<HTMLVideoElement>;
  onClick?: (paused: boolean, event: React.MouseEvent) => void;
  onPlay?: () => void;
  onCoverLoad?: (event: React.SyntheticEvent<HTMLImageElement, Event>) => void;
};

const prefixCls = 'im-video';

const VideoContent: FC<VideoMessageContentProps> = props => {
  const {
    className,
    src,
    cover,
    duration,
    onClick,
    onCoverLoad,
    style,
    videoRef: outerVideoRef,
    children,
    onPlay,
    ...other
  } = props;

  const localVideoRef = useRef<HTMLVideoElement>(null!);
  const videoRef = outerVideoRef || localVideoRef;

  const [isPlayed, setIsPlayed] = useState(false);
  const [paused, setPaused] = useState(true);

  function handleClick(e: React.MouseEvent) {
    setIsPlayed(true);
    const video = videoRef.current;

    if (video) {
      if (video.ended || video.paused) {
        video.play();
      } else {
        video.pause();
      }
    }

    onClick?.(paused, e);
  }

  function handlePlay() {
    setPaused(false);
    onPlay?.();
  }

  function handlePause() {
    setPaused(true);
  }

  const hasCover = !isPlayed && Boolean(cover);
  const hasDuration = hasCover && Boolean(duration);

  return (
    <VideoBox
      className={classNames(`${prefixCls}-wrap`, `is-${paused ? 'paused' : 'playing'}`, className)}
      style={style}
    >
      {/* {hasCover && <img className={`${prefixCls}-cover`} src={cover} onLoad={onCoverLoad} alt="" />} */}
      {/* {hasDuration && <span className={`${prefixCls}-duration`}>{duration}</span>} */}
      <video
        className={`${prefixCls}`}
        src={src}
        ref={videoRef}
        hidden={hasCover}
        controls
        onPlay={handlePlay}
        onPause={handlePause}
        onEnded={handlePause}
        {...other}
      >
        {children}
      </video>
      {/* {hasCover && (
        <button className={classNames(`${prefixCls}-playBtn`, { paused })} type="button" onClick={handleClick}>
          <span className={`${prefixCls}-playIcon`} />
        </button>
      )} */}
    </VideoBox>
  );
};

interface VideoMessageProps {
  message?: any;
}

const VideoMessage: FC<VideoMessageProps> = props => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);
  const { message } = props;

  let duration = 0;
  let previewUrl = '';
  let remoteURL = '';
  let height: string | number = 0;
  let width = 240;
  const content = message.content && parseMessageContent(message);

  const files = content?.__files;
  const { ext = {} } = message || {};

  if (files) {
    const keys = Object.keys(files);
    const msgContent = files?.[keys?.[0]];
    previewUrl = msgContent?.ext?.[FileExtKey.VideoCoverUrl];
    remoteURL = msgContent?.remoteURL;
    duration = msgContent?.ext?.[FileExtKey.VideoDuration];
    // const originWidth = Number(msgContent.ext['s:file_ext_key_original_width']);
    // const originHeight = Number(msgContent.ext['s:file_ext_key_original_height']);

    // width = Math.min(originWidth, 240) || 100;
    // height = (originWidth <= 240 ? originHeight : (240 / originWidth) * originHeight) || 100;
  }

  // const size = useMemo(() => {
  //   const { original_width, original_height } = ext;
  //   width = Math.min(original_width, 240) || 100;
  //   height = (original_width <= 240 ? original_height : (240 / original_width) * original_height) || 100;

  //   return {
  //     width: `${width}px`,
  //     height: `${height}px`,
  //   };
  // }, [ext]);

  return (
    <>
      {remoteURL ? (
        <VideoContent
          cover={previewUrl}
          duration={Number(ext?.duration)}
          src={remoteURL}
          style={{
            width,
          }}
          onPlay={() => {
            bytedIMInstance.sendMessageReadReceipts({ conversation: currentConversation, messages: [message] });
          }}
        />
      ) : (
        <FileProgress message={message} />
      )}
    </>
  );
};

export default VideoMessage;
