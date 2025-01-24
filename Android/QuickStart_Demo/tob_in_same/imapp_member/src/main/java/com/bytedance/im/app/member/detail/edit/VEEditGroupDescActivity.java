package com.bytedance.im.app.member.detail.edit;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.Nullable;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.core.api.model.BIMMember;

public class VEEditGroupDescActivity extends VEEditActivity {
    private ProgressDialog waitDialog;

    public static void start(Context context, String conversationId) {
        Intent intent = new Intent(context, VEEditGroupDescActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected int initMaxEditCount() {
        return 100;
    }

    @Override
    protected String initTitle(boolean isOwner) {
        return "群描述";
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getDescription();
    }

    @Override
    protected boolean needTrim() {
        return false;
    }

    @Override
    protected void onConfirmClick(String text) {
        setDesc(text);
    }

    @Override
    protected boolean enableEdit(BIMMember self, BIMConversation conversation) {
        return self != null && (self.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || self.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
    }

    /**
     * 修改群描述
     */
    private void setDesc(String desc) {
        waitDialog = ProgressDialog.show(VEEditGroupDescActivity.this, "群描述修改中, 稍等...", "");

        BIMGroupInfo info = new BIMGroupInfo.BIMGroupInfoBuilder()
                .description(desc)
                .build();
        BIMClient.getInstance().setGroupInfo(conversationId, info, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                Toast.makeText(VEEditGroupDescActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                Toast.makeText(VEEditGroupDescActivity.this, "操作失败: " + code.getValue(), Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }
}
