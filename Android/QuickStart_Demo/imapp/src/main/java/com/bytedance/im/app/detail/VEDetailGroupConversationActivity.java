package com.bytedance.im.app.detail;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.manager.VEGroupManagerConfigActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.app.detail.edit.VEEditGroupNameActivity;
import com.bytedance.im.app.detail.edit.VEEditGroupNoticeActivity;
import com.bytedance.im.app.detail.member.VEGroupMemberAddActivity;
import com.bytedance.im.app.detail.member.VEGroupMemberRemoveActivity;
import com.bytedance.im.app.detail.member.VEMemberListActivity;
import com.bytedance.im.app.detail.member.adapter.VEMemberHozionAdapter;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.user.UserManager;

import java.util.ArrayList;
import java.util.List;

public class VEDetailGroupConversationActivity extends Activity {
    private static final String TAG = "VEDetailGroupConversationActivity";
    private static final String CONVERSATION_ID = "conversation_id";
    public static final String IS_DELETE_LOCAL = "is_delete_local";
    private String conversationId;
    private RecyclerView recyclerView;
    private VEMemberHozionAdapter adapter;
    private List<BIMMember> allMemberList;
    private View optionNameLayout;
    private View optionNoticeLayout;
    private View optionManager;
    private View optionDissolveGroup;
    private View optionQuitGroup;
    private ImageView noticeArrow;
    private ImageView nameArrow;

    private TextView tvGroupName;
    private TextView tvNotice;
    private BIMMember curMember;//当前用户
    private ProgressDialog waitDialog;
    private BIMConversation bimConversation;

    public static void startForResult(Activity activity, String cid, int requestCode) {
        Intent intent = new Intent(activity, VEDetailGroupConversationActivity.class);
        intent.putExtra(CONVERSATION_ID, cid);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        if (TextUtils.isEmpty(conversationId)) {
            Toast.makeText(this, "会话非法", Toast.LENGTH_SHORT).show();
            finish();
        }
        setContentView(R.layout.ve_im_activity_detail_group_chat);
        optionNameLayout = findViewById(R.id.cl_conversation_name);
        optionNoticeLayout = findViewById(R.id.cl_conversation_notice);
        recyclerView = findViewById(R.id.recycler_view_member);
        tvGroupName = findViewById(R.id.tv_conversation_group_name);
        tvNotice = findViewById(R.id.tv_conversation_group_notice_null);
        optionManager = findViewById(R.id.cl_conversation_owner_manage);
        optionDissolveGroup = findViewById(R.id.fl_dissolve_group);
        optionQuitGroup = findViewById(R.id.fl_quit_group);
        noticeArrow = findViewById(R.id.iv_conversation_notice);
        nameArrow = findViewById(R.id.iv_conversation_name);
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapter = new VEMemberHozionAdapter(this, new VEMemberHozionAdapter.OnClickListener() {
            @Override
            public void onAddClick() {
                VEGroupMemberAddActivity.start(VEDetailGroupConversationActivity.this, conversationId, getCurAllMemberIdList());
            }

            @Override
            public void onDeleteClick() {
                VEGroupMemberRemoveActivity.start(VEDetailGroupConversationActivity.this, conversationId);
            }

            @Override
            public void onMemberClick(BIMMember member) {
                Toast.makeText(VEDetailGroupConversationActivity.this, "敬请期待", Toast.LENGTH_SHORT).show();
            }
        });
        recyclerView.setAdapter(adapter);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> VEMemberListActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionNameLayout.setOnClickListener(v -> VEEditGroupNameActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionNoticeLayout.setOnClickListener(v -> VEEditGroupNoticeActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionManager.setOnClickListener(v -> VEGroupManagerConfigActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionDissolveGroup.setOnClickListener(v -> dissolveGroup());
        optionQuitGroup.setOnClickListener(v -> quitGroup());
        BIMUIClient.getInstance().addConversationListener(conversationListener);
    }

    private BIMConversationListListener conversationListener = new BIMConversationListListener() {
        @Override
        public void onNewConversation(List<BIMConversation> conversationList) {

        }

        @Override
        public void onConversationChanged(List<BIMConversation> conversationList) {
            if (conversationList == null || conversationList.isEmpty()) return;
            for (BIMConversation conversation : conversationList) {
                if (conversation.getConversationID().equals(conversationId)) {
                    bimConversation = conversation;
                }
            }
        }

        @Override
        public void onConversationDelete(List<BIMConversation> conversationList) {

        }

        @Override
        public void onTotalUnreadMessageCountChanged(int totalUnreadCount) {

        }
    };

    @Override
    protected void onResume() {
        super.onResume();
        refreshDetailView();
    }

    @Override
    protected void onStop() {
        super.onStop();
        BIMUIClient.getInstance().removeConversationListener(conversationListener);
    }

    private void refreshDetailView() {
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                if (!checkConversationValid(conversation)) {
                    finish();
                }
                Switch topSwitch = findViewById(R.id.switch_top);
                Switch muteSwitch = findViewById(R.id.switch_mute);
                VEDetailController.initStickSwitch(topSwitch, conversation, VEDetailGroupConversationActivity.this);
                VEDetailController.initMuteSwitch(muteSwitch, conversation, VEDetailGroupConversationActivity.this);
                String name = VEDetailController.getGroupName(conversation);
                String notice = VEDetailController.getNotice(conversation);
                tvGroupName.setText(name);
                tvNotice.setText(notice);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEDetailGroupConversationActivity.this, "会话不存在", Toast.LENGTH_SHORT).show();
                finish();
            }
        });
        BIMUIClient.getInstance().getGroupMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> members) {
                Log.i(TAG, "refreshUserListView() members.size(): " + members.size());
                allMemberList = members;
                if (members != null && !members.isEmpty()) {
                    for (BIMMember member : members) {
                        if (member.getUserID() == BIMUIClient.getInstance().getCurUserId()) {
                            curMember = member;
                            break;
                        }
                    }
                }
                boolean isShowAdd = curMember != null && (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
                boolean isShowRemove = curMember != null && (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN);
                adapter.updateUserInfoList(members, isShowAdd, isShowRemove);
                if (curMember != null) {
                    if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                        optionDissolveGroup.setVisibility(View.VISIBLE);
                        optionManager.setVisibility(View.VISIBLE);
                    } else {
                        optionDissolveGroup.setVisibility(View.GONE);
                        optionManager.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "onFailed() code: " + code);
            }
        });
    }

    public ArrayList<Integer> getCurAllMemberIdList() {
        ArrayList<Integer> r = new ArrayList<>();
        if (allMemberList == null) {
            return r;
        }
        for (BIMMember member : allMemberList) {
            r.add((int) member.getUserID());
        }
        return r;
    }


    private void quitGroup() {
        if (!checkConversationValid(bimConversation)) {
            return;
        }
        waitDialog = ProgressDialog.show(VEDetailGroupConversationActivity.this, "退出中,稍等...", "");
        String text = UserManager.geInstance().getUserName(BIMUIClient.getInstance().getCurUserId()) + " 退出群组 ";
        BIMGroupNotifyElement content = new BIMGroupNotifyElement();
        content.setText(text);
        BIMMessage  leaveMessage = BIMUIClient.getInstance().createCustomMessage(content);
        BIMUIClient.getInstance().sendMessage(leaveMessage, conversationId, new BIMSendCallback() {
            @Override
            public void onProgress(BIMMessage message, int progress) {

            }

            @Override
            public void onSaved(BIMMessage bimMessage) {

            }

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                //发送成功后，执行退出
                BIMUIClient.getInstance().leaveGroup(conversationId, false, new BIMSimpleCallback() {
                    @Override
                    public void onSuccess() {
                        List<Long> mySelf = new ArrayList<>();
                        mySelf.add(BIMUIClient.getInstance().getCurUserId());
                        waitDialog.dismiss();
                        setResultDelete();
                        finish();
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        waitDialog.dismiss();
                        finish();
                    }
                });
            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                waitDialog.dismiss();
            }
        });

    }

    private void dissolveGroup() {
        if (!checkConversationValid(bimConversation)) {
            return;
        }
        waitDialog = ProgressDialog.show(VEDetailGroupConversationActivity.this, "解散中,稍等...", "");
        String text = " 群聊被解散 ";
        BIMGroupNotifyElement content = new BIMGroupNotifyElement();
        content.setText(text);
        BIMMessage dissolveMessage = BIMUIClient.getInstance().createCustomMessage(content);
        BIMUIClient.getInstance().sendMessage(dissolveMessage, conversationId, new BIMSendCallback() {

            @Override
            public void onProgress(BIMMessage message, int progress) {

            }

            @Override
            public void onSaved(BIMMessage bimMessage) {

            }

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                //发送成功后,执行解散
                BIMUIClient.getInstance().dissolveGroup(conversationId, true, new BIMSimpleCallback() {
                    @Override
                    public void onSuccess() {
                        waitDialog.dismiss();
                        setResultDelete();
                        finish();
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        waitDialog.dismiss();
                        finish();
                    }
                });
            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                waitDialog.dismiss();
            }
        });

    }
    private boolean checkConversationValid(BIMConversation conversation){
        if (conversation.isDissolved()) {
            Toast.makeText(VEDetailGroupConversationActivity.this, "群聊已解散", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (!conversation.isMember()) {
            Toast.makeText(VEDetailGroupConversationActivity.this, "已退出群聊", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    private void setResultDelete(){
        Intent data = new Intent();
        data.putExtra(IS_DELETE_LOCAL,true);
        setResult(RESULT_OK,data);
    }

}
