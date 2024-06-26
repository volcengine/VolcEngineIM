package com.bytedance.im.ui.message;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.LinearSmoothScroller;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageNewPropertyModifyType;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMDownloadCallback;
import com.bytedance.im.core.api.interfaces.BIMMessageListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.interfaces.BIMStreamMessageListener;
import com.bytedance.im.core.api.model.BIMConvTag;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGetMessageOption;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageListResult;
import com.bytedance.im.core.api.model.BIMMessageNewPropertyModify;
import com.bytedance.im.core.api.model.BIMMessageReadReceipt;
import com.bytedance.im.core.api.model.BIMReadReceipt;
import com.bytedance.im.core.model.LocalPropertyItem;
import com.bytedance.im.core.model.Message;
import com.bytedance.im.core.model.inner.msg.BIMTextElement;
import com.bytedance.im.core.service.BIMINService;
import com.bytedance.im.core.service.manager.BIMMessageManager;
import com.bytedance.im.core.stream.interfaces.StreamMessageListener;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.emoji.EmojiInfo;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageAdapter;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.widget.input.VEInPutView;
import com.bytedance.im.ui.message.adapter.ui.widget.input.audio.VoiceInputButton;
import com.bytedance.im.ui.message.adapter.ui.widget.input.measure.KeyBoardHeightHelper;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.CustomToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.FileToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.ImageToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.PhotoTooBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.BIMMessageOptionPopupWindow;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;
import com.bytedance.im.ui.utils.BIMUIUtils;
import com.bytedance.im.ui.utils.media.MediaInfo;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;

public class BIMMessageListFragment extends Fragment {
    private static List<BaseToolBtn> customToolBtnList = new ArrayList<>();
    private static final String TAG = "VEMessageListFragment";
    public static final String TARGET_CID = "target_cid";
    public static final String TARGET_MSG_ID = "target_msg_id";
    public static final String ACTION = "com.bytedance.im.page.message_list";
    public static final String ACTION_PORTRAIT_CLICK = "com.bytedance.im.page.message_list.portrait_click";
    private String conversationId;
    private BIMConversation bimConversation;
    private BIMMessageRecyclerView recyclerView;
    private BIMMessageAdapter adapter;
    private BIMMessage earliestMessage = null;
    private BIMMessage lastMessage = null;
    private boolean olderHasMore = false;
    private boolean newerHasMore = false;
    private boolean isSyncingOlder = false;
    private boolean isSyncingNewer = false;
    private VEInPutView inPutView;

    private OnPortraitClickListener onPortraitClickListener;
    private VEInPutView.OnInputListener onInputListener;
    private VoiceInputButton.OnAudioRecordListener onAudioRecordListener;
    private OnReadReceiptClickListener onReadReceiptClickListener;
    private BIMMessageOptionPopupWindow msgOptionMenu;
    private String startMsgId;
    private BIMUserProvider userProvider;
    private boolean isShowKeyBoard = false;
    public interface OnPortraitClickListener{
        void onClick(long uid);
    }

    public interface OnReadReceiptClickListener{
        void onReadReceiptClick(BIMMessage bimMessage);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getActivity().getIntent();
        conversationId = intent.getStringExtra(TARGET_CID);
        startMsgId = intent.getStringExtra(BIMMessageListFragment.TARGET_MSG_ID);
        BIMLog.i(TAG, "onCreate() conversationId: " + conversationId + " startMsgId: " + startMsgId);
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        conversationId = getActivity().getIntent().getStringExtra(TARGET_CID);
        startMsgId = getActivity().getIntent().getStringExtra(BIMMessageListFragment.TARGET_MSG_ID);
        BIMLog.i(TAG, "onCreateView() conversationId: " + conversationId + " startMsgId: " + startMsgId);
        View v = inflater.inflate(R.layout.bim_im_fragment_message_list, container, false);
        recyclerView = v.findViewById(R.id.message_list);
        inPutView = v.findViewById(R.id.inputView);
        inPutView.setOnKeyboardListener(new KeyBoardHeightHelper.OnMeasureCompleteListener() {
            @Override
            public void onKeyBoardShow(int keyBoardHeight) {
                isShowKeyBoard = true;
            }

            @Override
            public void onKeyBoardHide() {
                isShowKeyBoard = false;
            }
        });
        userProvider = BIMUIClient.getInstance().getUserProvider(); //单聊
        adapter = new BIMMessageAdapter(recyclerView, userProvider, new BIMMessageAdapter.OnMessageItemClickListener() {
            @Override
            public void onPortraitClick(BIMMessage message) {
                if (onPortraitClickListener != null) {
                    onPortraitClickListener.onClick(message.getSenderUID());
                }
            }

            @Override
            public void onResentClick(BIMMessage message) {
                Toast.makeText(getActivity(), "重发消息 uuid:" + message.getUuid(), Toast.LENGTH_SHORT).show();
                sendMessage(message);
            }

            @Override
            public void onReadReceiptClick(BIMMessage message) {
                if (onReadReceiptClickListener != null) {
                    onReadReceiptClickListener.onReadReceiptClick(message);
                }
            }
        }, new BIMMessageAdapter.OnMessageItemLongClickListener() {
            @Override
            public boolean onLongMessageItemClick(View v, View msgContainer, BIMMessage message) {
                BIMLog.i(TAG, "onLongMessageItemClick() uuid: " + message.getUuid());
                if (bimConversation != null && bimConversation.isDissolved()) {
                    Toast.makeText(getActivity(), "群聊已解散", Toast.LENGTH_SHORT).show();
                    return true;
                }
                showMessageOperationDialog(msgContainer, message);
                return true;
            }
        }, new BIMMessageAdapter.OnRefreshListener() {
            @Override
            public void refreshMediaMessage(BIMMessage bimMessage, BIMResultCallback<BIMMessage> callback) {
                BIMClient.getInstance().refreshMediaMessage(bimMessage, callback);
            }
        }, new BIMMessageAdapter.OnDownloadListener() {
            @Override
            public void downLoadMessage(BIMMessage bimMessage, String url, boolean needNotify, BIMDownloadCallback callback) {
                BIMClient.getInstance().downloadFile(bimMessage, url, new BIMDownloadCallback() {
                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        adapter.insertOrUpdateMessage(bimMessage);
                        if (callback != null) {
                            callback.onSuccess(bimMessage);
                        }
                    }

                    @Override
                    public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                        if (needNotify) {
                            if (code == BIMErrorCode.BIM_DOWNLOAD_FILE_DUPLICATE) {
                                Toast.makeText(getActivity(), "下载中", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(getActivity(), "下载失败，请重试", Toast.LENGTH_SHORT).show();
                            }
                        }
                        if (callback != null) {
                            callback.onError(bimMessage, code);
                        }
                    }
                });
            }
        });
        refreshConversation();

        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity(), RecyclerView.VERTICAL, true));
        recyclerView.setItemAnimator(null);
        recyclerView.setAdapter(adapter);
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (dy == 0) return;
                boolean isSlideToBottom = isSlideToTop(recyclerView);
                boolean isSideTop = isSlideToBottom(recyclerView);
                BIMLog.i(TAG, "onScrolled() isSlideToBottom: " + isSlideToBottom + " olderHasMore:" + olderHasMore
                        + " isSideTop: " + isSideTop + " newerHasMore:" + newerHasMore);
                if (isSlideToBottom) {
                    if (olderHasMore) {
                        loadOlderData(null);
                    } else {
                        if (dy < 0) {
                            Toast.makeText(getActivity(), "历史没有更多了", Toast.LENGTH_SHORT).show();
                        }
                    }
                }
                if (isSideTop) {
                    if (newerHasMore) {
                        loadNewerData(null);
                    } else {
                        Toast.makeText(getActivity(), "最新没有更多了", Toast.LENGTH_SHORT).show();
                    }
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
        recyclerView.addOnChildAttachStateChangeListener(new RecyclerView.OnChildAttachStateChangeListener() {
            @Override
            public void onChildViewAttachedToWindow(@NonNull View view) {
                RecyclerView.ViewHolder viewHolder = recyclerView.getChildViewHolder(view);
                BIMMessage bimMessage = adapter.getMessage(viewHolder.getAdapterPosition());
                sendRedReceipt(bimMessage);
            }

            @Override
            public void onChildViewDetachedFromWindow(@NonNull View view) {

            }
        });

        BIMUIClient.getInstance().addMessageListener(receiveMessageListener);
        BIMClient.getInstance().addConversationListener(conversationListListener);
        BIMClient.getInstance().getService(BIMINService.class).subscribeConversationStreamMessage(conversationId, streamMessageListener);
        if (!TextUtils.isEmpty(startMsgId)) {
            newerHasMore = true;
            BIMClient.getInstance().getMessage(startMsgId, new BIMResultCallback<BIMMessage>() {
                @Override
                public void onSuccess(BIMMessage bimMessage) {
                    earliestMessage = bimMessage;
                    lastMessage = bimMessage;
                    initBothDirectData(bimMessage);
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        } else {
            initOlderDirection();
        }
        addUserListener();
        BIMClient.getInstance().markConversationMessagesRead(conversationId, null);
        return v;
    }
    private List<BaseToolBtn> initToolbtns() {
        List<BaseToolBtn> toolBtnList = new ArrayList<>();
        toolBtnList.add(new ImageToolBtn(new BIMResultCallback<MediaInfo>() {
            @Override
            public void onSuccess(MediaInfo mediaInfo) {
                if (mediaInfo.getFileType() == MediaInfo.MEDIA_TYPE_IMAGE) {
                    sendImageMessage(mediaInfo.getFilePath(),mediaInfo.getUri());
                } else {
                    sendVideoMessage(mediaInfo.getFilePath(),mediaInfo.getUri());
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }));
        toolBtnList.add(new PhotoTooBtn(new BIMResultCallback<MediaInfo>() {
            @Override
            public void onSuccess(MediaInfo info) {
                sendImageMessage(info.getFilePath(),info.getUri());
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
        toolBtnList.addAll(customToolBtnList);
        return toolBtnList;
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        BIMLog.i(TAG, "onConfigurationChanged() newConfig: " + newConfig);
    }

    private void refreshConversation() {
        BIMClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                String name = "";
                String draft = bimConversation.getDraftText();
                initInputView(conversation);
                if (!TextUtils.isEmpty(draft) && TextUtils.isEmpty(inPutView.getmInputEt().getText())) {
                    inPutView.setEditDraft(draft);
                }
                if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {  //仅支持单聊
                    BIMClient.getInstance().markConversationMessagesRead(conversationId, null);
                }
                adapter.updateConversation(bimConversation);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        refreshConversation();
        BIMClient.getInstance().markConversationRead(conversationId, null);
        if (isShowKeyBoard) {
            inPutView.postDelayed(() -> {
                EditText editText = inPutView.getmInputEt();
                BIMUIUtils.showKeyBoard(editText);
            }, 500);
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        BIMClient.getInstance().markConversationRead(conversationId, null);
        String draft = inPutView.getEditDraft();
        BIMClient.getInstance().setConversationDraft(draft, conversationId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        BIMUIClient.getInstance().removeMessageListener(receiveMessageListener);
        BIMClient.getInstance().removeConversationListener(conversationListListener);
        BIMINService biminService = BIMClient.getInstance().getService(BIMINService.class);
        if (biminService != null) {
            biminService.unSubscribeConversationStreamMessage(conversationId);
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        inPutView.onActivityResult(requestCode, resultCode, data);
        if (msgOptionMenu != null) {
            //长按弹窗处理
            msgOptionMenu.onActivityResult(requestCode, resultCode, data);
        }
    }

    /**
     * 从最新消息初始化
     */
    private void initOlderDirection() {
        BIMLog.i(TAG, "initOlderDirection()");
        loadOlderData(new BIMSimpleCallback() {
            @Override
            public void onSuccess() {

            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }); // 仅使用历史方向拉取
    }

    /**
     * 根据中间消息，两个方向拉取消息
     *
     * @param startMessage
     */
    private void initBothDirectData(BIMMessage startMessage) {
        BIMLog.i(TAG, "initBothDirectData()");
        adapter.insertOrUpdateMessage(startMessage); //先插入第一条锚点消息
        CountDownLatch countDownLatch = new CountDownLatch(2);
        loadOlderData(new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                checkInitAndScroll(countDownLatch, startMessage);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                checkInitAndScroll(countDownLatch, startMessage);
            }
        });
        loadNewerData(new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                checkInitAndScroll(countDownLatch, startMessage);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                checkInitAndScroll(countDownLatch, startMessage);
            }
        });
    }

    private void checkInitAndScroll(CountDownLatch countDownLatch, BIMMessage startMessage) {
        countDownLatch.countDown();
        if (countDownLatch.getCount() == 0) {
            int index = adapter.findIndex(startMessage);
            BIMLog.i(TAG, "checkInitAndScroll index:" + index);
            if (index > 0) {
                recyclerView.post(() -> {
                    RecyclerView.SmoothScroller smoothScroller = new CenterSmoothScroller(recyclerView.getContext());
                    smoothScroller.setTargetPosition(index);
                    recyclerView.getLayoutManager().startSmoothScroll(smoothScroller);
                });
            }
        }
    }

    private void loadMessageReceipt(List<BIMMessage> messageList) {
        BIMLog.i(TAG, "loadMessageReceipt()");
        if (messageList != null && !messageList.isEmpty()) {
            BIMClient.getInstance().getMessagesReadReceipt(messageList, new BIMResultCallback<List<BIMMessageReadReceipt>>() {
                @Override
                public void onSuccess(List<BIMMessageReadReceipt> messageReadReceipts) {
                    for (BIMMessageReadReceipt readReceipt: messageReadReceipts) {
                        adapter.insertOrUpdateMessage(readReceipt.getMessage());
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    BIMLog.e(TAG, "loadMessageReceipt failed");
                }
            });
        }
    }

    private void loadOlderData(BIMSimpleCallback loadOldCallback) {
        BIMLog.i(TAG, "loadOlderData()");
        if (isSyncingOlder) {
            return;
        }
        isSyncingOlder = true;
//        Toast.makeText(getActivity(), "加载更多历史消息中...", Toast.LENGTH_SHORT).show();
        BIMGetMessageOption option = new BIMGetMessageOption.Builder().isNeedServer(true).limit(20).anchorMessage(earliestMessage).build();
        if (earliestMessage != null) {
            BIMLog.i(TAG, "loadOlderData() earliestMessage:" + earliestMessage.getContentData());
        }
        BIMClient.getInstance().getHistoryMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
            @Override
            public void onSuccess(BIMMessageListResult bimMessageListResult) {
                BIMLog.i(TAG, "loadOlderData bimMessageListResult: " + bimMessageListResult + " thread:" + Thread.currentThread());
                adapter.addAllMessageList(bimMessageListResult.getMessageList());
                earliestMessage = bimMessageListResult.getAnchorMessage();
                olderHasMore = bimMessageListResult.isHasMore();
                BIMLog.i(TAG, "loadOlderData olderHasMore: " + olderHasMore);
                isSyncingOlder = false;
                if (loadOldCallback != null) {
                    loadOldCallback.onSuccess();
                }
                loadMessageReceipt(bimMessageListResult.getMessageList());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "getHistoryMessageList onFailed() code: " + code);
//                Toast.makeText(getActivity(), "出错了 code：" + code, Toast.LENGTH_SHORT).show();
                isSyncingOlder = false;
                if (loadOldCallback != null) {
                    loadOldCallback.onFailed(code);
                }
            }
        });
    }

    private void loadNewerData(BIMSimpleCallback loadNewCallback) {
        BIMLog.i(TAG, "loadNewerData()");
        if (isSyncingNewer) {
            return;
        }
        isSyncingNewer = true;
        BIMGetMessageOption option = new BIMGetMessageOption.Builder().isNeedServer(true).limit(20).anchorMessage(lastMessage).build();
        if (lastMessage != null) {
            BIMLog.i(TAG, "loadNewerData() lastMessage: " + lastMessage.getContentData());
        }
        BIMClient.getInstance().getNewerMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
            @Override
            public void onSuccess(BIMMessageListResult bimMessageListResult) {
                BIMLog.i(TAG, "loadNewerData bimMessageListResult: " + bimMessageListResult + " thread:" + Thread.currentThread());
                adapter.addAllMessageList(bimMessageListResult.getMessageList());
                lastMessage = bimMessageListResult.getAnchorMessage();
                newerHasMore = bimMessageListResult.isHasMore();
                isSyncingNewer = false;
                if (loadNewCallback != null) {
                    loadNewCallback.onSuccess();
                }
                loadMessageReceipt(bimMessageListResult.getMessageList());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "getNewerMessageList onFailed() code: " + code);
                isSyncingNewer = false;
                if (loadNewCallback != null) {
                    loadNewCallback.onFailed(code);
                }
            }
        });
    }

    /**
     * 滑动到顶部
     *
     * @param recyclerView
     * @return
     */
    private boolean isSlideToTop(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        return recyclerView.computeVerticalScrollOffset() == 0;
    }

    /**
     * 滑动到底部
     *
     * @param recyclerView
     * @return
     */
    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        return !recyclerView.canScrollVertically(1);
    }

    private void sendTextMessage(String text) {
        BIMMessage bimMessage = BIMClient.getInstance().createTextMessage(text);
        sendMessage(bimMessage);
    }

    private void sendRefMessage(String text, BIMMessage refMessage, List<Long> uids) {
        BIMMessage bimMessage = BIMClient.getInstance().createTextMessage(text, uids, refMessage, refMessage.getHint());
        sendMessage(bimMessage);
    }

    private void sendVoiceMessage(String path) {
        File file = new File(path);
        if (!file.exists()) {
            BIMLog.i(TAG, "sendVoiceMessage() file not exist! path: " + path);
            return;
        }
        BIMLog.i(TAG, "sendVoiceMessage() length: " + file.length() + " path: " + path);
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        long duration = 0;
        try {
            retriever.setDataSource(path);
            duration = Long.parseLong(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)) / 1000;
        } catch (Exception e) {
            BIMLog.i(TAG, "e: " + Log.getStackTraceString(e));
        }
        if (duration < 1) {
            Toast.makeText(getActivity(), "录制时间太短，录音失败", Toast.LENGTH_SHORT).show();
            return;
        }
        Uri outputUri = Uri.fromFile(new File(path));
        BIMMessage bimMessage = BIMClient.getInstance().createAudioMessage(path);
        sendMessage(bimMessage);
    }

    private void sendImageMessage(String path, Uri uri) {
        BIMLog.i(TAG, "sendImageMessage() path: " + path + " uri: " + uri);
        BIMMessage imageMessage = BIMClient.getInstance().createImageMessage(path);
        sendMessage(imageMessage);
    }

    private void sendVideoMessage(String path, Uri uri) {
        BIMLog.i(TAG, "sendVideoMessage() path: " + path+" uri: "+uri);
        BIMMessage videoMessage = BIMClient.getInstance().createVideoMessage(path);
        sendMessage(videoMessage);
    }

    private void sendFileMessage(Uri uri, String path, String fileName, long length) {
        BIMLog.i(TAG, "sendFileMessage() uri: " + uri + " path: " + path + " fileName: " + fileName + " length: " + length);
        BIMMessage fileMessage = BIMClient.getInstance().createFileMessage(uri, path, fileName, length);
        sendMessage(fileMessage);
    }

    private void sendMentionTextMessage(String text, List<Long> uidList) {
        BIMMessage bimMessage = BIMClient.getInstance().createTextMessage(text, uidList);
        sendMessage(bimMessage);
    }

    private void sendCustomMessage() {
        BIMShareElement shareVEContent = new BIMShareElement();
        shareVEContent.setLink("https://www.volcengine.com/");
        shareVEContent.setText("欢迎体验火山引擎即时通信IM Demo");
        BIMMessage customMessage = BIMClient.getInstance().createCustomMessage(BIMMessageManager.getInstance().encode(shareVEContent));
        sendMessage(customMessage);
    }
    //修改消息
    private void modifyTextMessage(String newText,BIMMessage oldMessage){
        BIMTextElement textElement = (BIMTextElement) oldMessage.getElement();
        textElement.setText(newText);
        BIMClient.getInstance().modifyMessage(oldMessage, null);
    }

    public void onRefMessage(BIMMessage message) {
        inPutView.onRefMessage(message);
    }

    public void onEditMessage(BIMMessage message) {
        inPutView.onEditMessage(message);
    }

    public void onClickEmoji(EmojiInfo emojiInfo, BIMMessage message) {
        long uid = BIMClient.getInstance().getCurrentUserID();
        Map<String, List<LocalPropertyItem>> map = message.getMessage().getPropertyItemListMap();

        BIMMessageNewPropertyModify bimMessageNewPropertyModify = new BIMMessageNewPropertyModify();
        bimMessageNewPropertyModify.setValue("" + uid);
        bimMessageNewPropertyModify.setKey(emojiInfo.text);
        bimMessageNewPropertyModify.setIdempotentID("" + uid);

        //没有消息属性，或消息属性中不存在该表情，直接添加
        boolean needAdd = false;
        if (map == null || map.size() == 0 || !map.containsKey(emojiInfo.text)) {
            needAdd = true;
        } else {
            boolean needRemove = false;
            for (Map.Entry<String, List<LocalPropertyItem>> entry : map.entrySet()) {
                if (entry.getKey().equals(emojiInfo.text) && entry.getValue().size() != 0) {
                    for (LocalPropertyItem item : entry.getValue()) {
                        if (item.uid == BIMClient.getInstance().getCurrentUserID()) {
                            needRemove = true;
                            break;
                        }
                    }
                    if (needRemove) {
                        break;
                    }
                }
            }
            needAdd = !needRemove;
        }
        bimMessageNewPropertyModify.setType(needAdd ? BIMMessageNewPropertyModifyType.ADD : BIMMessageNewPropertyModifyType.REMOVE);
        BIMClient.getInstance().modifyMessageProperty(message, Collections.singletonList(bimMessageNewPropertyModify), new BIMSimpleCallback() {
            @Override
            public void onSuccess() { }

            @Override
            public void onFailed(BIMErrorCode code) { }
        });
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
        if (!bimConversation.isMember()) {
            Toast.makeText(getActivity(), "已退出群组", Toast.LENGTH_SHORT).show();
            return;
        }
        BIMLog.i(TAG, "sendMessage() uuid: " + msg.getUuid());
        BIMClient.getInstance().sendMessage(msg, bimConversation.getConversationID(), new BIMSendCallback() {

            @Override
            public void onProgress(BIMMessage message, int progress) {
                BIMLog.i(TAG, "sendMessage onProgress() content" + message.getElement() + " uuid: " + message.getUuid() + " progress: " + progress + " thread:" + Thread.currentThread());
                adapter.insertOrUpdateMessage(message);
            }

            @Override
            public void onSaved(BIMMessage bimMessage) {
                BIMLog.i(TAG, "sendMessage onSaved() uuid: " + bimMessage.getUuid() + " thread:" + Thread.currentThread());//开始上传
                if (adapter.insertOrUpdateMessage(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                BIMLog.i(TAG, "sendMessage onSuccess() uuid: " + bimMessage.getUuid() + " thread:" + Thread.currentThread());
                if (adapter.insertOrUpdateMessage(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                BIMLog.i(TAG, "sendMessage onError() uuid: " + bimMessage.getUuid() + " code: " + code + " thread:" + Thread.currentThread());
                if (isAdded()) {
                    if (code == BIMErrorCode.BIM_UPLOAD_FILE_SIZE_OUT_LIMIT) {
                        Toast.makeText(getActivity(), "消息发送失败：文件大小超过限制", Toast.LENGTH_SHORT).show();
                        return;
                    } else if (code == BIMErrorCode.BIM_CONVERSATION_NOT_EXIST) {
                        Toast.makeText(getActivity(), "发送失败 code: " + code, Toast.LENGTH_SHORT).show();
                        return;
                    } else if (code == BIMErrorCode.BIM_SERVER_ERROR_SEND_MESSAGE_TOO_LARGE) {
                        Toast.makeText(getActivity(), "消息发送失败：消息内容超过限制", Toast.LENGTH_SHORT).show();
                        return;
                    } else if (code == BIMErrorCode.BIM_SERVER_NOT_FRIEND) {
                        Toast.makeText(getActivity(), "对方不是你的好友，无法发送消息", Toast.LENGTH_SHORT).show();
                        return;
                    } else if (code == BIMErrorCode.BIM_SERVER_AlREADY_IN_BLACK) {
                        Toast.makeText(getActivity(), "对方已拒收你的消息", Toast.LENGTH_SHORT).show();
                        return;
                    } else {
                        Toast.makeText(getActivity(), "发送失败 code: " + code, Toast.LENGTH_SHORT).show();
                    }
                }
                if (adapter.insertOrUpdateMessage(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }
        });
    }

    private void sendRedReceipt(BIMMessage bimMessage) {
        if (!bimMessage.isSelf() && !bimMessage.isSendReadReceipt()
                && bimMessage.getMsgType() != BIMMessageType.BIM_MESSAGE_TYPE_AUDIO
                && bimMessage.getMsgType() != BIMMessageType.BIM_MESSAGE_TYPE_VIDEO) {
            BIMLog.i(TAG, "sendRedReceipt()  uuid: "+bimMessage.getUuid());
            BIMClient.getInstance().sendMessageReadReceipts(Collections.singletonList(bimMessage), new BIMSimpleCallback() {
                @Override
                public void onSuccess() {
                    BIMLog.i(TAG, "sendRedReceipt() onSuccess() ");
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    BIMLog.i(TAG, "sendRedReceipt() onFailed() code: " + code);
                }
            });
        }
    }

    private BIMMessageListener receiveMessageListener = new BIMMessageListener() {
        @Override
        public void onReceiveMessage(BIMMessage message) {
            BIMLog.i(TAG, "onReceiveMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
                int r = adapter.insertOrUpdateMessage(message);
                if (r == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                } else if (r == BIMMessageAdapter.UPDATE) {
                    Toast.makeText(getActivity(), "出现错误，重复收到消息！", Toast.LENGTH_SHORT).show();
                }
            }
        }

        @Override
        public void onSendMessage(BIMMessage message) {
            BIMLog.i(TAG, "onSendMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
                if (adapter.insertOrUpdateMessage(message) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }
        }

        @Override
        public void onDeleteMessage(BIMMessage message) {
            BIMLog.i(TAG, "onDeleteMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (bimConversation != null && message.getConversationID().equals(bimConversation.getConversationID())) {
                adapter.deleteMessage(message);
            }
        }

        @Override
        public void onRecallMessage(BIMMessage message) {
            BIMLog.i(TAG, "onRecallMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
                adapter.insertOrUpdateMessage(message);
            }
        }

        @Override
        public void onUpdateMessage(BIMMessage message) {
            BIMLog.i(TAG, "onUpdateMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread() +" element: "+message.getElement() +" contentData:"+message.getContentData());
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
                adapter.insertOrUpdateMessage(message);
            }
        }

        @Override
        public void onReceiveMessagesReadReceipt(List<BIMMessageReadReceipt> receiptList) {

        }

        @Override
        public void onReceiveReadReceipt(List<BIMReadReceipt> readReceiptList) {
            for (BIMReadReceipt receipt: readReceiptList) {
                BIMLog.i(TAG, "onReceiveMessagesReadReceipt() uuid: " + receipt.getMessage().getUuid() + " thread:" + Thread.currentThread());
                BIMMessage bimMessage = receipt.getMessage();
                if (bimMessage != null && bimMessage.getConversationID().equals(bimConversation.getConversationID())) {
                    adapter.insertOrUpdateMessage(receipt.getMessage());
                }
            }
        }
    };

    //tob 无法使用此功能[流式消息]
    private BIMStreamMessageListener streamMessageListener = new BIMStreamMessageListener() {

        @Override
        public void onStreamAppend(BIMMessage msg) {
            adapter.insertOrUpdateMessage(msg);
        }

        @Override
        public void onStreamComplete(BIMMessage msg) {
            adapter.insertOrUpdateMessage(msg);
        }

        @Override
        public void onStreamInterrupt(BIMMessage msg) {
            adapter.insertOrUpdateMessage(msg);
        }

        @Override
        public void onReceiveStreamMsg(BIMMessage msg) {
            adapter.insertOrUpdateMessage(msg);
        }

        @Override
        public void onError(BIMMessage message, int code, String msg, Exception e) {
            if (message != null) {
                adapter.insertOrUpdateMessage(message);
            }
        }
    };

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
                        adapter.updateConversation(conversation);
                    }
                }
            }
        }

        @Override
        public void onConversationDelete(List<BIMConversation> conversationList) {
            getActivity().finish();
        }

        @Override
        public void onTotalUnreadMessageCountChanged(int totalUnreadCount) {

        }

        @Override
        public void onConversationRead(String conversationId, long fromUid) {
            adapter.notifyDataSetChanged();
        }
    };

    private void showMessageOperationDialog(View view, BIMMessage message) {
        if (bimConversation == null) return;
        if (msgOptionMenu != null) {
            if (msgOptionMenu.isShowing()) {
                msgOptionMenu.dismiss();
            }
        } else {
            msgOptionMenu = new BIMMessageOptionPopupWindow(getActivity(), BIMMessageListFragment.this);
        }
        msgOptionMenu.setBimMessageAndShow(view, message);
    }

    private void initInputView(BIMConversation bimConversation){
        inPutView.initFragment(this, bimConversation, initToolbtns(), new VoiceInputButton.OnAudioRecordListener() {
            @Override
            public void onStart() {
                if(onAudioRecordListener!=null){
                    onAudioRecordListener.onStart();
                }
            }

            @Override
            public void onCancel() {
                if (onAudioRecordListener != null) {
                    onAudioRecordListener.onCancel();
                }
            }

            @Override
            public void onSuccess(String path) {
                if (onAudioRecordListener != null) {
                    onAudioRecordListener.onSuccess(path);
                }
                sendVoiceMessage(path);//发语音
            }
        }, new VEInPutView.OnInputListener() {
            @Override
            public void onSendClick(String text, BIMMessage refMessage, List<Long> mentionIdList) {
                if (refMessage != null) {
                    //发送引用消息
                    sendRefMessage(text, refMessage, mentionIdList);
                } else {
                    if (mentionIdList.isEmpty()) {
                        sendTextMessage(text);
                    } else {
                        sendMentionTextMessage(text, mentionIdList);
                    }
                }
                if (onInputListener != null) {
                    onInputListener.onSendClick(text, refMessage, mentionIdList);
                }
            }

            @Override
            public void onSendEditClick(String newText, BIMMessage editMessage, List<Long> mentionIdList) {
                //发编辑消息
                modifyTextMessage(newText,editMessage);
                if (onInputListener != null) {
                    onInputListener.onSendEditClick(newText, editMessage, mentionIdList);
                }
            }

            @Override
            public void onEditTextChanged(String text) {
                if (onInputListener != null) {
                    onInputListener.onEditTextChanged(text);
                }
            }
        });
    }

    private void scrollBottom() {
        BIMLog.i(TAG, "scrollBottom()");
        QuickSmoothScroller quickSmoothScroller = new QuickSmoothScroller(recyclerView.getContext());
        quickSmoothScroller.setTargetPosition(0);
        recyclerView.getLayoutManager().startSmoothScroll(quickSmoothScroller);
    }

    public static class CenterSmoothScroller extends LinearSmoothScroller {
        @Override
        protected void onStart() {
            super.onStart();
        }

        public CenterSmoothScroller(Context context) {
            super(context);
        }

        @Override
        public int calculateDtToFit(int viewStart, int viewEnd, int boxStart, int boxEnd, int snapPreference) {
            return (boxStart + (boxEnd - boxStart) / 2) - (viewStart + (viewEnd - viewStart) / 2);
        }

        @Override
        protected int calculateTimeForScrolling(int dx) {
            return 1;
        }
    }

    public static class QuickSmoothScroller extends LinearSmoothScroller{

        public QuickSmoothScroller(Context context) {
            super(context);
        }

        @Override
        protected int calculateTimeForScrolling(int dx) {
            return 1;
        }
    }

    public void setOnPortraitClickListener(OnPortraitClickListener onPortraitClickListener) {
        this.onPortraitClickListener = onPortraitClickListener;
    }

    public void setOnInputListener(VEInPutView.OnInputListener onInputListener){
        this.onInputListener = onInputListener;
    }

    public void setOnAudioRecordListener(VoiceInputButton.OnAudioRecordListener onAudioRecordListener) {
        this.onAudioRecordListener = onAudioRecordListener;
    }
    public void setOnReadReceiptClickListener(OnReadReceiptClickListener listener) {
        this.onReadReceiptClickListener = listener;
    }

    private OnUserInfoUpdateListener listener;
    /**
     * 好友信息更新监听
     */
    public void addUserListener(){
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
        BIMUIClient.getInstance().getUserProvider().addUserUpdateListener(listener);
    }

    public void removeUserListener(){
        if (listener != null) {
            BIMUIClient.getInstance().getUserProvider().removeUserUpdateListener(listener);
        }
    }

    public static void registerCustomToolBtn(BaseToolBtn toolBtn) {
        customToolBtnList.add(toolBtn);
    }
}
