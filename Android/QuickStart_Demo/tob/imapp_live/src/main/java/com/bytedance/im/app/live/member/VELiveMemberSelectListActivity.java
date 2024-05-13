package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.member.adapter.VELiveMemberSelectAdapter;
import com.bytedance.im.app.live.member.adapter.VELiveMemberWrapper;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.model.BIMMember;

import java.util.List;

public class VELiveMemberSelectListActivity extends Activity {
    private static final String TAG = "VELiveMemberSelectListActivity";
    protected static final String CONVERSATION_SHORT_ID = "conversation_short_id";

    private RecyclerView memberListV;
    private VELiveMemberSelectAdapter adapter;
    protected long conversationId = -1;
    private VELiveAllMemberListViewModel allMemberListViewModel;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_member_list_select_layout);
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
        adapter = new VELiveMemberSelectAdapter(VELiveMemberSelectListActivity.this);
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

    protected void onConfirmClick(List<VELiveMemberWrapper> selectList) {

    }

    /**
     * 是否展示角色标签，如管理员
     * @return
     */
    protected boolean isShowTag(){
        return true;
    }
}
