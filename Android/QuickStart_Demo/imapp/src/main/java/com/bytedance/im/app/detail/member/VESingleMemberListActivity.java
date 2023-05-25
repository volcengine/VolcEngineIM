package com.bytedance.im.app.detail.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.widget.TextView;

import com.bytedance.im.app.R;

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
}
