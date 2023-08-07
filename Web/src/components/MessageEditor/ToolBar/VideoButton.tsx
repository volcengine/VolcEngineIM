import React, { FC, useRef } from 'react';
import { im_proto } from '@volcengine/im-web-sdk';
import { IconFileVideo } from '@arco-design/web-react/icon';
import { Message, Tooltip } from '@arco-design/web-react';

import IconButtonMask from '../../IconButtonMask';
import { ErrorType } from '../../../types';

interface ImageButtonProps {
  sendMessage?: any;
  useCustomCover?: boolean;
}

const VideoButton: FC<ImageButtonProps> = props => {
  const { sendMessage, useCustomCover } = props;
  const inputRef = useRef<HTMLInputElement>();
  const coverInputRef = useRef<HTMLInputElement>();
  const coverFileRef = useRef<File>();

  const handleInputClick = async e => {
    const { files } = e.target;
    if (files?.[0]) {
      try {
        await sendMessage?.(files?.[0]);
      } catch (err) {
        if (err.type === ErrorType.MPVolumeExceedUpperLimit) {
          Message.error('视频大小超过上限');
        }
      }
      inputRef.current.value = '';
    }
  };

  return (
    <Tooltip position="top" content={useCustomCover ? '视频(先选封面)' : '视频'}>
      <div
        className="toolbar-item image-item"
        onClick={() => {
          useCustomCover ? coverInputRef.current.click() : inputRef.current.click();
        }}
      >
        <IconButtonMask>
          <IconFileVideo style={{ fontSize: '20px' }} />

          <input
            ref={coverInputRef}
            style={{ display: 'none' }}
            type="file"
            name="file"
            accept=".png,.jpeg,.jpg,.gif,"
            multiple={false}
            onChange={e => {
              const { files } = e.target;
              let file = files?.[0];
              if (file) {
                coverFileRef.current = file;
                inputRef.current.click();
              }
            }}
          />

          <input
            ref={inputRef}
            style={{ display: 'none' }}
            type="file"
            name="file"
            accept=".mp4"
            multiple={false}
            onChange={handleInputClick}
          />
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default VideoButton;
