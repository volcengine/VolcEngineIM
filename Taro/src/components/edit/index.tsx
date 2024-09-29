import { useCallback, useState } from 'react';
import { View, Image, Input, Textarea } from '@tarojs/components';
import { OsModal, OsToast } from 'ossaui';
import Taro from '@tarojs/taro';

// import EmojiSvg from '../../assets/svg/emoji.svg';
import AddSvg from '../../assets/svg/add.svg';
import AudioSvg from '../../assets/svg/audio.svg';
import KeyboardSvg from '../../assets/svg/keyboard.svg';

import { useRecorder } from '../../hooks/useRecorder';
import MoreOperator from '../more-operator';

import * as IMLib from '@volcengine/im-mp-sdk';

import './index.scss';

const { im_proto } = IMLib;
const { SendMessageStatus } = im_proto;

let startTime = 0;
let endTime = 0;

interface EditProps {
  sendTextMessage: (text: string) => any;
  sendImageMessage: (fileInfo: any) => void;
  sendVideoMessage: (fileInfo: any) => void;
  sendAudioMessage: (fileInfo: any) => void;
  sendVolcMessage: () => void;
  showFileSendIcon: boolean;
}

const Edit: React.FC<EditProps> = ({
  sendTextMessage,
  sendImageMessage,
  sendVideoMessage,
  sendAudioMessage,
  sendVolcMessage,
  showFileSendIcon
}) => {
  const [inputText, setInputText] = useState('');
  const [isAudioStatus, setAudioStatus] = useState(false);
  const [isShowMoreOperator, setShowMoreOperator] = useState(false);
  const [isRecord, setRecord] = useState(false);
  const [showSingleBtn, setShowSingleBtn] = useState(false);
  const [showToast, setShowToast] = useState(false);
  const [text, setText] = useState('');

  const handleSwitchInputStatus = useCallback(() => {
    setAudioStatus(!isAudioStatus);
  }, [isAudioStatus]);

  const handleMoreOperatorClick = useCallback(() => {
    setShowMoreOperator(!isShowMoreOperator);
  }, [isShowMoreOperator]);

  const handleKeyDown = event => {
    const textValue = event.detail.value;
    if (textValue.includes('\n')) {
      // 处理回车的逻辑
      handleConfirmClick();
      return;
    }
    setInputText(textValue);
  };

  const handleConfirmClick = useCallback(async () => {
    if (inputText.trim() !== '') {
      const content = JSON.stringify({
        text: inputText
      });
      const { success, statusCode } = await sendTextMessage(content);
      if (!success) {
        if (statusCode === SendMessageStatus.USER_HAS_BEEN_BLOCKED) {
          setText('已被禁言');
          setShowToast(true);
        } else if (statusCode === SendMessageStatus.CHECK_CONVERSATION_NOT_FOUND) {
          setText('直播群不存在');
          setShowToast(true);
        } else {
          setText('发送失败');
          setShowToast(true);
        }
        return;
      }
    } else {
      setShowSingleBtn(true);
    }
    setInputText('');
  }, [inputText, sendTextMessage]);

  const handleRecordEnd = useCallback(
    ({ fileSize, tempFilePath: filePath }) => {
      setRecord(false);
      endTime = Date.now();
      const duration = Math.round((endTime - startTime) / 1000);
      if (duration < 1) {
        Taro.showToast({
          title: '发送时间小于1秒',
          icon: 'error',
          duration: 1000
        });
        return;
      }
      const fileInfo = {
        fileSize,
        filePath,
        audioDuration: duration
      };
      try {
        sendAudioMessage(fileInfo);
      } catch (err) {
        console.error('audio message send fail', err);
      }
    },
    [sendAudioMessage]
  );

  const { startRecord, stopRecord } = useRecorder({
    onRecordEnd: handleRecordEnd
  });

  const handleTouchStart = useCallback(() => {
    startTime = Date.now();
    setRecord(true);
    startRecord();
  }, [startRecord]);

  const handleTouchStop = useCallback(() => {
    setRecord(false);
    stopRecord();
  }, [stopRecord]);

  const onClose = useCallback(() => {
    setShowToast(false);
  }, []);

  return (
    <View className="edit-wrapper">
      <View className="edit-input-wrapper">
        {showFileSendIcon && (
          <View className="left">
            <View className="icon-wrapper" onClick={handleSwitchInputStatus}>
              {isAudioStatus ? (
                <Image className="icon" src={KeyboardSvg}></Image>
              ) : (
                <Image className="icon" src={AudioSvg}></Image>
              )}
            </View>
          </View>
        )}

        <View className="center">
          {isAudioStatus ? (
            <View className="audio-desc" onTouchStart={handleTouchStart} onTouchEnd={handleTouchStop}>
              {isRecord ? '松开 发送' : '按住 说话'}
            </View>
          ) : (
            <View className="input-box">
              <Textarea
                className="input-wrapper"
                value={inputText}
                autoHeight={true}
                confirmType="send"
                onInput={handleKeyDown}
                onConfirm={handleConfirmClick}
              ></Textarea>
            </View>
          )}
        </View>

        {showFileSendIcon && (
          <View className="right">
            {/* <View className='icon-wrapper'>
            <Image className='icon' src={EmojiSvg}></Image>
          </View> */}
            <View className="icon-wrapper add-wrapper" onClick={handleMoreOperatorClick}>
              <Image className="icon icon-add" src={AddSvg}></Image>
            </View>
          </View>
        )}
      </View>

      {isShowMoreOperator && (
        <View className="edit-more-operator">
          <MoreOperator
            sendImageMessage={sendImageMessage}
            sendVideoMessage={sendVideoMessage}
            sendVolcMessage={sendVolcMessage}
          />
        </View>
      )}

      <OsModal
        title="提示"
        cancelText="确定"
        content="不能发送空白消息"
        isShow={showSingleBtn}
        showCloseIcon={false}
        className="modal-content"
        onCancel={() => setShowSingleBtn(false)}
        onClose={() => setShowSingleBtn(false)}
        onConfirm={() => setShowSingleBtn(false)}
      ></OsModal>

      <OsToast isShow={showToast} text={text} duration={3000} onClose={onClose}></OsToast>
    </View>
  );
};

export default Edit;
