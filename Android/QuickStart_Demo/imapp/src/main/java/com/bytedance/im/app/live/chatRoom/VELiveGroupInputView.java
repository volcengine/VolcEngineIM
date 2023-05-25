package com.bytedance.im.app.live.chatRoom;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.message.adapter.ui.widget.VEInPutView;

public class VELiveGroupInputView extends VEInPutView {
    private OnInputListener childListener;

    public VELiveGroupInputView(@NonNull Context context) {
        super(context);
    }

    public VELiveGroupInputView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
    }

    public VELiveGroupInputView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void onResume() {
        findViewById(R.id.iv_voice_input).setVisibility(View.GONE);
        findViewById(R.id.tv_voice_input_button).setVisibility(View.GONE);
        findViewById(R.id.iv_input_type_more).setOnClickListener(null);

        ((ImageView)findViewById(R.id.iv_input_type_more)).setImageResource(R.drawable.icon_live_group_custom_message);
        findViewById(R.id.iv_input_type_more).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != childListener) {
                    childListener.onCustomClick();
                }
            }
        });
    }

    public void setListener(OnInputListener listener) {
        super.setListener(listener);
        childListener = listener;
    }
}
