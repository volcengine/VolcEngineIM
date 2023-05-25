package com.bytedance.im.app.live.chatRoom;

import static android.app.Activity.RESULT_OK;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.live.detail.VELiveDetailActivity;
import com.bytedance.im.app.login.data.UserMock;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.BIMLiveConversationListener;
import com.bytedance.im.live.api.BIMLiveGroupMemberEventListener;
import com.bytedance.im.live.api.BIMLiveMessageListener;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageAdapter;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.widget.VEInPutView;
import com.bytedance.im.ui.message.convert.manager.BIMMessageManager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VELiveGroupMessageListFragment extends Fragment {
    private static String TAG = "VELiveGroupMessageListFragment";
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";
    private static final String EXT_NICK_NAME = "a:live_group_nick_name";
    public static final int REQUEST_EDIT_DETAIL = 0;
    private View ivMore;
    private TextView tvTitle;
    private TextView tvOnlineNum;
    private BIMConversation bimConversation;
    private RecyclerView recyclerView;
    private BIMMessageAdapter adapter;
    private BIMMessage earliestMessage;
    private Boolean hasMore = false;
    private Boolean isSyncing = false;
    private VELiveGroupInputView inPutView;

    private long conversationShortId = -1L;
    private BIMLiveExpandService service;

    private BIMLiveMessageListener messageListener = new BIMLiveMessageListener() {
        public void onReceiveMessage(BIMMessage message) {
            BIMLog.i(TAG, "onReceiveMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            //更新本地数据
            if (message.getExtra() != null) {
                String nickName = message.getExtra().get(EXT_NICK_NAME);
                if (!TextUtils.isEmpty(nickName)) {
                    UserMock.getInstance().updateName(message.getSenderUID(), nickName);
                }
            }
            if (bimConversation != null && message.getConversationShortID() == bimConversation.getConversationShortID()) {
                if (adapter.appendOrUpdate(message) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }
        }

        public void onSendMessage(BIMMessage message) {
            BIMLog.i(TAG, "onSendMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (bimConversation != null && message.getConversationShortID() == bimConversation.getConversationShortID()) {
                if (adapter.appendOrUpdate(message) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }
        }

        public void onDeleteMessage(BIMMessage message) {
            BIMLog.i(TAG, "onDeleteMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (bimConversation != null && message.getConversationShortID() == bimConversation.getConversationShortID()) {
                adapter.deleteMessage(message);
            }
        }

        public void onRecallMessage(BIMMessage message) {
            BIMLog.i(TAG, "onRecallMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationShortID() == bimConversation.getConversationShortID()) {
                adapter.appendOrUpdate(message);
            }
        }

        public void onUpdateMessage(BIMMessage message) {
            BIMLog.i(TAG, "onUpdateMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationShortID() == bimConversation.getConversationShortID()) {
                adapter.appendOrUpdate(message);
            }
        }
    };

    private BIMLiveGroupMemberEventListener memberEventListener = new BIMLiveGroupMemberEventListener() {
        @Override
        public void onMemberJoined(BIMConversation conversation, List<BIMMember> memberList) {
            BIMLog.i(TAG, "onMemberJoined() memberList: " + buildMemberLog(memberList));
            if(!isAdded())return;
            Toast.makeText(getActivity(), "成员加入: " + buildMemberLog(memberList), Toast.LENGTH_SHORT).show();

        }

        @Override
        public void onMemberLeave(BIMConversation conversation, List<BIMMember> memberList) {
            BIMLog.i(TAG, "onMemberLeave() memberList: " + buildMemberLog(memberList));
            if(!isAdded())return;
            Toast.makeText(getActivity(), "成员离开: " + buildMemberLog(memberList), Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onMemberKicked(BIMConversation conversation, List<BIMMember> memberList, long operatorID) {
            BIMLog.i(TAG, "onMemberKicked() memberList: "+buildMemberLog(memberList));
            if(!isAdded())return;
            Toast.makeText(getActivity(), "成员被踢: " + buildMemberLog(memberList), Toast.LENGTH_SHORT).show();
            if (memberList != null) {
                for (BIMMember member : memberList) {
                    if (member.getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                        Toast.makeText(getActivity(), "当前用户被踢: " + buildMemberLog(memberList), Toast.LENGTH_SHORT).show();
                        getActivity().finish();
                        break;
                    }
                }
            }
        }

        @Override
        public void onMemberOwnerChanged(BIMConversation conversation, long fromUID, long toUID) {
            BIMLog.i(TAG, "onMemberOwnerChanged() fromUID: " + fromUID + " toUID: " + toUID);
            if(!isAdded())return;
            Toast.makeText(getActivity(), "群主被 " + fromUID + " 转让给：" + toUID, Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onMemberSilent(BIMConversation conversation, List<BIMMember> memberSilentList, BIMBlockStatus status, long operatorId) {
            BIMLog.i(TAG, "onMemberSilent() 是否禁言:" + status + "操作人:" + operatorId + "用户列表: " + buildMemberLog(memberSilentList));
            if(!isAdded())return;
            Toast.makeText(getActivity(), "成员被禁言：" + buildMemberLog(memberSilentList), Toast.LENGTH_SHORT).show();

        }

        @Override
        public void onAllMemberSilent(BIMConversation conversation, BIMBlockStatus status, long operatorId) {
            BIMLog.i(TAG, "onAllMemberSilent() conversationID: " + conversation.getConversationID() + "status:" + status + "operatorId:" + operatorId);
            if(!isAdded())return;
            Toast.makeText(getActivity(), "会话被禁言：" + conversation.getConversationID(), Toast.LENGTH_SHORT).show();
        }
    };
    private BIMLiveConversationListener conversationListListener = new BIMLiveConversationListener() {
        @Override
        public void onConversationChanged(BIMConversation conversation) {
            BIMLog.i(TAG, "onConversationChanged() conversation:" + conversation.getConversationID());
            tvTitle.setText(conversation.getName());
            refreshOnlineNum(conversation.getOnLineMemberCount());
        }
    };

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        conversationShortId = getActivity().getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1);
        service = BIMClient.getInstance().getService(BIMLiveExpandService.class);
        service.addLiveGroupMessageListener(messageListener);
        service.addLiveGroupMemberListener(memberEventListener);
        service.addLiveConversationListener(conversationListListener);
        service.joinLiveGroup(conversationShortId, new BIMResultCallback<BIMConversation>() {

            @Override
            public void onSuccess(BIMConversation conversation) {
                Toast.makeText(getActivity(), "加入成功", Toast.LENGTH_SHORT).show();
                bimConversation = conversation;
                String draft = bimConversation.getDraftText();
                if (!TextUtils.isEmpty(draft) && TextUtils.isEmpty(inPutView.getmInputEt().getText())) {
                    inPutView.setEditDraft(draft);
                }
                tvTitle.setText(conversation.getName());
                refreshOnlineNum(conversation.getOnLineMemberCount());
            }

            public void onFailed(BIMErrorCode code) {
                if (code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_IS_BLOCK) {
                    Toast.makeText(getActivity(), "用户在进群黑名单!" , Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(getActivity(), "加入失败:" + code, Toast.LENGTH_SHORT).show();
                }
                getActivity().finish();
            }
        });
        BIMLog.i(TAG, "onCreate() conversationId: $conversationId");
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.ve_im_fragment_message_list, container, false);

        ivMore = v.findViewById(R.id.message_list_more);
        tvTitle = v.findViewById(R.id.message_list_title);
        tvOnlineNum = v.findViewById(R.id.live_group_online_num);
        v.findViewById(R.id.iv_back).setOnClickListener(view -> getActivity().finish());
        ivMore.setOnClickListener(view -> VELiveDetailActivity.startForResult(this, conversationShortId, REQUEST_EDIT_DETAIL));

        recyclerView = v.findViewById(R.id.message_list);
        inPutView = v.findViewById(R.id.inputView);
        adapter = new BIMMessageAdapter(new BIMMessageAdapter.OnMessageItemClickListener() {
            public void onPortraitClick(BIMMessage message) {
                Toast.makeText(getActivity(), "点击头像 uid:" + message.getSenderUID(), Toast.LENGTH_SHORT).show();
            }

            public void onResentClick(BIMMessage message) {
                Toast.makeText(getActivity(), "重发消息 uuid:" + message.getUuid(), Toast.LENGTH_SHORT).show();
                sendMessage(message);
            }
        }, new BIMMessageAdapter.OnMessageItemLongClickListener() {
            public boolean onLongMessageItemClick(View v, View msgContainer, BIMMessage message) {
                BIMLog.i(TAG, "onLongMessageItemClick() uuid: " + message.getUuid());
                //直播群客户端暂不支持消息操作
//                if (msgContainer != null && message != null) {
//                    showMessageOperationDialog(msgContainer, message);
//                }
                return true;
            }
        });
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity(), RecyclerView.VERTICAL, true));
        recyclerView.setItemAnimator(null);
        recyclerView.setAdapter(adapter);
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                boolean isSlideToBottom = isSlideToBottom(recyclerView);
                if (isSlideToBottom && hasMore) {
                    if (hasMore) {
                        loadData();
                    } else {
                        Toast.makeText(getActivity(), "没有更多了", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });
        loadData();
        initInputView();
        return v;
    }

    private void initInputView() {
        inPutView.setListener(new VEInPutView.OnInputListener() {
            public void onSendClick(String text) {
                BIMLog.i(TAG, "onSendClick() text: " + text);
                sendTextMessage(text);
            }

            public void onAtClick() {
                BIMLog.i(TAG, "onAtClick()");
            }

            public void onAudioStart() {
            }

            public void onAudioEnd() {
            }

            public void onAudioCancel() {
            }

            public void onSelectImageClick() {
            }

            public void onTakePhotoClick() {
            }

            public void onFileClick() {
            }

            public void onCustomClick() {
                sendCustomMessage();
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        inPutView.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        service.removeLiveGroupMessageListener(messageListener);
        service.removeLiveGroupMemberListener(memberEventListener);
        service.removeLiveConversationListener(conversationListListener);
        service.leaveLiveGroup(conversationShortId, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
            }

            @Override
            public void onFailed(BIMErrorCode code) {
            }
        });
    }

    private void loadData() {
        BIMLog.i(TAG, "loadData()");
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) {
            return false;
        } else {
            return recyclerView.computeVerticalScrollOffset() == 0;
        }
    }

    private void sendTextMessage(String text) {
        BIMMessage bimMessage = BIMClient.getInstance().createTextMessage(text);
        sendMessage(bimMessage);
    }

    private void sendCustomMessage() {
        BIMShareElement shareVEContent = new BIMShareElement();
        shareVEContent.setLink("https://www.volcengine.com/");
        shareVEContent.setText("火山引擎");
        BIMMessage customMessage = BIMClient.getInstance().createCustomMessage(BIMMessageManager.getInstance().encode(shareVEContent));
        sendMessage(customMessage);
    }

    private void sendMessage(BIMMessage msg) {
        if (msg == null) {
            Toast.makeText(getActivity(), "消息为空", Toast.LENGTH_SHORT).show();
            return;
        }
        if (bimConversation == null || bimConversation.isDissolved()) {
            Toast.makeText(getActivity(), "群聊已解散", Toast.LENGTH_SHORT).show();
            return;
        }
        BIMLog.i(TAG, "sendMessage() uuid: " + msg.getUuid());
        Map<String, String> nickNameExt = new HashMap<String, String>();
        nickNameExt.put(EXT_NICK_NAME, UserMock.getInstance().getUserInfo(BIMClient.getInstance().getCurrentUserID()).getNickName());
        msg.setExtra(nickNameExt);
        BIMClient.getInstance().getService(BIMLiveExpandService.class).sendLiveGroupMessage(msg, bimConversation, new BIMSendCallback() {

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                BIMLog.i(TAG, "sendMessage onSuccess() uuid: " + bimMessage.getUuid() + " thread:" + Thread.currentThread());
                if (adapter.appendOrUpdate(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                BIMLog.i(TAG, "sendMessage onError() uuid: " + bimMessage.getUuid() + " code: " + code + " thread:" + Thread.currentThread());
                if (adapter.appendOrUpdate(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
                String failedText = "发送失败:"+ code;
                if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_CONVERSATION_NOT_EXIST) {
                    failedText += "会话不存在";
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_USER_SILENT) {
                    failedText += "当前用户被禁言";
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_CONVERSATION_SILENT) {
                    failedText += "当前会话被禁言";
                } else {
                    failedText += code;
                }
                Toast.makeText(getActivity(), failedText, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void scrollBottom() {
        recyclerView.scrollToPosition(0);
    }

    private void refreshOnlineNum(long count) {
        BIMLog.i(TAG, "refreshOnlineNum count: " + count);
        if (null != tvOnlineNum) {
            tvOnlineNum.setText("" + count + "人");
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_EDIT_DETAIL && resultCode == RESULT_OK) {
            boolean isDelete = data.getBooleanExtra(VELiveDetailActivity.IS_DELETE_LOCAL, false);
            if (isDelete) {
                getActivity().finish();
            }
        }
    }

    private String buildMemberLog(List<BIMMember> list){
        String result = "empty";
        if (list != null) {
            StringBuilder builder = new StringBuilder("[");
            for (BIMMember member:list){
                builder.append(member.getUserID());
                builder.append(",");
            }
            if(!list.isEmpty()){
                return builder.substring(0, builder.length() - 1) + "]";
            }
        }
        return result;
    }
}