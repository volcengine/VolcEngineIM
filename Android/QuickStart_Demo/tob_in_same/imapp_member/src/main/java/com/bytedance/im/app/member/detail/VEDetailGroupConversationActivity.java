package com.bytedance.im.app.member.detail;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.BuildConfig;
import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.group.VEDetailController;
import com.bytedance.im.app.member.group.VEMemberUtils;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.app.member.group.adapter.VEMemberHozionAdapter;
import com.bytedance.im.app.member.VEDebugConversationDetailActivity;
import com.bytedance.im.app.member.detail.edit.VEEditGroupNameActivity;
import com.bytedance.im.app.member.detail.edit.VEEditGroupNoticeActivity;
import com.bytedance.im.app.member.detail.ext.VEDebugExtActivity;
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
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.starter.ModuleStarter;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class VEDetailGroupConversationActivity extends Activity {
    private static final String TAG = "VEDetailGroupActivity";
    private static final int REQUEST_CODE_ADD_USER = 1000;
    private static final int REQUEST_CODE_REMOVE_USER = 1001;
    private static final int REQUEST_CODE_SET_ADMIN = 1002;

    private String conversationId;
    private RecyclerView recyclerView;
    private VEMemberHozionAdapter adapter;
    private List<MemberWrapper> allMemberList;
    private Map<Long, MemberWrapper> memberMap;
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
    private View customLayout;
    private ArrayList<Long> adminIdList;
    private View queryConv;
    private View btnMore;
    public static void startForResult(Activity activity, String cid, int requestCode) {
        Intent intent = new Intent(activity, VEDetailGroupConversationActivity.class);
        intent.putExtra(ModuleStarter.MODULE_KEY_CID, cid);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
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
        customLayout = findViewById(R.id.fl_custom);

        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapter = new VEMemberHozionAdapter(this, new VEMemberHozionAdapter.OnClickListener() {
            @Override
            public void onAddClick() {
                ArrayList<Long> memberList = new ArrayList<>();
                if (allMemberList != null) {
                    for (MemberWrapper memberWrapper : allMemberList) {
                        memberList.add(memberWrapper.getMember().getUserID());
                    }
                }
                BIMUIClient.getInstance().getModuleStarter().startMemberModuleAddForResult(VEDetailGroupConversationActivity.this, "添加成员", memberList, REQUEST_CODE_ADD_USER);
            }

            @Override
            public void onDeleteClick() {
                BIMUIClient.getInstance().getModuleStarter().startMemberModuleSelect(VEDetailGroupConversationActivity.this, "移除群成员",
                        conversationId, null, null, false, false, REQUEST_CODE_REMOVE_USER);
            }

            @Override
            public void onMemberClick(BIMMember member) {
                BIMUIClient.getInstance().getModuleStarter().startProfileModule(VEDetailGroupConversationActivity.this, member.getUserID(), conversationId);
            }
        });
        recyclerView.setAdapter(adapter);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> BIMUIClient.getInstance().getModuleStarter().startMemberModuleList(VEDetailGroupConversationActivity.this, "群成员列表", conversationId));
        optionNameLayout.setOnClickListener(v -> VEEditGroupNameActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionNoticeLayout.setOnClickListener(v -> VEEditGroupNoticeActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        optionManager.setOnClickListener(v ->
                BIMUIClient.getInstance().getModuleStarter().startMemberModuleSelect(VEDetailGroupConversationActivity.this, "设置管理员",
                        conversationId, null, adminIdList, true, true, REQUEST_CODE_SET_ADMIN));
        flSearch.setOnClickListener(v ->
                BIMUIClient.getInstance().getModuleStarter().startSearchModule(VEDetailGroupConversationActivity.this, conversationId)
        );
        optionDissolveGroup.setOnClickListener(v -> dissolveGroup());
        optionQuitGroup.setOnClickListener(v -> quitGroup());
        customLayout.setOnClickListener(v -> VEDebugExtActivity.start(VEDetailGroupConversationActivity.this, conversationId));
        BIMUIClient.getInstance().addConversationListener(conversationListener);

        queryConv = findViewById(R.id.query_conv);
        queryConv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (bimConversation != null) {
                    VEDebugConversationDetailActivity.start(VEDetailGroupConversationActivity.this, bimConversation.getConversationShortID());
                }
            }
        });
        btnMore = findViewById(R.id.btn_more);
        if (!BIMUIClient.getInstance().getModuleStarter().checkExistInDetailGroupActivity(VEDetailGroupConversationActivity.this)) {
            btnMore.setVisibility(View.GONE);
        }
        btnMore.setOnClickListener(v -> {
            BIMUIClient.getInstance().getModuleStarter().startInDetailGroupActivity(VEDetailGroupConversationActivity.this, conversationId);
        });
        if (BuildConfig.DEBUG) {
            queryConv.setVisibility(View.VISIBLE);
        } else {
            queryConv.setVisibility(View.GONE);
        }
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

        @Override
        public void onConversationRead(String conversationId, long fromUid) {

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
                memberMap = new HashMap<>();
                adminIdList = new ArrayList<>();
                if (wrapperList != null && !wrapperList.isEmpty()) {
                    for (MemberWrapper wrapper : wrapperList) {
                        if (wrapper.getMember().getUserID() == BIMUIClient.getInstance().getCurUserId()) {
                            curMember = wrapper;
                            memberMap.put(wrapper.getMember().getUserID(), wrapper);
                        }
                        if (wrapper.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                            adminIdList.add(wrapper.getMember().getUserID());
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
        BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(BIMClient.getInstance().getCurrentUserID(), new BIMResultCallback<BIMUIUser>() {
            @Override
            public void onSuccess(BIMUIUser user) {
                String text = BIMUINameUtils.getShowNickName(user) + " 退出群组 ";
                BIMGroupNotifyElement content = new BIMGroupNotifyElement();
                content.setText(text);
                BIMMessage leaveMessage = BIMUIClient.getInstance().createCustomMessage(content);
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

    private boolean checkConversationValid(BIMConversation conversation) {
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

    private void setResultDelete() {
        Intent data = new Intent();
        data.putExtra(ModuleStarter.MODULE_IS_DELETE_LOCAL, true);
        setResult(RESULT_OK, data);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == REQUEST_CODE_ADD_USER) {
                ArrayList<Long> uidList = (ArrayList<Long>) data.getSerializableExtra(ModuleStarter.MODULE_KEY_UID_LIST);
                addMember(uidList);
            } else if (requestCode == REQUEST_CODE_REMOVE_USER) {
                ArrayList<Long> uidList = (ArrayList<Long>) data.getSerializableExtra(ModuleStarter.MODULE_KEY_UID_LIST);
                removeMember(uidList);
            } else if (requestCode == REQUEST_CODE_SET_ADMIN) {
                ArrayList<Long> uidList = (ArrayList<Long>) data.getSerializableExtra(ModuleStarter.MODULE_KEY_UID_LIST);
                updateAdminList(uidList);
            }
        }
    }

    private void addMember(ArrayList<Long> uidList) {
        BIMUIClient.getInstance().addGroupMemberList(conversationId, uidList, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                sendAddMemberMessage(uidList);
                Toast.makeText(VEDetailGroupConversationActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                refreshDetailView();
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_MORE_THAN_LIMIT) {
                    Toast.makeText(VEDetailGroupConversationActivity.this, "加群个数超过上限", Toast.LENGTH_SHORT).show();
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_CONVERSATION_MEMBER_TOUCH_LIMIT) {
                    Toast.makeText(VEDetailGroupConversationActivity.this, "群成员已达上限", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(VEDetailGroupConversationActivity.this, "添加失败 code: " + code, Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void removeMember(List<Long> selectList) {
        for (Long uid : selectList) {
            MemberWrapper wrapper = memberMap.get(uid);
            if (curMember.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN && wrapper.getMember().getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                //管理员不可以移出管理员
                Toast.makeText(VEDetailGroupConversationActivity.this, "移出失败", Toast.LENGTH_SHORT).show();
                return;
            }
        }

        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(selectList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                String text = BIMUINameUtils.buildNickNameList(bimuiUsers) + " 退出群聊 ";
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
                        BIMUIClient.getInstance().removeGroupMemberList(conversationId, selectList, new BIMSimpleCallback() {
                            @Override
                            public void onSuccess() {
                                Toast.makeText(VEDetailGroupConversationActivity.this, "移出成功", Toast.LENGTH_SHORT).show();
                                refreshDetailView();
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(VEDetailGroupConversationActivity.this, "移出失败", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }

                    @Override
                    public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                        finish();
                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    private void sendAddMemberMessage(List<Long> addIdList) {
        addIdList.add(BIMClient.getInstance().getCurrentUserID());
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(addIdList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                if (bimuiUsers != null) {
                    BIMUIUser self = null;
                    Iterator<BIMUIUser> iterator = bimuiUsers.iterator();
                    while (iterator.hasNext()) {
                        BIMUIUser user = iterator.next();
                        if (user.getUid() == BIMClient.getInstance().getCurrentUserID()) {
                            self = user;
                            iterator.remove();
                            break;
                        }
                    }
                    String text = BIMUINameUtils.getShowNickName(self)
                            + " 邀请 "
                            + BIMUINameUtils.buildNickNameList(bimuiUsers) + " 加入群聊";
                    BIMGroupNotifyElement content = new BIMGroupNotifyElement();
                    content.setText(text);
                    BIMMessage addMemberMessage = BIMUIClient.getInstance().createCustomMessage(content);
                    BIMUIClient.getInstance().sendMessage(addMemberMessage, conversationId, null);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    protected void updateAdminList(List<Long> selectUidList) {
        if (selectUidList == null) {
            return;
        }
        //添加管理员
        List<Long> addList = new ArrayList<>();
        for (long uid : selectUidList) {
            if (!adminIdList.contains(uid)) {
                addList.add(uid);
            }
        }
        //移出管理员
        List<Long> removeList = new ArrayList<>();
        for (long uid : adminIdList) {
            if (!selectUidList.contains(uid)) {
                removeList.add(uid);
            }
        }

        if (!addList.isEmpty()) {
            BIMUIClient.getInstance().setGroupMemberRole(conversationId, addList, BIMMemberRole.BIM_MEMBER_ROLE_ADMIN, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    sendAddManagerMessage(addList);
                    Toast.makeText(VEDetailGroupConversationActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                    refreshDetailView();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VEDetailGroupConversationActivity.this, "添加失败", Toast.LENGTH_SHORT).show();
                }
            });
        }

        if (!removeList.isEmpty()) {
            BIMUIClient.getInstance().setGroupMemberRole(conversationId, removeList, BIMMemberRole.BIM_MEMBER_ROLE_NORMAL, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    sendRemoveManagerMessage(removeList);
                    Toast.makeText(VEDetailGroupConversationActivity.this, "移出成功", Toast.LENGTH_SHORT).show();
                    refreshDetailView();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VEDetailGroupConversationActivity.this, "移出失败", Toast.LENGTH_SHORT).show();
                }
            });
        }
    }


    private void sendAddManagerMessage(List<Long> addIdList) {
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(addIdList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> userList) {
                String text = BIMUINameUtils.buildNickNameList(userList) + " 成为管理员 ";
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
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(removeIdList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> userList) {
                String text = BIMUINameUtils.buildNickNameList(userList) + " 被取消管理员 ";
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
