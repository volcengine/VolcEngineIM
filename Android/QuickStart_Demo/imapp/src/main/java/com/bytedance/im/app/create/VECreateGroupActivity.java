package com.bytedance.im.app.create;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

import com.bytedance.im.app.message.VEMessageListActivity;
import com.bytedance.im.app.user.VEUserAddActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.user.UserManager;

import java.util.List;

public class VECreateGroupActivity extends VEUserAddActivity {
    private static final String TAG = "VECreateGroupActivity";
    private ProgressDialog waitDialog;

    public static void start(Context context) {
        Intent intent = new Intent(context, VECreateGroupActivity.class);
        context.startActivity(intent);
    }


    @Override
    protected void onConfirmClick(List<Long> uidList) {
        if (uidList == null || uidList.isEmpty()) {
            Toast.makeText(this, "请添加群成员", Toast.LENGTH_SHORT).show();
            return;
        }
        createGroupConversationAndStart(uidList);
    }

    private void createGroupConversationAndStart(List<Long> uidList) {
        waitDialog = ProgressDialog.show(this, "创建群组中,稍等...", "");
        BIMGroupInfo groupInfo = new BIMGroupInfo.BIMGroupInfoBuilder().name("未命名群聊").build();
        BIMUIClient.getInstance().createGroupConversation(groupInfo, uidList, new BIMResultCallback<BIMConversation>() {

            @Override
            public void onSuccess(BIMConversation bimConversation) {
                Log.i(TAG, "createGroupConversationAndStart() onSuccess()");
                sendAddMemberMessage(bimConversation, uidList);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "createGroupConversationAndStart() onFailed() code: " + code);
                waitDialog.dismiss();
                if (code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_CONVERSATION_MORE_THAN_LIMIT) {
                    Toast.makeText(VECreateGroupActivity.this, "加群个数超过上限", Toast.LENGTH_SHORT).show();
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_CONVERSATION_MEMBER_TOUCH_LIMIT) {
                    Toast.makeText(VECreateGroupActivity.this, "群成员已达上限", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(VECreateGroupActivity.this, "创建群聊失败 code: " + code, Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void sendAddMemberMessage(BIMConversation conversation, List<Long> uidList) {
        String text = UserManager.geInstance().getUserName(BIMUIClient.getInstance().getCurUserId())
                + " 邀请 "
                + UserManager.geInstance().builderNamelist(uidList) +" 加入群聊";
        BIMGroupNotifyElement content = new BIMGroupNotifyElement();
        content.setText(text);
        BIMMessage createAddMemberMessage = BIMUIClient.getInstance().createCustomMessage(content);
        BIMUIClient.getInstance().sendMessage(createAddMemberMessage, conversation.getConversationID(), new BIMSendCallback() {

            @Override
            public void onProgress(BIMMessage message, int progress) {

            }

            @Override
            public void onSaved(BIMMessage bimMessage) {

            }

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                waitDialog.dismiss();
                VEMessageListActivity.start(VECreateGroupActivity.this, conversation.getConversationID());
                finish();
            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                waitDialog.dismiss();
                finish();
            }
        });
    }
}
