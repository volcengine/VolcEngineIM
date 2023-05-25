package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;

public class VEEditLivePortraitActivity extends VEEditLiveActivity {
    private ProgressDialog waitDialog;
    public static void start(Activity activity, long conversationId) {
        Intent intent = new Intent(activity, VEEditLivePortraitActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getPortraitURL();
    }

    @Override
    protected int initMaxEditCount() {
        return 100;
    }

    @Override
    protected void onConfirmClick(String text) {
        super.onConfirmClick(text);
        waitDialog = ProgressDialog.show(VEEditLivePortraitActivity.this, "群图标修改中, 稍等...", "");
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupIcon(conversationId, text, new BIMSimpleCallback() {
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
