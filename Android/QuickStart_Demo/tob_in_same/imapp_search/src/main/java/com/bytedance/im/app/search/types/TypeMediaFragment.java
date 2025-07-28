package com.bytedance.im.app.search.types;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.media.VESearchMediaAdapter;
import com.bytedance.im.app.search.model.VEMediaWrapper;
import com.bytedance.im.app.search.types.model.MsgListViewModel;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;
import com.bytedance.im.core.api.interfaces.BIMDownloadCallback;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMFileElement;
import com.bytedance.im.core.model.inner.msg.BIMImageElement;
import com.bytedance.im.core.model.inner.msg.BIMVideoElement;
import com.bytedance.im.core.model.inner.msg.BIMVideoElementV2;
import com.bytedance.im.download.api.BIMDownloadExpandService;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.message.adapter.ui.inner.FileMessageUI;
import com.bytedance.im.ui.utils.media.PicturePreviewActivity;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class TypeMediaFragment extends Fragment {
    private static final String TAG = "SearchMediaFragment";
    private MsgListViewModel msgListViewModel;
    private VESearchMediaAdapter mediaAdapter;
    private List<BIMMessageType> bimMessageTypeList;
    private BIMPullDirection bimPullDirection;
    private RecyclerView recyclerView;
    private View emptyView;

    public static TypeMediaFragment create(String conversationID, List<BIMMessageType> bimMessageTypeList, BIMPullDirection bimPullDirection) {
        TypeMediaFragment typeMediaFragment = new TypeMediaFragment();
        Bundle bundle = new Bundle();
        ArrayList<Integer> msgTypeList = new ArrayList<>();
        for (BIMMessageType type : bimMessageTypeList) {
            msgTypeList.add(type.getValue());
        }

        bundle.putString("search_cid", conversationID);
        bundle.putIntegerArrayList("search_msgType", msgTypeList);
        bundle.putInt("pull_direction", bimPullDirection.getValue());
        typeMediaFragment.setArguments(bundle);
        return typeMediaFragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_fragment_media_by_type, container, false);
        String conversationID = getArguments().getString("search_cid");
        ArrayList<Integer> msgTypeList = getArguments().getIntegerArrayList("search_msgType");
        bimMessageTypeList = new ArrayList<>();
        for (int type : msgTypeList) {
            bimMessageTypeList.add(BIMMessageType.getType(type));
        }
        int direction = getArguments().getInt("pull_direction", BIMPullDirection.DESC.getValue());
        bimPullDirection = BIMPullDirection.getType(direction);
        msgListViewModel = new MsgListViewModel(conversationID, bimMessageTypeList, bimPullDirection);
        emptyView = view.findViewById(R.id.empty_msg);
        recyclerView = view.findViewById(R.id.recycler_view);
        recyclerView.setItemAnimator(null);
        if (bimMessageTypeList.contains(BIMMessageType.BIM_MESSAGE_TYPE_FILE)) {
            recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        } else {
            recyclerView.setLayoutManager(new GridLayoutManager(getActivity(), 4));
        }
        mediaAdapter = new VESearchMediaAdapter(getActivity(), veMediaWrapper -> {
            BIMMessage bimMessage = veMediaWrapper.getBimMessage();
            if(bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE){
                BIMImageElement imageElement = (BIMImageElement) bimMessage.getElement();
                String path = imageElement.getOriginImg().getDownloadPath();
                boolean hasLocalFile = new File(path).exists();
                if (hasLocalFile) {
                    PicturePreviewActivity.start(getActivity(), path);
                } else {
                    if (bimMessage.isSelf() && !TextUtils.isEmpty(imageElement.getLocalPath())) {
                        PicturePreviewActivity.start(getActivity(), imageElement.getLocalPath());
                    } else {
                        BIMClient.getInstance().downloadFile(bimMessage, imageElement.getOriginImg().getURL(), new BIMDownloadCallback() {
                            @Override
                            public void onSuccess(BIMMessage bimMessage) {
                                if (isAdded()) {
                                    Toast.makeText(getActivity(), "下载成功", Toast.LENGTH_SHORT).show();
                                    PicturePreviewActivity.start(getActivity(), path);
                                }
                            }

                            @Override
                            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                                if (isAdded()) {
                                    if (code == BIMErrorCode.BIM_DOWNLOAD_FILE_DUPLICATE) {
                                        Toast.makeText(getActivity(), "下载中", Toast.LENGTH_SHORT).show();
                                    } else {
                                        Toast.makeText(getActivity(), "下载失败，请重试", Toast.LENGTH_SHORT).show();
                                    }
                                }
                            }
                        });
                    }
                }
            } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO ||
                    bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO_V2) {
                String localFile = "";
                String localPath = "";
                String url = "";
                if(bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO ){
                    BIMVideoElement videoElement = (BIMVideoElement) bimMessage.getElement();
                     localFile = videoElement.getDownloadPath();
                    localPath=videoElement.getLocalPath();
                    url = videoElement.getURL();
                }else if(bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO_V2){
                    BIMVideoElementV2 videoElementV2 = (BIMVideoElementV2) bimMessage.getElement();
                    localFile = videoElementV2.getDownloadPath();
                    localPath=videoElementV2.getLocalPath();
                    url = videoElementV2.getURL();
                }

                Uri uri = null;
                if (new File(localFile).exists()) {
                    uri = convertUri(view.getContext(), localFile);
                } else {
                    if (bimMessage.isSelf() && !TextUtils.isEmpty(localPath)) {
                        uri = convertUri(view.getContext(), localPath);
                    } else {
                        uri = Uri.parse(url);
                        BIMClient.getInstance().downloadFile(bimMessage, url, new BIMDownloadCallback() {
                            @Override
                            public void onSuccess(BIMMessage bimMessage) {
                                if (isAdded()) {
                                    Toast.makeText(getActivity(), "下载成功", Toast.LENGTH_SHORT).show();
                                }
                            }

                            @Override
                            public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                                if (isAdded()) {
                                    if (code == BIMErrorCode.BIM_DOWNLOAD_FILE_DUPLICATE) {
                                        Toast.makeText(getActivity(), "下载中", Toast.LENGTH_SHORT).show();
                                    } else {
                                        Toast.makeText(getActivity(), "下载失败，请重试", Toast.LENGTH_SHORT).show();
                                    }
                                }
                            }
                        });
                    }
                }

                if (uri == null) {
                    return;
                }
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(uri, "video/*");
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                try {
                    getActivity().startActivity(intent);
                } catch (Exception e) {
                    //没有播放器可以使用
                    e.printStackTrace();
                }
            } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_FILE) {
//                Toast.makeText(getActivity(), "暂不支持文件预览", Toast.LENGTH_SHORT).show();
                BIMFileElement fileElement = (BIMFileElement) bimMessage.getElement();
                String localFile = fileElement.getDownloadPath();
                if (new File(localFile).exists()) {
                    FileMessageUI.showFileInfo(getActivity(), localFile);
                } else {
                    BIMClient.getInstance().downloadFile(bimMessage, fileElement.getURL(), new BIMDownloadCallback() {
                        @Override
                        public void onSuccess(BIMMessage bimMessage) {
                            if(isAdded()){
                                Toast.makeText(getActivity(), "下载成功", Toast.LENGTH_SHORT).show();
                                FileMessageUI.showFileInfo(getActivity(), localFile);
                            }
                        }

                        @Override
                        public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                            if(isAdded()){
                                if (code == BIMErrorCode.BIM_DOWNLOAD_FILE_DUPLICATE) {
                                    Toast.makeText(getActivity(), "下载中", Toast.LENGTH_SHORT).show();
                                } else {
                                    Toast.makeText(getActivity(), "下载失败，请重试", Toast.LENGTH_SHORT).show();
                                }
                            }
                        }
                    });
                }
            }
        });
        recyclerView.setAdapter(mediaAdapter);
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (isSlideToBottom(recyclerView)) {
                    loadMore();
                }
            }
        });
        loadMore();
        return view;
    }

    private Uri convertUri(Context context, String filePath) {
        String packageName = context.getPackageName();
        Uri contentUri = null;
        try {
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(packageName, PackageManager.GET_PROVIDERS);
            ProviderInfo[] providers = packageInfo.providers;
            for (ProviderInfo providerInfo: providers) {
                try {
                    contentUri = FileProvider.getUriForFile(context, providerInfo.authority, new File(filePath));
                    context.getContentResolver().openInputStream(contentUri);
                    break;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return contentUri;
    }

    private void loadMore() {
        Log.i(TAG, "bimMessageType: " + bimMessageTypeList.get(0) + " loadMore()");
        if (msgListViewModel.isHasMore()) {
            msgListViewModel.loadMore(new BIMResultCallback<List<BIMMessage>>() {
                @Override
                public void onSuccess(List<BIMMessage> messageList) {
                    if (messageList != null) {
                        Log.i(TAG, "loadMore onSuccess" + bimMessageTypeList.get(0) + " messageList: " + messageList.size());
                        Set<Long> uidSet = new HashSet<>();
                        for (BIMMessage msg : messageList) {
                            uidSet.add(msg.getSenderUID());
                        }
                        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(new ArrayList<>(uidSet), new BIMResultCallback<List<BIMUIUser>>() {
                            @Override
                            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                                if (bimuiUsers != null && !bimuiUsers.isEmpty()) {
                                    Map<Long, BIMUIUser> userMap = new HashMap<>();
                                    for (BIMUIUser user : bimuiUsers) {
                                        userMap.put(user.getUid(), user);
                                    }
                                    List<VEMediaWrapper> wrapperList = new ArrayList<>();
                                    for (BIMMessage msg : messageList) {
                                        wrapperList.add(new VEMediaWrapper(msg, userMap.get(msg.getSenderUID())));
                                    }
                                    if (mediaAdapter.getItemCount() == 0 && wrapperList.size() == 0) {
                                        showEmpty(true);
                                    } else {
                                        showEmpty(false);
                                        mediaAdapter.appendData(wrapperList);
                                    }

                                }
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                showEmpty(true);
                            }
                        });

                    } else {
                        Log.i(TAG, "loadMore onSuccess" + bimMessageTypeList.get(0)+ " messageList: " + null);
                        showEmpty(true);
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    showEmpty(true);
                }
            });
        } else {
            Toast.makeText(getActivity(), "没有更多了", Toast.LENGTH_SHORT).show();
        }
    }

    private void showEmpty(boolean isShowEmpty){
        if (isShowEmpty) {
            emptyView.setVisibility(View.VISIBLE);
            recyclerView.setVisibility(ViewGroup.GONE);
        } else {
            emptyView.setVisibility(View.GONE);
            recyclerView.setVisibility(ViewGroup.VISIBLE);
        }
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        return !recyclerView.canScrollVertically(1);
    }
}
