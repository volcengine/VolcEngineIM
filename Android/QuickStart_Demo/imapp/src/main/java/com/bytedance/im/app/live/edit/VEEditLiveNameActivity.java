package com.bytedance.im.app.live.edit;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;

public class VEEditLiveNameActivity extends VEEditLiveActivity {

    private ProgressDialog waitDialog;

    public static void start(Context context, long conversationId) {
        Intent intent = new Intent(context, VEEditLiveNameActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationId);
        context.startActivity(intent);
    }

    @Override
    protected String initTitle(boolean isOwner) {
        if (isOwner) {
            return "编辑直播群名称";
        } else {
            return "直播群群名称";
        }
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getName();
    }

    @Override
    protected void onConfirmClick(String text) {
        setGroupName(text);
    }

    @Override
    protected int initMaxEditCount() {
        return 10;
    }

    /**
     * 修改群名称
     *
     * @param text
     */
    private void setGroupName(String text) {
        waitDialog = ProgressDialog.show(VEEditLiveNameActivity.this, "名称修改中, 稍等...", "");
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupName(conversationId, text, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                finish();
            }
        });
    }
}
