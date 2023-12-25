package com.bytedance.im.app.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.VEDetailController;
import com.bytedance.im.app.detail.VEDetailGroupConversationActivity;
import com.bytedance.im.app.detail.VEDetailSingleConversationActivity;
import com.bytedance.im.app.main.edit.VEUserProfileEditActivity;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.List;


public class VEMessageListActivity extends Activity {
    public static final String TAG = "VESingleChatActivity";
    private TextView tvTitle;
    private ImageView back;
    private ImageView more;
    private BIMConversation bimConversation;
    private String conversationId;
    private int REQUEST_CODE_CONVERSATION_DETAIL = 5;

    /**
     * 跳转到最新消息
     *
     * @param context
     * @param cid
     */
    public static void start(Context context, String cid) {
        Intent intent = new Intent(context, VEMessageListActivity.class);
        intent.putExtra(BIMMessageListFragment.TARGET_CID, cid);
        context.startActivity(intent);
    }

    /**
     * 跳转到某条消息
     *
     * @param context
     * @param cid
     * @param msgId   // 跳转的消息Id
     */
    public static void start(Context context, String cid, String msgId) {
        Intent intent = new Intent(context, VEMessageListActivity.class);
        intent.putExtra(BIMMessageListFragment.TARGET_CID, cid);
        intent.putExtra(BIMMessageListFragment.TARGET_MSG_ID, msgId);
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
        back.setOnClickListener(v -> onBackPressed());
        refreshConversation();
        more.setOnClickListener(v -> {
            if (bimConversation != null) {
                if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                    VEDetailSingleConversationActivity.start(VEMessageListActivity.this, conversationId);
                } else if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                    VEDetailGroupConversationActivity.startForResult(VEMessageListActivity.this, conversationId, REQUEST_CODE_CONVERSATION_DETAIL);
                }
            } else {
                Toast.makeText(VEMessageListActivity.this, "操作过快", Toast.LENGTH_SHORT).show();
            }
        });
        refreshFragment();
        BIMClient.getInstance().addConversationListener(conversationListListener);
    }

    private BIMConversationListListener conversationListListener = new BIMConversationListListener() {
        @Override
        public void onNewConversation(List<BIMConversation> conversationList) {

        }

        @Override
        public void onConversationChanged(List<BIMConversation> conversationList) {
            if (conversationList != null) {
                for (BIMConversation conversation : conversationList) {
                    if (conversationId.equals(conversation.getConversationID())) {
                        bimConversation = conversation;
                        break;
                    }
                }
            }
        }

        @Override
        public void onConversationDelete(List<BIMConversation> conversationList) {

        }

        @Override
        public void onTotalUnreadMessageCountChanged(int totalUnreadCount) {

        }
    };

    @Override
    protected void onResume() {
        super.onResume();
        refreshConversation();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        BIMClient.getInstance().removeConversationListener(conversationListListener);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        String refreshCid = intent.getStringExtra(BIMMessageListFragment.TARGET_CID);
        String refreshMsgId = intent.getStringExtra(BIMMessageListFragment.TARGET_MSG_ID);
        getIntent().putExtra(BIMMessageListFragment.TARGET_CID, refreshCid);
        getIntent().putExtra(BIMMessageListFragment.TARGET_MSG_ID, refreshMsgId);
        refreshFragment();
    }

    private void refreshFragment() {
        BIMMessageListFragment messageListFragment = new BIMMessageListFragment();
        messageListFragment.setOnPortraitClickListener(uid -> VEUserProfileEditActivity.start(VEMessageListActivity.this,uid));
        getFragmentManager().beginTransaction().replace(R.id.message_list_container, messageListFragment).commit();
    }

    private void refreshConversation() {
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                    BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfo(conversation.getOppositeUserID(), new BIMResultCallback<BIMUserFullInfo>() {

                        @Override
                        public void onSuccess(BIMUserFullInfo fullInfo) {
                            tvTitle.setText(VENameUtils.getShowName(fullInfo));
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {

                        }
                    });

                } else if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                    tvTitle.setText(VEDetailController.getGroupName(conversation));
                }

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
