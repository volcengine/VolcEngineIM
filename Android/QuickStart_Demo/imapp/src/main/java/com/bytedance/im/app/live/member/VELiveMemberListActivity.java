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
import com.bytedance.im.core.api.model.BIMMember;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class VELiveMemberListActivity extends Activity {

    private static final String TAG = "VELiveMemberListActivity";
    protected static final String CONVERSATION_ID = "conversation_id";

    private RecyclerView memberListV;
    private VEMemberListAdapter adapter;
    private long conversationId;

    private VEAllMemberListViewModel allMemberListViewModel;

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
        allMemberListViewModel = new VEAllMemberListViewModel(conversationId, memberList -> appendMemberList(memberList));
        findViewById(R.id.back).setOnClickListener(v -> finish());
        memberListV = findViewById(R.id.user_list);
        memberListV.setItemAnimator(null);
        memberListV.setLayoutManager(new LinearLayoutManager(this));
        adapter = new VEMemberListAdapter(VELiveMemberListActivity.this, member -> onMemberClick(member),false,true);
        memberListV.setAdapter(adapter);
        memberListV.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if(VELiveUtils.isScrollToBottom(recyclerView)){
                    allMemberListViewModel.loadMore();
                }
            }
        });
        allMemberListViewModel.loadMore();
    }


    private void appendMemberList(List<BIMMember> list) {
        if (adapter != null) {
            adapter.appendMemberList(list);
        }
    }

    protected void onMemberClick(BIMMember member) {
        Toast.makeText(VELiveMemberListActivity.this, "敬请期待", Toast.LENGTH_SHORT).show();
    }
}
