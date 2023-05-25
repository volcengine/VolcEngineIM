package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;

public class VEEditLiveNoticeActivity extends VEEditLiveActivity {
    private ProgressDialog waitDialog;

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VEEditLiveNoticeActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    protected String initTitle(boolean isOwner) {
        if (isOwner) {
            return "编辑直播群公告";
        } else {
            return "直播群公告";
        }
    }

    @Override
    protected int initMaxEditCount() {
        return 100;
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getNotice();
    }

    @Override
    protected void onConfirmClick(String text) {
        super.onConfirmClick(text);
        waitDialog = ProgressDialog.show(VEEditLiveNoticeActivity.this, "群公告修改中, 稍等...", "");
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupNotice(conversationId, text, new BIMSimpleCallback() {
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
