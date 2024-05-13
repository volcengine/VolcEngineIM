package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.text.TextUtils;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;
//自己在直播群的头像
public class VEEditLiveMemberPortraitActivity extends VEEditLiveActivity{
    private ProgressDialog waitDialog;
    public static void start(Activity activity, long conversationId) {
        Intent intent = new Intent(activity, VEEditLiveMemberPortraitActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected String initTitle(boolean isOwner) {
        return "我的群头像";
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getCurrentMember().getAvatarUrl();
    }

    @Override
    protected boolean checkEditable(BIMConversation conversation) {
        return true;
    }

    @Override
    protected int initMaxEditCount() {
        return Integer.MAX_VALUE;
    }

    @Override
    protected void onConfirmClick(String text) {
        super.onConfirmClick(text);
        waitDialog = ProgressDialog.show(this, "我的头像修改中, 稍等...", "");
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupMemberAvatar(conversationId, text, new BIMSimpleCallback() {
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
