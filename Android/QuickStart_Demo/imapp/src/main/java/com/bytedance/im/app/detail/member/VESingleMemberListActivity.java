package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;

import java.util.Iterator;
import java.util.List;

public class VESingleMemberListActivity extends VEMemberListActivity {

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VESingleMemberListActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView title = findViewById(R.id.tv_title);
        title.setText("成员列表");
    }

    @Override
    protected List<BIMMember> filterMember(List<BIMMember> members) {
        if (members.size() >= 2) {
            Iterator<BIMMember> iterator = members.iterator();
            while (iterator.hasNext()) {
                BIMMember member = iterator.next();
                if (member.getUserID() == BIMUIClient.getInstance().getCurUserId()) {
                    iterator.remove();
                    break;
                }
            }
        }
        return members;
    }
}
