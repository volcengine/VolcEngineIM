package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.detail.member.adapter.VEMemberSelectAdapter;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;

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

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_member_list_select_layout);
        String conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        findViewById(R.id.tv_confirm).setOnClickListener(v -> {
            onConfirmClick(adapter.getSelectMember());
        });
        memberListV = findViewById(R.id.user_list);
        memberListV.setLayoutManager(new LinearLayoutManager(this));

        VEMemberUtils.getGroupMemberList(conversationId, new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> memberWrappers) {
                if (memberWrappers != null) {
                    Log.i(TAG, "refreshUserListView() members.size(): " + memberWrappers.size());
                    for (MemberWrapper wrapper : memberWrappers) {
                        if (wrapper.getMember().getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                            selfMember = wrapper.getMember();
                        }
                    }
                    adapter = new VEMemberSelectAdapter(VEMemberSelectListActivity.this, filter(memberWrappers), onInitCheckList(memberWrappers), isShowTag());
                    memberListV.setAdapter(adapter);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }


    protected List<MemberWrapper> filter(List<MemberWrapper> members){
        return members;
    }
    /**
     * 返回初始化就设置选中的成员
     *
     * @param list
     * @return
     */
    protected List<MemberWrapper> onInitCheckList(List<MemberWrapper> list) {
        return null;
    }

    protected void onConfirmClick(List<MemberWrapper> selectList) {

    }

    protected boolean isShowTag(){
        return true;
    }
}
