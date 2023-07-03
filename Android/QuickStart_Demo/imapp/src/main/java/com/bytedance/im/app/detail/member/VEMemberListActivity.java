package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.VEMemberListAdapter;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
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

        initData();
    }

    protected void initData() {
        String conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        BIMUIClient.getInstance().getGroupMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> members) {
                Log.i(TAG, "refreshUserListView() members.size(): " + members.size());
                adapter = new VEMemberListAdapter(VEMemberListActivity.this, filterMember(members), member -> onMemberClick(member));
                memberListV.setAdapter(adapter);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "onFailed() code: " + code);
            }
        });
    }

    protected void onMemberClick(BIMMember member) {
        Toast.makeText(VEMemberListActivity.this, "敬请期待", Toast.LENGTH_SHORT).show();
    }

    protected List<BIMMember> filterMember(List<BIMMember> members){
        return members;
    }
}
