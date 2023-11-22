import { useRecoilValue, useSetRecoilState } from 'recoil';
import { im_proto, Conversation } from '@volcengine/im-web-sdk';

import { BytedIMInstance, CurrentConversation } from '../store';
import { CheckCode } from '../constant';
import { Message } from '@arco-design/web-react';
import { useLive } from './useLive';

const { ConversationOperationStatus, ConversationType } = im_proto;

export const useLiveConversation = () => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const setCurrentConversation = useSetRecoilState(CurrentConversation);
  const { clearCurrentLiveConversationStatus } = useLive();

  /**
   * 获取直播群列表
   */
  const getLiveConversationList = async params => {
    const { limit, cursor = undefined, policy } = params;
    const result = await bytedIMInstance?.getLiveConversationListOnline?.({
      cursor,
      policy,
      limit,
    });
    return result;
  };

  /**
   * 创建直播群聊
   * @param params
   */
  const createLiveConversation = async (params: { name: string }) => {
    const { name } = params;
    try {
      const { payload, success, checkCode, statusCode, statusMsg } = await bytedIMInstance?.createConversation?.({
        participants: [],
        type: ConversationType.MASS_CHAT,
        name,
      });
      if ([ConversationOperationStatus.MASS_CONV_TOUCH_LIMIT].includes(statusCode)) {
        Message.error('创建直播群超过上限');
        return false;
      }
      if (success === false && checkCode.toNumber() === CheckCode.SENSITIVE_WORDS) {
        Message.error('文本中可能包含敏感词，请修改后重试');
        return false;
      }
      return payload;
    } catch (e) {
      Message.error('创建直播群聊失败');
    }
    return false;
  };

  /**
   * 禁言
   * @param params.conversation 会话
   * @param params.block 是否禁言
   * @param params.normalOnly 是否只禁言普通群成员
   */
  const setConversationMute = async params => {
    const { conversation, block, normalOnly = false } = params;
    const result = await bytedIMInstance?.setConversationMute?.({
      conversation,
      block,
      normalOnly,
    });
    return result;
  };

  /**
   * 设置群公告、头像、群名、描述
   * @param id 群id
   * @param config 群设置参数
   */
  const configLiveConversationCoreInfo = async (
    conv: Conversation,
    config: { name?: string; desc?: string; icon?: string; notice?: string }
  ) => {
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
   * 直播群解散群（群主）
   * @param id 群id
   */
  const dissolveLiveGroupConversation = async conv => {
    await bytedIMInstance?.dissolveConversation({
      conversation: conv,
    });
  };

  /**
   * 设置当前选中会话
   * @param conv
   */
  const selectLiveConversation = async conv => {
    clearCurrentLiveConversationStatus(false);
    const newConv = await bytedIMInstance?.getConversationOnline({
      conversationId: conv.id,
      shortId: conv.shortId,
      type: conv.type,
    });
    setCurrentConversation(newConv);
  };

  return {
    getLiveConversationList,
    createLiveConversation,
    dissolveLiveGroupConversation,
    setConversationMute,
    configLiveConversationCoreInfo,
    selectLiveConversation,
  };
};
