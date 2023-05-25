package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.VEMemberSelectAdapter;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;

import java.util.List;

public class VELiveMemberSelectListActivity extends Activity {
    private static final String TAG = "VEMemberListActivity";
    protected static final String CONVERSATION_SHORT_ID = "conversation_short_id";

    private RecyclerView memberListV;
    private VEMemberSelectAdapter adapter;
    private long cursor = -1;
    private long pageSize = 20;
    private boolean hasMore = true;
    protected long conversationId = -1;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_select_layout);
        conversationId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        findViewById(R.id.tv_confirm).setOnClickListener(v -> {
            onConfirmClick(adapter.getSelectMember());
        });
        memberListV = findViewById(R.id.user_list);
        memberListV.setLayoutManager(new LinearLayoutManager(this));
        adapter = new VEMemberSelectAdapter(VELiveMemberSelectListActivity.this);
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
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberOnlineList(conversationId, cursor, pageSize,new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                Log.i(TAG, "getLiveGroupMemberOnlineList() hasMore: " + resultMemberList.isHasMore());
                hasMore = resultMemberList.isHasMore();
                cursor = resultMemberList.getNextCursor();
                adapter.appendMemberList(filter(resultMemberList.getMemberList()));
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    protected List<BIMMember> filter(List<BIMMember> members) {
        return members;
    }

    /**
     * 返回初始化就设置选中的成员
     *
     * @param list
     * @return
     */
    protected List<BIMMember> onInitCheckList(List<BIMMember> list) {
        return null;
    }

    protected void onConfirmClick(List<BIMMember> selectList) {

    }
}
