package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.detail.member.adapter.VEMemberListAdapter;
import com.bytedance.im.app.main.edit.VEUserProfileEditActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;

import java.util.List;

/**
 * 群成员列表
 */
public class VEMemberListActivity extends Activity {
    public static final String TAG = "VEMemberListActivity";
    public static final String CONVERSATION_ID = "conversation_id";

    protected RecyclerView memberListV;
    protected VEMemberListAdapter adapter;

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEMemberListActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_layout);
//        String conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        memberListV = findViewById(R.id.user_list);
        memberListV.setLayoutManager(new LinearLayoutManager(this));


    }

    @Override
    protected void onResume() {
        super.onResume();
        initData();
    }

    protected void initData() {
        String conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        VEMemberUtils.getGroupMemberList(conversationId, new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> memberWrappers) {
                Log.i(TAG, "refreshUserListView() members.size(): " + memberWrappers.size());
                adapter = new VEMemberListAdapter(VEMemberListActivity.this, filterMember(memberWrappers), memberWrapper -> onMemberClick(memberWrapper));
                memberListV.setAdapter(adapter);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "onFailed() code: " + code);
            }
        });
    }

    protected void onMemberClick(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        VEUserProfileEditActivity.start(VEMemberListActivity.this, member.getUserID(), member.getAlias(), member.getAvatarUrl());
    }

    protected List<MemberWrapper> filterMember(List<MemberWrapper> members){
        return members;
    }
}
