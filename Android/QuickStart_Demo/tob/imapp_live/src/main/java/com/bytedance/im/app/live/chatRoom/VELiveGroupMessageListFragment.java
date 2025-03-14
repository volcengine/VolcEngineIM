package com.bytedance.im.app.live.chatRoom;

import static android.app.Activity.RESULT_OK;

import android.app.Fragment;
import android.content.Intent;
import android.graphics.drawable.ColorDrawable;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;


import com.bytedance.im.app.live.LiveUserProvider;
import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.chatRoom.operation.VELiveMessageOptionPopWindow;
import com.bytedance.im.app.live.detail.VELiveDetailActivity;

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
import com.bytedance.im.live.api.enmus.BIMMessagePriority;
import com.bytedance.im.live.api.model.BIMLiveJoinGroupResult;
import com.bytedance.im.live.api.model.BIMLiveMessageListResult;
import com.bytedance.im.live.api.model.MemberUpdateInfo;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.BIMMessageRecyclerView;
import com.bytedance.im.ui.message.adapter.BIMMessageAdapter;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.widget.input.VEInPutView;
import com.bytedance.im.ui.message.adapter.ui.widget.input.audio.VoiceInputButton;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.CustomToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.FileToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.ImageToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.PhotoTooBtn;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;
import com.bytedance.im.ui.utils.media.MediaInfo;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VELiveGroupMessageListFragment extends Fragment {
    private static String TAG = "VELiveGroupMessageListFragment";
    public static String CONVERSATION_SHORT_ID = "conversation_short_id";
    public static String START_TYPE = "start_type";
    public static final String ALIAS = "alias";
    public static final String AVATAR_URL = "avatar_url";
    private static final String EXT_ALIAS_NAME = "a:live_group_member_alias_name";
    private static final String EXT_AVATAR_URL = "a:live_group_member_avatar_url";
    private static final String CHECK_MSG_KEY = "s:send_response_check_msg";
    private static final String CHECK_CODE_KEY = "s:send_response_check_code";
    public static final int REQUEST_EDIT_DETAIL = 0;
    public static final int TYPE_SKIP_UPDATE_MY_MEMBER_INFO = 0;
    public static final int TYPE_UPDATE_MY_MEMBER_INFO = 1;
    private int startType = TYPE_SKIP_UPDATE_MY_MEMBER_INFO;
    private View ivMore;
    private TextView tvTitle;
    private TextView tvOnlineNum;
    private BIMConversation bimConversation;
    private BIMMessageRecyclerView recyclerView;
    private BIMMessageAdapter adapter;

    private VEInPutView inPutView;
    private long conversationShortId = -1L;
    private BIMLiveExpandService service;
    private BIMMessagePriority messagePriority = BIMMessagePriority.NORMAL;
    private Handler getOnlineHandler = new Handler();
    private VELiveMessageOptionPopWindow msgOptionMenu;
    private Boolean hasMore = false;
    private Boolean isSyncing = false;
    private long earliestCursor; //最旧的消息游标
    public LiveUserProvider liveUserProvider;

    private BIMLiveMessageListener messageListener = new BIMLiveMessageListener() {
        public void onReceiveMessage(BIMMessage message) {
            BIMLog.i(TAG, "onReceiveMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            //更新本地数据
            cacheMemberInfo(message, false);
            if (bimConversation != null && message.getConversationShortID() == bimConversation.getConversationShortID()) {
                if (adapter.appendOrUpdate(message) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }
        }

        public void onSendMessage(BIMMessage message) {
            BIMLog.i(TAG, "onSendMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            cacheMemberInfo(message, false);
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

        public void onUpdateMessage(BIMMessage message) {
            BIMLog.i(TAG, "onUpdateMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            cacheMemberInfo(message, false);
            if (message.getConversationShortID() == bimConversation.getConversationShortID()) {
                adapter.appendOrUpdate(message);
            }
        }
    };

    private BIMLiveGroupMemberEventListener memberEventListener = new BIMLiveGroupMemberEventListener() {

        @Override
        public void onMemberKicked(BIMConversation conversation, List<BIMMember> memberList, long operatorID) {
            BIMLog.i(TAG, "onMemberKicked() memberList: " + buildMemberLog(memberList));
            if (!isAdded()) return;
            boolean isSelfKicked = false;
            if (memberList != null) {
                for (BIMMember member : memberList) {
                    if (member.getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                        toast("当前用户被踢: " + buildMemberLog(memberList));
                        isSelfKicked = true;
                        getActivity().finish();
                        break;
                    }
                }
            }
            if (!isSelfKicked) {
                toast("成员被踢: " + buildMemberLog(memberList));
            }
        }

        @Override
        public void onMemberKicked(BIMConversation conversation, List<BIMMember> memberList, String operatorIDString) {
            BIMLog.i(TAG, "onMemberKickedByStringUid() memberList: " + buildMemberUidStringLog(memberList) + " operatorIDString: " + operatorIDString);
            if (!isAdded()) return;
            boolean isSelfKicked = false;
            if (memberList != null) {
                for (BIMMember member : memberList) {
                    if (BIMClient.getInstance().getCurrentUserIDString().equals(member.getUserIDString()) ) {
                        toast("当前用户被踢: " + buildMemberUidStringLog(memberList));
                        isSelfKicked = true;
                        getActivity().finish();
                        break;
                    }
                }
            }
            if (!isSelfKicked) {
                toast("成员被踢: " + buildMemberUidStringLog(memberList));
            }
        }

        @Override
        public void onMemberOwnerChanged(BIMConversation conversation, long fromUID, long toUID) {
            BIMLog.i(TAG, "onMemberOwnerChanged() fromUID: " + fromUID + " toUID: " + toUID);
            if (!isAdded()) return;
            toast("群主被 " + fromUID + " 转让给：" + toUID);
        }

        @Override
        public void onMemberOwnerChanged(BIMConversation conversation, String fromUIDString, String toUIDString) {
            BIMLog.i(TAG, "onMemberOwnerChangedByStringUid() fromUID: " + fromUIDString + " toUID: " + toUIDString);
            if (!isAdded()) return;
            toast("群主被 " + fromUIDString + " 转让给：" + toUIDString);
        }

        @Override
        public void onMemberSilent(BIMConversation conversation, List<BIMMember> memberSilentList, BIMBlockStatus status, long operatorId) {
            BIMLog.i(TAG, "onMemberSilent() 是否禁言:" + status + "操作人:" + operatorId + "用户列表: " + buildMemberLog(memberSilentList));
        }

        @Override
        public void onMemberSilent(BIMConversation conversation, List<BIMMember> memberSilentList, BIMBlockStatus status, String operatorIdString) {
            BIMLog.i(TAG, "onMemberSilentByStringUid() 是否禁言:" + status + "操作人:" + operatorIdString + "用户列表: " + buildMemberUidStringLog(memberSilentList));
        }

        @Override
        public void onAllMemberSilent(BIMConversation conversation, BIMBlockStatus status, long operatorId) {
            BIMLog.i(TAG, "onAllMemberSilent() conversationID: " + conversation.getConversationID() + "status:" + status + "operatorId:" + operatorId);

        }

        @Override
        public void onAllMemberSilent(BIMConversation conversation, BIMBlockStatus status, String operatorIdString) {
            BIMLog.i(TAG, "onAllMemberSilentByStringUid() conversationID: " + conversation.getConversationID() + "status:" + status + "operatorIdString:" + operatorIdString);
        }

        @Override
        public void onAddAdmin(BIMConversation conversation, List<BIMMember> adminList, long operatorId) {
            BIMLog.i(TAG, "onAddAdmin() conversationID: " + conversation.getConversationID() + "operatorId:" + operatorId);
        }

        @Override
        public void onAddAdmin(BIMConversation conversation, List<BIMMember> adminList, String operatorIdString) {
            BIMLog.i(TAG, "onAddAdminByStringUid() conversationID: " + conversation.getConversationID()+ " uidList:" +buildMemberUidStringLog(adminList) + " operatorId:" + operatorIdString);

        }

        @Override
        public void onRemoveAdmin(BIMConversation conversation, List<BIMMember> adminList, long operatorId) {
            BIMLog.i(TAG, "onRemoveAdmin() conversationID: " + conversation.getConversationID() + "operatorId:" + operatorId);
        }


        @Override
        public void onRemoveAdmin(BIMConversation conversation, List<BIMMember> adminList, String operatorIdString) {
            BIMLog.i(TAG, "onRemoveAdminByStringUid() conversationID: " + conversation.getConversationID() +" uidList:" +buildMemberUidStringLog(adminList) + " operatorIdStr:" + operatorIdString);
        }

        @Override
        public void onMemberInfoChanged(BIMConversation conversation, BIMMember member) {
            BIMLog.i(TAG, "onMemberInfoChanged() conversationID: " + conversation.getConversationID() + "operatorId:" + member.getUserID());
            liveUserProvider.cacheLiveUserInfo(new LiveUserProvider.LiveUserInfo(member.getUserID(), member.getUserIDString(), member.getAlias(), member.getAvatarUrl()));
            adapter.notifyDataSetChanged();
        }

        @Override
        public void onBatchMemberInfoChanged(BIMConversation conversation, List<BIMMember> members) {
            BIMLog.i(TAG, "onMemberInfoChanged() conversationID: " + conversation.getConversationID());
            for (BIMMember member : members) {
                liveUserProvider.cacheLiveUserInfo(new LiveUserProvider.LiveUserInfo(member.getUserID(), member.getUserIDString(), member.getAlias(), member.getAvatarUrl()));
            }
            adapter.notifyDataSetChanged();
        }
    };
    private BIMLiveConversationListener conversationListListener = new BIMLiveConversationListener() {
        @Override
        public void onConversationChanged(BIMConversation conversation) {
            BIMLog.i(TAG, "onConversationChanged() conversation:" + conversation.getConversationID());
            bimConversation = conversation;
            tvTitle.setText(conversation.getName());
            refreshOnlineNum(conversation.getOnLineMemberCount());
        }
    };

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        liveUserProvider = new LiveUserProvider();
        conversationShortId = getActivity().getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1);
        int startType = getActivity().getIntent().getIntExtra(START_TYPE, TYPE_SKIP_UPDATE_MY_MEMBER_INFO);
        String alias = getActivity().getIntent().getStringExtra(ALIAS);
        String avatarUrl = getActivity().getIntent().getStringExtra(AVATAR_URL);
        service = BIMClient.getInstance().getService(BIMLiveExpandService.class);
        service.addLiveGroupMessageListener(messageListener);
        service.addLiveGroupMemberListener(memberEventListener);
        service.addLiveConversationListener(conversationListListener);
        MemberUpdateInfo memberUpdateInfo = new MemberUpdateInfo();
        memberUpdateInfo.setAvatarUrl(avatarUrl);
        memberUpdateInfo.setAlias(alias);
        if (startType == TYPE_UPDATE_MY_MEMBER_INFO) {
            //加入群组，并设置个人资料
            service.joinLiveGroup(conversationShortId, memberUpdateInfo, new BIMResultCallback<BIMLiveJoinGroupResult>() {

                @Override
                public void onSuccess(BIMLiveJoinGroupResult bimLiveJoinGroupResult) {
                    joinSuccess(bimLiveJoinGroupResult);
                }

                public void onFailed(BIMErrorCode code) {
                    joinFailed(code);
                }
            });
        } else if (startType == TYPE_SKIP_UPDATE_MY_MEMBER_INFO) {
            //加入群组，不设置个人资料
            service.joinLiveGroup(conversationShortId, new BIMResultCallback<BIMLiveJoinGroupResult>() {
                @Override
                public void onSuccess(BIMLiveJoinGroupResult bimLiveJoinGroupResult) {
                    joinSuccess(bimLiveJoinGroupResult);
                }

                public void onFailed(BIMErrorCode code) {
                    joinFailed(code);
                }
            });
        }
        addUserListener();
        BIMLog.i(TAG, "onCreate() conversationId: $conversationId");
    }

    private void joinSuccess(BIMLiveJoinGroupResult bimLiveJoinGroupResult) {
        toast("加入成功");
        bimConversation = bimLiveJoinGroupResult.getConversation();
        initVeInputView(bimConversation);
        tvTitle.setText(bimConversation.getName());
        refreshOnlineNum(bimConversation.getOnLineMemberCount());
        earliestCursor = bimLiveJoinGroupResult.getJoinMessageCursor();
        BIMMember member = bimConversation.getCurrentMember();
        if (member != null) {
            liveUserProvider.cacheLiveUserInfo(new LiveUserProvider.LiveUserInfo(member.getUserID(), member.getUserIDString(), member.getAlias(), member.getAvatarUrl()));
        }
        loadData();
    }

    private void joinFailed(BIMErrorCode code) {
        if (isAdded()) {
            if (code == BIMErrorCode.BIM_SERVER_ADD_MEMBER_IS_BLOCK) {
                toast("用户在进群黑名单!");
            } else {
                toast("加入失败:" + code);
            }
            getActivity().finish();
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.ve_im_live_fragment_message_list, container, false);

        ivMore = v.findViewById(R.id.message_list_more);
        tvTitle = v.findViewById(R.id.message_list_title);
        tvOnlineNum = v.findViewById(R.id.live_group_online_num);
        v.findViewById(R.id.iv_back).setOnClickListener(view -> getActivity().finish());
        ivMore.setOnClickListener(view -> VELiveDetailActivity.startForResult(this, conversationShortId, REQUEST_EDIT_DETAIL));

        recyclerView = v.findViewById(R.id.message_list);
        inPutView = v.findViewById(R.id.inputView);
        adapter = new BIMMessageAdapter(conversationShortId+"",recyclerView, liveUserProvider, null, new BIMMessageAdapter.OnMessageItemClickListener() {
            public void onPortraitClick(BIMMessage message) {
                BIMUIClient.getInstance().getModuleStarter().startProfileModule(getActivity(), message.getSenderUID());
            }

            public void onResentClick(BIMMessage message) {
                toast("重发消息 uuid:" + message.getUuid());
                sendMessage(message);
            }

            @Override
            public void onReadReceiptClick(BIMMessage message) {

            }
        }, new BIMMessageAdapter.OnMessageItemLongClickListener() {
            public boolean onLongMessageItemClick(View v, View msgContainer, BIMMessage message) {
                BIMLog.i(TAG, "onLongMessageItemClick() uuid: " + message.getUuid());
                //直播群客户端暂不支持消息操作
                if (msgContainer != null && message != null) {
                    showMessageOperationDialog(msgContainer, message);
                }
                return true;
            }
        }, new BIMMessageAdapter.OnRefreshListener() {
            @Override
            public void refreshMediaMessage(BIMMessage bimMessage, BIMResultCallback<BIMMessage> callback) {
                BIMClient.getInstance().getService(BIMLiveExpandService.class).refreshLiveGroupMediaMessage(bimMessage, callback);
            }
        }, null);
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
                        toast("没有更多历史消息了");
                    }
                }
            }

            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (isSlideToBottom(recyclerView) && newState == 0 && !hasMore) {
                    toast("没有更多历史消息了");
                }
            }
        });
        recyclerView.setOnDispatchListener(new BIMMessageRecyclerView.OnDispatchListener() {
            @Override
            public boolean dispatchTouchEvent(MotionEvent ev) {
                inPutView.reset();
                return false;
            }
        });
        startGetOnlineCount();
        return v;
    }


    private void sendFileMessage(Uri uri, String path, String name, long length) {
        BIMMessage bimMessage = BIMClient.getInstance().createFileMessage(uri, path, name, length);
        sendMessage(bimMessage);
    }

    private void sendVoiceMessage(String path) {
        File file = new File(path);
        if (!file.exists()) {
            return;
        }
        BIMLog.i(TAG, "sendVoiceMessage() length: " + file.length() + " path: " + path);
        long duration = 0;
        try {
            MediaMetadataRetriever retriever = new MediaMetadataRetriever();
            retriever.setDataSource(path);
            duration = Long.parseLong(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)) / 1000;
        } catch (Exception e) {
            BIMLog.i(TAG, "e: " + Log.getStackTraceString(e));
        }
        if (duration < 1) {
            toast("录制时间太短，录音失败");
            return;
        }

        Uri outputUri = Uri.fromFile(new File(path));
        BIMMessage message = BIMClient.getInstance().createAudioMessage(path, outputUri);
        sendMessage(message);
    }

    private void sendImageMessage(String filePath, Uri uri) {
        BIMMessage bimMessage = BIMClient.getInstance().createImageMessage(filePath, uri);
        sendMessage(bimMessage);
    }

    private void sendVideoMessage(String filePath, Uri uri) {
        BIMMessage bimMessage = BIMClient.getInstance().createVideoMessage(filePath, uri);
        sendMessage(bimMessage);
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
        getOnlineHandler.removeCallbacks(getOnLineCountRunnable);
        removeUserListener();
    }

    private void loadData() {
        BIMLog.i(TAG, "loadData() isSyncing:" + isSyncing);
        if (isSyncing) {
            return;
        }
        isSyncing = true;
        if (isAdded()) {
            toast("加载更多历史消息中...");
        }
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupHistoryMessageList(conversationShortId, earliestCursor, 20, new BIMResultCallback<BIMLiveMessageListResult>() {
            @Override
            public void onSuccess(BIMLiveMessageListResult bimLiveMsgBodyListResult) {
                BIMLog.i(TAG, "loadData() success result: " + bimLiveMsgBodyListResult);
                earliestCursor = bimLiveMsgBodyListResult.getNextCursor();
                hasMore = bimLiveMsgBodyListResult.isHasMore();
                List<BIMMessage> list = bimLiveMsgBodyListResult.getMessageList();
                if (list != null) {
                    for (BIMMessage message : list) {
                        cacheMemberInfo(message, true);
                        adapter.inertHeadOrUpdate(message);
                    }
                }
                isSyncing = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "loadData() failed");
                if (isAdded()) {
                    toast("加载失败 code: " + code);
                }
                isSyncing = false;
            }
        });
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
        shareVEContent.setText("欢迎体验火山引擎即时通信IM Demo");
        BIMMessage customMessage = BIMUIClient.getInstance().createCustomMessage(shareVEContent);
        sendMessage(customMessage);
    }

    private void sendMessage(BIMMessage msg) {
        if (msg == null) {
            toast("消息为空");
            return;
        }
        if (bimConversation == null || bimConversation.isDissolved()) {
            toast("群聊已解散");
            return;
        }
        BIMLog.i(TAG, "sendMessage() uuid: " + msg.getUuid());
        BIMMember bimMember = bimConversation.getCurrentMember();
        Map<String, String> ext = new HashMap<String, String>();
        String alias = bimMember.getAlias();
        String avatarUrl = bimMember.getAvatarUrl();
        if (alias != null) {
            ext.put(EXT_ALIAS_NAME, alias);
        }
        if (avatarUrl != null) {
            ext.put(EXT_AVATAR_URL, avatarUrl);
        }
        msg.setExtra(ext);
        BIMClient.getInstance().getService(BIMLiveExpandService.class).sendLiveGroupMessage(msg, bimConversation, messagePriority, new BIMSendCallback() {
            @Override
            public void onSaved(BIMMessage bimMessage) {
                if (adapter.appendOrUpdate(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                BIMLog.i(TAG, "sendMessage onSuccess() uuid: " + bimMessage.getUuid() + " thread:" + Thread.currentThread());
                if (adapter.appendOrUpdate(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }

            @Override
            public void onProgress(BIMMessage message, int progress) {
                BIMLog.i(TAG, "sendMessage onProgress() uuid: " + message.getUuid() + " progress: " + progress + " thread:" + Thread.currentThread());
                if (adapter.appendOrUpdate(message) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                BIMLog.i(TAG, "sendMessage onError() uuid: " + bimMessage.getUuid() + " code: " + code + " thread:" + Thread.currentThread());
                if (code == BIMErrorCode.BIM_UPLOAD_FILE_SIZE_OUT_LIMIT) {
                    toast("消息发送失败：文件大小超过限制");
                    return;
                }
                if (adapter.appendOrUpdate(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
                String failedText = "消息发送失败: ";
                if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_CONVERSATION_NOT_EXIST) {
                    failedText += "会话不存在";
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_USER_SILENT) {
                    failedText += "当前用户被禁言";
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_CONVERSATION_SILENT) {
                    failedText += "当前会话被禁言";
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_MESSAGE_TOO_LARGE) {
                    failedText += "消息体过大";
                } else if (code == BIMErrorCode.BIM_SERVER_MESSAGE_FREQUENCY) {
                    failedText += "发送消息过于频繁";
                } else if (bimMessage.getCheckMessage() != null) {
                    failedText = "checkCode:" + bimMessage.getCheckCode() + ", checkMessage:" + bimMessage.getCheckMessage();
                } else {
                    failedText += code.getValue();
                }
                toast(failedText);
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
        if (resultCode == RESULT_OK) {
            inPutView.onActivityResult(requestCode, resultCode, data);
            if (requestCode == REQUEST_EDIT_DETAIL) {
                boolean isDelete = data.getBooleanExtra(VELiveDetailActivity.IS_DELETE_LOCAL, false);
                if (isDelete) {
                    getActivity().finish();
                }
            }
        }
    }

    private String buildMemberLog(List<BIMMember> list) {
        String result = "empty";
        if (list != null) {
            StringBuilder builder = new StringBuilder("[");
            for (BIMMember member : list) {
                builder.append(member.getUserID());
                builder.append(",");
            }
            if (!list.isEmpty()) {
                return builder.substring(0, builder.length() - 1) + "]";
            }
        }
        return result;
    }

    private String buildMemberUidStringLog(List<BIMMember> list) {
        String result = "empty";
        if (list != null) {
            StringBuilder builder = new StringBuilder("[");
            for (BIMMember member : list) {
                builder.append(member.getUserIDString());
                builder.append(",");
            }
            if (!list.isEmpty()) {
                return builder.substring(0, builder.length() - 1) + "]";
            }
        }
        return result;
    }

    /**
     * 循环请求在线人数
     */
    private void startGetOnlineCount() {
        getOnlineHandler.removeCallbacks(getOnLineCountRunnable);
        getOnlineHandler.post(getOnLineCountRunnable);
    }

    private Runnable getOnLineCountRunnable = new Runnable() {
        @Override
        public void run() {
            BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupOnLineCount(conversationShortId, new BIMResultCallback<Long>() {
                @Override
                public void onSuccess(Long count) {
                    refreshOnlineNum(count);
                    getOnlineHandler.postDelayed(getOnLineCountRunnable, 2000);
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
    };

    private void showMessageOperationDialog(View view, BIMMessage message) {
        if (bimConversation == null) return;
        if (msgOptionMenu != null) {
            if (msgOptionMenu.isShowing()) {
                msgOptionMenu.dismiss();
            }
        } else {
            msgOptionMenu = new VELiveMessageOptionPopWindow(getActivity(), this);
        }
        msgOptionMenu.setBimMessageAndShow(view, message);
    }

    private void cacheMemberInfo(BIMMessage message, boolean fromLoadOlder) {
        if (message.getExtra() != null) {
            String liveAliasName = message.getExtra().get(EXT_ALIAS_NAME);
            String avatarUrl = message.getExtra().get(EXT_AVATAR_URL);
            long uid = message.getSenderUID();
            String uidStr = message.getSenderUIDString();
            LiveUserProvider.LiveUserInfo liveUserInfo = new LiveUserProvider.LiveUserInfo(uid, uidStr, liveAliasName, avatarUrl);
            if (fromLoadOlder) {
                if (!liveUserProvider.isCachedLiveInfo(uid)) {
                    liveUserProvider.cacheLiveUserInfo(liveUserInfo);
                }
            } else {
                liveUserProvider.cacheLiveUserInfo(liveUserInfo);
            }
            adapter.notifyDataSetChanged();
        }
    }

    private void showPriorityWindow() {
        PopupWindow popupWindow = new PopupWindow(getActivity());
        View v = LayoutInflater.from(getActivity()).inflate(R.layout.ve_im_live_input_priority_window_layout, null, false);
        View.OnClickListener listener = v1 -> {
            int id = v1.getId();
            if (id == R.id.high) {
                messagePriority = BIMMessagePriority.HIGH;
                inPutView.getTvPriority().setText("高");
            } else if (id == R.id.normal) {
                messagePriority = BIMMessagePriority.NORMAL;
                inPutView.getTvPriority().setText("普通");
            } else if (id == R.id.low) {
                messagePriority = BIMMessagePriority.LOW;
                inPutView.getTvPriority().setText("低");
            }
            popupWindow.dismiss();
        };
        v.findViewById(R.id.high).setOnClickListener(listener);
        v.findViewById(R.id.normal).setOnClickListener(listener);
        v.findViewById(R.id.low).setOnClickListener(listener);
        popupWindow.setContentView(v);
        popupWindow.setBackgroundDrawable(new ColorDrawable(0));
        int width = getActivity().getResources().getDimensionPixelSize(R.dimen.ve_live_input_pop_priority_width);
        int height = getActivity().getResources().getDimensionPixelSize(R.dimen.ve_live_input_pop_priority_height);
        popupWindow.setHeight(height);
        popupWindow.setWidth(width);
        popupWindow.setOutsideTouchable(true);
        popupWindow.showAsDropDown(inPutView.getTvPriority(), 0, -1 * (height + inPutView.getTvPriority().getHeight() + 20), Gravity.BOTTOM);
    }


    private OnUserInfoUpdateListener listener;

    /**
     * 好友信息更新监听
     */
    public void addUserListener() {
        if (listener == null) {
            listener = new OnUserInfoUpdateListener() {
                @Override
                public void onUpdate(long uid, BIMUIUser user) {
                    if (adapter != null) {
                        adapter.notifyDataSetChanged();
                    }
                }
            };
        }
        liveUserProvider.addUserUpdateListener(listener);
    }

    public void removeUserListener() {
        if (listener != null) {
            liveUserProvider.removeUserUpdateListener(listener);
        }
    }

    private void toast(String msg) {
        if (isAdded()) {
            Toast.makeText(getActivity(), msg, Toast.LENGTH_SHORT).show();
        }
    }

    // 初始化输入面板
    private void initVeInputView(BIMConversation conversation) {
        inPutView.initFragment(this, conversation, true, initToolbtns(), new VoiceInputButton.OnAudioRecordListener() {
            @Override
            public void onStart() {

            }

            @Override
            public void onCancel() {

            }

            @Override
            public void onSuccess(String path) {
                sendVoiceMessage(path);
            }
        }, new VEInPutView.OnInputListener() {
            @Override
            public void onSendClick(String text, BIMMessage refMessage, List<Long> mentionIdList) {
                sendTextMessage(text);
            }

            @Override
            public void onSendEditClick(String text, BIMMessage editMessage, List<Long> mentionIdList) {

            }

            @Override
            public void onEditTextChanged(String text) {

            }
        });
        inPutView.getTvPriority().setOnClickListener(v1 -> {
            showPriorityWindow();
        });
    }

    //工具栏按钮
    private List<BaseToolBtn> initToolbtns() {
        List<BaseToolBtn> toolBtnList = new ArrayList<>();
        toolBtnList.add(new ImageToolBtn(new BIMResultCallback<MediaInfo>() {
            @Override
            public void onSuccess(MediaInfo mediaInfo) {
                if (mediaInfo.getFileType() == MediaInfo.MEDIA_TYPE_IMAGE) {
                    sendImageMessage(mediaInfo.getFilePath(), mediaInfo.getUri());
                } else {
                    sendVideoMessage(mediaInfo.getFilePath(), mediaInfo.getUri());
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }));
        toolBtnList.add(new PhotoTooBtn(new BIMResultCallback<MediaInfo>() {
            @Override
            public void onSuccess(MediaInfo info) {
                sendImageMessage(info.getFilePath(), info.getUri());
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }));
        toolBtnList.add(new FileToolBtn(new BIMResultCallback<FileToolBtn.SelectFileInfo>() {
            @Override
            public void onSuccess(FileToolBtn.SelectFileInfo info) {
                sendFileMessage(info.getUri(), info.getPath(), info.getName(), info.getLength());
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }));
        toolBtnList.add(new CustomToolBtn(new BIMResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
                sendCustomMessage();
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }));
        return toolBtnList;
    }

}