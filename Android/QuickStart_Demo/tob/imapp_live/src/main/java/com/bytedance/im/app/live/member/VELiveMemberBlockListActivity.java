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
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VELiveMemberBlockListActivity extends Activity {
    private static String TAG = "VELiveGroupMemberBlockListActivity";
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";

    private static final int REQUEST_EDIT_UID = 0;
    private Long cursor = 0L;
    private boolean hasMore = true;
    private Long conversationShortId = 0L;
    private VELiveMemberListAdapter adapter;

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VELiveMemberBlockListActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_member_list_layout);
        ((TextView) findViewById(R.id.tv_title)).setText("进群黑名单");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        RecyclerView recyclerView = findViewById(R.id.user_list);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setItemAnimator(null);
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0L);
        adapter = new VELiveMemberListAdapter(this, memberWrapper -> showOperation(memberWrapper), false, false);
        recyclerView.setAdapter(adapter);
        findViewById(R.id.tv_more).setVisibility(View.VISIBLE);
        findViewById(R.id.tv_more).setOnClickListener((view) -> VEEditCommonActivity.startForResult(this, "添加进群黑名单", "", 19, REQUEST_EDIT_UID));
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

    private void showOperation(VELiveMemberWrapper memberWrapper) {
        List dialogInfo = new ArrayList<android.util.Pair<String, VELiveGroupDialogUtils.BottomInputDialogListener>>();
        dialogInfo.add(new android.util.Pair("移出成员", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> {
            BIMSimpleCallback removeBlockCallback = new BIMSimpleCallback() {
                public void onSuccess() {
                    Toast.makeText(VELiveMemberBlockListActivity.this, "移出禁言黑名单成功" + BIMUINameUtils.getShowNameInGroup(memberWrapper.getMember(), memberWrapper.getFullInfo()), Toast.LENGTH_SHORT).show();
                    adapter.remove(memberWrapper.getMember().getUserID());
                }

                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VELiveMemberBlockListActivity.this, "移出禁言黑名单失败" + BIMUINameUtils.getShowNameInGroup(memberWrapper.getMember(), memberWrapper.getFullInfo()), Toast.LENGTH_SHORT).show();
                }
            };
            BIMClient.getInstance().getService(BIMLiveExpandService.class).removeLiveGroupMemberBlockListString(conversationShortId, Collections.singletonList(memberWrapper.getMember().getUserIDString()), removeBlockCallback);
        }));
        dialogInfo.add(new android.util.Pair("取消", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> Toast.makeText(VELiveMemberBlockListActivity.this, "取消", Toast.LENGTH_SHORT).show()));
        VELiveGroupDialogUtils.showBottomMultiItemDialog(this, dialogInfo);
    }

    protected void loadData() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberBlockList(conversationShortId, cursor, 20, new BIMResultCallback<BIMLiveMemberListResult>() {
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
            BIMSimpleCallback addBlockCallback = new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    Toast.makeText(VELiveMemberBlockListActivity.this, "添加进群黑名单成功", Toast.LENGTH_SHORT).show();
                    initData();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VELiveMemberBlockListActivity.this, "添加进群黑名单失败", Toast.LENGTH_SHORT).show();
                }
            };
            long blockTime = 24 * 60 * 60;//one day
            String uidStr = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
            BIMClient.getInstance().getService(BIMLiveExpandService.class).addLiveGroupMemberBlockListString(conversationShortId, Collections.singletonList(uidStr), blockTime, addBlockCallback);
        }
    }


    private void initData() {
        hasMore = true;
        cursor = -1L;
        adapter.clear();
        loadData();
    }
}
