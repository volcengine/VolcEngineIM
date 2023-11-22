import { useRecoilValue, useSetRecoilState } from 'recoil';
import { im_proto, ConversationSettingWeakMuteInfo, PushStatus } from '@volcengine/im-web-sdk';

import { BytedIMInstance, CurrentConversation, UserId } from '../store';
import { ACCOUNTS_INFO, CheckCode } from '../constant';
import useMessage from './useMessage';
import { Message } from '@arco-design/web-react';

const { ConversationOperationStatus, ConversationType } = im_proto;

const useConversation = () => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const setCurrentConversation = useSetRecoilState(CurrentConversation);
  const userId = useRecoilValue(UserId);
  const { sendSystemMessage } = useMessage();

  /**
   * 根据id获取会话
   * @param id
   * @returns
   */
  const getConversation = (id: string) => {
    try {
      if (!id) return null;
      const conv = bytedIMInstance?.getConversation?.({ conversationId: id });
      if (conv?.id) {
        return conv;
      }
    } catch (error) {
      console.log(`根据id: ${id}获取会话失败`);
      throw Error(`根据id: ${id}获取会话失败`);
    }
  };

  /**
   * 创建群聊
   * @param ids
   * @param bizExt
   */
  const createGroupConversation = async (ids, bizExt) => {
    const params = {
      type: ConversationType.GROUP_CHAT,
      participants: [bizExt.userId, ...ids],
      name: bizExt.name,
    };
    try {
      const { payload, success, checkCode, statusCode, statusMsg } = await bytedIMInstance?.createConversation?.(
        params
      );
      if (
        [
          ConversationOperationStatus.MORE_THAN_USER_CONVERSATION_COUNT_LIMITS,
          ConversationOperationStatus.MASS_CONV_TOUCH_LIMIT,
        ].includes(statusCode)
      ) {
        const info = JSON.parse(statusMsg);
        Message.error(`${info?.moreThanConversationCountLimitUserIds} 加群个数超过上限`);
        return false;
      }
      if (success === false && checkCode.toNumber() === CheckCode.SENSITIVE_WORDS) {
        Message.error('文本中可能包含敏感词，请修改后重试');
        return false;
      }
      setCurrentConversation(payload);
      await sendSystemMessage(
        payload,
        `${ACCOUNTS_INFO[bizExt.userId].realName} 邀请 ${ids
          .map(id => ACCOUNTS_INFO[id]?.realName)
          .join('、')} 加入群聊`
      );
      return true;
    } catch (e) {
      console.error('创建群聊失败', e);
    }
    return false;
  };

  /**
   * 发起单聊
   * @param uid
   */
  const createOneOneConversation = async (uid: string) => {
    try {
      const { payload } = await bytedIMInstance.createConversation({
        type: ConversationType.ONE_TO_ONE_CHAT,
        participants: uid,
      });
      setCurrentConversation(payload);
    } catch (e) {
      console.error('发起单聊失败', e);
    }
  };

  /**
   * 设置当前选中会话
   * @param id
   */
  const selectConversation = (id: string) => {
    const conv = getConversation(id);
    if (conv?.id) {
      setCurrentConversation(conv);
    }
  };

  /**
   * 删除会话
   * @param id
   */
  const removeConversation = async (id: string) => {
    const conv = getConversation(id);

    if (conv?.id) {
      await bytedIMInstance?.deleteConversation({
        conversation: conv,
      });
      setCurrentConversation(null);
    }
  };

  /**
   * 退群
   * @param id 群id
   */
  const leaveGroupConversation = async (id: string) => {
    const conv = getConversation(id);

    if (conv?.id) {
      await sendSystemMessage(conv, `${ACCOUNTS_INFO[userId]?.realName} 退出群聊`);
      await bytedIMInstance?.leaveConversation({
        conversation: conv,
      });
      setCurrentConversation(null);
    }
  };

  /**
   * 解散群（群主）
   * @param id 群id
   */
  const dissolveGroupConversation = async (id: string) => {
    const conv = getConversation(id);

    if (conv?.id) {
      await sendSystemMessage(conv, '群聊被解散');
      await bytedIMInstance?.dissolveConversation({
        conversation: conv,
      });
      setCurrentConversation(null);
    }
  };

  /**
   * 设置群公告、头像、群名、描述
   * @param id 群id
   * @param config 群设置参数
   */
  const configGroupConversationCoreInfo = async (
    id: string,
    config: { name?: string; desc?: string; icon?: string; notice?: string }
  ) => {
    const conv = getConversation(id);

    if (conv?.id) {
      const { name, desc, icon, notice } = config;
      const { success, checkCode } = await bytedIMInstance?.setConversationCoreInfo({
        conversation: conv,
        name,
        desc,
        icon,
        notice,
        isNameSet: name ? true : false,
        isDescSet: desc ? true : false,
        isIconSet: icon ? true : false,
        isNoticeSet: notice ? true : false,
      });
      if (success === false && checkCode.toNumber() === CheckCode.SENSITIVE_WORDS) {
        Message.error('文本中可能包含敏感词，请修改后重试');
      } else {
        Message.success('保存成功');
      }
    }
  };

  /**
   * 设置会话顶置、免打扰模式
   * @param id
   * @param config
   */
  const configConversationSettingInfo = async (
    id: string,
    config: { mute?: boolean; stickOnTop?: boolean; pushStatus?: PushStatus }
  ) => {
    const conv = getConversation(id);

    if (conv?.id) {
      const { mute, stickOnTop = conv.isStickOnTop, pushStatus } = config;
      await bytedIMInstance?.setConversationSettingInfo({
        conversation: conv,
        mute,
        pushStatus,
        stickOnTop,
      });
    }
  };

  /**
   * 设置低打扰模式
   * @param id
   * @param config
   */
  const configConversationWeakMute = async (id: string, config: ConversationSettingWeakMuteInfo) => {
    const conv = getConversation(id);

    if (conv?.id) {
      await bytedIMInstance?.setConversationWeakMuteConfig({
        conversation: conv,
        config,
      });
    }
  };

  return {
    getConversation,
    selectConversation,
    removeConversation,
    createGroupConversation,
    createOneOneConversation,
    leaveGroupConversation,
    dissolveGroupConversation,
    configGroupConversationCoreInfo,
    configConversationSettingInfo,
    configConversationWeakMute,
  };
};

export default useConversation;
