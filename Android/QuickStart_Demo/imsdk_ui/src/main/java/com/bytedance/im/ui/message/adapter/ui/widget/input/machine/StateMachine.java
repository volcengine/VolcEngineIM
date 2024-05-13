package com.bytedance.im.ui.message.adapter.ui.widget.input.machine;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

public class StateMachine {
    public static final int MSG_VOICE_CLICK = 0;
    public static final int MSG_EMOJI_CLICK = 1;
    public static final int MSG_OPTION_CLICK = 2;
    public static final int MSG_KEY_BOARD_SHOW = 3;
    public static final int MSG_KEY_BOARD_HIDE = 4;
    public static final int MSG_KEY_BOARD_IS_SHOW = 5;
    public static final int MSG_EMPTY_CLICK = 6;

    private View emojiPanl;
    private View optionalPanl;
    private EditText inputEt;
    private View voiceTv;
    private View functionLayout;
    private State statNormal = new StateNorMal();
    private State stateVoice = new StateVoice();
    private State stateEmoji = new StateEmoji();
    private State stateOption = new StateOptional();
    private State curState = new StateNorMal();


    public StateMachine(View emojiGroup, View inputOptional, EditText inputEt, View voiceTv, View functionLayout) {
        this.emojiPanl = emojiGroup;
        this.optionalPanl = inputOptional;
        this.inputEt = inputEt;
        this.voiceTv = voiceTv;
        this.functionLayout = functionLayout;
    }

    public void sendMsg(int msg) {
        curState.processMsg(msg);
    }

    class StateNorMal extends State {

        @Override
        void init(int msg) {
            inputEt.setVisibility(View.VISIBLE);
            voiceTv.setVisibility(View.GONE);
            emojiPanl.setVisibility(View.GONE);
            optionalPanl.setVisibility(View.GONE);
            functionLayout.setVisibility(View.VISIBLE);
            if (msg != MSG_KEY_BOARD_IS_SHOW) {
                hideKeyBoard(inputEt);
                functionLayout.setVisibility(View.GONE);
            }
        }

        @Override
        public boolean processMsg(int msg) {
            switch (msg) {
                case MSG_VOICE_CLICK:
                    stateVoice.transTo(MSG_VOICE_CLICK);
                    break;
                case MSG_EMOJI_CLICK:
                    stateEmoji.transTo(MSG_EMOJI_CLICK);
                    break;
                case MSG_OPTION_CLICK:
                    stateOption.transTo(MSG_OPTION_CLICK);
                    break;
                case MSG_KEY_BOARD_SHOW:
                    functionLayout.setVisibility(View.VISIBLE);
                    break;
                case MSG_KEY_BOARD_HIDE:
                    functionLayout.setVisibility(View.GONE);
                    break;
                case MSG_EMPTY_CLICK:
                    statNormal.transTo(MSG_EMPTY_CLICK);
                    break;

            }
            return true;
        }

    }

    class StateVoice extends State {
        @Override
        public void init(int msg) {
            inputEt.setVisibility(View.GONE);
            voiceTv.setVisibility(View.VISIBLE);
            emojiPanl.setVisibility(View.GONE);
            optionalPanl.setVisibility(View.GONE);
            functionLayout.setVisibility(View.GONE);
            hideKeyBoard(inputEt);
        }

        @Override
        public boolean processMsg(int msg) {
            switch (msg) {
                case MSG_VOICE_CLICK:
                    statNormal.transTo(MSG_VOICE_CLICK);
                    break;
                case MSG_EMOJI_CLICK:
                    stateEmoji.transTo(MSG_EMOJI_CLICK);
                    break;
                case MSG_OPTION_CLICK:
                    stateOption.transTo(MSG_OPTION_CLICK);
                    break;
            }
            return true;
        }
    }

    class StateEmoji extends State {
        private boolean isKeyBoardShow;

        @Override
        void init(int msg) {
            inputEt.setVisibility(View.VISIBLE);
            voiceTv.setVisibility(View.GONE);
            emojiPanl.setVisibility(View.VISIBLE);
            optionalPanl.setVisibility(View.GONE);
            functionLayout.setVisibility(View.VISIBLE);
            hideKeyBoard(inputEt);
            isKeyBoardShow = false;
        }

        @Override
        boolean processMsg(int msg) {
            switch (msg) {
                case MSG_VOICE_CLICK:
                    stateVoice.transTo(MSG_VOICE_CLICK);
                    break;
                case MSG_EMOJI_CLICK:
                    if (isKeyBoardShow) {
                        statNormal.transTo(MSG_KEY_BOARD_IS_SHOW);
                    } else {
                        statNormal.transTo(MSG_EMOJI_CLICK);
                    }
                    break;
                case MSG_OPTION_CLICK:
                    stateOption.transTo(MSG_OPTION_CLICK);
                    break;
                case MSG_KEY_BOARD_SHOW:
                    isKeyBoardShow = true;
                    statNormal.transTo(MSG_KEY_BOARD_IS_SHOW);
                    break;
                case MSG_KEY_BOARD_HIDE:
                    isKeyBoardShow = false;
                    break;
                case MSG_EMPTY_CLICK:
                    statNormal.transTo(MSG_EMPTY_CLICK);
                    break;
            }
            return true;
        }
    }

    class StateOptional extends State {
        private boolean isKeyBoardShow;

        @Override
        void init(int msg) {
            inputEt.setVisibility(View.VISIBLE);
            voiceTv.setVisibility(View.GONE);
            emojiPanl.setVisibility(View.GONE);
            optionalPanl.setVisibility(View.VISIBLE);
            functionLayout.setVisibility(View.VISIBLE);
            hideKeyBoard(inputEt);
            isKeyBoardShow = false;
        }

        @Override
        boolean processMsg(int msg) {
            switch (msg) {
                case MSG_VOICE_CLICK:
                    stateVoice.transTo(MSG_VOICE_CLICK);
                    break;
                case MSG_EMOJI_CLICK:
                    stateEmoji.transTo(MSG_EMOJI_CLICK);
                    break;
                case MSG_OPTION_CLICK:
                    if (isKeyBoardShow) {
                        statNormal.transTo(MSG_KEY_BOARD_IS_SHOW);
                    } else {
                        statNormal.transTo(MSG_OPTION_CLICK);
                    }
                    break;
                case MSG_KEY_BOARD_SHOW:
                    isKeyBoardShow = true;
                    statNormal.transTo(MSG_KEY_BOARD_IS_SHOW);
                    break;
                case MSG_KEY_BOARD_HIDE:
                    isKeyBoardShow = false;
                    break;
                case MSG_EMPTY_CLICK:
                    statNormal.transTo(MSG_EMPTY_CLICK);
                    break;
            }

            return true;
        }
    }


    abstract class State {
        abstract void init(int msg);

        abstract boolean processMsg(int msg);

        boolean transTo(int msg) {
            curState = this;
            init(msg);
            return true;
        }
    }

    private void hideKeyBoard(EditText editText) {
        // 隐藏软键盘
        InputMethodManager imm = (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
    }
}
