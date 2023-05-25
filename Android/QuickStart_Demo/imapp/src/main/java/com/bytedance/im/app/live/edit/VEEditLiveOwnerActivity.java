package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.content.Intent;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.live.BIMLiveExpandService;

public class VEEditLiveOwnerActivity extends VEEditLiveActivity {
    public static void start(Activity activity, long conversationId) {
        Intent intent = new Intent(activity, VEEditLiveOwnerActivity.class);
        intent.putExtra(LIVE_CONVERSATION_SHORT_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected int initMaxEditCount() {
        return 10;
    }

    @Override
    protected void onConfirmClick(String text) {
        super.onConfirmClick(text);
        long uid = -1;
        try {
            uid = Long.parseLong(text);
        } catch (Exception e) {

        }

        BIMClient.getInstance().getService(BIMLiveExpandService.class).transLiveGroupOwner(conversationId, uid, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Toast.makeText(VEEditLiveOwnerActivity.this, "转让群主成功", Toast.LENGTH_SHORT).show();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (code == BIMErrorCode.BIM_SERVER_SET_OWNER_PARTICIPANT_IS_BLOCK) {
                    Toast.makeText(VEEditLiveOwnerActivity.this, "黑名单用户无法转让", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(VEEditLiveOwnerActivity.this, "转让群主失败", Toast.LENGTH_SHORT).show();
                }
                finish();
            }
        });

    }
}
