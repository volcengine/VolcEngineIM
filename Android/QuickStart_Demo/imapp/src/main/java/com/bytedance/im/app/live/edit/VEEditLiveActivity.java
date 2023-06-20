package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.InputFilter;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;

public class VEEditLiveActivity extends Activity {
    protected static final String LIVE_CONVERSATION_SHORT_ID = "live_conversation_id";
    private EditText editText;
    protected long conversationId;
    private TextView title;
    private View confirm;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getLongExtra(LIVE_CONVERSATION_SHORT_ID, -1);
        setContentView(R.layout.ve_im_activity_edit_group_name);
        title = findViewById(R.id.tv_title);
        editText = findViewById(R.id.edit_text);
        confirm = findViewById(R.id.tv_confirm);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(initMaxEditCount())});
        findViewById(R.id.back).setOnClickListener(v -> finish());
        confirm.setOnClickListener(v -> onConfirmClick(editText.getText().toString()));
        title.setText(initTitle(false));
        editText.setEnabled(false);
        confirm.setVisibility(View.GONE);
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroup(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                editText.setText(onUpdateEditText(conversation));
                BIMMember member = conversation.getCurrentMember();
                if (member != null && (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER)) {
                    editText.setEnabled(true);
                    confirm.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    protected String initTitle(boolean isOwner) {
        return "编辑";
    }

    protected int initMaxEditCount() {
        return 10;
    }

    @Override
    protected void onResume() {
        super.onResume();
        editText.requestFocus();
    }

    protected String onUpdateEditText(BIMConversation conversation) {
        return "";
    }

    protected void onConfirmClick(String text) {

    }
}
