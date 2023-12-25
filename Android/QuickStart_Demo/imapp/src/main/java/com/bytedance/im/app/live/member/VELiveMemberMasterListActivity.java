package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Pair;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.VEMemberUtils;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.detail.member.adapter.VEMemberListAdapter;
import com.bytedance.im.app.live.VELiveGroupDialogUtils;
import com.bytedance.im.app.live.create.VEEditCommonActivity;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;
import com.bytedance.im.ui.log.BIMLog;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VELiveMemberMasterListActivity extends Activity {
    private static String TAG = "VELiveMemberMasterListActivity";
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";

    private static final int REQUEST_EDIT_UID = 0;
    private Long cursor = 0L;
    private boolean hasMore = true;
    private Long conversationShortId = 0L;
    private VEMemberListAdapter adapter;

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VELiveMemberMasterListActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_layout);
        ((TextView) findViewById(R.id.tv_title)).setText("群管理员列表");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        RecyclerView recyclerView = findViewById(R.id.user_list);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setItemAnimator(null);
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0L);
        adapter = new VEMemberListAdapter(this, memberWrapper -> showOperation(memberWrapper), true,true);
        recyclerView.setAdapter(adapter);
        findViewById(R.id.tv_more).setVisibility(View.VISIBLE);
        findViewById(R.id.tv_more).setOnClickListener((view) -> VEEditCommonActivity.startForResult(this, "添加群管理员", "", 19, REQUEST_EDIT_UID));
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
    }

    private void showOperation(MemberWrapper memberWrapper) {
        List dialogInfo = new ArrayList<Pair<String, VELiveGroupDialogUtils.BottomInputDialogListener>>();
        dialogInfo.add(new android.util.Pair("移出管理员", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> BIMClient.getInstance().getService(BIMLiveExpandService.class).removeLiveGroupAdmin(conversationShortId, Collections.singletonList(memberWrapper.getMember().getUserID()), new BIMSimpleCallback() {
            public void onSuccess() {
                Toast.makeText(VELiveMemberMasterListActivity.this, "移出管理员成功 " + VENameUtils.getPortraitUrl(memberWrapper), Toast.LENGTH_SHORT).show();
                adapter.remove(memberWrapper.getMember().getUserID());
            }

            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VELiveMemberMasterListActivity.this, "移出管理员失败 " + VENameUtils.getPortraitUrl(memberWrapper), Toast.LENGTH_SHORT).show();
            }

        })));
        dialogInfo.add(new android.util.Pair("取消", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> Toast.makeText(VELiveMemberMasterListActivity.this, "取消", Toast.LENGTH_SHORT).show()));
        VELiveGroupDialogUtils.showBottomMultiItemDialog(this, dialogInfo);
    }

    protected void loadData() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberList(conversationShortId, cursor, 20, new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                hasMore = resultMemberList.isHasMore();
                cursor = resultMemberList.getNextCursor();
                VEMemberUtils.getMemberWrapperList(resultMemberList.getMemberList(), new BIMResultCallback<List<MemberWrapper>>() {
                    @Override
                    public void onSuccess(List<MemberWrapper> wrapperList) {
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
            long uid = -1;
            try {
                uid = Long.parseLong(data.getStringExtra(VEEditCommonActivity.RESULT_TEXT));
            } catch (Exception e) {
                Toast.makeText(this, "请输入用户id", Toast.LENGTH_SHORT).show();
            }
            List<Long> uidList = new ArrayList<>();
            uidList.add(uid);
            BIMClient.getInstance().getService(BIMLiveExpandService.class).addLiveGroupAdmin(conversationShortId, uidList, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    Toast.makeText(VELiveMemberMasterListActivity.this, "设置管理员成功", Toast.LENGTH_SHORT).show();
                    initData();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VELiveMemberMasterListActivity.this, "设置管理员失败: " + code, Toast.LENGTH_SHORT).show();

                }
            });
        }
    }

    private void initData() {
        hasMore = true;
        cursor = -1L;
        adapter.clear();
        loadData();
    }


}
