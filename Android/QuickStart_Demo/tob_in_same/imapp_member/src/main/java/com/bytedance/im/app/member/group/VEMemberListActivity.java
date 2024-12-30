package com.bytedance.im.app.member.group;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.app.member.group.adapter.VEMemberListAdapter;
import com.bytedance.im.app.member.group.adapter.VEMemberSelectAdapter;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.List;

/**
 * 群成员列表
 */
public class VEMemberListActivity extends Activity {
    public static final String TAG = "VEMemberListActivity";

    protected RecyclerView memberListV;
    protected VEMemberListAdapter adapter;
    private String conversationId;
    private MemberListViewModel viewModel;

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEMemberListActivity.class);
        intent.putExtra(ModuleStarter.MODULE_KEY_CID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_layout);
        conversationId = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        memberListV = findViewById(R.id.user_list);
        memberListV.setLayoutManager(new LinearLayoutManager(this));
        findViewById(R.id.msg_search_bar).setOnClickListener(v -> BIMUIClient.getInstance().getModuleStarter().startConvMemberSearch(VEMemberListActivity.this, conversationId));
    }

    @Override
    protected void onResume() {
        super.onResume();
        viewModel = new MemberListViewModel(conversationId, 20);
        adapter = null;
        loadData();
        memberListV.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                boolean isSlideToBottom = isSlideToBottom(recyclerView);
                if (isSlideToBottom && viewModel.hasMore()) {
                    loadData();
                }
            }
        });
    }

    private void loadData() {
        viewModel.loadMore(new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> memberWrappers) {
                if (memberWrappers != null) {
                    Log.i(TAG, "refreshUserListView() success");
                    if (adapter == null) {
                        adapter = new VEMemberListAdapter(VEMemberListActivity.this, filterMember(memberWrappers), memberWrapper -> onMemberClick(memberWrapper));
                        memberListV.setAdapter(adapter);
                    } else {
                        adapter.appendMemberList(filterMember(memberWrappers));
                    }
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    protected void onMemberClick(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        BIMUIClient.getInstance().getModuleStarter().startProfileModule(VEMemberListActivity.this, member.getUserID(), conversationId);
    }

    protected List<MemberWrapper> filterMember(List<MemberWrapper> members) {
        return members;
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                >= recyclerView.computeVerticalScrollRange())
            return true;
        return false;
    }
}
