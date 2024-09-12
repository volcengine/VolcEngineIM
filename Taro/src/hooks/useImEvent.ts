import { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import * as IMLib from '@volcengine/im-mp-sdk';

import { computedVisibleTime } from '../utils/message-preview';
import {
  selectConversation,
  selectIm,
  setConversation,
  setConversationList,
  setMessageList,
  setHasInit
} from '../store/imReducers';
import { useAppSelector } from '../store/hooks';

const { im_proto, IMEvent } = IMLib;
const { ConversationType } = im_proto;
const liveMsgsMap = new Map();
import lang from 'lodash/lang';

export const useImEvent = () => {
  const imInstance = useAppSelector(selectIm);
  const oldConversation = useAppSelector(selectConversation);
  const dispatch = useDispatch();

  useEffect(() => {
    if (!imInstance) {
      return;
    }
    // 初始化成功
    const handelInitSuccess = () => {
      dispatch(setHasInit(true));
    };
    const initFinish = imInstance.event.subscribe(IMEvent.InitFinish, handelInitSuccess);

    // 会话变更
    const handleConversation = () => {
      const conversationList = imInstance.getConversationList();
      dispatch(setConversationList(conversationList));
    };
    const conversationChange = imInstance.event.subscribe(IMEvent.ConversationChange, handleConversation);

    const handleConversationUpsert = conv => {
      if (oldConversation?.id === conv.id) {
        dispatch(setConversation(lang.cloneDeep(conv)));
      }
    };

    const conversationUpsert = imInstance.event.subscribe(IMEvent.ConversationUpsert, handleConversationUpsert);

    // 消息变更
    const handleMessageChange = msg => {
      console.log('handleMessageChange');
      if (!oldConversation || msg.conversationId !== oldConversation.id) {
        return;
      }
      if (oldConversation.type !== ConversationType.MASS_CHAT) {
        // 普通群消息
        const messageList = oldConversation.getMessageList();
        computedVisibleTime(messageList);
        dispatch(setMessageList(messageList));
      } else {
        // 直播群消息
        liveMsgsMap.set(msg.clientId, msg);
        dispatch(setMessageList(Array.from(liveMsgsMap.values())));
      }
    };
    const messageUpsert = imInstance.event.subscribe(IMEvent.MessageUpsert, handleMessageChange);

    return () => {
      imInstance.event.unsubscribe(IMEvent.MessageUpsert, messageUpsert);
      imInstance.event.unsubscribe(IMEvent.InitFinish, initFinish);
      imInstance.event.unsubscribe(IMEvent.ConversationChange, conversationChange);
      imInstance.event.unsubscribe(IMEvent.ConversationUpsert, conversationUpsert);
    };
  }, [oldConversation?.id, imInstance]);

  useEffect(() => {
    if (!imInstance || !oldConversation) {
      liveMsgsMap.clear();
      dispatch(setMessageList([]));
    }
  }, [oldConversation, imInstance]);

  useEffect(() => {
    if (!oldConversation) {
      return;
    }
    if (oldConversation.type !== ConversationType.MASS_CHAT) {
      // 普通群消息
      const messageList = oldConversation.getMessageList();
      computedVisibleTime(messageList);
      dispatch(setMessageList(messageList));
    } else {
      // 直播群消息
      liveMsgsMap.clear();
      dispatch(setMessageList([]));
    }
  }, [oldConversation]);
};
