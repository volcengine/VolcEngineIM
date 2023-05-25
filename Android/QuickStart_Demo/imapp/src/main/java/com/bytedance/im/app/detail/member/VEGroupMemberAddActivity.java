package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.app.user.BIMUserSelectActivity;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMessage;

import java.util.ArrayList;
import java.util.List;

public class VEGroupMemberAddActivity extends BIMUserSelectActivity {
    private static final String CONVERSATION_ID = "conversation_id";
    private String conversationId;
    private ProgressDialog waitDialog;

    @Override
    protected boolean onConfirmClick(List<Long> uidList) {
        if (uidList != null && uidList.size() > 0 && !TextUtils.isEmpty(conversationId)) {
            waitDialog = ProgressDialog.show(VEGroupMemberAddActivity.this, "添加成员中,稍等...", "");
            BIMUIClient.getInstance().addGroupMemberList(conversationId, uidList, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    waitDialog.dismiss();
                    sendAddMemberMessage(uidList);
                    Toast.makeText(VEGroupMemberAddActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                    finish();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    waitDialog.dismiss();
                    if (code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT) {
                        Toast.makeText(VEGroupMemberAddActivity.this, "加群个数超过上限", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(VEGroupMemberAddActivity.this, "添加失败 code: " + code, Toast.LENGTH_SHORT).show();
                    }
                    finish();
                }
            });
        } else {
            finish();
        }
        return true;
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        TextView title = findViewById(R.id.tv_title);
        title.setText("添加成员");
    }

    public static void start(Activity activity, String conversationId, ArrayList<Integer> excludeIdList) {
        Intent intent = new Intent(activity, VEGroupMemberAddActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        intent.putIntegerArrayListExtra(EXCLUDE_ID_LIST, excludeIdList);
        activity.startActivity(intent);
    }

    private void sendAddMemberMessage(List<Long> addIdList) {
        String text = UserManager.geInstance().getUserName(BIMUIClient.getInstance().getCurUserId())
                + " 邀请 "
                + UserManager.geInstance().builderNamelist(addIdList);
        BIMGroupNotifyElement content = new BIMGroupNotifyElement();
        content.setText(text);
        BIMMessage addMemberMessage = BIMUIClient.getInstance().createCustomMessage(content);
        BIMUIClient.getInstance().sendMessage(addMemberMessage, conversationId, null);
    }
}
