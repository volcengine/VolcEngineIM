import React, { useEffect, useState } from 'react';
import { Message, Tooltip } from '@arco-design/web-react';
import { IconRecordStop, IconVoice } from '@arco-design/web-react/icon';
import { connect } from 'extendable-media-recorder-wav-encoder';
import { register, MediaRecorder as ExtendableMediaRecorder, IMediaRecorder } from 'extendable-media-recorder';

import IconButtonMask from '../../IconButtonMask';
import { ErrorType } from '../../../types';
import { useRecoilValue } from 'recoil';
import { BytedIMInstance, CurrentConversation } from '../../../store';
import { im_proto } from '@volcengine/im-web-sdk';
import { useInterval } from 'ahooks';

let mediaRecord: IMediaRecorder;
let chunks = [];
let startTime;

const AudioButton = props => {
  const { sendMessage } = props;
  const [isRecord, setIsRecord] = useState(false);

  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);

  const [interval, setInterval] = useState<number | undefined>(500);

  const clear = useInterval(() => {
    console.log('p2p', currentConversation, currentConversation.toParticipantUserId);
    if (currentConversation.type === im_proto.ConversationType.ONE_TO_ONE_CHAT) {
      bytedIMInstance.sendP2PMessage({
        conversation: currentConversation,
        sendType: im_proto.SendType.BY_USER,
        msgType: im_proto.MessageType.MESSAGE_TYPE_CUSTOM_P2P,
        content: JSON.stringify({
          type: 1000,
          ext: '',
          message_type: im_proto.MessageType.MESSAGE_TYPE_AUDIO,
        }),
        visibleUser: [currentConversation.toParticipantUserId],
      });
    }
  }, interval);

  useEffect(() => {
    const setup = async () => {
      await register(await connect());
    };
    setup();
    clear();
  }, []);

  const handleStartAudio = () => {
    setIsRecord(true);
    setInterval(i => i + 1);
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
        clear();
      });
  };

  const handleEndAudio = () => {
    setIsRecord(false);
    clear();
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
