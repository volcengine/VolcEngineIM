package com.bytedance.im.ui.message.adapter.ui.widget;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.constraint.ConstraintLayout;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.emoji.EmojiInfo;
import com.bytedance.im.ui.emoji.EmojiManager;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.Message;
import com.bytedance.im.ui.utils.BIMUtils;

public class VEInPutView extends FrameLayout implements View.OnClickListener, EmojiGroupView.EmojiClickListener {
    private static final String TAG = "VEInPutView";
    private int mCurrentInputType = InputType.NORMAL;
    private ImageView mEmojiIv;
    private EmojiGroupView mEmojiGroupView;
    private Message longClickToMsg;
    private ConstraintLayout moreInputOptional;
    private ImageView optionalFile;
    private ImageView optionalImage;
    private ImageView optionalPhoto;
    private ImageView optionalCustom;
    private ImageView mVoiceIv;
    protected TextView mVoiceInputTv;
    protected EditText mInputEt;
    private TextView sendBtn;
    private ImageView inputMenu;
    private OnInputListener listener;
    private View replayMsgLayout;
    private TextView replayMsgTv;
    private View closeReplayMsgTv;
    private BIMMessage refMessage;

    public VEInPutView(@NonNull Context context) {
        this(context, null);
    }

    public VEInPutView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public VEInPutView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        inflate(getContext(), R.layout.bim_im_input_layout, this);
        init();
    }

    private void init() {
        mEmojiIv = findViewById(R.id.iv_input_type_emoji);
        mEmojiGroupView = findViewById(R.id.v_emoji_group);
        mEmojiIv.setOnClickListener(this);
        sendBtn = findViewById(R.id.tv_send);
        inputMenu = findViewById(R.id.iv_input_type_more);
        mEmojiGroupView.setEmojiClickListener(this);
        //voice input
        mVoiceIv = findViewById(R.id.iv_voice_input);
        optionalFile = findViewById(R.id.iv_input_optional_file);
        optionalImage = findViewById(R.id.iv_input_optional_img);
        optionalPhoto = findViewById(R.id.iv_input_optional_photo);
        optionalCustom = findViewById(R.id.iv_input_optional_custom_message);
        replayMsgLayout = findViewById(R.id.ll_replay_msg);
        replayMsgTv = findViewById(R.id.tv_replay_msg);
        closeReplayMsgTv = findViewById(R.id.tv_close_replay_msg);

        closeReplayMsgTv.setOnClickListener(this);
        sendBtn.setOnClickListener(this);
        mVoiceIv.setOnClickListener(this);
        inputMenu.setOnClickListener(this);
        inputMenu.setOnClickListener(this);
        optionalFile.setOnClickListener(this);
        optionalImage.setOnClickListener(this);
        optionalPhoto.setOnClickListener(this);
        optionalCustom.setOnClickListener(this);
        mVoiceInputTv = findViewById(R.id.tv_voice_input_button);
        mVoiceInputTv.setOnTouchListener(new AudioTouchListener());
        moreInputOptional = findViewById(R.id.cl_input_more);
        mInputEt = findViewById(R.id.et_input_content);
        mInputEt.addTextChangedListener(mTextWatcher);
        updateInputUI(mCurrentInputType);
    }

    public String getEditDraft(){
        return mInputEt.getText().toString();
    }

    public void setEditDraft(String draft){
        mInputEt.setText(draft);
    }

    @Override
    public void onClick(View v) {
        if (v == sendBtn) {
            if (listener != null) {
                listener.onSendClick(mInputEt.getText().toString());
                closeReplayMsgTv.performClick();
            }
            mInputEt.getText().clear();
            sendBtn.setVisibility(View.GONE);
        } else if (v == mEmojiIv) {
            if (mCurrentInputType != InputType.EMOJI) {
                updateInputUI(InputType.EMOJI);
            } else {
                updateInputUI(InputType.NORMAL);
            }
        } else if (v == inputMenu) {
            if (mCurrentInputType != InputType.EXTEND) {
                updateInputUI(InputType.EXTEND);
            } else {
                updateInputUI(InputType.NORMAL);
            }
        } else if (v == mVoiceIv) {
            if (mCurrentInputType != InputType.VOICE) {
                updateInputUI(InputType.VOICE);
            } else {
                updateInputUI(InputType.NORMAL);
            }
        } else if (v == optionalImage) {
            if (listener != null) {
                listener.onSelectImageClick();
            }
        } else if (v == optionalPhoto) {
            if (listener != null) {
                listener.onTakePhotoClick();
            }
        } else if (v == optionalFile) {
            if (listener != null) {
                listener.onFileClick();
            }
        } else if (v == closeReplayMsgTv) {
            replayMsgLayout.setVisibility(View.GONE);
            refMessage = null;
        } else if (v == optionalCustom) {
            if (listener != null) {
                listener.onCustomClick();
            }
        }
    }

    public void onRefMessage(BIMMessage message) {
        refMessage = message;
        replayMsgLayout.setVisibility(View.VISIBLE);
        String fixHint = BIMUtils.fixWebHint(message.getHint());
        if (TextUtils.isEmpty(fixHint)) {
            fixHint = message.getHint();
        }
        replayMsgTv.setText("引用: "+fixHint);
    }

    @Override
    public void OnEmojiClick(EmojiInfo info) {
        if (info == null || TextUtils.isEmpty(info.text)) {
            return;
        }
        int preSelection = mInputEt.getSelectionStart();
        StringBuilder builder = new StringBuilder(mInputEt.getText());
        //delete button
        if (info.code == -10000) {
            KeyEvent eventDown = new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DEL);
            mInputEt.onKeyDown(KeyEvent.KEYCODE_DEL, eventDown);

            KeyEvent eventUp = new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_DEL);
            mInputEt.onKeyUp(KeyEvent.KEYCODE_DEL, eventUp);
        } else {
            builder.insert(preSelection, info.text);
            mInputEt.setText(EmojiManager.getInstance().parseEmoJi(getContext(), builder.toString()));
            mInputEt.setSelection(preSelection + info.text.length());
        }
    }

    public interface InputType {
        int NORMAL = 0;
        int EMOJI = 1;
        int EXTEND = 2;
        int VOICE = 3;
    }

    private void updateInputUI(int inputType) {
        if (mCurrentInputType == inputType) {
            return;
        }
        mCurrentInputType = inputType;
        switch (mCurrentInputType) {
            case InputType.NORMAL:
                mEmojiGroupView.setVisibility(View.GONE);
                moreInputOptional.setVisibility(View.GONE);
                mInputEt.setVisibility(View.VISIBLE);
                mVoiceInputTv.setVisibility(View.GONE);
                break;
            case InputType.EMOJI:
                mEmojiGroupView.setVisibility(View.VISIBLE);
                moreInputOptional.setVisibility(View.GONE);
                mInputEt.setVisibility(View.VISIBLE);
                mVoiceInputTv.setVisibility(View.GONE);
                break;
            case InputType.EXTEND:
                mEmojiGroupView.setVisibility(View.GONE);
                moreInputOptional.setVisibility(View.VISIBLE);
                mInputEt.setVisibility(View.VISIBLE);
                mVoiceInputTv.setVisibility(View.GONE);
                break;
            case InputType.VOICE:
                mEmojiGroupView.setVisibility(View.GONE);
                moreInputOptional.setVisibility(View.GONE);
                mInputEt.setVisibility(View.GONE);
                mVoiceInputTv.setVisibility(View.VISIBLE);
                break;
            default:
                break;
        }
    }
    private static String last = "";
    private TextWatcher mTextWatcher = new TextWatcher() {

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            if (s == null || s.toString().isEmpty()) {
                sendBtn.setVisibility(View.GONE);
            } else {
                sendBtn.setVisibility(View.VISIBLE);
            }
            boolean isSameLast = last != null && s != null && s.toString().equals(last);
            if (!isSameLast && s.toString().endsWith("@")) {
                //跳转选择
                if (listener != null) {
                    listener.onAtClick();
                }
            }
            last = s.toString();
        }

        @Override
        public void afterTextChanged(Editable s) {

        }
    };


    public EditText getmInputEt() {
        return mInputEt;
    }

    public interface OnInputListener {
        void onSendClick(String text);

        void onAtClick();

        void onAudioStart();

        void onAudioEnd();

        void onAudioCancel();

        void onSelectImageClick();

        void onTakePhotoClick();

        void onFileClick();

        void onCustomClick();
    }

    public void setListener(OnInputListener listener) {
        this.listener = listener;
    }

    private class AudioTouchListener implements OnTouchListener {
        private boolean callEnd = false;
        private boolean callCancel = false;

        @Override
        public boolean onTouch(View v, MotionEvent event) {
            if (event.getAction() == MotionEvent.ACTION_DOWN) {
                mVoiceInputTv.setText("正在录音,手指上滑取消");
                if (listener != null) {
                    listener.onAudioStart();
                }
                callEnd = false;
                callCancel = false;
            } else if (event.getAction() == MotionEvent.ACTION_UP) {
                mVoiceInputTv.setText("点击录音");
                if (listener != null && !callEnd && !callCancel) {
                    listener.onAudioEnd();
                }
                callEnd = true;
            } else if (event.getAction() == MotionEvent.ACTION_MOVE) {
                if (event.getY() < 0 && !callCancel) {
                    mVoiceInputTv.setText("点击录音");
                    if (listener != null) {
                        listener.onAudioCancel();
                    }
                    callCancel = true;
                }
            }
            return true;
        }
    }

    public BIMMessage getRefMessage() {
        return refMessage;
    }
}
