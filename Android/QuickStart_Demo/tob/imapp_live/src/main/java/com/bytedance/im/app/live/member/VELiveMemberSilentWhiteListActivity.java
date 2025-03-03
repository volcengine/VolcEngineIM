package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.VELiveGroupDialogUtils;
import com.bytedance.im.app.live.VELiveMemberUtils;
import com.bytedance.im.app.live.create.VEEditCommonActivity;
import com.bytedance.im.app.live.member.adapter.VELiveMemberListAdapter;
import com.bytedance.im.app.live.member.adapter.VELiveMemberWrapper;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VELiveMemberSilentWhiteListActivity extends Activity {
    private static String TAG = "VELiveMemberSilentWhiteListActivity";
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";

    private static final int REQUEST_EDIT_UID = 0;
    private Long cursor = 0L;
    private boolean hasMore = true;
    private Long conversationShortId = 0L;
    private VELiveMemberListAdapter adapter;
    private View more;
    private BIMConversation mConversation;

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VELiveMemberSilentWhiteListActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_member_list_layout);
        ((TextView) findViewById(R.id.tv_title)).setText("禁言白名单");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        RecyclerView recyclerView = findViewById(R.id.user_list);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setItemAnimator(null);
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0L);
        adapter = new VELiveMemberListAdapter(this, memberWrapper -> {
            showOperation(memberWrapper);
        }, true, false);
        recyclerView.setAdapter(adapter);
        more = findViewById(R.id.tv_more);
        more.setOnClickListener((view) -> VEEditCommonActivity.startForResult(this, "添加禁言白名单", "", 19, REQUEST_EDIT_UID));
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (VELiveUtils.isScrollToBottom(recyclerView) && hasMore) {
                    loadData();
                }
            }
        });
        initData();
        updateUI();
    }

    private void showOperation(VELiveMemberWrapper memberWrapper) {
        if (mConversation != null && mConversation.getCurrentMember() != null) {
            BIMMemberRole role = mConversation.getCurrentMember().getRole();
            if (role == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || role == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                List dialogInfo = new ArrayList<android.util.Pair<String, VELiveGroupDialogUtils.BottomInputDialogListener>>();
                dialogInfo.add(new android.util.Pair("移出成员", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> {
                    List<String> uidStrList = Collections.singletonList(memberWrapper.getMember().getUserIDString());
                    BIMClient.getInstance().getService(BIMLiveExpandService.class).removeLiveGroupMemberSilentWhiteListString(conversationShortId, uidStrList, new BIMSimpleCallback() {
                        public void onSuccess() {
                            Toast.makeText(VELiveMemberSilentWhiteListActivity.this, "移出禁言白名单成功" + BIMUINameUtils.getShowNameInGroup(memberWrapper.getMember(), memberWrapper.getFullInfo()), Toast.LENGTH_SHORT).show();
                            adapter.remove(memberWrapper.getMember().getUserID());
                        }

                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VELiveMemberSilentWhiteListActivity.this, "移出禁言白名单失败" + BIMUINameUtils.getShowNameInGroup(memberWrapper.getMember(), memberWrapper.getFullInfo()), Toast.LENGTH_SHORT).show();
                        }
                    });
                }));
                dialogInfo.add(new android.util.Pair("取消", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> Toast.makeText(VELiveMemberSilentWhiteListActivity.this, "取消", Toast.LENGTH_SHORT).show()));
                VELiveGroupDialogUtils.showBottomMultiItemDialog(this, dialogInfo);
            }
        }
    }

    protected void loadData() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberSilentWhiteList(conversationShortId, cursor, 20, new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                hasMore = resultMemberList.isHasMore();
                cursor = resultMemberList.getNextCursor();
                VELiveMemberUtils.getMemberWrapperList(resultMemberList.getMemberList(), new BIMResultCallback<List<VELiveMemberWrapper>>() {
                    @Override
                    public void onSuccess(List<VELiveMemberWrapper> wrapperList) {
                        adapter.appendMemberList(wrapperList);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {

                    }
                });

            }

            public void onFailed(BIMErrorCode code) {
                BIMLog.e(TAG, "get data failed" + code);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_EDIT_UID) {
            String uidStr = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
            List<String> uidStrList = new ArrayList<>();
            uidStrList.add(uidStr);
            BIMClient.getInstance().getService(BIMLiveExpandService.class).addLiveGroupMemberSilentWhiteListString(conversationShortId, uidStrList, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    Toast.makeText(VELiveMemberSilentWhiteListActivity.this, "添加禁言白名单成功", Toast.LENGTH_SHORT).show();
                    initData();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VELiveMemberSilentWhiteListActivity.this, "添加禁言白名单失败", Toast.LENGTH_SHORT).show();
                }
            });
        }
    }


    private void updateUI() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroup(conversationShortId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                mConversation = conversation;
                BIMMember member = conversation.getCurrentMember();
                if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_NORMAL || member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_VISITOR) {
                    more.setVisibility(View.GONE);
                } else {
                    more.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    private void initData() {
        hasMore = true;
        cursor = -1L;
        adapter.clear();
        loadData();
    }
}
