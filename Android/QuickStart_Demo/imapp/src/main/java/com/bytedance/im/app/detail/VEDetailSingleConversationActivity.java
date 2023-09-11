package com.bytedance.im.app.detail;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.Switch;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.VESingleMemberListActivity;
import com.bytedance.im.app.detail.member.adapter.VEMemberHozionAdapter;
import com.bytedance.im.app.search.VESearchResultActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;

import java.util.List;

public class VEDetailSingleConversationActivity extends Activity {
    private static final String TAG = "VEDetailSingleConversationActivity";
    private static final String CONVERSATION_ID = "conversation_id";
    private RecyclerView recyclerView;

    public static void start(Context context, String cid) {
        Intent intent = new Intent(context, VEDetailSingleConversationActivity.class);
        intent.putExtra(CONVERSATION_ID, cid);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_detail_singel_chat);
        String conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        recyclerView = findViewById(R.id.recycler_view_member);
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        VEMemberHozionAdapter adapter = new VEMemberHozionAdapter(this, null);
        recyclerView.setAdapter(adapter);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> VESingleMemberListActivity.start(VEDetailSingleConversationActivity.this, conversationId));
        findViewById(R.id.fl_search_msg).setOnClickListener(v -> VESearchResultActivity.start(VEDetailSingleConversationActivity.this, conversationId));
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                Switch topSwitch = findViewById(R.id.switch_top);
                Switch muteSwitch = findViewById(R.id.switch_mute);
                VEDetailController.initStickSwitch(topSwitch, conversation, VEDetailSingleConversationActivity.this);
                VEDetailController.initMuteSwitch(muteSwitch, conversation, VEDetailSingleConversationActivity.this);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEDetailSingleConversationActivity.this, "会话不存在", Toast.LENGTH_SHORT).show();
                finish();
            }
        });

        BIMUIClient.getInstance().getGroupMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> memberList) {

                if (memberList != null
                        && memberList.size() >= 2
                        && memberList.get(0).getUserID() == BIMClient.getInstance().getCurrentUserID()
                        && memberList.get(1).getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                    //自己和自己发起聊天
                    memberList.remove(1);
                }
                adapter.updateUserInfoList(memberList, false, false);
            }


            @Override
            public void onFailed(BIMErrorCode code) {

            }

        });
    }


}
