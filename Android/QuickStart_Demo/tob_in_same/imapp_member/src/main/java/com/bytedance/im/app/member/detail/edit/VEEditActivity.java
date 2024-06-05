package com.bytedance.im.app.member.detail.edit;

import android.app.Activity;
import android.os.Bundle;
import android.text.InputFilter;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.member.R;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;

public class VEEditActivity extends Activity {
    protected static final String CONVERSATION_ID = "conversation_id";
    private EditText editText;
    protected String conversationId;
    private TextView title ;
    private View confirm;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        setContentView(R.layout.ve_im_activity_edit_group_name);
        title = findViewById(R.id.tv_title);
        editText = findViewById(R.id.edit_text);
        confirm = findViewById(R.id.tv_confirm);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(initMaxEditCount())});
        editText.setEnabled(false);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        confirm.setOnClickListener(v -> onConfirmClick(editText.getText().toString()));
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                editText.setText(onUpdateEditText(conversation));
                BIMMember mySelf = conversation.getCurrentMember();
                boolean isSelfOwner = mySelf != null && mySelf.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER;
                editText.setEnabled(isSelfOwner);
                title.setText(initTitle(isSelfOwner));
                if (isSelfOwner) {
                    confirm.setVisibility(View.VISIBLE);
                } else {
                    confirm.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    protected String initTitle(boolean isOwner){
        return "编辑";
    }

    protected int initMaxEditCount() {
        return 100;
    }
    @Override
    protected void onResume() {
        super.onResume();
        editText.requestFocus();
    }

    protected String onUpdateEditText(BIMConversation conversation){
        return "";
    }

    protected void onConfirmClick(String text) {

    }
}
