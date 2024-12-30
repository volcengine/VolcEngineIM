package com.bytedance.im.ui.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMMessageListener;
import com.bytedance.im.core.api.interfaces.BIMP2PMessageListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageReadReceipt;
import com.bytedance.im.core.api.model.BIMReadReceipt;
import com.bytedance.im.core.model.inner.msg.BIMCustomElement;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMP2PTypingElement;
import com.bytedance.im.ui.message.adapter.ui.widget.input.VEInPutView;
import com.bytedance.im.ui.message.adapter.ui.widget.input.audio.VoiceInputButton;
import com.bytedance.im.ui.starter.ModuleStarter;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class BIMMessageListActivity extends Activity {
    public static final String TAG = "VESingleChatActivity";
    private TextView tvTitle;
    private ImageView back;
    private ImageView more;
    private BIMConversation bimConversation;
    private String conversationId;
    private int REQUEST_CODE_CONVERSATION_DETAIL = 5;
    private String titleName;
    private static final int MSG_WHAT_CHECK_TYPING = 100;
    private static final int MSG_WHAT_CHECK_RECORDING = 101;
    private static final int MSG_WHAT_SEND_RECODING = 102;
    private static final int DELAY_CHECK_TIME = 3000;
    private static final int DELAY_SEND_RECORDING = 1000;
    private Handler typingCheckHandler = new Handler(Looper.getMainLooper()){
        @Override
        public void dispatchMessage(Message msg) {
            super.dispatchMessage(msg);
            if (msg.what == MSG_WHAT_CHECK_TYPING || msg.what == MSG_WHAT_CHECK_RECORDING) {
                tvTitle.setText(titleName);
            } else if (msg.what == MSG_WHAT_SEND_RECODING) {
                sendAudioTypingP2PMessage();
                typingCheckHandler.sendEmptyMessageDelayed(MSG_WHAT_SEND_RECODING,DELAY_SEND_RECORDING);
            }
        }
    };
    /**
     * 跳转到最新消息
     *
     * @param context
     * @param cid
     */
    public static void start(Context context, String cid) {
        Intent intent = new Intent(context, BIMMessageListActivity.class);
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
        Intent intent = new Intent(context, BIMMessageListActivity.class);
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
                    BIMUIClient.getInstance().getModuleStarter().startDetailSingleActivity(BIMMessageListActivity.this, conversationId);
                } else if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT
                        || bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LITE_LIVE_CHAT) {
                    BIMUIClient.getInstance().getModuleStarter().startDetailGroupActivity(BIMMessageListActivity.this, conversationId);
                }
            } else {
                Toast.makeText(BIMMessageListActivity.this, "操作过快", Toast.LENGTH_SHORT).show();
            }
        });
        refreshFragment();
        BIMClient.getInstance().addConversationListener(conversationListListener);
        BIMUIClient.getInstance().addP2PMessageListener(bimp2PMessageListener);
        BIMUIClient.getInstance().addMessageListener(messageListener);
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

        @Override
        public void onConversationRead(String conversationId, long fromUid) {

        }
    };

    private BIMP2PMessageListener bimp2PMessageListener = new BIMP2PMessageListener() {
        @Override
        public void onReceiveP2PMessage(BIMMessage bimMessage) {
            BIMLog.i(TAG, "onReceiveP2PMessage bimMessage: " + bimMessage);
            if (bimMessage.getConversationID().equals(conversationId)) {
                BIMCustomElement element = (BIMCustomElement) bimMessage.getElement();
                if (element instanceof BIMP2PTypingElement && BIMClient.getInstance().getCurrentUserID() != bimMessage.getSenderUID()) {
                    BIMLog.i(TAG, "onReceiveP2PMessage BIMP2PTypingElement: " + element);
                    int msgType = ((BIMP2PTypingElement) element).getMessageType();
                    if (msgType == BIMMessageType.BIM_MESSAGE_TYPE_TEXT.getValue()) {
                        tvTitle.setText("对方正在输入中...");
                        typingCheckHandler.removeMessages(MSG_WHAT_CHECK_TYPING);
                        typingCheckHandler.sendEmptyMessageDelayed(MSG_WHAT_CHECK_TYPING, DELAY_CHECK_TIME);
                    } else if (msgType == BIMMessageType.BIM_MESSAGE_TYPE_AUDIO.getValue()) {
                        tvTitle.setText("对方正在讲话...");
                        typingCheckHandler.removeMessages(MSG_WHAT_CHECK_RECORDING);
                        typingCheckHandler.sendEmptyMessageDelayed(MSG_WHAT_CHECK_RECORDING, DELAY_CHECK_TIME);
                    }
                }
            }
        }

        @Override
        public void onSendP2PMessage(BIMMessage bimMessage) {
                BIMLog.i(TAG,"onSendP2PMessage onSendP2PMessage: "+bimMessage);
        }
    };

    private BIMMessageListener messageListener = new BIMMessageListener() {
        @Override
        public void onReceiveMessage(BIMMessage message) {
            BIMLog.i(TAG,"onReceiveMessage message: "+message.getUuid() +" type: "+message.getMsgType());
            if (bimConversation != null && bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {

                typingCheckHandler.removeMessages(MSG_WHAT_CHECK_TYPING);
                typingCheckHandler.removeMessages(MSG_WHAT_CHECK_RECORDING);
                tvTitle.setText(titleName);
            }
        }

        @Override
        public void onSendMessage(BIMMessage message) {

        }

        @Override
        public void onDeleteMessage(BIMMessage message) {

        }

        @Override
        public void onRecallMessage(BIMMessage message) {

        }

        @Override
        public void onUpdateMessage(BIMMessage message) {

        }

        @Override
        public void onReceiveMessagesReadReceipt(List<BIMMessageReadReceipt> receiptList) {

        }

        @Override
        public void onReceiveReadReceipt(List<BIMReadReceipt> readReceiptList) {

        }

        @Override
        public void onConversationClearMessage(List<String> conversationIdList) {

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
        BIMUIClient.getInstance().removeP2PMessageListener(bimp2PMessageListener);
        BIMUIClient.getInstance().removeMessageListener(messageListener);
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
        messageListFragment.setOnPortraitClickListener(uid -> {
            BIMUIClient.getInstance().getModuleStarter().startProfileModule(this, uid, conversationId);
        });
        messageListFragment.setOnInputListener(new VEInPutView.OnInputListener() {
            @Override
            public void onSendClick(String text, BIMMessage refMessage, List<Long> mentionIdList) {

            }

            @Override
            public void onSendEditClick(String text, BIMMessage editMessage, List<Long> mentionIdList) {

            }

            @Override
            public void onEditTextChanged(String text) {
                if (!TextUtils.isEmpty(text) && bimConversation != null && bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                    sendTextTypingP2PMessage();
                }
            }
        });
        messageListFragment.setOnAudioRecordListener(new VoiceInputButton.OnAudioRecordListener() {
            @Override
            public void onStart() {
                typingCheckHandler.sendEmptyMessage(MSG_WHAT_SEND_RECODING);
            }

            @Override
            public void onCancel() {
                typingCheckHandler.removeMessages(MSG_WHAT_SEND_RECODING);
            }

            @Override
            public void onSuccess(String path) {
                typingCheckHandler.removeMessages(MSG_WHAT_SEND_RECODING);
            }
        });
        messageListFragment.setOnReadReceiptClickListener(bimMessage -> {
            if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                BIMUIClient.getInstance().getModuleStarter().startReadReceiptListActivity(BIMMessageListActivity.this, bimMessage.getUuid());
            }
        });
        getFragmentManager().beginTransaction().replace(R.id.message_list_container, messageListFragment).commit();
    }

    private void refreshConversation() {
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
                    BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(conversation.getOppositeUserID(), new BIMResultCallback<BIMUIUser>() {
                        @Override
                        public void onSuccess(BIMUIUser user) {
                            titleName = BIMUINameUtils.getShowName(user);
                            tvTitle.setText(titleName);
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {

                        }
                    });
                } else if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT
                        || bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LITE_LIVE_CHAT) {
                    titleName = getGroupName(conversation);
                    tvTitle.setText(titleName);
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
                boolean isDeleteConversation = data.getBooleanExtra(ModuleStarter.MODULE_IS_DELETE_LOCAL, false);
                if (isDeleteConversation) {
                    finish();
                }
            }
        }
    }

    private void sendTextTypingP2PMessage(){
        BIMP2PTypingElement typingElement = new BIMP2PTypingElement();
        Map<String,String> fakeExt = new HashMap<>();
        fakeExt.put("fakkey","fakevalue");
        typingElement.setMessageType(BIMMessageType.BIM_MESSAGE_TYPE_TEXT.getValue());
        typingElement.setExt(fakeExt);
        BIMMessage message = BIMUIClient.getInstance().createP2PMessage(typingElement);
        BIMUIClient.getInstance().sendP2PMessage(message, conversationId, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                BIMLog.i(TAG, "sendP2PMessage success() messageType:" + typingElement.getMessageType());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "sendP2PMessage failed code messageType: " + typingElement.getMessageType());
            }
        });
    }

    private void sendAudioTypingP2PMessage(){
        BIMP2PTypingElement recordingElement = new BIMP2PTypingElement();
        Map<String,String> fakeExt = new HashMap<>();
        fakeExt.put("fakkey","fakevalue");
        recordingElement.setMessageType(BIMMessageType.BIM_MESSAGE_TYPE_AUDIO.getValue());
        recordingElement.setExt(fakeExt);
        BIMMessage message = BIMUIClient.getInstance().createP2PMessage(recordingElement);
        List<Long> uidList = null;
        if (bimConversation != null) {
            uidList = Collections.singletonList(bimConversation.getOppositeUserID());
        }
        BIMUIClient.getInstance().sendP2PMessage(message, conversationId, uidList, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                BIMLog.i(TAG, "sendP2PMessage success() messageType:" + recordingElement.getMessageType());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "sendP2PMessage failed code messageType: " + recordingElement.getMessageType());
            }
        });
    }

    public static String getGroupName(BIMConversation conversation) {
        String name = conversation.getName();
        if (TextUtils.isEmpty(name)) {
            name = "未命名群聊";
        }
        return name;
    }
}
