import React, { FC, useRef } from 'react';
import { Message, Tooltip } from '@arco-design/web-react';
import { IconFile } from '@arco-design/web-react/icon';
import { im_proto } from '@volcengine/im-web-sdk';

import IconButtonMask from '../../IconButtonMask';
import { ErrorType } from '../../../types';

interface FileButtonProps {
  sendMessage?: any;
}

const FileButton: FC<FileButtonProps> = props => {
  const { sendMessage } = props;
  const inputRef = useRef<HTMLInputElement>();

  const handleChange = async e => {
    const { files } = e.target;
    if (files?.[0]) {
      if (files?.[0].size > 1024 * 1024 * 50) {
        Message.error({ content: '文件大小超过限制', position: 'bottom' });
        return;
      }
      try {
        await sendMessage?.(files?.[0]);
      } catch (err) {
        if (err.type === ErrorType.MPVolumeExceedUpperLimit) {
          Message.error('文件大小超过上限');
        }
      }
      inputRef.current.value = '';
    }
  };

  return (
    <Tooltip position="top" content="文件">
      <div
        className="toolbar-item image-item"
        onClick={() => {
          inputRef.current.click();
        }}
      >
        <IconButtonMask>
          <IconFile style={{ fontSize: '20px' }} />

          <input
            ref={inputRef}
            style={{ display: 'none' }}
            type="file"
            name="file"
            accept=""
            multiple={false}
            onChange={handleChange}
          />
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default FileButton;
