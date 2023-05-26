package com.bytedance.im.app.create;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.app.message.VEMessageListActivity;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.app.user.BIMUserListActivity;

import java.util.ArrayList;

public class VECreateSingleConversationActivity extends BIMUserListActivity {
    private static final String TAG = "VECreateSingleConversationActivity";

    public static void start(Context context) {
        Intent intent = new Intent(context, VECreateSingleConversationActivity.class);
        ArrayList<Integer> selfId = new ArrayList<>();
        selfId.add((int) BIMUIClient.getInstance().getCurUserId());
        intent.putIntegerArrayListExtra(EXCLUDE_ID_LIST, selfId);
        context.startActivity(intent);
    }

    @Override
    protected void onUserClick(BIMUser user) {
        createSingleConversationAndStart(user.getUserID());
    }

    private void createSingleConversationAndStart(long toUid) {
        BIMUIClient.getInstance().createSingleConversation(toUid, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation bimConversation) {
                VEMessageListActivity.start(VECreateSingleConversationActivity.this, bimConversation.getConversationID());
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VECreateSingleConversationActivity.this, "创建单聊失败 code: " + code, Toast.LENGTH_SHORT).show();

            }
        });
    }
}
