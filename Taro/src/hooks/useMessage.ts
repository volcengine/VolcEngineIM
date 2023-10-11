import { useCallback } from 'react';

import { selectConversation, selectIm } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';

export const useMessage = () => {
  const instance = useAppSelector(selectIm);
  const conversation = useAppSelector(selectConversation);

  const sendTextMessage = useCallback(
    async (content: string) => {
      const message = await instance.createTextMessage({
        conversation,
        content
      });
      return await instance.sendMessage({
        message
      });
    },
    [conversation, instance]
  );

  const sendImageMessage = useCallback(
    async (fileInfo: any) => {
      const message = await instance.createImageMessage({
        conversation,
        fileInfo: {
          ...fileInfo,
          type: 'image',
          displayType: 'media'
        }
      });
      return await instance.sendMessage({
        message
      });
    },
    [conversation, instance]
  );

  const sendVideoMessage = useCallback(
    async (fileInfo: any) => {
      const message = await instance.createVideoMessage({
        conversation,
        fileInfo: {
          ...fileInfo,
          type: 'video',
          displayType: 'media'
        }
      });
      return await instance.sendMessage({
        message
      });
    },
    [conversation, instance]
  );

  const sendAudioMessage = useCallback(
    async (fileInfo: any) => {
      const message = await instance.createAudioMessage({
        conversation,
        fileInfo: {
          ...fileInfo,
          type: 'audio',
          displayType: 'media'
        }
      });
      return await instance.sendMessage({
        message
      });
    },
    [conversation, instance]
  );

  const sendFileMessage = useCallback(
    async (fileInfo: any) => {
      const message = await instance.createFileMessage({
        conversation,
        fileInfo
      });
      return await instance.sendMessage({
        message
      });
    },
    [conversation, instance]
  );

  const markConversationRead = useCallback(
    (readIndex: any) => {
      return instance.markConversationRead({
        conversation,
        readIndex
      });
    },
    [conversation, instance]
  );

  return {
    sendTextMessage,
    sendImageMessage,
    sendVideoMessage,
    sendAudioMessage,
    sendFileMessage,
    markConversationRead
  };
};
