import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { FileType, im_proto, IMEvent, Message } from '@volcengine/im-web-sdk';

import {
  BytedIMInstance,
  CurrentConversation,
  FileUploadProcessStore,
  Messages,
  ReferenceMessage,
  SendMessagePriority,
  UserId,
  EditMessage,
} from '../store';
import { CalcVideo, getImageSize, getMessagePreview } from '../utils';
import { Message as ArcoMessage } from '@arco-design/web-react';
import { EXT_ALIAS_NAME, EXT_AVATAR_URL } from '../constant';
import { isBotConversion } from '../utils/bot';

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
  const sendTextMessage = async (msg: object) => {
    if (editingMessage && editingMessage.type === im_proto.MessageType.MESSAGE_TYPE_TEXT) {
      await editTextMessage(editingMessage, JSON.stringify(msg));
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
   * 发送文件消息
   * @param file
   */
  const sendFileMessage = async (file: File) => {
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
   * 发送图片消息
   * @param file
   * @param encrypt
   */
  const sendImageMessage = async (file: File, encrypt?: boolean) => {
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
   * 发送视频消息
   * @param file
   */
  const sendVideoMessage = async (file: File) => {
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
   * 发送语音消息
   */
  const sendAudioMessage = async ({ file, duration }: { file: File; duration?: number }) => {
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
   * 发送系统消息
   * @param conversation
   * @param text
   */
  const sendSystemMessage = async (conversation, text: string) => {
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
    sendFileMessage,
    sendImageMessage,
    sendVideoMessage,
    sendAudioMessage,
    sendVolcMessage,
    sendSystemMessage,
    markMessageRead,
    loadMoreMessage,
    replyMessage,
    editMessage,
    editingMessage,
    recallMessage,
    deleteMessage,
    modifyMessageProperty,
    sendCouponMessage,
  };
};

export default useMessage;
