import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { Conversation, FileType, im_proto, IMEvent, Message } from '@volcengine/im-web-sdk';

import {
  BytedIMInstance,
  CurrentConversation,
  FileUploadProcessStore,
  Messages,
  ReferenceMessage,
  SendMessagePriority,
  UserId,
  EditMessage,
  SendSingleMsgType,
} from '../store';
import { CalcVideo, getImageSize, getMessagePreview } from '../utils';
import { Message as ArcoMessage } from '@arco-design/web-react';
import { EXT_ALIAS_NAME, EXT_AVATAR_URL } from '../constant';

let markReadTimer: any = null;
let toMarkReadList: Array<{ key: number; value: Message }> = [];
let calcVideoInstance: CalcVideo;

function sendMessageCheckCode(result) {
  switch (result.statusCode) {
    case im_proto.StatusCode.NOT_FRIEND:
      ArcoMessage.error('对方不是你的好友，无法发送消息');
      break;
    case im_proto.StatusCode.AlREADY_IN_BLACK:
      ArcoMessage.error('对方已拒收你的消息');
      break;
    case im_proto.StatusCode.MESSAGE_FREQ:
      ArcoMessage.error('消息被限频：78');
      break;
    case 3:
      if (result.checkCode.eq(100)) {
        ArcoMessage.error(`该用户已注销，不存在`);
      }
      break;
    default:
      break;
  }
  return result;
}

const useMessage = () => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const currentConversation = useRecoilValue(CurrentConversation);
  const [messages, setMessages] = useRecoilState(Messages);
  const [referenceMessage, setReferenceMessage] = useRecoilState(ReferenceMessage);
  const [editingMessage, setEditingMessage] = useRecoilState(EditMessage);

  const setFileUploadProcess = useSetRecoilState(FileUploadProcessStore);
  const userId = useRecoilValue(UserId);
  const priority = useRecoilValue(SendMessagePriority);
  const sendSingleMsgType = useRecoilValue(SendSingleMsgType);

  /**
   * 重发消息
   * @param message
   */
  const resendMessage = async (message: Message) => {
    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  async function insertAliasExtForMassChat(ext: {}) {
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      try {
        const resp = await bytedIMInstance.getLiveParticipantDetailOnline({
          conversation: currentConversation,
          participantIds: [userId],
        });
        const { avatarUrl, alias } = resp[0];
        ext[EXT_ALIAS_NAME] = alias;
        ext[EXT_AVATAR_URL] = avatarUrl;
      } catch (e) {}
    }
    return ext;
  }

  /**
   * 发送普通文本消息
   * @param msg
   */
  const sendTextMessage = async (msg: any) => {
    if (editingMessage && editingMessage.type === im_proto.MessageType.MESSAGE_TYPE_TEXT) {
      await editTextMessage(editingMessage, JSON.stringify(msg));
      return;
    }

    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendTextMessageUseToUserId(currentConversation.toParticipantUserId, msg.text);
      return;
    }

    const params = {
      conversation: currentConversation,
      content: JSON.stringify(msg),
      referenceMessage,
      referenceHint: getMessagePreview(referenceMessage),
      ext: {},
    };
    await insertAliasExtForMassChat(params.ext);

    const message = await bytedIMInstance.createTextMessage(params);
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }
    const result = await bytedIMInstance.sendMessage({ message, priority });
    sendMessageCheckCode(result);
    setReferenceMessage(null);
  };

  const editTextMessage = async (message: Message, content: string) => {
    const resp = await bytedIMInstance.modifyMessage({
      message,
      content: content,
    });
    setEditingMessage(null);
  };

  /**
   * 通过指定toUserId，通过server发送普通文本消息(目前仅支持单聊、 int64类型uid)
   * @param toUserId
   * @param messageText
   */
  const sendTextMessageUseToUserId = async (toUserId: string, messageText: string) => {
    const params = {
      toUserId,
      content: JSON.stringify({ text: messageText }),
    };
    const message = await bytedIMInstance.createTextMessage(params);
    console.log('sendTextMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendTextMessageUseToUserId result', result);
    const conversationId = result?.body?.conversation?.conversation_id;
    sendMessageCheckCode(result);
    return { success: result?.success, conversationId: conversationId || result?.payload?.conversationId };
  };

  /**
   * 发送文件消息
   * @param file
   */
  const sendFileMessage = async (file: File) => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendFileMessageUseToUserId(currentConversation.toParticipantUserId, file);
      return;
    }

    const message = await bytedIMInstance.createFileMessage({
      conversation: currentConversation,
      fileInfo: {
        type: FileType.CommonFile,
        fileHandler: file,
        displayType: 'media',
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: await insertAliasExtForMassChat({}),
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送文件消息(目前仅支持单聊、 int64类型uid)
   * @param toUserId
   * @param file
   */
  const sendFileMessageUseToUserId = async (toUserId: string, file: File) => {
    const params = {
      toUserId,
      fileInfo: {
        type: FileType.CommonFile,
        fileHandler: file,
        displayType: 'media',
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
    };
    const message = await bytedIMInstance.createFileMessage(params);
    console.log('sendFileMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendFileMessageUseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 发送图片消息
   * @param file
   * @param encrypt
   */
  const sendImageMessage = async (file: File, encrypt?: boolean) => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendImageMessageUseToUserId(currentConversation.toParticipantUserId, file, encrypt);
      return;
    }

    const objectUrl = URL?.createObjectURL(file);
    const { width, height } = (await getImageSize(objectUrl)) || {};
    const message = await bytedIMInstance.createImageMessage({
      conversation: currentConversation,
      fileInfo: {
        type: FileType.Image,
        fileHandler: file,
        displayType: 'media', // image
        encrypt: encrypt ? true : undefined,
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: await insertAliasExtForMassChat({
        's:file_ext_key_original_width': width?.toString(),
        's:file_ext_key_original_height': height?.toString(),
      }),
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
    setTimeout(() => {
      URL.revokeObjectURL(objectUrl);
    });
  };

  /**
   * 通过指定toUserId，通过server发送图片消息(目前仅支持单聊、 int64类型uid)
   * @param toUserId
   * @param file
   * @param encrypt
   */
  const sendImageMessageUseToUserId = async (toUserId: string, file: File, encrypt?: boolean) => {
    const objectUrl = URL?.createObjectURL(file);
    const { width, height } = (await getImageSize(objectUrl)) || {};

    const message = await bytedIMInstance.createImageMessage({
      toUserId,
      fileInfo: {
        type: FileType.Image,
        fileHandler: file,
        displayType: 'media', // image
        encrypt: encrypt ? true : undefined,
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: {
        's:file_ext_key_original_width': width?.toString(),
        's:file_ext_key_original_height': height?.toString(),
      },
    });
    console.log('sendImageMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendImageMessageUseToUserId result', result);
    sendMessageCheckCode(result);

    setTimeout(() => {
      URL.revokeObjectURL(objectUrl);
    });
  };

  /**
   * 发送视频消息
   * @param file
   */
  const sendVideoMessage = async (file: File) => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendVideoMessageUseToUserId(currentConversation.toParticipantUserId, file);
      return;
    }

    if (!calcVideoInstance) {
      calcVideoInstance = new CalcVideo();
    }
    const { width, height, duration, coverURL } = (await calcVideoInstance.loadVideo(file, 2)) || {};
    const message = await bytedIMInstance.createVideoMessage({
      conversation: currentConversation,
      fileInfo: {
        type: FileType.Video,
        fileHandler: file,
        displayType: 'media',
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: await insertAliasExtForMassChat({
        duration: duration?.toString(),
        // coverURL,
        original_width: width?.toString(),
        original_height: height?.toString(),
      }),
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送视频消息(目前仅支持单聊、 int64类型uid)
   * @param toUserId
   * @param file
   */
  const sendVideoMessageUseToUserId = async (toUserId: string, file: File) => {
    if (!calcVideoInstance) {
      calcVideoInstance = new CalcVideo();
    }
    const { width, height, duration, coverURL } = (await calcVideoInstance.loadVideo(file, 2)) || {};

    const params = {
      toUserId,
      fileInfo: {
        type: FileType.Video,
        fileHandler: file,
        displayType: 'media',
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: {
        duration: duration?.toString(),
        // coverURL,
        original_width: width?.toString(),
        original_height: height?.toString(),
      },
    };
    const message = await bytedIMInstance.createVideoMessage(params);
    console.log('sendVideoMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendVideoMessageUseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 发送视频消息 V1 版本 (使用 MESSAGE_TYPE_VIDEO)
   * @param file
   */
  const sendVideoMessageV1 = async (file: File) => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendVideoMessageV1UseToUserId(currentConversation.toParticipantUserId, file);
      return;
    }
    if (!calcVideoInstance) {
      calcVideoInstance = new CalcVideo();
    }
    const { width, height, duration, coverURL } = (await calcVideoInstance.loadVideo(file, 2)) || {};
    const message = await bytedIMInstance.createVideoMessage({
      conversation: currentConversation,
      fileInfo: {
        type: FileType.Video,
        fileHandler: file,
        displayType: 'media',
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: await insertAliasExtForMassChat({
        duration: duration?.toString(),
        // coverURL,
        original_width: width?.toString(),
        original_height: height?.toString(),
      }),
      videoType: 'v1',
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送视频消息 V1 版本 (使用 MESSAGE_TYPE_VIDEO)
   * @param toUserId
   * @param file
   */
  const sendVideoMessageV1UseToUserId = async (toUserId: string, file: File) => {
    if (!calcVideoInstance) {
      calcVideoInstance = new CalcVideo();
    }
    const { width, height, duration, coverURL } = (await calcVideoInstance.loadVideo(file, 2)) || {};
    const message = await bytedIMInstance.createVideoMessage({
      toUserId,
      fileInfo: {
        type: FileType.Video,
        fileHandler: file,
        displayType: 'media',
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: {
        duration: duration?.toString(),
        // coverURL,
        original_width: width?.toString(),
        original_height: height?.toString(),
      },
      videoType: 'v1',
    });
    console.log('sendVideoMessageV1UseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendVideoMessageV1UseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 发送语音消息
   */
  const sendAudioMessage = async ({ file, duration }: { file: File; duration?: number }) => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendAudioMessageUseToUserId(currentConversation.toParticipantUserId, { file, duration });
      return;
    }

    const message = await bytedIMInstance.createAudioMessage({
      conversation: currentConversation,
      fileInfo: {
        type: FileType.Audio,
        fileHandler: file,
        displayType: 'media',
        audioDuration: duration,
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
      ext: await insertAliasExtForMassChat({}),
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送语音消息(目前仅支持单聊、 int64类型uid)
   */
  const sendAudioMessageUseToUserId = async (
    toUserId: string,
    { file, duration }: { file: File; duration?: number }
  ) => {
    const params = {
      toUserId,
      fileInfo: {
        type: FileType.Audio,
        fileHandler: file,
        displayType: 'media',
        audioDuration: duration,
        onUploadProcess: res => setFileUploadProcess(cur => ({ ...cur, [message.clientId]: res })),
      },
    };
    const message = await bytedIMInstance.createAudioMessage(params);
    console.log('sendAudioMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendAudioMessageUseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 发送系统消息
   * @param conversation
   * @param text
   */
  const sendSystemMessage = async (conversation: Conversation, text: string) => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === conversation.id
    ) {
      sendSystemMessageUseToUserId(currentConversation.toParticipantUserId, text);
      return;
    }

    const message = await bytedIMInstance.createCustomMessage({
      conversation,
      content: JSON.stringify({
        type: 2,
        text,
      }),
    });
    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送系统消息(目前仅支持单聊、 int64类型uid)
   * @param toUserId
   * @param text
   */
  const sendSystemMessageUseToUserId = async (toUserId: string, text: string) => {
    const params = {
      toUserId,
      content: JSON.stringify({
        type: 2,
        text,
      }),
    };
    const message = await bytedIMInstance.createCustomMessage(params);
    console.log('sendSystemMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendSystemMessageUseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 发送自定义消息
   */
  const sendVolcMessage = async () => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendVolcMessageUseToUserId(currentConversation.toParticipantUserId);
      return;
    }

    const ext = {};
    await insertAliasExtForMassChat(ext);
    const message = await bytedIMInstance.createCustomMessage({
      conversation: currentConversation,
      content: JSON.stringify({
        type: 1,
        link: 'https://www.volcengine.com/',
        text: '欢迎体验火山引擎即时通讯 IM demo',
      }),
      ext: ext,
    });
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送自定义消息(目前仅支持单聊、 int64类型uid)
   */
  const sendVolcMessageUseToUserId = async (toUserId: string) => {
    const params = {
      toUserId,
      content: JSON.stringify({
        type: 1,
        link: 'https://www.volcengine.com/',
        text: '欢迎体验火山引擎即时通讯 IM demo',
      }),
    };
    const message = await bytedIMInstance.createCustomMessage(params);
    console.log('sendVolcMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendVolcMessageUseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 发送优惠券消息
   */
  const sendCouponMessage = async () => {
    if (
      currentConversation.type == im_proto.ConversationType.ONE_TO_ONE_CHAT &&
      sendSingleMsgType.useToUserId &&
      sendSingleMsgType.conversationId === currentConversation.id
    ) {
      sendCouponMessageUseToUserId(currentConversation.toParticipantUserId);
      return;
    }
    const ext = {};
    await insertAliasExtForMassChat(ext);
    const message = await bytedIMInstance.createCustomMessage({
      conversation: currentConversation,
      content: JSON.stringify({
        detail: '这是一张优惠券,点击此处领取',
        start: 8,
        end: 14,
        type: '3',
      }),
      ext: ext,
    });

    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
  };

  /**
   * 通过指定toUserId，通过server发送优惠券消息(目前仅支持单聊、 int64类型uid)
   */
  const sendCouponMessageUseToUserId = async (toUserId: string) => {
    const params = {
      toUserId,
      content: JSON.stringify({
        detail: '这是一张优惠券,点击此处领取',
        start: 8,
        end: 14,
        type: '3',
      }),
    };
    const message = await bytedIMInstance.createCustomMessage(params);
    console.log('sendCouponMessageUseToUserId message', message);
    const result = await bytedIMInstance.sendMessage({ message, priority });
    console.log('sendCouponMessageUseToUserId result', result);
    sendMessageCheckCode(result);
  };

  /**
   * 设置消息已读
   * @param msg
   * @param index
   * @returns
   */
  const markMessageRead = (msg: Message, index: number) => {
    if (!currentConversation.unreadCount || !msg || msg.indexInConversation.lte(currentConversation.readIndex)) {
      return;
    }

    toMarkReadList.push({ key: index, value: msg });

    clearTimeout(markReadTimer);

    markReadTimer = setTimeout(async () => {
      const latestMessage = toMarkReadList?.reduce?.((temp, item) => {
        return item?.key >= temp?.key ? item : temp;
      }, toMarkReadList?.[0])?.value;

      if (!latestMessage) {
        return;
      }

      if (latestMessage.indexInConversation && latestMessage.conversationId === currentConversation.id) {
        await bytedIMInstance.markConversationRead({
          conversation: currentConversation,
          readIndex: latestMessage.indexInConversation,
        });
      }
      toMarkReadList.length = 0;
    }, 20);
  };

  /**
   * 回复消息
   * @param msg
   * @returns
   */
  const replyMessage = (msg: Message) => {
    if (!msg) {
      return;
    }
    setReferenceMessage(msg);
    setEditingMessage(null);
  };

  const editMessage = (msg: Message) => {
    setReferenceMessage(null);
    setEditingMessage(msg);
  };

  /**
   * 撤回消息
   * @param msg
   * @returns
   */
  const recallMessage = async (msg: Message) => {
    if (!msg) {
      return;
    }
    await bytedIMInstance.recallMessage({
      message: msg,
    });
  };

  /**
   * 删除消息
   * @param msg
   * @returns
   */
  const deleteMessage = async (msg: Message) => {
    if (!msg) {
      return;
    }
    await bytedIMInstance.deleteMessage({
      message: msg,
    });
  };

  /**
   * 点赞消息
   * @param msg
   * @param key
   * @param value
   */
  const modifyMessageProperty = async (msg: Message, key: string, value: string) => {
    await bytedIMInstance.modifyMessageProperty({
      message: msg,
      modifyContent: [
        {
          key,
          value: userId, // 与客户端对齐
          operation: 0,
          idempotentId: userId,
        },
      ],
    });
  };

  /**
   * 加载更多消息
   * @param cursor
   * @returns
   */
  const loadMoreMessage = async (cursor): Promise<boolean> => {
    const res = await bytedIMInstance
      .getMessagesByConversation({
        conversation: currentConversation,
        cursor,
      })
      .catch(e => {
        return {
          messages: [],
        };
      });

    return res.messages.length > 0;
  };

  return {
    messages,
    resendMessage,
    sendTextMessage,
    sendTextMessageUseToUserId,
    sendFileMessage,
    sendFileMessageUseToUserId,
    sendImageMessage,
    sendImageMessageUseToUserId,
    sendAudioMessage,
    sendAudioMessageUseToUserId,
    sendVideoMessage,
    sendVideoMessageUseToUserId,
    sendVideoMessageV1,
    sendVideoMessageV1UseToUserId,
    sendVolcMessage,
    sendVolcMessageUseToUserId,
    sendSystemMessage,
    sendSystemMessageUseToUserId,
    sendCouponMessage,
    sendCouponMessageUseToUserId,
    markMessageRead,
    loadMoreMessage,
    replyMessage,
    editMessage,
    editingMessage,
    recallMessage,
    deleteMessage,
    modifyMessageProperty,
  };
};

export default useMessage;
