import React, { useEffect, useState } from 'react';
import { Message, Tooltip } from '@arco-design/web-react';
import { IconRecordStop, IconVoice } from '@arco-design/web-react/icon';
import { connect } from 'extendable-media-recorder-wav-encoder';
import { register, MediaRecorder as ExtendableMediaRecorder, IMediaRecorder } from 'extendable-media-recorder';

import IconButtonMask from '../../IconButtonMask';
import { ErrorType } from '../../../types';

let mediaRecord: IMediaRecorder;
let chunks = [];
let startTime;

const AudioButton = props => {
  const { sendMessage } = props;
  const [isRecord, setIsRecord] = useState(false);

  useEffect(() => {
    const setup = async () => {
      await register(await connect());
    };
    setup();
  }, []);

  const handleStartAudio = () => {
    setIsRecord(true);
    navigator.mediaDevices
      .getUserMedia({ audio: true })
      .then(stream => {
        mediaRecord = new ExtendableMediaRecorder(stream, { mimeType: 'audio/wav' });
        mediaRecord.onstop = async () => {
          const duration = (Date.now() - startTime) / 1000;
          stream.getTracks().forEach(item => item.stop());
          const blob = new Blob(chunks, { type: 'audio/wav' });
          chunks = [];
          const fileOfBlob = new File([blob], `${new Date().getTime()}.wav`);
          try {
            await sendMessage?.({
              file: fileOfBlob,
              duration,
            });
          } catch (err) {
            if (err.type === ErrorType.MPVolumeExceedUpperLimit) {
              Message.error('音频大小超过上限');
            }
          }
        };
        mediaRecord.ondataavailable = e => {
          chunks.push(e.data);
        };
        startTime = Date.now();
        mediaRecord.start();
      })
      .catch(err => {
        setIsRecord(false);
      });
  };

  const handleEndAudio = () => {
    setIsRecord(false);
    mediaRecord.stop();
  };

  return (
    <Tooltip position="top" content={isRecord ? '发送语音消息' : '录制语音消息'}>
      <div className="toolbar-item" onClick={isRecord ? handleEndAudio : handleStartAudio}>
        <IconButtonMask>
          {isRecord ? <IconRecordStop style={{ fontSize: '20px' }} /> : <IconVoice style={{ fontSize: '20px' }} />}
        </IconButtonMask>
      </div>
    </Tooltip>
  );
};

export default AudioButton;
