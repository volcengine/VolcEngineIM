import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { FileType, Message, im_proto, IMEvent } from '@volcengine/im-web-sdk';

import {
  Messages,
  CurrentConversation,
  BytedIMInstance,
  ReferenceMessage,
  FileUploadProcessStore,
  UserId,
  LiveConversationNickName,
  SendMessagePriority,
} from '../store';
import { CalcVideo, getImageSize, getMessagePreview } from '../utils';
import { Message as ArcoMessage } from '@arco-design/web-react';
import { SEND_MESSAGE_STATUS_STR } from '../utils/code';

let markReadTimer: any = null;
let toMarkReadList: Array<{ key: number; value: Message }> = [];
let calcVideoInstance: CalcVideo;

function sendMessageCheckCode(result) {
  switch (result.statusCode) {
    case im_proto.StatusCode.NOT_FRIEND:
      ArcoMessage.error('对方不是你的好友，无法发送消息');
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
  const liveConversationNickName = useRecoilValue(LiveConversationNickName);
  const [referenceMessage, setReferenceMessage] = useRecoilState(ReferenceMessage);
  const setFileUploadProcess = useSetRecoilState(FileUploadProcessStore);
  const userId = useRecoilValue(UserId);
  const priority = useRecoilValue(SendMessagePriority);

  /**
   * 重发消息
   * @param message
   */
  const resendMessage = async (message: Message) => {
    await bytedIMInstance.sendMessage({ message });
  };

  /**
   * 发送普通文本消息
   * @param msg
   */
  const sendTextMessage = async (msg: object) => {
    const params = {
      conversation: currentConversation,
      content: JSON.stringify(msg),
      referenceMessage,
      referenceHint: getMessagePreview(referenceMessage),
      ext: {},
    };
    if (liveConversationNickName !== undefined && currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      params.ext['a:live_group_nick_name'] = liveConversationNickName;
    }

    const message = await bytedIMInstance.createTextMessage(params);
    if (currentConversation.type == im_proto.ConversationType.MASS_CHAT) {
      bytedIMInstance?.event?.emit?.(IMEvent.MessageUpsert, null, message);
    }

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message, priority }));
    setReferenceMessage(null);
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
    });

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message }));
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
      ext: {
        's:file_ext_key_original_width': width?.toString(),
        's:file_ext_key_original_height': height?.toString(),
      },
    });

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message }));
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
      ext: {
        duration: duration?.toString(),
        // coverURL,
        original_width: width?.toString(),
        original_height: height?.toString(),
      },
    });

    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message }));
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
    });
    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message }));
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
    sendMessageCheckCode(await bytedIMInstance.sendMessage({ message }));
  };

  /**
   * 发送自定义消息
   */
  const sendVolcMessage = async () => {
    const message = await bytedIMInstance.createCustomMessage({
      conversation: currentConversation,
      content: JSON.stringify({
        type: 1,
        link: 'https://www.volcengine.com/',
        text: '欢迎体验即时通讯IM demo',
      }),
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
          value,
          operation: 0,
          idempotentId: String(key) + userId + value,
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
    recallMessage,
    deleteMessage,
    modifyMessageProperty,
  };
};

export default useMessage;
