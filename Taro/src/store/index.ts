import { configureStore, ThunkAction, Action, getDefaultMiddleware } from '@reduxjs/toolkit';
import counterReducer from './imReducers';
import userReducers from './userReducers';
import { atom } from 'recoil';
import { BytedIM, im_proto } from '@volcengine/im-mp-sdk';

export const store = configureStore({
  reducer: {
    im: counterReducer,
    user: userReducers
  },
  middleware: getDefaultMiddleware({
    serializableCheck: false
  })
});

export type AppDispatch = typeof store.dispatch;

export type RootState = ReturnType<typeof store.getState>;

export type AppThunk<ReturnType = void> = ThunkAction<ReturnType, RootState, unknown, Action<string>>;
export const BytedIMInstance = atom<BytedIM>({
  key: 'BytedIMInstance',
  default: null,
  dangerouslyAllowMutability: true
});

export const AccountsInfoVersion = atom<im_proto.MessagePriority>({
  key: 'AccountsInfoVersion',
  default: 0,
  dangerouslyAllowMutability: true
});
export const LiveMemberCount = atom<number>({
  key: 'LiveMemberCount',
  default: 0,
  dangerouslyAllowMutability: true
});
