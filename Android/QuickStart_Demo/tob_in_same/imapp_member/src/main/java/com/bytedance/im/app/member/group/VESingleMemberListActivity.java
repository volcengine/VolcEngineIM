package com.bytedance.im.app.member.group;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.Nullable;


import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.List;

public class VESingleMemberListActivity extends VEMemberListActivity {

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VESingleMemberListActivity.class);
        intent.putExtra(ModuleStarter.MODULE_KEY_CID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView title = findViewById(R.id.tv_title);
        title.setText("成员列表");
    }

    @Override
    protected List<MemberWrapper> filterMember(List<MemberWrapper> memberList) {
        if (memberList != null
                && memberList.size() >= 2
                && memberList.get(0).getMember().getUserID() == BIMClient.getInstance().getCurrentUserID()
                && memberList.get(1).getMember().getUserID() == BIMClient.getInstance().getCurrentUserID()) {
            //自己和自己发起聊天
            memberList.remove(1);
        }
        return memberList;
    }
}
