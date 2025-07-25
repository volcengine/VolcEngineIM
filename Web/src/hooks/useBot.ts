import { useAccountsInfo } from './useProfileUpdater';
import { BytedIMInstance } from '../store';
import { IS_EXTERNAL_DEMO } from '../constant';

import { useRecoilValue } from 'recoil';

const useBot = () => {
  const ACCOUNTS_INFO = useAccountsInfo();

  const bytedIMInstance = useRecoilValue(BytedIMInstance);

  /**
   * 是否是机器人单聊会话
   * @param toParticipantUserId 单聊会话的对方用户的 uid
   * @returns boolean 是否是机器人单聊会话
   */
  const isBotConversion = (toParticipantUserId: string) => {
    const result = ACCOUNTS_INFO?.[toParticipantUserId]?.isRobot;
    return result;
  };

  /**
   * 是否是特殊机器人单聊会话
   * @param conversionId 单聊会话的 conversationId
   * @returns boolean 是否是特殊机器人单聊会话
   */
  const isSpecialBotConversion = (conversionId: string) => {
    const result =  false;
    return result;
  };

  /**
   * 是否是特殊机器人单聊会话 V2
   * @param toParticipantUserId 单聊会话的对方用户的 uid
   * @returns boolean 是否是特殊机器人单聊会话
   */
  const isSpecialBotConversionV2 = (toParticipantUserId: string) => {
    const result =  false;
    return result;
  };

  /**
   * 获取机器列表
   */
  const getBotList = async () => {
    try {
      const resp = await bytedIMInstance.getBotListOnline();
      const BOT_DEBUG = localStorage.getItem('BOT_DEBUG');
      console.log('lllllll BotList', BOT_DEBUG, resp.list);
      let list = resp.list;
      
      return list;
    } catch (e) {
      console.error('获取机器列表失败', e);
    }
  };

  return {
    isBotConversion,
    isSpecialBotConversion,
    isSpecialBotConversionV2,
    getBotList,
  };
};

export default useBot;
