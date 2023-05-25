package com.bytedance.im.app.live.edit;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;

public class VEEditLiveDesActivity extends VEEditLiveActivity {
    private ProgressDialog waitDialog;
    public static void start(Context context, long conversationId) {
        Intent intent = new Intent(context, VEEditLiveDesActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationId);
        context.startActivity(intent);
    }

    @Override
    protected String initTitle(boolean isOwner) {
        if (isOwner) {
            return "编辑直播群简介";
        } else {
            return "直播群简介";
        }
    }

    @Override
    protected int initMaxEditCount() {
        return 100;
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getDescription();
    }

    @Override
    protected void onConfirmClick(String text) {
        waitDialog = ProgressDialog.show(VEEditLiveDesActivity.this, "简介修改中, 稍等...", "");
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupDescription(conversationId, text, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Toast.makeText(VEEditLiveDesActivity.this,"修改群简介成功",Toast.LENGTH_SHORT).show();
                waitDialog.dismiss();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEEditLiveDesActivity.this,"修改群简介失败",Toast.LENGTH_SHORT).show();
                waitDialog.dismiss();
                finish();
            }
        });
    }
}
