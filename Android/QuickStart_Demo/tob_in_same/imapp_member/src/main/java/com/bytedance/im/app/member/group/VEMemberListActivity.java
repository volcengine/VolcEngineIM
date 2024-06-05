package com.bytedance.im.app.member.group;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.app.member.group.adapter.VEMemberListAdapter;
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
    }

    @Override
    protected void onResume() {
        super.onResume();
        initData();
    }

    protected void initData() {
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
        BIMUIClient.getInstance().getModuleStarter().startProfileModule(VEMemberListActivity.this, member.getUserID(), conversationId);
    }

    protected List<MemberWrapper> filterMember(List<MemberWrapper> members){
        return members;
    }
}
