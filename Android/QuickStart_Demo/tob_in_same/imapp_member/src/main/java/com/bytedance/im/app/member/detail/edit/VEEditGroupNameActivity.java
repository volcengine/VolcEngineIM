package com.bytedance.im.app.member.detail.edit;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;

public class VEEditGroupNameActivity extends VEEditActivity {
    private ProgressDialog waitDialog;
    private TextView title;

    public static void start(Context context, String conversationId) {
        Intent intent = new Intent(context, VEEditGroupNameActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        title = findViewById(R.id.tv_title);
        title.setText("群名称");
    }

    @Override
    protected String initTitle(boolean isOwner) {
        if (isOwner) {
            return "编辑群名称";
        } else {
            return "群名称";
        }
    }

    @Override
    protected int initMaxEditCount() {
        return 10;
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getName();
    }

    @Override
    protected void onConfirmClick(String text) {
        setGroupName(text);
    }

    /**
     * 修改群名称
     * @param text
     */
    private void setGroupName(String text) {
        if (TextUtils.isEmpty(text)) {
            Toast.makeText(VEEditGroupNameActivity.this, "名称无效", Toast.LENGTH_SHORT).show();
            return;
        }
        waitDialog = ProgressDialog.show(VEEditGroupNameActivity.this, "名称修改中, 稍等...", "");
        BIMUIClient.getInstance().setGroupName(conversationId, text, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                Toast.makeText(VEEditGroupNameActivity.this, "名称修改成功", Toast.LENGTH_SHORT).show();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                String failReason = "名称修改失败";
                if (code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
                    failReason = "文本中可能包含敏感词,请修改后重试";
                }
                Toast.makeText(VEEditGroupNameActivity.this, failReason, Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }
}
