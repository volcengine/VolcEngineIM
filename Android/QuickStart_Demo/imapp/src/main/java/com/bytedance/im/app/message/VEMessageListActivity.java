package com.bytedance.im.app.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.VEDetailController;
import com.bytedance.im.app.detail.VEDetailGroupConversationActivity;
import com.bytedance.im.app.detail.VEDetailSingleConversationActivity;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.user.UserManager;


public class VEMessageListActivity extends Activity {
    public static final String TAG = "VESingleChatActivity";
    private TextView tvTitle;
    private ImageView back;
    private ImageView more;
    private BIMConversation bimConversation;
    private String conversationId;
    private int REQUEST_CODE_CONVERSATION_DETAIL = 5;

    public static void start(Context context, String cid) {
        Intent intent = new Intent(context, VEMessageListActivity.class);
        intent.putExtra(BIMMessageListFragment.TARGET_CID, cid);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getIntent();
        conversationId = intent.getStringExtra(BIMMessageListFragment.TARGET_CID);
        setContentView(R.layout.ve_im_activity_message_list);
        back = findViewById(R.id.iv_back);
        tvTitle = findViewById(R.id.message_list_title);
        more = findViewById(R.id.message_list_more);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });
        refreshConversation();
        more.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (bimConversation != null) {
                    if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                        VEDetailSingleConversationActivity.start(VEMessageListActivity.this, conversationId);
                    } else if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                        VEDetailGroupConversationActivity.startForResult(VEMessageListActivity.this, conversationId, REQUEST_CODE_CONVERSATION_DETAIL);
                    }
                } else {
                    Toast.makeText(VEMessageListActivity.this, "操作过快", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        refreshConversation();
    }

    private void refreshConversation() {
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                String name = "";
                if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                    BIMUser BIMUser = UserManager.geInstance().getUserProvider().getUserInfo(conversation.getOppositeUserID());
                    if (BIMUser == null) {
                        name = String.valueOf(conversation.getOppositeUserID());
                    } else {
                        name = BIMUser.getNickName();
                    }
                } else if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                    name = VEDetailController.getGroupName(conversation);
                }
                tvTitle.setText(name);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == REQUEST_CODE_CONVERSATION_DETAIL) {
                //是否删除会话
                boolean isDeleteConversation = data.getBooleanExtra(VEDetailGroupConversationActivity.IS_DELETE_LOCAL, false);
                if (isDeleteConversation) {
                    finish();
                }
            }
        }
    }
}
