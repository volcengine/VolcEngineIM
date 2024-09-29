import { createSlice, PayloadAction } from '@reduxjs/toolkit';
import { User, UserInfo } from '../../src/interface';
import { RootState } from '.';
import { USER_LIST } from '../../src/constants';

const initialState: UserInfo = Array.from(USER_LIST.values())[0];

export const counterSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    updateId: (state, action: PayloadAction<string>) => {
      state.id = action.payload;
    },
    updateName: (state, action: PayloadAction<string>) => {
      state.name = action.payload;
    },
    logout: (state) => {
      state.isLogin = false;
    },
    login: (state, action: PayloadAction<User>) => {
      state.id = action.payload.id;
      state.name = action.payload.name;
      state.isLogin = true;
    },
  },
});

export const { updateId, updateName, logout, login } = counterSlice.actions;

export const selectUser = (state: RootState) => state.user;

export default counterSlice.reducer;
