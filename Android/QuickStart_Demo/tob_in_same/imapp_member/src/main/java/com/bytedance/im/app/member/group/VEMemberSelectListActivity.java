package com.bytedance.im.app.member.group;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.app.member.group.adapter.VEMemberSelectAdapter;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 群成员列表
 */
public class VEMemberSelectListActivity extends Activity {
    private static final String TAG = "VEMemberListActivity";
    protected static final String CONVERSATION_ID = "conversation_id";

    private RecyclerView memberListV;
    private VEMemberSelectAdapter adapter;
    protected BIMMember selfMember;
    private List<Long> removedList;
    private List<Long> checkedList;
    private boolean isShowOwner;
    private boolean isOwnerSelectable;
    private boolean isShowTag;
    private TextView tvTitle;
    private MemberListViewModel viewModel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        removedList = (List<Long>) getIntent().getSerializableExtra(ModuleStarter.MODULE_KEY_UID_LIST_REMOVED);
        checkedList = (List<Long>) getIntent().getSerializableExtra(ModuleStarter.MODULE_KEY_UID_LIST_CHECKED);
        isShowOwner = getIntent().getBooleanExtra(ModuleStarter.MODULE_KEY_SHOW_OWNER, false);
        isOwnerSelectable = getIntent().getBooleanExtra(ModuleStarter.MODULE_KEY_OWNER_SELECTABLE, false);
        isShowTag = getIntent().getBooleanExtra(ModuleStarter.MODULE_KEY_SHOW_TAG, false);
        String title = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_TITLE);
        setContentView(R.layout.ve_im_activity_member_list_select_layout);
        String conversationId = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        findViewById(R.id.tv_confirm).setOnClickListener(v -> {
            if (adapter != null) {
                onConfirmClick(adapter.getSelectMember());
            }
        });
        tvTitle = findViewById(R.id.tv_title);
        memberListV = findViewById(R.id.user_list);
        memberListV.setLayoutManager(new LinearLayoutManager(this));
        viewModel = new MemberListViewModel(conversationId, 20);
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
        tvTitle.setText(title);
        loadData();
    }


    private void loadData() {
        viewModel.loadMore(new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> memberWrappers) {
                if (memberWrappers != null) {
                    Log.i(TAG, "refreshUserListView() members.size(): " + memberWrappers.size());
                    for (MemberWrapper wrapper : memberWrappers) {
                        if (wrapper.getMember().getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                            selfMember = wrapper.getMember();
                        }
                    }
                    if (adapter == null) {
                        adapter = new VEMemberSelectAdapter(VEMemberSelectListActivity.this,
                                filter(memberWrappers),
                                checkedList,
                                isShowTag, isOwnerSelectable); //第一页数据
                        memberListV.setAdapter(adapter);
                    } else {
                        adapter.appendMemberWrapper(memberWrappers); //第 2、3、4 ... 页数据
                    }

                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }


    protected List<MemberWrapper> filter(List<MemberWrapper> members) {
        Iterator<MemberWrapper> iterator = members.iterator();
        while (iterator.hasNext()) {
            MemberWrapper memberWrapper = iterator.next();
            BIMMember member = memberWrapper.getMember();
            if (!isShowOwner && member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                iterator.remove();
            }
            if (removedList != null && removedList.contains(member.getUserID())) {
                iterator.remove();
            }
        }
        return members;
    }

    protected void onConfirmClick(List<MemberWrapper> selectList) {
        ArrayList<Long> list = new ArrayList<>();
        for (MemberWrapper memberWrapper : selectList) {
            list.add(memberWrapper.getMember().getUserID());
        }
        Intent intent = new Intent();
        intent.putExtra(ModuleStarter.MODULE_KEY_UID_LIST, list);
        setResult(RESULT_OK, intent);
        finish();
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                >= recyclerView.computeVerticalScrollRange())
            return true;
        return false;
    }

}
