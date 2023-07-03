package com.bytedance.im.app.live.detail;

import android.app.Activity;
import android.app.Fragment;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.app.detail.VEDetailController;
import com.bytedance.im.app.detail.member.adapter.VEMemberHozionAdapter;
import com.bytedance.im.app.live.create.VEEditCommonActivity;
import com.bytedance.im.app.live.edit.VEEditLiveDesActivity;
import com.bytedance.im.app.live.edit.VEEditLiveNameActivity;
import com.bytedance.im.app.live.edit.VEEditLiveNoticeActivity;
import com.bytedance.im.app.live.edit.VEEditLiveOwnerActivity;
import com.bytedance.im.app.live.edit.VEEditLivePortraitActivity;
import com.bytedance.im.app.live.member.VELiveMemberBlockListActivity;
import com.bytedance.im.app.live.member.VELiveMemberListActivity;
import com.bytedance.im.app.live.member.VELiveMemberMasterListActivity;
import com.bytedance.im.app.live.member.VELiveMemberRemoveActivity;
import com.bytedance.im.app.live.member.VELiveMemberSilentListActivity;
import com.bytedance.im.app.live.member.VELiveMemberSilentWhiteListActivity;
import com.bytedance.im.app.live.member.VELiveOnLineQueryActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.user.UserManager;

import java.util.ArrayList;
import java.util.List;

public class VELiveDetailActivity extends Activity {

    private static final String TAG = "VEDetailLive";
    public static final String CONVERSATION_SHORT_ID = "conversation_id";
    public static final String IS_DELETE_LOCAL = "is_delete_local";
    private static final int REQUEST_CODE_NICKNAME = 0;
    private long conversationShortId;
    private RecyclerView recyclerView;
    private VEMemberHozionAdapter adapter;
    private View optionNameLayout;
    private View optionIconLayout;
    private View optionDesLayout;
    private View optionNoticeLayout;
    private View optionMyNickNamLayout;
    private View optionSilentLayout;
    private View optionOwnerManagerLayout;
    private View optionMasterManagerLayout;
    private View optionSilentBlockLayout;
    private View optionSilentWhiteLayout;
    private View optionBlockLayout;
    private View optionDissolveGroup;
    private View optionQuitGroup;
    private View optionOnlineInfoLayout;
    private Switch silentSwitch;
    private long ownerId;

    private TextView tvOnlineCount;
    private TextView tvGroupName;
    private ImageView tvIcon;
    private TextView tvNotice;
    private TextView tvDes;
    private TextView tvNickName;
    private BIMMember curMember;//当前用户
    private ProgressDialog waitDialog;
    private BIMConversation bimConversation;


    public static void startForResult(Fragment fragment, long cid, int requestCode) {
        Intent intent = new Intent(fragment.getActivity(), VELiveDetailActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, cid);
        fragment.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1);
        BIMLog.i(TAG, "conversationShortId: " + conversationShortId);
        if (conversationShortId == -1) {
            Toast.makeText(this, "会话非法", Toast.LENGTH_SHORT).show();
            finish();
        }
        setContentView(R.layout.ve_im_activity_detail_live_group_chat);
        TextView title = findViewById(R.id.message_list_title);
        title.setText("直播群详情");
        optionOnlineInfoLayout = findViewById(R.id.cl_conversation_online_info);
        optionNameLayout = findViewById(R.id.cl_conversation_name);
        optionIconLayout = findViewById(R.id.cl_conversation_icon);
        optionNoticeLayout = findViewById(R.id.cl_conversation_notice);
        optionDesLayout = findViewById(R.id.cl_conversation_desc);
        optionMyNickNamLayout = findViewById(R.id.cl_conversation_my_nick_name);
        recyclerView = findViewById(R.id.recycler_view_member);
        tvOnlineCount = findViewById(R.id.online_count);
        tvGroupName = findViewById(R.id.tv_conversation_group_name);
        tvIcon = findViewById(R.id.tv_conversation_group_icon);
        tvNotice = findViewById(R.id.tv_conversation_group_notice);
        tvDes = findViewById(R.id.tv_conversation_group_desc);
        tvNickName = findViewById(R.id.tv_conversation_my_nick_name);
        optionOwnerManagerLayout = findViewById(R.id.cl_conversation_owner_manage);
        optionMasterManagerLayout = findViewById(R.id.cl_conversation_master_config);
        optionSilentLayout = findViewById(R.id.cl_conversation_silent_layout);
        optionSilentBlockLayout = findViewById(R.id.cl_conversation_silent_bl);
        optionSilentWhiteLayout = findViewById(R.id.cl_conversation_silent_wl);
        optionBlockLayout = findViewById(R.id.cl_conversation_block_bl);
        optionDissolveGroup = findViewById(R.id.fl_dissolve_group);
        optionQuitGroup = findViewById(R.id.fl_quit_group);
        silentSwitch = findViewById(R.id.switch_silent);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> VELiveMemberListActivity.start(this, conversationShortId));
        optionOnlineInfoLayout.setOnClickListener(v -> VELiveOnLineQueryActivity.start(this, conversationShortId));
        optionNameLayout.setOnClickListener(v -> VEEditLiveNameActivity.start(this, conversationShortId));
        optionIconLayout.setOnClickListener(v -> VEEditLivePortraitActivity.start(this, conversationShortId));
        optionDesLayout.setOnClickListener(v -> VEEditLiveDesActivity.start(this, conversationShortId));
        optionNoticeLayout.setOnClickListener(v -> VEEditLiveNoticeActivity.start(this, conversationShortId));
        optionMyNickNamLayout.setOnClickListener(v -> VEEditCommonActivity.startForResult(this, "我的群昵称", tvNickName.getText().toString(), 10, REQUEST_CODE_NICKNAME));
        silentSwitch.setOnCheckedChangeListener((buttonView, isChecked) -> switchSilent(buttonView, isChecked));
        optionSilentBlockLayout.setOnClickListener(v -> VELiveMemberSilentListActivity.start(this, conversationShortId));
        optionSilentWhiteLayout.setOnClickListener(v -> VELiveMemberSilentWhiteListActivity.start(this, conversationShortId));
        optionBlockLayout.setOnClickListener(v -> VELiveMemberBlockListActivity.start(this, conversationShortId));
        optionOwnerManagerLayout.setOnClickListener(v -> VEEditLiveOwnerActivity.start(this, conversationShortId));
        optionMasterManagerLayout.setOnClickListener(v -> {
            VELiveMemberMasterListActivity.start(this, conversationShortId);

        });
        optionDissolveGroup.setOnClickListener(v -> dissolveGroup());
        optionQuitGroup.setOnClickListener(v -> quitGroup());
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapter = new VEMemberHozionAdapter(this, new VEMemberHozionAdapter.OnClickListener() {
            @Override
            public void onAddClick() {

            }

            @Override
            public void onDeleteClick() {
                VELiveMemberRemoveActivity.start(VELiveDetailActivity.this, conversationShortId);
            }

            @Override
            public void onMemberClick(BIMMember member) {
                Toast.makeText(VELiveDetailActivity.this, "敬请期待", Toast.LENGTH_SHORT).show();
            }
        });
        recyclerView.setAdapter(adapter);
        tvNickName.setText(VEIMApplication.accountProvider.getUserProvider().getUserInfo(BIMClient.getInstance().getCurrentUserID()).getNickName());
    }

    @Override
    protected void onResume() {
        super.onResume();
        refreshDetailView();
    }

    private void updateConvSilentWLUI(boolean isSilent) {
        if (isSilent) {
            optionSilentWhiteLayout.setVisibility(View.VISIBLE);
        } else {
            optionSilentWhiteLayout.setVisibility(View.GONE);
        }
    }

    private void refreshDetailView() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroup(conversationShortId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                BIMMember curMember = conversation.getCurrentMember();
                bimConversation = conversation;
                String name = VEDetailController.getGroupName(conversation);
                String notice = VEDetailController.getNotice(conversation);
                String des = VEDetailController.getDescription(conversation);
                String url = conversation.getPortraitURL();
                boolean isConvSilent = conversation.getBlockStatus() == BIMBlockStatus.BIM_BLOCK_STATUS_BLOCK;
                tvGroupName.setText(name);
                tvNotice.setText(notice);
                tvDes.setText(des);
                Glide.with(tvIcon.getContext()).load(url).into(tvIcon);
                ownerId = bimConversation.getOwnerId();
                tvOnlineCount.setText(bimConversation.getOnLineMemberCount() + " 人");
                silentSwitch.setChecked(isConvSilent);
                updateConvSilentWLUI(isConvSilent);
                if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL || curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_VISITOR) {
                    optionSilentBlockLayout.setVisibility(View.GONE);
                    optionBlockLayout.setVisibility(View.GONE);
                    optionOwnerManagerLayout.setVisibility(View.GONE);
                    optionMasterManagerLayout.setVisibility(View.GONE);
                    optionDissolveGroup.setVisibility(View.GONE);
                    silentSwitch.setEnabled(false);
                } else if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                    silentSwitch.setEnabled(true);
                    optionSilentBlockLayout.setVisibility(View.VISIBLE);
                    optionBlockLayout.setVisibility(View.VISIBLE);
                    optionOwnerManagerLayout.setVisibility(View.GONE);
                    optionMasterManagerLayout.setVisibility(View.GONE);
                    optionDissolveGroup.setVisibility(View.GONE);
                } else if (curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                    silentSwitch.setEnabled(true);
                    optionSilentBlockLayout.setVisibility(View.VISIBLE);
                    optionBlockLayout.setVisibility(View.VISIBLE);
                    optionOwnerManagerLayout.setVisibility(View.VISIBLE);
                    optionMasterManagerLayout.setVisibility(View.VISIBLE);
                    optionDissolveGroup.setVisibility(View.VISIBLE);
                    optionOwnerManagerLayout.setVisibility(View.VISIBLE);
                }

                boolean isShowRemove = curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER || curMember.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN;
                BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberOnlineList(conversationShortId, -1, 5, new BIMResultCallback<BIMLiveMemberListResult>() {
                    @Override
                    public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                        List<BIMMember> members = resultMemberList.getMemberList();
                        adapter.updateUserInfoList(members, false, isShowRemove);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Log.i(TAG, "onFailed() code: " + code);
                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VELiveDetailActivity.this, "会话不存在", Toast.LENGTH_SHORT).show();
                finish();
            }
        });
        adapter.updateUserInfoList(new ArrayList<>(), false, true);
    }

    private void quitGroup() {
        waitDialog = ProgressDialog.show(VELiveDetailActivity.this, "退出中,稍等...", "");
        waitDialog.show();
        String text = UserManager.geInstance().getUserName(BIMUIClient.getInstance().getCurUserId()) + " 退出群组 ";
        BIMGroupNotifyElement content = new BIMGroupNotifyElement();
        content.setText(text);
        BIMClient.getInstance().getService(BIMLiveExpandService.class).leaveLiveGroup(conversationShortId, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                Intent data = new Intent();
                data.putExtra(IS_DELETE_LOCAL, true);
                setResult(RESULT_OK, data);
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                Toast.makeText(VELiveDetailActivity.this, "退出群聊失败: " + code, Toast.LENGTH_SHORT).show();
            }
        });

    }

    private void dissolveGroup() {
        waitDialog = ProgressDialog.show(VELiveDetailActivity.this, "解散中,稍等...", "");
        //发送成功后,执行解散
        BIMClient.getInstance().getService(BIMLiveExpandService.class).dissolveLiveGroup(conversationShortId, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                waitDialog.dismiss();
                setResultDelete();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                waitDialog.dismiss();
                Toast.makeText(VELiveDetailActivity.this, "解散群聊失败: " + code, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void switchSilent(CompoundButton buttonView, boolean isChecked) {
        if (!buttonView.isPressed()) {
            return;
        }
        BIMClient.getInstance().getService(BIMLiveExpandService.class).setLiveGroupSilent(conversationShortId, isChecked, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Toast.makeText(VELiveDetailActivity.this, "会话禁言成功", Toast.LENGTH_SHORT).show();
                updateConvSilentWLUI(isChecked);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VELiveDetailActivity.this, "会话禁言失败: " + code, Toast.LENGTH_SHORT).show();
                buttonView.setChecked(!isChecked);
            }
        });
    }

    private void setResultDelete() {
        Intent data = new Intent();
        data.putExtra(IS_DELETE_LOCAL, true);
        setResult(RESULT_OK, data);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_NICKNAME) {
            String myNickName = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
            tvNickName.setText(myNickName);
        }
    }
}
