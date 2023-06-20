package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMessage;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class VEGroupMemberRemoveActivity extends VEMemberSelectListActivity {
    private static final String CONVERSATION_ID = "conversation_id";
    private String conversationId;
    private ProgressDialog waitDialog;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        TextView title = findViewById(R.id.tv_title);
        title.setText("移出群成员");
    }

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEGroupMemberRemoveActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected List<BIMMember> filter(List<BIMMember> members) {
        Iterator<BIMMember> iterator = members.iterator();
        while (iterator.hasNext()) {
            BIMMember member = iterator.next();
            if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || member.getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                iterator.remove();
            }
        }
        return members;
    }

    @Override
    protected void onConfirmClick(List<BIMMember> selectList) {
        super.onConfirmClick(selectList);
        if (selectList != null && selectList.size() > 0 && !TextUtils.isEmpty(conversationId)) {
            List<Long> uidList = new ArrayList<>();
            for (BIMMember member : selectList) {
                if (selfMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN && member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                    //管理员不可以移出管理员
                    Toast.makeText(VEGroupMemberRemoveActivity.this, "移出失败", Toast.LENGTH_SHORT).show();
                    return;
                }
                uidList.add(member.getUserID());
            }

            waitDialog = ProgressDialog.show(VEGroupMemberRemoveActivity.this, "移出成员中,稍等...", "");
            String text = UserManager.geInstance().builderNamelist(uidList) + " 退出群聊 ";
            BIMGroupNotifyElement content = new BIMGroupNotifyElement();
            content.setText(text);
            BIMMessage removeMessage = BIMUIClient.getInstance().createCustomMessage(content);
            BIMUIClient.getInstance().sendMessage(removeMessage, conversationId, new BIMSendCallback() {
                @Override
                public void onProgress(BIMMessage message, int progress) {

                }

                @Override
                public void onSaved(BIMMessage bimMessage) {

                }

                @Override
                public void onSuccess(BIMMessage bimMessage) {
                    BIMUIClient.getInstance().removeGroupMemberList(conversationId, uidList, new BIMSimpleCallback() {
                        @Override
                        public void onSuccess() {
                            waitDialog.dismiss();
                            Toast.makeText(VEGroupMemberRemoveActivity.this, "移出成功", Toast.LENGTH_SHORT).show();
                            finish();
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            waitDialog.dismiss();
                            Toast.makeText(VEGroupMemberRemoveActivity.this, "移出失败", Toast.LENGTH_SHORT).show();
                            finish();
                        }
                    });
                }

                @Override
                public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                    waitDialog.dismiss();
                    finish();
                }
            });
        } else {
            finish();
        }
    }
}
