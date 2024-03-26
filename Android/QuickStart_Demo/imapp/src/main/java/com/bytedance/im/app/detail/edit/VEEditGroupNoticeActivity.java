package com.bytedance.im.app.detail.edit;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.widget.Toast;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;

public class VEEditGroupNoticeActivity extends VEEditActivity {
    private ProgressDialog waitDialog;

    public static void start(Context context, String conversationId) {
        Intent intent = new Intent(context, VEEditGroupNoticeActivity.class);
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
        if (isOwner) {
            return "编辑群公告";
        } else {
            return "群公告";
        }
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getNotice();
    }

    @Override
    protected void onConfirmClick(String text) {
        setNotice(text);
    }

    /**
     * 修改群公告
     */
    private void setNotice(String text) {
        waitDialog = ProgressDialog.show(VEEditGroupNoticeActivity.this, "群公告修改中, 稍等...", "");
        BIMUIClient.getInstance().setGroupNotice(conversationId, text, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                Toast.makeText(VEEditGroupNoticeActivity.this, "群公告修改成功", Toast.LENGTH_SHORT).show();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                String failReason = "名称修改失败";
                if (code == BIMErrorCode.BIM_SERVER_SET_GROUP_INFO_REJECT) {
                    failReason = "文本中可能包含敏感词,请修改后重试";
                }
                Toast.makeText(VEEditGroupNoticeActivity.this, failReason, Toast.LENGTH_SHORT).show();
                finish();
            }
        });
    }
}
