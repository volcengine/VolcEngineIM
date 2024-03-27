package com.bytedance.im.app.detail.manager;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.widget.TextView;

import com.bytedance.im.app.detail.member.VEMemberListActivity;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.ui.R;

public class VEGroupOwnerConfigActivity extends VEMemberListActivity {

    private String conversationId;
    private ProgressDialog waitDialog;

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEGroupOwnerConfigActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        TextView textView = findViewById(R.id.tv_title);
        textView.setText("设置群主");

    }

    @Override
    protected void onMemberClick(MemberWrapper member) {
        super.onMemberClick(member);// 暂不支持转让群主
    }
}
