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
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.manager.VEGroupManagerConfigActivity;
import com.bytedance.im.app.detail.member.VEMemberAddActivity;
import com.bytedance.im.app.detail.member.VEMemberUtils;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.main.edit.VEUserProfileEditActivity;
import com.bytedance.im.app.search.VESearchResultActivity;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.core.api.BIMClient;
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
import com.bytedance.im.app.detail.member.VEGroupMemberRemoveActivity;
import com.bytedance.im.app.detail.member.VEMemberListActivity;
import com.bytedance.im.app.detail.member.adapter.VEMemberHozionAdapter;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.List;

public class VEDetailGroupConversationActivity extends Activity {
    private static final String TAG = "VEDetailGroupActivity";
    private static final String CONVERSATION_ID = "conversation_id";
    public static final String IS_DELETE_LOCAL = "is_delete_local";
    private String conversationId;
    private RecyclerView recyclerView;
    private VEMemberHozionAdapter adapter;
    private List<MemberWrapper> allMemberList;
    private View optionNameLayout;
    private View optionNoticeLayout;
    private View optionManager;
    private View optionDissolveGroup;
    private View optionQuitGroup;
    private ImageView noticeArrow;
    private ImageView nameArrow;

    private TextView tvGroupName;
    private TextView tvNotice;
    private MemberWrapper curMember;//当前用户
    private ProgressDialog waitDialog;
    private BIMConversation bimConversation;
    private FrameLayout flSearch;

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
        flSearch = findViewById(R.id.fl_search_msg);
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapter = new VEMemberHozionAdapter(this, new VEMemberHozionAdapter.OnClickListener() {
            @Override
            public void onAddClick() {
                VEMemberAddActivity.start(VEDetailGroupConversationActivity.this, conversationId);
            }

            @Override
            public void onDeleteClick() {
                VEGroupMemberRemoveActivity.start(VEDetailGroupConversationActivity.this, conversationId);
            }

            @Override
            public void onMemberClick(BIMMember member) {
                VEUserProfileEditActivity.start(VEDetailGroupConversationActivity.this, member.getUserID(), member.getAlias(), member.getAvatarUrl());
            }
        });
        recyclerView.setAdapter(adapter);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> VEMemberListActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionNameLayout.setOnClickListener(v -> VEEditGroupNameActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionNoticeLayout.setOnClickListener(v -> VEEditGroupNoticeActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionManager.setOnClickListener(v -> VEGroupManagerConfigActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        flSearch.setOnClickListener(v-> VESearchResultActivity.start(VEDetailGroupConversationActivity.this, conversationId));
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

        VEMemberUtils.getGroupMemberList(conversationId, new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> wrapperList) {
                Log.i(TAG, "refreshUserListView() members.size(): " + wrapperList.size());
                allMemberList = wrapperList;
                if (wrapperList != null && !wrapperList.isEmpty()) {
                    for (MemberWrapper wrapper : wrapperList) {
                        if (wrapper.getMember().getUserID() == BIMUIClient.getInstance().getCurUserId()) {
                            curMember = wrapper;
                            break;
                        }
                    }
                }
                boolean isShowAdd = curMember != null && (curMember.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
                boolean isShowRemove = curMember != null && (curMember.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || curMember.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN);
                adapter.updateUserInfoList(wrapperList, isShowAdd, isShowRemove);
                if (curMember != null) {
                    if (curMember.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
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

    private void quitGroup() {
        if (!checkConversationValid(bimConversation)) {
            return;
        }

        waitDialog = ProgressDialog.show(VEDetailGroupConversationActivity.this, "退出中,稍等...", "");

        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfo(BIMClient.getInstance().getCurrentUserID(), new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo fullInfo) {
                String text = VENameUtils.getShowNickName(fullInfo) + " 退出群组 ";
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

            @Override
            public void onFailed(BIMErrorCode code) {

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
