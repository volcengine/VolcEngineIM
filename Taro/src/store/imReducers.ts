import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { Conversation, BytedIM } from '@volcengine/im-mp-sdk';
import { RootState } from '.';

export interface imState {
  instance: BytedIM;
  conversation: Conversation;
  conversationList: Conversation[];
  messageList: any;
  participantList: any;
  hasInit: boolean;
}

const initialState: imState = {
  instance: null,
  conversation: null,
  conversationList: null,
  messageList: null,
  participantList: null,
  hasInit: false
};

export const counterSlice = createSlice({
  name: 'im',
  initialState,
  reducers: {
    setIm: (state, action: PayloadAction<any>) => {
      state.instance = action.payload;
    },
    setConversationList: (state, action: PayloadAction<any>) => {
      state.conversationList = action.payload;
    },
    setConversation: (state, action: PayloadAction<any>) => {
      state.conversation = action.payload;
    },
    setMessageList: (state, action: PayloadAction<any>) => {
      state.messageList = action.payload;
    },
    setParticipantList: (state, action: PayloadAction<any>) => {
      state.participantList = action.payload;
    },
    setHasInit: (state, action: PayloadAction<any>) => {
      state.hasInit = action.payload;
    },
    clearAll: state => {
      state.instance = null;
      state.conversation = null;
      state.conversationList = null;
      state.messageList = null;
      state.participantList = null;
      state.hasInit = false;
    }
  }
});

export const { setIm, setConversationList, setConversation, setMessageList, setParticipantList, setHasInit, clearAll } =
  counterSlice.actions;

export const selectIm = (state: RootState) => state.im.instance;
export const selectConversation = (state: RootState) => state.im.conversation;
export const selectConversationList = (state: RootState) => state.im.conversationList;
export const selectMessageList = (state: RootState) => state.im.messageList;
export const selectParticipantList = (state: RootState) => state.im.participantList;
export const selectHasInit = (state: RootState) => state.im.hasInit;

export default counterSlice.reducer;
