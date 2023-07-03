package com.bytedance.im.ui.member;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;

import java.util.ArrayList;
import java.util.List;

public class BIMGroupMemberListActivity extends Activity {

    private static final String TAG = "VEMemberListActivity";
    protected static final String CONVERSATION_ID = "conversation_id";
    public static final String RESULT_ID_LIST = "result_id_list";
    private RecyclerView memberListV;
    private BIMGroupMemberListAdapter adapter;

    public static void startForResult(Fragment fragment, String conversationId,int requestCode) {
        Intent intent = new Intent(fragment.getActivity(), BIMGroupMemberListActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        fragment.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bim_activity_member_list_layout);
        String conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        memberListV = findViewById(R.id.user_list);
        memberListV.setLayoutManager(new LinearLayoutManager(this));
        BIMClient.getInstance().getConversationMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> members) {
                BIMLog.i(TAG, "refreshUserListView() members.size(): " + members.size());
                adapter = new BIMGroupMemberListAdapter(BIMGroupMemberListActivity.this, members, member -> onMemberClick(member));
                memberListV.setAdapter(adapter);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "onFailed() code: " + code);
            }
        });
    }

    protected void onMemberClick(BIMMember member) {
        ArrayList<Long> uidList = new ArrayList<>();
        uidList.add(member.getUserID());
        Intent data = new Intent();
        data.putExtra(RESULT_ID_LIST, uidList);
        setResult(RESULT_OK, data);
        finish();
    }
}
