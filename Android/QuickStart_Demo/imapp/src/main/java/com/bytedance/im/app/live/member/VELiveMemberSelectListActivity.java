package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.detail.member.adapter.VEMemberSelectAdapter;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.model.BIMMember;

import java.util.List;

public class VELiveMemberSelectListActivity extends Activity {
    private static final String TAG = "VELiveMemberSelectListActivity";
    protected static final String CONVERSATION_SHORT_ID = "conversation_short_id";

    private RecyclerView memberListV;
    private VEMemberSelectAdapter adapter;
    protected long conversationId = -1;
    private VELiveAllMemberListViewModel allMemberListViewModel;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_select_layout);
        conversationId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1);
        allMemberListViewModel = new VELiveAllMemberListViewModel(conversationId, memberList -> {
            if (adapter != null) {
                adapter.appendMemberList(memberList);
            }
        });
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
                if (VELiveUtils.isScrollToBottom(recyclerView)) {
                    allMemberListViewModel.loadMore();
                }
            }
        });
        allMemberListViewModel.loadMore();
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

    protected void onConfirmClick(List<MemberWrapper> selectList) {

    }

    /**
     * 是否展示角色标签，如管理员
     * @return
     */
    protected boolean isShowTag(){
        return true;
    }
}
