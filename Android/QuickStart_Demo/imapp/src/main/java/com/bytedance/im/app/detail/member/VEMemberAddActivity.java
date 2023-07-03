package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.user.VEUserAddActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.user.UserManager;


import java.util.List;

public class VEMemberAddActivity extends VEUserAddActivity {
    private static final String CONVERSATION_ID = "conversation_id";
    private String conversationId;
    private ProgressDialog waitDialog;
    private List<BIMMember> mMemberList;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        BIMUIClient.getInstance().getGroupMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> memberList) {
                mMemberList = memberList;
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
        TextView title = findViewById(R.id.tv_title);
        title.setText("添加成员");
    }

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEMemberAddActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onConfirmClick(List<Long> uidList) {
        if (uidList == null || uidList.size() == 0) {
            Toast.makeText(this, "请添加群成员", Toast.LENGTH_SHORT).show();
            return;
        }
        if (!TextUtils.isEmpty(conversationId)) {
            waitDialog = ProgressDialog.show(VEMemberAddActivity.this, "添加成员中,稍等...", "");
            BIMUIClient.getInstance().addGroupMemberList(conversationId, uidList, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    waitDialog.dismiss();
                    sendAddMemberMessage(uidList);
                    Toast.makeText(VEMemberAddActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                    finish();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    waitDialog.dismiss();
                    if (code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT) {
                        Toast.makeText(VEMemberAddActivity.this, "加群个数超过上限", Toast.LENGTH_SHORT).show();
                    } else if(code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_CONVERSATION_MEMBER_TOUCH_LIMIT){
                        Toast.makeText(VEMemberAddActivity.this, "群成员已达上限", Toast.LENGTH_SHORT).show();
                    }else {
                        Toast.makeText(VEMemberAddActivity.this, "添加失败 code: " + code, Toast.LENGTH_SHORT).show();
                    }
                }
            });
        } else {
            finish();
        }
    }

    @Override
    protected boolean checkMemberExist(BIMUser user) {
        if (mMemberList != null) {
            for (BIMMember member : mMemberList) {
                if (member.getUserID() == user.getUserID()) {
                    if (member.getUserID() == BIMUIClient.getInstance().getCurUserId()) {
                        Toast.makeText(VEMemberAddActivity.this, "您已在群聊中", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(VEMemberAddActivity.this, "用户已在群", Toast.LENGTH_SHORT).show();
                    }
                    return true;
                }
            }
        }
        return super.checkMemberExist(user);
    }

    private void sendAddMemberMessage(List<Long> addIdList) {
        String text = UserManager.geInstance().getUserName(BIMUIClient.getInstance().getCurUserId())
                + " 邀请 "
                + UserManager.geInstance().builderNamelist(addIdList) +" 加入群聊";
        BIMGroupNotifyElement content = new BIMGroupNotifyElement();
        content.setText(text);
        BIMMessage addMemberMessage = BIMUIClient.getInstance().createCustomMessage(content);
        BIMUIClient.getInstance().sendMessage(addMemberMessage, conversationId, null);
    }
}
