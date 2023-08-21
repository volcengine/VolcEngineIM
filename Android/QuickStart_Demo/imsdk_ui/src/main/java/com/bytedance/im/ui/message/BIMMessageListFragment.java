package com.bytedance.im.ui.message;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.content.res.Configuration;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.content.FileProvider;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Selection;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMMessageListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGetMessageOption;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageListResult;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.member.BIMGroupMemberListActivity;
import com.bytedance.im.ui.message.adapter.BIMMessageAdapter;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.widget.VEInPutView;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.BIMMessageOptionPopupWindow;
import com.bytedance.im.ui.message.convert.manager.BIMMessageManager;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.ui.utils.BIMPermissionController;
import com.bytedance.im.ui.utils.FileUtils;
import com.bytedance.im.ui.utils.FilePathUtils;
import com.bytedance.im.ui.utils.audio.VoiceRecordManager;
import com.bytedance.im.ui.utils.media.BIMMediaListActivity;
import com.bytedance.im.ui.utils.media.MediaInfo;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

public class BIMMessageListFragment extends Fragment {
    private static final String TAG = "VEMessageListFragment";
    public static final String TARGET_CID = "target_cid";
    public static final String ACTION = "com.bytedance.im.page.message_list";
    private String conversationId;
    private BIMConversation bimConversation;
    private RecyclerView recyclerView;
    private BIMMessageAdapter adapter;
    private BIMMessage earliestMessage = null;
    private boolean hasMore = false;
    private boolean isSyncing = false;
    private VEInPutView inPutView;
    private VoiceRecordManager voiceRecordManager;
    private int REQUEST_CODE_SELECT_MEDIA = 0;
    private int REQUEST_CODE_TAKE_PHOTO = 2;
    private int REQUEST_CODE_SELECT_FILE = 3;
    private int REQUEST_CODE_SELECT_USER_FOR_AT = 4;
    private static String takePhotoPath = "";
    private Set<Long> mentionIds = new HashSet<Long>();
    private BIMMessageOptionPopupWindow msgOptionMenu;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = getActivity().getIntent();
        conversationId = intent.getStringExtra(TARGET_CID);
        BIMLog.i(TAG, "onCreate() conversationId: " + conversationId);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.bim_im_fragment_message_list, container, false);
        recyclerView = v.findViewById(R.id.message_list);
        inPutView = v.findViewById(R.id.inputView);
        refreshConversation();
        adapter = new BIMMessageAdapter(new BIMMessageAdapter.OnMessageItemClickListener() {
            @Override
            public void onPortraitClick(BIMMessage message) {
                Toast.makeText(getActivity(), "点击头像 uid:" + message.getSenderUID(), Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onResentClick(BIMMessage message) {
                Toast.makeText(getActivity(), "重发消息 uuid:" + message.getUuid(), Toast.LENGTH_SHORT).show();
                sendMessage(message);
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
        });

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
        BIMClient.getInstance().addMessageListener(receiveMessageListener);
        loadData();
        initInputView();
        return v;
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        BIMLog.i(TAG, "onConfigurationChanged() newConfig: " + newConfig);
    }

    private void initInputView() {
        inPutView.setListener(new VEInPutView.OnInputListener() {
            @Override
            public void onSendClick(String text) {
                BIMLog.i(TAG, "onSendClick() text: " + text);
                if (inPutView.getRefMessage() != null) {
                    //发送引用消息
                    sendRefMessage(text, inPutView.getRefMessage(), new ArrayList<>(mentionIds));
                } else {
                    if (mentionIds.isEmpty()) {
                        sendTextMessage(text);
                    } else {
                        sendMentionTextMessage(text, new ArrayList<>(mentionIds));
                    }
                }
                mentionIds.clear();
            }

            @Override
            public void onAtClick() {
                BIMLog.i(TAG, "onAtClick()");
                BIMGroupMemberListActivity.startForResult(BIMMessageListFragment.this,conversationId, REQUEST_CODE_SELECT_USER_FOR_AT);
            }

            @Override
            public void onAudioStart() {
                BIMLog.i(TAG, "onAudioStart()");
                requestPermission(new String[]{Manifest.permission.RECORD_AUDIO,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
                    if (isAllGranted) {
                        if (voiceRecordManager == null) {
                            voiceRecordManager = new VoiceRecordManager();
                        }
                        voiceRecordManager.reset(FileUtils.getAudioPath() + File.separator + System.currentTimeMillis() + ".aac");
                        voiceRecordManager.start();
                    }
                });
            }

            @Override
            public void onAudioEnd() {
                BIMLog.i(TAG, "onAudioEnd()");
                if (voiceRecordManager != null) {
                    voiceRecordManager.stop();
                    voiceRecordManager.release();
                    sendVoiceMessage(voiceRecordManager.getPath());
                }
            }

            @Override
            public void onAudioCancel() {
                BIMLog.i(TAG, "onAudioCancel()");
                voiceRecordManager.stop();
                voiceRecordManager.release();
            }

            @Override
            public void onSelectImageClick() {
                requestPermission(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
                    if (isAllGranted) {
                        BIMMediaListActivity.startForResultMedia(BIMMessageListFragment.this, REQUEST_CODE_SELECT_MEDIA);
                    }
                });
            }

            @Override
            public void onTakePhotoClick() {
                requestPermission(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
                    if (isAllGranted) {
                        startIntentToTakePhoto();
                    }
                });
            }

            @Override
            public void onFileClick() {
                requestPermission(new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
                    if (isAllGranted) {
                        startIntentToTakeFile();
                    }
                });
            }

            @Override
            public void onCustomClick() {
                sendCustomMessage();
            }
        });
    }


    private void requestPermission(String[] permission, BIMPermissionController.IPermissionReqListener listener) {
        BIMPermissionController.checkPermission(getActivity(), permission, listener);
    }


    private void startIntentToTakeFile() {
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("*/*");//设置类型，我这里是任意类型，任意后缀的可以这样写。
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        startActivityForResult(intent, REQUEST_CODE_SELECT_FILE);
    }

    private void refreshConversation(){
        BIMClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                String name = "";
                String draft = bimConversation.getDraftText();
                if (!TextUtils.isEmpty(draft) && TextUtils.isEmpty(inPutView.getmInputEt().getText())) {
                    inPutView.setEditDraft(draft);
                }
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
        BIMClient.getInstance().markConversationRead(conversationId,null);
    }

    @Override
    public void onStop() {
        super.onStop();
        BIMClient.getInstance().markConversationRead(conversationId,null);
        String draft = inPutView.getEditDraft();
        BIMClient.getInstance().setConversationDraft(draft, conversationId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        BIMClient.getInstance().removeMessageListener(receiveMessageListener);
    }

    private void startIntentToTakePhoto() {
        Intent captureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
        String imageFileName = String.format("JPEG_%s.jpg", timeStamp);
        File storageDir = getActivity().getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        File tempFile = new File(storageDir, imageFileName);
        takePhotoPath = tempFile.getAbsolutePath();
        Uri uri = FileProvider.getUriForFile(getActivity(), "com.bytedance.im.app.fileprovider", tempFile);
        captureIntent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        captureIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        startActivityForResult(captureIntent, REQUEST_CODE_TAKE_PHOTO);
    }
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_SELECT_MEDIA) {
                //选图片
                MediaInfo info = (MediaInfo) data.getParcelableExtra(BIMMediaListActivity.RESULT_KEU);
                if (info.getFileType() == MediaInfo.MEDIA_TYPE_IMAGE) {
                    sendImageMessage(info.getFilePath());
                } else {
                    sendVideoMessage(info.getFilePath());
                }
            } else if (requestCode == REQUEST_CODE_TAKE_PHOTO) {
                //拍照
                sendImageMessage(takePhotoPath);
            } else if (requestCode == REQUEST_CODE_SELECT_FILE) {
                //选文件
                if (data != null && data.getData() != null) {
                    Uri uri = data.getData();
                    //需要给权限，不然关闭页面不会继续上传
                    getActivity().grantUriPermission(getActivity().getPackageName(), uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    //存在获取不到path的情况，所以直接用uri上传
                    String path = FilePathUtils.getPath(getActivity(), uri);
                    long length = FileUtils.getLengthFromUri(getActivity(), uri);
                    String name = FileUtils.getFileNameFromUri(getActivity(), uri);
                    sendFileMessage(uri, path, name, length);
                }
            } else if (requestCode == REQUEST_CODE_SELECT_USER_FOR_AT) {
                //选成员
                List<Long> selectUid = (List<Long>) data.getSerializableExtra(BIMGroupMemberListActivity.RESULT_ID_LIST);
                StringBuffer mentionStr = new StringBuffer();
                for (long uid : selectUid) {
                    BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(uid);
                    mentionStr.append(" ");
                    mentionStr.append("@");
                    mentionStr.append(user.getNickName());
                    mentionStr.append(" "); //用空格区分@的内容
                    mentionIds.add(uid);
                }
                StringBuffer stringBuffer = new StringBuffer(inPutView.getmInputEt().getText());
                stringBuffer.deleteCharAt(inPutView.getmInputEt().getText().length() - 1);
                stringBuffer.append(mentionStr);

                inPutView.getmInputEt().setText(stringBuffer.toString());
                Selection.setSelection(inPutView.getmInputEt().getText(), inPutView.getmInputEt().getText().length()); //移动光标到尾部
            }  else {
                if (msgOptionMenu != null) {
                    //长按弹窗处理
                    msgOptionMenu.onActivityResult(requestCode, resultCode, data);
                }
            }
        }
    }

    private void loadData() {
        BIMLog.i(TAG, "loadData()");
        if (isSyncing) {
            return;
        }
        isSyncing = true;
//        Toast.makeText(getActivity(), "加载更多历史消息中...", Toast.LENGTH_SHORT).show();
        BIMGetMessageOption option = new BIMGetMessageOption.Builder().isNeedServer(true).limit(20).earliestMessage(earliestMessage).build();
        BIMClient.getInstance().getHistoryMessageList(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
            @Override
            public void onSuccess(BIMMessageListResult bimMessageListResult) {
                BIMLog.i(TAG, "loadData bimMessageListResult: " + bimMessageListResult + " thread:" + Thread.currentThread());
                adapter.appendMessageList(bimMessageListResult.getMessageList());
                earliestMessage = bimMessageListResult.getEarliestMessage();
                hasMore = bimMessageListResult.isHasMore();
                isSyncing = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "onFailed() code: " + code);
//                Toast.makeText(getActivity(), "出错了 code：" + code, Toast.LENGTH_SHORT).show();
                isSyncing = false;
            }
        });
    }


    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        return recyclerView.computeVerticalScrollOffset() == 0;
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
            return;
        }
        BIMLog.i(TAG, "sendVoiceMessage() length: " + file.length() + " path: " + path);
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        retriever.setDataSource(path);
        long duration = 0;
        try {
            duration = Long.parseLong(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)) / 1000;
        } catch (Exception e) {
            BIMLog.i(TAG, "e: " + Log.getStackTraceString(e));
        }
        if (duration < 1) {
            Toast.makeText(getActivity(), "录制时间太短，录音失败", Toast.LENGTH_SHORT).show();
            return;
        }
        BIMMessage bimMessage = BIMClient.getInstance().createAudioMessage(path);
        sendMessage(bimMessage);
    }

    private void sendImageMessage(String path) {
        BIMLog.i(TAG, "sendImageMessage() path: " + path);
        BIMMessage imageMessage = BIMClient.getInstance().createImageMessage(path);
        sendMessage(imageMessage);
    }

    private void sendVideoMessage(String path) {
        BIMLog.i(TAG, "sendVideoMessage() path: " + path);
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
        shareVEContent.setText("欢迎体验火山引擎即时通讯IM Demo");
        BIMMessage customMessage = BIMClient.getInstance().createCustomMessage(BIMMessageManager.getInstance().encode(shareVEContent));
        sendMessage(customMessage);
    }

    public void onRefMessage(BIMMessage message) {
        inPutView.onRefMessage(message);
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
                } else {
                    Toast.makeText(getActivity(), "发送失败 code: " + code, Toast.LENGTH_SHORT).show();
                }
                if (adapter.insertOrUpdateMessage(bimMessage) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
                }
            }
        });
    }

    private BIMMessageListener receiveMessageListener = new BIMMessageListener() {
        @Override
        public void onReceiveMessage(BIMMessage message) {
            BIMLog.i(TAG, "onReceiveMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
                if (adapter.insertOrUpdateMessage(message) == BIMMessageAdapter.APPEND) {
                    scrollBottom();
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
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
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
            BIMLog.i(TAG, "onUpdateMessage() uuid: " + message.getUuid() + " thread:" + Thread.currentThread());
            if (message.getConversationID().equals(bimConversation.getConversationID())) {
                adapter.insertOrUpdateMessage(message);
            }
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

    private void scrollBottom() {
        recyclerView.scrollToPosition(0);
    }
}
