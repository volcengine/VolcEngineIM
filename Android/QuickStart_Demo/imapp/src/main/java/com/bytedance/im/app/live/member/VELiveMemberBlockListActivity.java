package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.VEMemberListAdapter;
import com.bytedance.im.app.live.VELiveGroupDialogUtils;
import com.bytedance.im.app.live.create.VEEditCommonActivity;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;
import com.bytedance.im.ui.log.BIMLog;

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
    private VEMemberListAdapter adapter;

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VELiveMemberBlockListActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_layout);
        ((TextView) findViewById(R.id.tv_title)).setText("进群黑名单");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        RecyclerView recyclerView = findViewById(R.id.user_list);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setItemAnimator(null);
        conversationShortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0L);
        adapter = new VEMemberListAdapter(this, member -> showOperation(member),true);
        recyclerView.setAdapter(adapter);
        findViewById(R.id.tv_more).setVisibility(View.VISIBLE);
        findViewById(R.id.tv_more).setOnClickListener((view) -> VEEditCommonActivity.startForResult(this, "添加进群黑名单", "",10, REQUEST_EDIT_UID));
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

    private void showOperation(BIMMember member) {
        List dialogInfo = new ArrayList<android.util.Pair<String, VELiveGroupDialogUtils.BottomInputDialogListener>>();
        dialogInfo.add(new android.util.Pair("移出成员", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> BIMClient.getInstance().getService(BIMLiveExpandService.class).removeLiveGroupMemberBlockList(conversationShortId, Collections.singletonList(member.getUserID()), new BIMSimpleCallback() {
            public void onSuccess() {
                Toast.makeText(VELiveMemberBlockListActivity.this, "移除禁言黑名单成功" + member.getUserID(), Toast.LENGTH_SHORT).show();
                adapter.remove(member.getUserID());
            }

            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VELiveMemberBlockListActivity.this, "移除禁言黑名单失败" + member.getUserID(), Toast.LENGTH_SHORT).show();
            }

        })));
        dialogInfo.add(new android.util.Pair("取消", (VELiveGroupDialogUtils.BottomInputDialogListener) (v, text) -> Toast.makeText(VELiveMemberBlockListActivity.this, "取消", Toast.LENGTH_SHORT).show()));
        VELiveGroupDialogUtils.showBottomMultiItemDialog(this, dialogInfo);
    }

    protected void loadData() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberBlockList(conversationShortId, cursor, 20, new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                hasMore = resultMemberList.isHasMore();
                cursor = resultMemberList.getNextCursor();
                adapter.appendMemberList(resultMemberList.getMemberList());
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
            long blocktime = 24 * 60 * 60;//one day
            BIMClient.getInstance().getService(BIMLiveExpandService.class).addLiveGroupMemberBlockList(conversationShortId, uidList, blocktime, new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    Toast.makeText(VELiveMemberBlockListActivity.this, "添加禁言黑名单成功", Toast.LENGTH_SHORT).show();
                    initData();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Toast.makeText(VELiveMemberBlockListActivity.this, "添加禁言黑名单失败", Toast.LENGTH_SHORT).show();
                }
            });
        }
    }

    private void initData(){
        hasMore = true;
        cursor = -1L;
        adapter.clear();
        loadData();
    }
}
