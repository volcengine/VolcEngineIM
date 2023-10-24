package com.bytedance.im.app.live.edit;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;
//自己在直播群的昵称
public class VEEditLiveMemberNameActivity  extends VEEditLiveActivity {
    private ProgressDialog waitDialog;

    public static void start(Context context, long conversationId) {
        Intent intent = new Intent(context, VEEditLiveMemberNameActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationId);
        context.startActivity(intent);
    }

    @Override
    protected String initTitle(boolean isOwner) {
        return "我的昵称";
    }

    @Override
    protected String onUpdateEditText(BIMConversation conversation) {
        return conversation.getCurrentMember().getAlias();
    }

    @Override
    protected void onConfirmClick(String text) {
        setGroupName(text);
    }

    @Override
    protected int initMaxEditCount() {
        return 10;
    }

    @Override
    protected boolean checkEditable(BIMConversation conversation) {
        return true;
    }

    /**
     * 修改群名称
     *
     * @param text
     */
    private void setGroupName(String text) {
        waitDialog = ProgressDialog.show(VEEditLiveMemberNameActivity.this, "名称修改中, 稍等...", "");
        if (TextUtils.isEmpty(text)) {
            text = "用户" + BIMClient.getInstance().getCurrentUserID();
        }
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupMemberAlias(conversationId, text, new BIMSimpleCallback() {
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
