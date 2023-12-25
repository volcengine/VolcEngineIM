package com.bytedance.im.app.detail.manager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.detail.member.VEMemberSelectListActivity;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public class VEGroupManagerConfigActivity extends VEMemberSelectListActivity {
    private String conversationId;
    private ProgressDialog waitAddDialog;
    private ProgressDialog waitRemoveDialog;
    private List<Long> oldManagerUidList;    //修改前管理员列表
    CountDownLatch countDownLatch = null;
    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEGroupManagerConfigActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected List<MemberWrapper> onInitCheckList(List<MemberWrapper> list) {
        List<MemberWrapper> checkedList = new ArrayList<>();
        for (MemberWrapper member : list) {
            if (member.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                checkedList.add(member);
                oldManagerUidList.add(member.getMember().getUserID());
            }
        }
        return checkedList;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        TextView textView = findViewById(R.id.tv_title);
        textView.setText("设置管理员");
        oldManagerUidList = new ArrayList<>();
    }

    @Override
    protected void onConfirmClick(List<MemberWrapper> selectList) {
        if (selectList == null ) {
            finish();
            return;
        }
        List<Long> selectUidList = new ArrayList<>();
        for (MemberWrapper wrapper : selectList) {
            selectUidList.add(wrapper.getMember().getUserID());
        }

        //添加管理员
        List<Long> addList = new ArrayList<>();
        for (long uid : selectUidList) {
            if (!oldManagerUidList.contains(uid)) {
                addList.add(uid);
            }
        }
        //移出管理员
        List<Long> removeList = new ArrayList<>();
        for (long uid : oldManagerUidList) {
            if (!selectUidList.contains(uid)) {
                removeList.add(uid);
            }
        }

        if (!addList.isEmpty()) {
            waitAddDialog = ProgressDialog.show(VEGroupManagerConfigActivity.this, "设置中,稍等...", "");
            BIMUIClient.getInstance().setGroupMemberRole(conversationId, addList, BIMMemberRole.BIM_MEMBER_ROLE_ADMIN, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    sendAddManagerMessage(addList);
                    waitAddDialog.dismiss();
                    Toast.makeText(VEGroupManagerConfigActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                    checkEnd();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    waitAddDialog.dismiss();
                    Toast.makeText(VEGroupManagerConfigActivity.this, "添加失败", Toast.LENGTH_SHORT).show();
                    checkEnd();
                }
            });
        }

        if (!removeList.isEmpty()) {
            waitRemoveDialog = ProgressDialog.show(VEGroupManagerConfigActivity.this, "设置中,稍等...", "");
            BIMUIClient.getInstance().setGroupMemberRole(conversationId, removeList, BIMMemberRole.BIM_MEMBER_ROLE_NORMAL, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    sendRemoveManagerMessage(removeList);
                    waitRemoveDialog.dismiss();
                    Toast.makeText(VEGroupManagerConfigActivity.this, "移出成功", Toast.LENGTH_SHORT).show();
                    checkEnd();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    waitRemoveDialog.dismiss();
                    Toast.makeText(VEGroupManagerConfigActivity.this, "移出失败", Toast.LENGTH_SHORT).show();
                    checkEnd();
                }
            });
        }
    }



    private void checkEnd(){
        if ((waitAddDialog == null || !waitAddDialog.isShowing())   //添加管理员完成
                && (waitRemoveDialog == null || !waitRemoveDialog.isShowing())) {   //移出管理员完成
            finish();
        }
    }


    private void sendAddManagerMessage(List<Long> addIdList) {
        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfoList(addIdList, new BIMResultCallback<List<BIMUserFullInfo>>() {
            @Override
            public void onSuccess(List<BIMUserFullInfo> userFullInfos) {
                String text = VENameUtils.buildNickNameList(userFullInfos) + " 成为管理员 ";
                BIMGroupNotifyElement content = new BIMGroupNotifyElement();
                content.setText(text);
                BIMMessage addManagerMessage = BIMUIClient.getInstance().createCustomMessage(content);
                BIMUIClient.getInstance().sendMessage(addManagerMessage, conversationId, null);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });


    }

    private void sendRemoveManagerMessage(List<Long> removeIdList) {
        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfoList(removeIdList, new BIMResultCallback<List<BIMUserFullInfo>>() {
            @Override
            public void onSuccess(List<BIMUserFullInfo> userFullInfos) {
                String text = VENameUtils.buildNickNameList(userFullInfos) + " 被取消管理员 ";
                BIMGroupNotifyElement content = new BIMGroupNotifyElement();
                content.setText(text);
                BIMMessage removeManagerMessage = BIMUIClient.getInstance().createCustomMessage(content);
                BIMUIClient.getInstance().sendMessage(removeManagerMessage, conversationId, null);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });

    }
}
