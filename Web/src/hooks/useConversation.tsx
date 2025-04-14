import { useRecoilState, useRecoilValue, useSetRecoilState } from 'recoil';
import { im_proto, ConversationSettingWeakMuteInfo, PushStatus, Conversation } from '@volcengine/im-web-sdk';

import { BytedIMInstance, CurrentConversation, Conversations, UserId, SpecialBotConvStickOnTop } from '../store';
import { CheckCode } from '../constant';
import useMessage from './useMessage';
import { Message } from '@arco-design/web-react';
import { useAccountsInfo } from './useProfileUpdater';
import singletonData from '../utils/singleton';
import { isSpecialBotConversion } from '../utils/bot';

const { ConversationOperationStatus, ConversationType } = im_proto;

const useConversation = () => {
  const bytedIMInstance = useRecoilValue(BytedIMInstance);
  const setCurrentConversation = useSetRecoilState(CurrentConversation);
  const setConversations = useSetRecoilState(Conversations);
  const setSpecialBotConvStickOnTop = useSetRecoilState(SpecialBotConvStickOnTop);
  const userId = useRecoilValue(UserId);

  const { sendSystemMessage, editMessage, replyMessage } = useMessage();
  const ACCOUNTS_INFO = useAccountsInfo();

  /**
   * 获取会话列表
   */
  const getConversationList = async (isFist?: boolean) => {
    try {
      let conversations: Conversation[] = await bytedIMInstance.getConversationList();
      conversations.sort((a, b) => {
        // 特殊机器人会话强制置顶最上方
        const aIsSpecialConv = isSpecialBotConversion(a.id);
        const bIsSpecialConv = isSpecialBotConversion(b.id);
        return aIsSpecialConv ? -1 : bIsSpecialConv ? 1 : b.rankScore - a.rankScore;
      });
      console.log(`获取会话列，排序后的Conv, isFist:`, isFist, conversations);
      if (isFist) {
        // 特殊机器人会话999880
        const hasSpecialConv = conversations?.[0]?.id && isSpecialBotConversion(conversations?.[0]?.id);
        if (hasSpecialConv) {
          const specialConv: Conversation = conversations[0];
          // 是否发送开场白
          const sendNotice = specialConv.lastMessage ? false : true;
          bytedIMInstance.markNewChat({ conversation: specialConv, sendNotice });
          // 置顶机器人会话
          configConversationStickOnTop(specialConv.id, true);
        } else {
          // 创建新的特殊机器人会话 uid: 999880
          createBotOneOneConversation('999880');
        }
      } else {
        // 移除本地已经删除的特殊机器人会话（频繁发消息删不掉会话兜底，是否需要兜底根据实际业务诉求来做决策，做过滤的边界case：机器人还未回复完时做删除，新消息来时没有提醒，下次重新登录会把之前未读的消息拉回来）
        const isDeleteSpecialBotConv = singletonData.getInstance().getData('isDeleteSpecialBotConv');
        // if (isDeleteSpecialBotConv) {
        //   conversations = conversations.filter(conv => {
        //     if (conv?.id && isSpecialBotConversion(conv?.id)) {
        //       return false;
        //     }
        //     return true;
        //   });
        // }
        console.log(`获取会话列，not is Fist，isDeleteSpecialBotConv:`, isDeleteSpecialBotConv);
      }
      return conversations;
    } catch (error) {
      console.log(`获取会话列表失败 getConversationList error`);
      throw Error(`获取会话列表失败 getConversationList error`);
    }
  };

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
   * todo: 创建机器人群聊
   * @param ids
   * @param bizExt
   */
  const createBotGroupConversation = async (ids, bizExt) => {
    const params = {
      type: ConversationType.GROUP_CHAT,
      participants: [bizExt.userId, ...ids],
      name: bizExt.name,
    };
    try {
      // todo 二期支持
      return true;
    } catch (e) {
      console.error('创建群聊失败', e);
    }
    return false;
  };

  /**
   * 创建机器人单聊
   * @param uid
   */
  const createBotOneOneConversation = async (uid: string) => {
    try {
      const { payload } = await bytedIMInstance.createConversation({
        type: ConversationType.ONE_TO_ONE_CHAT,
        participants: uid,
      });
      setCurrentConversation(payload);
      console.log('createBotOneOneConversation setCurrentConversation', payload);
      // 是否发送开场白
      const sendNotice = payload.lastMessage ? false : true;
      bytedIMInstance.markNewChat({ conversation: payload, sendNotice });
      const isSpecialConv = isSpecialBotConversion(payload.id);
      if (isSpecialConv) {
        singletonData.getInstance().setData('isDeleteSpecialBotConv', false);
        // 置顶机器人会话
        configConversationStickOnTop(payload.id, true);
      }
      return true;
    } catch (e) {
      console.error('创建机器人单聊失败', e);
      return false;
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
      console.log('selectConversation setCurrentConversation', conv);
      if (conv.type === im_proto.ConversationType.ONE_TO_ONE_CHAT)
        void bytedIMInstance.markConversationMessagesRead({ conversation: conv });
      editMessage(null);
      replyMessage(null);
    }
  };

  /**
   * 删除会话
   * @param id
   */
  const removeConversation = async (id: string) => {
    const conv = getConversation(id);

    if (conv?.id) {
      const isSpecialConv = isSpecialBotConversion(conv.id);
      // console.log(`删除会话：`, isSpecialConv, conv?.id);
      try {
        if (isSpecialConv) {
          singletonData.getInstance().setData('isDeleteSpecialBotConv', true);
          // 清空会话历史消息不删除server会话
          await Promise.all([
            bytedIMInstance?.clearConversationMessage({ conversation: conv }),
            bytedIMInstance?.deleteConversation({
              conversation: conv,
              localOnly: true,
            }),
          ]);
          // await bytedIMInstance?.clearConversationMessage({ conversation: conv });
          setTimeout(() => {
            // 删会话会触发ConversationChange和ConversationUpsert,偶现会话被重置回来的问题。方案1: 延迟1s再置空；方案2:ConversationChange做过滤(该方案在机器人还未回复完时做删除，新消息来时没有提醒，下次重新登录会把之前未读的消息拉回来)
            setCurrentConversation(null);
          }, 1000);
          setCurrentConversation(null);
          console.log('removeConversation isSpecialConv setCurrentConversation', null);
          return;
        }
        await bytedIMInstance?.deleteConversation({
          conversation: conv,
        });
        setTimeout(() => {
          // 删会话会触发ConversationChange和ConversationUpsert,偶现会话被重置回来的问题。方案1: 延迟1s再置空；方案2:ConversationChange做补偿判空（该方案暂未实践，可能还有其他未知边界case）
          setCurrentConversation(null);
        }, 1000);
        console.log('removeConversation setCurrentConversation', null);
      } catch (error) {
        Message.error('删除会话失败，请刷新重试');
      }
    } else {
      Message.error('会话id不存在，请刷新重试');
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
      console.log('leaveGroupConversation setCurrentConversation', null);
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
      console.log('dissolveGroupConversation setCurrentConversation', null);
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
   * 设置会话置顶
   */
  const configConversationStickOnTop = async (id: string, stickOnTop?: boolean) => {
    const isSpecialConv = isSpecialBotConversion(id);
    if (isSpecialConv) {
      if (stickOnTop) {
        setSpecialBotConvStickOnTop(true);
        configConversationSettingInfo(id, { stickOnTop });
      } else {
        // 特殊会话 取消置顶，仅在本地内存记录
        setSpecialBotConvStickOnTop(false);
      }
    } else {
      configConversationSettingInfo(id, { stickOnTop });
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

  /**
   * 清空会话历史消息
   * @param id
   */
  const clearConversationMessage = async (id: string) => {
    const conv = getConversation(id);
    if (conv?.id) {
      try {
        await bytedIMInstance?.clearConversationMessage({ conversation: conv });
        Message.success('清空聊天记录请求成功');
      } catch (e) {
        Message.error('清空聊天记录请求失败');
      }
    }
  };

  /**
   * 清空AI机器人聊天的上下文
   * @param id
   */
  const clearConversationContext = async (id: string, sendNotice?: boolean) => {
    const conv = getConversation(id);
    if (conv?.id) {
      // 清空AI机器人聊天的上下文
      try {
        console.log('清空AI机器人聊天的上下文 clearConversationContext', conv);
        await sendSystemMessage(conv, '已清除上下文');
        await bytedIMInstance?.markNewChat({ conversation: conv, sendNotice });
        Message.success('清空上下文成功');
      } catch (error) {
        Message.error('清空上下文失败');
      }
    }
  };

  /**
   * 获取机器列表（api先放到这里）
   */
  const getBotList = async () => {
    try {
      const resp = await bytedIMInstance.getBotListOnline();
      const BOT_DEBUG = localStorage.getItem('BOT_DEBUG');
      console.log('lllllll BotList', BOT_DEBUG, resp.list);
      let list = resp.list;
      // 正式环境只展示两个机器人
      if (BOT_DEBUG !== '1') {
        list = list.filter(item => ['999880', '999881'].includes(item.uid));
      }
      // 特殊机器人会话999880 强制置顶最上方
      // list = list.filter(item => item.uid === '999880').concat(list.filter(item => item.uid !== '999880'));
      return list;
    } catch (e) {
      console.error('获取机器列表失败', e);
    }
  };

  return {
    getConversation,
    selectConversation,
    removeConversation,
    createGroupConversation,
    createOneOneConversation,
    createBotGroupConversation,
    createBotOneOneConversation,
    leaveGroupConversation,
    dissolveGroupConversation,
    configGroupConversationCoreInfo,
    configConversationSettingInfo,
    configConversationStickOnTop,
    configConversationWeakMute,
    clearConversationMessage,
    clearConversationContext,
    getConversationList,
    getBotList,
  };
};

export default useConversation;
