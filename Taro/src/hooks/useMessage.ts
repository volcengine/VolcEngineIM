import { useCallback } from 'react';

import { selectConversation, selectIm } from '../store/imReducers';
import { useAppSelector } from '../store/hooks';
import { IMEvent, im_proto } from '@volcengine/im-mp-sdk';
import { EXT_ALIAS_NAME, EXT_AVATAR_URL } from '../constants';

function sendMessageCheckCode(result) {
  switch (result.statusCode) {
    case im_proto.StatusCode.NOT_FRIEND:
      // ArcoMessage.error('对方不是你的好友，无法发送消息');
      break;
    case im_proto.StatusCode.AlREADY_IN_BLACK:
      // ArcoMessage.error('对方已拒收你的消息');
      break;
    case 3:
      if (result.checkCode.eq(100)) {
        // ArcoMessage.error(`该用户已注销，不存在`);
      }
      break;
    default:
      break;
  }
  return result;
}

export const useMessage = () => {
  const instance = useAppSelector(selectIm);
  const bytedIMInstance = instance;
  const conversation = useAppSelector(selectConversation);
  const currentConversation = conversation;
  const priority = im_proto.MessagePriority.NORMAL;
  const userId = instance.option.userId;

  async function insertAliasExtForMassChat(ext: {}) {
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      try {
        const resp = await bytedIMInstance.getLiveParticipantDetailOnline({
          conversation: currentConversation,
          participantIds: [userId]
        });
        const { avatarUrl, alias } = resp[0];
        ext[EXT_ALIAS_NAME] = alias;
        ext[EXT_AVATAR_URL] = avatarUrl;
      } catch (e) {}
    }
    return ext;
  }

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

  /**
   * 发送系统消息
   * @param conversation
   * @param text
   */
  const sendSystemMessage = async (conversation, text: string) => {
    const message = await bytedIMInstance.createCustomMessage({
      conversation,
      content: JSON.stringify({
        type: 2,
        text
      })
    });
    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 发送自定义消息
   */
  const sendVolcMessage = async () => {
    const ext = {};
    await insertAliasExtForMassChat(ext);
    const message = await bytedIMInstance.createCustomMessage({
      conversation: currentConversation,
      content: JSON.stringify({
        type: 1,
        link: 'https://www.volcengine.com/',
        text: '欢迎体验火山引擎即时通讯 IM demo'
      }),
      ext: ext
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 发送优惠券消息
   */
  const sendCouponMessage = async () => {
    const ext = {};
    await insertAliasExtForMassChat(ext);
    const message = await bytedIMInstance.createCustomMessage({
      conversation: currentConversation,
      content: JSON.stringify({
        detail: '这是一张优惠券,点击此处领取',
        start: 8,
        end: 14,
        type: '3'
      }),
      ext: ext
    });

    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  return {
    sendTextMessage,
    sendImageMessage,
    sendVideoMessage,
    sendAudioMessage,
    sendFileMessage,
    markConversationRead,
    sendSystemMessage,
    sendVolcMessage,
    sendCouponMessage
  };
};
