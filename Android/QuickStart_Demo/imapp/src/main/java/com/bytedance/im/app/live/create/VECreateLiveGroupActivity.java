package com.bytedance.im.app.live.create;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.live.chatRoom.VELiveGroupChatRoomActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.live.BIMLiveExpandService;

public class VECreateLiveGroupActivity extends Activity {

    private View optionName;
    private View optionPortrait;
    private View optionDes;
    private View optionNotice;

    private TextView tvName;
    private ImageView ivPortrait;
    private TextView tvDes;
    private TextView tvNotice;
    private View btnConfirm;
    private String url;

    private static int REQUEST_CODE_NAME = 0;
    private static int REQUEST_CODE_PORTRAIT = 1;
    private static int REQUEST_CODE_DES = 2;
    private static int REQUEST_CODE_NOTICE = 3;

    public static void start(Activity activity) {
        Intent intent = new Intent(activity, VECreateLiveGroupActivity.class);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_create_live_group);
        findViewById(R.id.iv_back).setOnClickListener(v -> {
            finish();
        });
        optionName = findViewById(R.id.cl_live_group_name);
        optionPortrait = findViewById(R.id.cl_live_group_portrait);
        optionDes = findViewById(R.id.cl_live_group_desc);
        optionNotice = findViewById(R.id.cl_live_group_notice);
        tvName = findViewById(R.id.tv_conversation_group_name);
        ivPortrait = findViewById(R.id.tv_live_group_portrait);
        tvDes = findViewById(R.id.tv_live_group_desc);
        tvNotice = findViewById(R.id.tv_live_group_notice);
        btnConfirm = findViewById(R.id.confirm_btn);

        optionName.setOnClickListener(v -> {
            VEEditCommonActivity.startForResult(this, "直播群名称", tvName.getText().toString(), 10,REQUEST_CODE_NAME);
        });
        optionPortrait.setOnClickListener(v -> {
            VEEditCommonActivity.startForResult(this, "直播群头像", "", 100,REQUEST_CODE_PORTRAIT);
        });
        optionDes.setOnClickListener(v -> {
            VEEditCommonActivity.startForResult(this, "直播群描述", "", 100,REQUEST_CODE_DES);
        });
        optionNotice.setOnClickListener(v -> {
            VEEditCommonActivity.startForResult(this, "直播群公告", "", 100,REQUEST_CODE_NOTICE);
        });

        btnConfirm.setOnClickListener(v -> {
            createLiveGroup(tvName.getText().toString(), url, tvDes.getText().toString(), tvNotice.getText().toString());
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            String resultText = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
            if (requestCode == REQUEST_CODE_NAME) {
                tvName.setText(resultText);
            } else if (requestCode == REQUEST_CODE_PORTRAIT) {
                url = resultText;
                Glide.with(ivPortrait.getContext()).load(url).into(ivPortrait);
            } else if (requestCode == REQUEST_CODE_DES) {
                tvDes.setText(resultText);
            } else if (requestCode == REQUEST_CODE_NOTICE) {
                tvNotice.setText(resultText);
            }
        }
    }

    private void createLiveGroup(String name, String url, String des, String notice) {
        if (TextUtils.isEmpty(name)) {
            name = "未命名直播间";
        }
        BIMGroupInfo groupInfo = new BIMGroupInfo.BIMGroupInfoBuilder()
                .name(name)
                .description(des)
                .avatarUrl(url)
                .notice(notice)
                .build();

        BIMClient.getInstance().getService(BIMLiveExpandService.class).createLiveGroup(groupInfo, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                Toast.makeText(VECreateLiveGroupActivity.this, "创建直播群成功", Toast.LENGTH_SHORT).show();
                VECreateJoinLiveGroupActivity.start(VECreateLiveGroupActivity.this, conversation.getConversationShortID());
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_LIVE_MORE_THAN_LIMIT) {
                    Toast.makeText(VECreateLiveGroupActivity.this, "创建直播群超过上限", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(VECreateLiveGroupActivity.this, "创建直播群失败", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
}
