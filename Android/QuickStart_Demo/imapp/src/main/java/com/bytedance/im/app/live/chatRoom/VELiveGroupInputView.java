package com.bytedance.im.app.live.chatRoom;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.live.api.enmus.BIMMessagePriority;
import com.bytedance.im.ui.emoji.EmojiManager;
import com.bytedance.im.ui.message.adapter.ui.widget.EmojiGroupView;

public class VELiveGroupInputView extends FrameLayout {

    private EditText etInput;
    private TextView tvPriority;
    private ImageView ivEmoji;
    private ImageView ivCustom;
    private TextView tvSend;
    private EmojiGroupView emojiGroupView;

    public interface OnLiveInputListener {
        void onSendClick(String text);

        void onCustomClick();

        void onPriorityChanged(BIMMessagePriority priority);
    }

    private OnLiveInputListener liveInputListener;

    public VELiveGroupInputView(@NonNull Context context) {
        this(context, null);
    }

    public VELiveGroupInputView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public VELiveGroupInputView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        inflate(context, R.layout.ve_im_live_input_layout, this);
        etInput = findViewById(R.id.et_input_content);
        tvPriority = findViewById(R.id.tv_priority);
        ivEmoji = findViewById(R.id.iv_emoji);
        ivCustom = findViewById(R.id.iv_custom);
        tvSend = findViewById(R.id.tv_send);
        emojiGroupView = findViewById(R.id.v_emoji_group);
        ivCustom.setOnClickListener(v -> {
            if (liveInputListener != null) {
                liveInputListener.onCustomClick();
            }
        });
        tvSend.setOnClickListener(v -> {
            if (liveInputListener != null) {
                Editable editable = etInput.getText();
                String text = editable == null ? "" : editable.toString();
                etInput.setText("");
                liveInputListener.onSendClick(text);
            }
        });
        ivEmoji.setOnClickListener(v -> {
            if (emojiGroupView.getVisibility() == View.VISIBLE) {
                emojiGroupView.setVisibility(View.GONE);
            } else {
                emojiGroupView.setVisibility(View.VISIBLE);
            }
        });

        emojiGroupView.setEmojiClickListener(info -> {
            if (info == null || TextUtils.isEmpty(info.text)) {
                return;
            }
            int preSelection = etInput.getSelectionStart();
            StringBuilder builder = new StringBuilder(etInput.getText());
            //delete button
            if (info.code == -10000) {
                KeyEvent eventDown = new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_DEL);
                etInput.onKeyDown(KeyEvent.KEYCODE_DEL, eventDown);

                KeyEvent eventUp = new KeyEvent(KeyEvent.ACTION_UP, KeyEvent.KEYCODE_DEL);
                etInput.onKeyUp(KeyEvent.KEYCODE_DEL, eventUp);
            } else {
                builder.insert(preSelection, info.text);
                etInput.setText(EmojiManager.getInstance().parseEmoJi(getContext(), builder.toString()));
                etInput.setSelection(preSelection + info.text.length());
            }
        });

        etInput.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s == null || s.toString().isEmpty() || !isTextValid(s.toString())) {
                    tvSend.setVisibility(View.GONE);
                    ivCustom.setVisibility(View.VISIBLE);
                } else {
                    tvSend.setVisibility(View.VISIBLE);
                    ivCustom.setVisibility(View.GONE);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        tvPriority.setOnClickListener(v -> {
            showPriorityWindow();
        });
    }

    public void setLiveInputListener(OnLiveInputListener liveInputListener) {
        this.liveInputListener = liveInputListener;
    }

    private void showPriorityWindow() {
        PopupWindow popupWindow = new PopupWindow(getContext());
        View v = inflate(getContext(), R.layout.ve_im_live_input_priority_window_layout, null);
        View.OnClickListener listener = v1 -> {
            switch (v1.getId()) {
                case R.id.high:
                    if (liveInputListener != null) {
                        liveInputListener.onPriorityChanged(BIMMessagePriority.HIGH);
                        tvPriority.setText("高");
                    }
                    break;
                case R.id.normal:
                    if (liveInputListener != null) {
                        liveInputListener.onPriorityChanged(BIMMessagePriority.NORMAL);
                        tvPriority.setText("普通");
                    }
                    break;
                case R.id.low:
                    if (liveInputListener != null) {
                        liveInputListener.onPriorityChanged(BIMMessagePriority.LOW);
                        tvPriority.setText("低");
                    }
                    break;
                default:
                    break;
            }
            popupWindow.dismiss();
        };
        v.findViewById(R.id.high).setOnClickListener(listener);
        v.findViewById(R.id.normal).setOnClickListener(listener);
        v.findViewById(R.id.low).setOnClickListener(listener);
        popupWindow.setContentView(v);
        popupWindow.setBackgroundDrawable(new ColorDrawable(0));
        int width = getContext().getResources().getDimensionPixelSize(R.dimen.ve_input_pop_priority_width);
        int height = getContext().getResources().getDimensionPixelSize(R.dimen.ve_input_pop_priority_height);
        popupWindow.setHeight(height);
        popupWindow.setWidth(width);
        popupWindow.setOutsideTouchable(true);
        popupWindow.showAsDropDown(tvPriority, 0, -1 * (height + tvPriority.getHeight() + 20), Gravity.BOTTOM);
    }

    private boolean isTextValid(String text) {
        if (null != text && !text.isEmpty()) {
            for (char c: text.toCharArray()) {
                if (c != ' ' && c != '\t' && c != '\n') {
                    return true;
                }
            }
        }
        return false;
    }
}
