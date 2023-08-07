import React, { FC, useRef } from 'react';
import { Message, Tooltip } from '@arco-design/web-react';
import { IconFileImage } from '@arco-design/web-react/icon';
import { im_proto } from '@volcengine/im-web-sdk';

import IconButtonMask from '../../IconButtonMask';
import { ErrorType } from '../../../types';

interface ImageButtonProps {
  sendMessage?: any;
  useEncrypt?: boolean;
}

const ImageButton: FC<ImageButtonProps> = props => {
  const { sendMessage, useEncrypt = false } = props;
  const inputRef = useRef<HTMLInputElement>();

  const handleClick = async e => {
    const { files } = e.target;
    if (files?.[0]) {
      try {
        await sendMessage?.(files?.[0]);
      } catch (err) {
        if (err.type === ErrorType.MPVolumeExceedUpperLimit) {
          Message.error('图片大小超过上限');
        }
      }
      inputRef.current.value = '';
    }
  };

  return (
    <Tooltip position="top" content={useEncrypt ? '图片(加密)' : '图片'}>
      <div
        className="toolbar-item image-item"
        onClick={() => {
          inputRef.current.click();
        }}
      >
        <IconButtonMask>
          <IconFileImage style={{ fontSize: '20px' }} />

          <input
            ref={inputRef}
            style={{ display: 'none' }}
            type="file"
            name="file"
            accept=".png,.jpeg,.jpg,.gif,.webp,.bmp,.heif,"
            multiple={false}
            onChange={handleClick}
          />
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default ImageButton;
