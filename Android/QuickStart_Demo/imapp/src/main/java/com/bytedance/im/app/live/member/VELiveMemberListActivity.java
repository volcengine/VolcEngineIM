package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.VEMemberListAdapter;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;

import java.util.List;

public class VELiveMemberListActivity extends Activity {

    private static final String TAG = "VELiveMemberListActivity";
    protected static final String CONVERSATION_ID = "conversation_id";

    private RecyclerView memberListV;
    private VEMemberListAdapter adapter;
    private long cursor = -1;
    private long pageSize = 20;
    private boolean hasMore = true;
    private long conversationId;

    public static void start(Activity activity, long conversationId) {
        Intent intent = new Intent(activity, VELiveMemberListActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_layout);
        conversationId = getIntent().getLongExtra(CONVERSATION_ID, 0);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        memberListV = findViewById(R.id.user_list);
        memberListV.setItemAnimator(null);
        memberListV.setLayoutManager(new LinearLayoutManager(this));
        adapter = new VEMemberListAdapter(VELiveMemberListActivity.this, member -> onMemberClick(member));
        memberListV.setAdapter(adapter);
        memberListV.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (VELiveUtils.isScrollToBottom(recyclerView) && hasMore) {
                    loadData();
                }
            }
        });
        loadData();
    }

    private void loadData() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberOnlineList(conversationId, cursor, pageSize, new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                cursor = resultMemberList.getNextCursor();
                hasMore = resultMemberList.isHasMore();
                appendMemberList(resultMemberList.getMemberList());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VELiveMemberListActivity.this, "加载失败:" + code, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void appendMemberList(List<BIMMember> list) {
        adapter.appendMemberList(list);
    }

    protected void onMemberClick(BIMMember member) {
        Toast.makeText(VELiveMemberListActivity.this, "敬请期待", Toast.LENGTH_SHORT).show();
    }
}
