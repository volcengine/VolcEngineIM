package com.bytedance.im.app.detail.manager;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;

import com.bytedance.im.app.R;


public class VEDetailGroupManagerActivity extends Activity {
    private static final String CONVERSATION_ID = "conversation_id";
    private View clMasterManager;
    private View clOwnerManager;
    private String conversationId;

    public static void start(Context context, String conversationId) {
        Intent intent = new Intent(context, VEDetailGroupManagerActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationId = getIntent().getStringExtra(CONVERSATION_ID);
        setContentView(R.layout.ve_im_activity_detail_manager_layout);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        clMasterManager = findViewById(R.id.cl_conversation_master);
        clOwnerManager = findViewById(R.id.cl_conversation_owner);
        clMasterManager.setOnClickListener(v -> {
            VEGroupManagerConfigActivity.start(VEDetailGroupManagerActivity.this, conversationId);

        });
        clOwnerManager.setOnClickListener(v -> {
            VEGroupOwnerConfigActivity.start(VEDetailGroupManagerActivity.this, conversationId);
        });
    }
}
