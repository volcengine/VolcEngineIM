package com.bytedance.im.ui.message.adapter.ui.widget.input;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.view.ViewPager;
import android.text.Editable;
import android.text.InputFilter;
import android.text.Selection;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.Message;
import com.bytedance.im.core.model.inner.msg.BIMTextElement;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.emoji.EmojiInfo;
import com.bytedance.im.ui.emoji.EmojiManager;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.member.BIMGroupMemberListActivity;
import com.bytedance.im.ui.message.adapter.ui.widget.EmojiGroupView;
import com.bytedance.im.ui.message.adapter.ui.widget.input.audio.VoiceInputButton;
import com.bytedance.im.ui.message.adapter.ui.widget.input.machine.StateMachine;
import com.bytedance.im.ui.message.adapter.ui.widget.input.measure.KeyBoardHeightHelper;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.adapter.ToolPageAdapter;
import com.bytedance.im.ui.utils.BIMUtils;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class VEInPutView extends FrameLayout implements View.OnClickListener, EmojiGroupView.EmojiClickListener {
    private static final String TAG = "VEInPutView";
    private int REQUEST_CODE_SELECT_USER_FOR_AT = 1000;
    private int MAX_LENGTH = 500;
    private ImageView mEmojiIv;
    private EmojiGroupView mEmojiGroupView;
    private Message longClickToMsg;
    private ViewPager moreInputOptional;
    private ImageView mVoiceIv;
    protected VoiceInputButton mVoiceInputTv;
    protected EditText mInputEt;
    private TextView sendBtn;
    private ImageView inputMenu;
    private OnInputListener listener;
    private View replayMsgLayout;
    private TextView replayMsgTv;
    private View closeReplayMsgTv;
    private BIMMessage refMessage;
    private BIMMessage editMessage;
    private List<BaseToolBtn> baseToolBtnList;
    private Set<Long> mentionIds = new HashSet<Long>();
    private Fragment fragment;
    private String conversationId;
    private TextView tvPriority;
    private FrameLayout functionLayout;
    private KeyBoardHeightHelper keyBoardHeightHelper;
    private StateMachine stateMachine;
    private boolean isInit = false;

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
        replayMsgLayout = findViewById(R.id.ll_replay_msg);
        replayMsgTv = findViewById(R.id.tv_replay_msg);
        closeReplayMsgTv = findViewById(R.id.tv_close_replay_msg);
        tvPriority = findViewById(R.id.msg_priority);
        tvPriority.setVisibility(View.GONE);
        closeReplayMsgTv.setOnClickListener(this);
        sendBtn.setOnClickListener(this);
        mVoiceIv.setOnClickListener(this);
        inputMenu.setOnClickListener(this);
        inputMenu.setOnClickListener(this);
        mVoiceInputTv = findViewById(R.id.tv_voice_input_button);
        moreInputOptional = findViewById(R.id.cl_input_more_page);
        functionLayout = findViewById(R.id.function_layout);
        mInputEt = findViewById(R.id.et_input_content);
        mInputEt.addTextChangedListener(mTextWatcher);
        mInputEt.setFilters(new InputFilter[]{new InputFilter.LengthFilter(MAX_LENGTH)});
        functionLayout.setVisibility(View.GONE);
        initByKeyBoard();
        stateMachine = new StateMachine(mEmojiGroupView, moreInputOptional, mInputEt, mVoiceInputTv, functionLayout);
    }

    public void reset(){
        stateMachine.sendMsg(StateMachine.MSG_EMPTY_CLICK);
    }

    private void initByKeyBoard() {
        keyBoardHeightHelper = new KeyBoardHeightHelper();
        keyBoardHeightHelper.showMeasureWindow(this, new KeyBoardHeightHelper.OnMeasureCompleteListener() {
            @Override
            public void onKeyBoardShow(int keyBoardHeight) {
                ViewGroup.LayoutParams layoutParams = functionLayout.getLayoutParams();
                layoutParams.height = keyBoardHeight;
                functionLayout.setLayoutParams(layoutParams);
                stateMachine.sendMsg(StateMachine.MSG_KEY_BOARD_SHOW);
            }

            @Override
            public void onKeyBoardHide() {
                stateMachine.sendMsg(StateMachine.MSG_KEY_BOARD_HIDE);
            }
        });
    }

    public void initFragment(Fragment fragment, BIMConversation bimConversation, boolean showPriority, List<BaseToolBtn> baseToolBtns, VoiceInputButton.OnAudioRecordListener audioRecordListener, OnInputListener inputListener) {
        initFragment(fragment, bimConversation, baseToolBtns, audioRecordListener, inputListener);
        if (showPriority) {
            tvPriority.setVisibility(View.VISIBLE);
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        keyBoardHeightHelper.onDetached();
        super.onDetachedFromWindow();
    }

    public TextView getTvPriority() {
        return tvPriority;
    }

    public void initFragment(Fragment fragment, BIMConversation conversation, List<BaseToolBtn> baseToolBtns, VoiceInputButton.OnAudioRecordListener audioRecordListener, OnInputListener inputListener) {
        if (isInit || conversation == null) {
            return;
        }
        isInit = true;//仅可以初始化一次
        this.fragment = fragment;
        this.conversationId = conversation.getConversationID();
        baseToolBtnList = baseToolBtns;
        mVoiceInputTv.init(fragment, audioRecordListener);
        this.listener = inputListener;
        moreInputOptional.setAdapter(new ToolPageAdapter(fragment, conversation, baseToolBtns));
    }


    public String getEditDraft() {
        return mInputEt.getText().toString();
    }

    public void setEditDraft(String draft) {
        mInputEt.setText(draft);
    }

    @Override
    public void onClick(View v) {
        if (!isInit) {
            return;
        }
        if (v == sendBtn) {
            if (listener != null) {
                if (editMessage != null) {
                    listener.onSendEditClick(mInputEt.getText().toString(), editMessage, new ArrayList<>(mentionIds));
                } else {
                    listener.onSendClick(mInputEt.getText().toString(), refMessage, new ArrayList<>(mentionIds));
                }
                mentionIds.clear();
                closeReplayMsgTv.performClick();
            }
            mInputEt.getText().clear();
            sendBtn.setVisibility(View.GONE);
        } else if (v == mEmojiIv) {
            stateMachine.sendMsg(StateMachine.MSG_EMOJI_CLICK);
        } else if (v == inputMenu) {
            stateMachine.sendMsg(StateMachine.MSG_OPTION_CLICK);
        } else if (v == mVoiceIv) {
            stateMachine.sendMsg(StateMachine.MSG_VOICE_CLICK);
        } else if (v == closeReplayMsgTv) {
            refMessage = null;
            editMessage = null;
            replayMsgTv.setText("");
            replayMsgLayout.setVisibility(View.GONE);
        }
    }

    public void onRefMessage(BIMMessage message) {
        refMessage = message;
        replayMsgLayout.setVisibility(View.VISIBLE);
        String fixHint = BIMUtils.fixWebHint(message.getHint());
        if (TextUtils.isEmpty(fixHint)) {
            fixHint = message.getHint();
        }
        replayMsgTv.setText("引用: " + fixHint);
    }


    public void onEditMessage(BIMMessage message){
        if (message.getMsgType() != BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
            return;
        }
        BIMTextElement textElement = (BIMTextElement) message.getElement();
        editMessage = message;
        replayMsgLayout.setVisibility(View.VISIBLE);
        replayMsgTv.setText("旧内容: " + textElement.getText());
    }

    @Override
    public void OnEmojiClick(EmojiInfo info) {
        if (info == null || TextUtils.isEmpty(info.text)||!isInit) {
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
            int end = preSelection+info.text.length();
            if (end > MAX_LENGTH) {
                mInputEt.setSelection(MAX_LENGTH);
            } else {
                mInputEt.setSelection(end);
            }
        }
    }

    private static String last = "";
    private TextWatcher mTextWatcher = new TextWatcher() {

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {

        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            if (s == null || s.toString().isEmpty() || !isTextValid(s.toString())) {
                sendBtn.setVisibility(View.GONE);
            } else {
                sendBtn.setVisibility(View.VISIBLE);
            }
            boolean isSameLast = last != null && s != null && s.toString().equals(last);
            if (!isSameLast && s.toString().endsWith("@")) {
                //跳转选择
                BIMLog.i(TAG, "onAtClick()");
                BIMGroupMemberListActivity.startForResult(fragment, conversationId, REQUEST_CODE_SELECT_USER_FOR_AT);
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
        void onSendClick(String text, BIMMessage refMessage, List<Long> mentionIdList);

        void onSendEditClick(String text, BIMMessage editMessage, List<Long> mentionIdList);
    }

    public void setListener(OnInputListener listener) {
        this.listener = listener;
    }

    private boolean isTextValid(String text) {
        if (null != text && !text.isEmpty()) {
            for (char c : text.toCharArray()) {
                if (c != ' ' && c != '\t' && c != '\n') {
                    return true;
                }
            }
        }
        return false;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_SELECT_USER_FOR_AT) {
            //选成员
            if (data == null) {
                return;
            }
            List<Long> selectUid = (List<Long>) data.getSerializableExtra(BIMGroupMemberListActivity.RESULT_ID_LIST);
            if (selectUid == null) {
                return;
            }

            BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(selectUid, new BIMResultCallback<List<BIMUIUser>>() {
                @Override
                public void onSuccess(List<BIMUIUser> bimuiUsers) {
                    for (BIMUIUser user : bimuiUsers) {
                        StringBuffer mentionStr = new StringBuffer();;
                        mentionStr.append(" ");
                        mentionStr.append("@");
                        mentionStr.append(getNickName(user));
                        mentionStr.append(" "); //用空格区分@的内容
                        mentionIds.add(user.getUid());
                        StringBuffer stringBuffer = new StringBuffer(mInputEt.getText());
                        stringBuffer.deleteCharAt(mInputEt.getText().length() - 1);
                        stringBuffer.append(mentionStr);
                        mInputEt.setText(stringBuffer.toString());
                        Selection.setSelection(mInputEt.getText(), mInputEt.getText().length()); //移动光标到尾部
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });

        } else {
            for (BaseToolBtn toolBtn : baseToolBtnList) {
                toolBtn.onActivityResult(requestCode, resultCode, data);
            }
        }
    }

    private String getNickName(BIMUIUser fullInfo) {
        String name = "用户" + fullInfo.getUid();         //用户ID
        if (!TextUtils.isEmpty(fullInfo.getNickName())) { //用户资料名
            name = fullInfo.getNickName();
        }
        return name;
    }
}
