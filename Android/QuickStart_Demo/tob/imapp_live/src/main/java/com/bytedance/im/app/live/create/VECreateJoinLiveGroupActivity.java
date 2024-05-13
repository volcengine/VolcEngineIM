package com.bytedance.im.app.live.create;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.chatRoom.VELiveGroupChatRoomActivity;

/**
 * 加入直播群时，修改个人资料
 */
public class VECreateJoinLiveGroupActivity extends Activity {
    private View optionName;
    private View optionPortrait;
    private static final String CONVERSATION_SHORT_ID = "conversation_short_id";

    private TextView tvName;
    private ImageView ivPortrait;
    private TextView tvDes;
    private TextView tvNotice;
    private View btnConfirm;
    private View btnSkip;
    private String url;
    private long conversationShortID;
    private static int REQUEST_MEMBER_NAME = 0;
    private static int REQUEST_MEMBER_PORTRAIT = 1;


    public static void start(Activity activity, long conversationID) {
        Intent intent = new Intent(activity, VECreateJoinLiveGroupActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, conversationID);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationShortID = getIntent().getLongExtra(CONVERSATION_SHORT_ID, 0);
        setContentView(R.layout.ve_im_live_activity_create_join_live_group);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        optionName = findViewById(R.id.cl_live_member_name);
        optionPortrait = findViewById(R.id.cl_member_group_portrait);
        tvName = findViewById(R.id.tv_conversation_group_name);
        ivPortrait = findViewById(R.id.tv_live_group_portrait);
//        tvDes = findViewById(R.id.tv_live_group_desc);
//        tvNotice = findViewById(R.id.tv_live_group_notice);
        btnConfirm = findViewById(R.id.confirm_btn);
        btnSkip = findViewById(R.id.skip_btn);
        optionName.setOnClickListener(v -> VEEditCommonActivity.startForResult(this, "我的昵称", tvName.getText().toString(), 10, REQUEST_MEMBER_NAME));
        optionPortrait.setOnClickListener(v -> VEEditCommonActivity.startForResult(this, "我的头像", url, Integer.MAX_VALUE, REQUEST_MEMBER_PORTRAIT));
        btnConfirm.setOnClickListener(v ->{
            String name = tvName.getText().toString();
            VELiveGroupChatRoomActivity.startChat(VECreateJoinLiveGroupActivity.this, conversationShortID, name, url);
            finish();
        } );
        btnSkip.setOnClickListener(v -> VELiveGroupChatRoomActivity.startChat(VECreateJoinLiveGroupActivity.this, conversationShortID));
        btnSkip.setVisibility(View.GONE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            String resultText = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
            if (requestCode == REQUEST_MEMBER_NAME) {
                tvName.setText(resultText);
            } else if (requestCode == REQUEST_MEMBER_PORTRAIT) {
                url = resultText;
                Glide.with(ivPortrait.getContext()).load(url).error(R.drawable.icon_recommend_user_default).into(ivPortrait);
            }
        }
    }
}
