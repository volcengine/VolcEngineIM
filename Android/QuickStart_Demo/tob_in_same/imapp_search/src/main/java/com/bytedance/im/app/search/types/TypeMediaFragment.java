package com.bytedance.im.app.search.types;

import android.app.Fragment;
import android.content.Intent;
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
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.internal.utils.IMLog;
import com.bytedance.im.core.model.inner.msg.BIMImageElement;
import com.bytedance.im.core.model.inner.msg.BIMVideoElement;
import com.bytedance.im.core.model.inner.msg.image.BIMImage;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.media.PicturePreviewActivity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class TypeMediaFragment extends Fragment {
    private static final String TAG = "SearchMediaFragment";
    private MsgListViewModel msgListViewModel;
    private VESearchMediaAdapter mediaAdapter;
    private BIMMessageType bimMessageType;
    private BIMPullDirection bimPullDirection;
    private RecyclerView recyclerView;
    private View emptyView;

    public static TypeMediaFragment create(String conversationID, BIMMessageType bimMessageType, BIMPullDirection bimPullDirection) {
        TypeMediaFragment typeMediaFragment = new TypeMediaFragment();
        Bundle bundle = new Bundle();
        bundle.putString("search_cid", conversationID);
        bundle.putInt("search_msgType", bimMessageType.getValue());
        bundle.putInt("pull_direction", bimPullDirection.getValue());
        typeMediaFragment.setArguments(bundle);
        return typeMediaFragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_fragment_media_by_type, container, false);
        String conversationID = getArguments().getString("search_cid");
        int msgType = getArguments().getInt("search_msgType", BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.getValue());
        bimMessageType = BIMMessageType.getType(msgType);
        int direction = getArguments().getInt("pull_direction", BIMPullDirection.DESC.getValue());
        bimPullDirection = BIMPullDirection.getType(direction);
        msgListViewModel = new MsgListViewModel(conversationID, bimMessageType,bimPullDirection);
        emptyView = view.findViewById(R.id.empty_msg);
        recyclerView = view.findViewById(R.id.recycler_view);
        recyclerView.setItemAnimator(null);
        if (bimMessageType == BIMMessageType.BIM_MESSAGE_TYPE_FILE) {
            recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        } else {
            recyclerView.setLayoutManager(new GridLayoutManager(getActivity(), 4));
        }
        mediaAdapter = new VESearchMediaAdapter(getActivity(), veMediaWrapper -> {
            BIMMessage bimMessage = veMediaWrapper.getBimMessage();
            if(bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE){
                BIMImageElement imageElement = (BIMImageElement) bimMessage.getElement();
                BIMImage bimImage = imageElement.getOriginImg();
                if (bimImage == null || TextUtils.isEmpty(bimImage.getURL())) {
                    Toast.makeText(getActivity(), "图片URL为空", Toast.LENGTH_SHORT).show();
                    return;
                }
                BIMClient.getInstance().refreshMediaMessage(bimMessage, new BIMResultCallback<BIMMessage>() {
                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        BIMImageElement imageElement = (BIMImageElement) bimMessage.getElement();
                        PicturePreviewActivity.start(getActivity(),imageElement.getOriginImg().getURL());
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {

                    }
                });

            }else if(bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO){
                BIMVideoElement videoElement = (BIMVideoElement) bimMessage.getElement();
                if (TextUtils.isEmpty(videoElement.getURL())) {
                    Toast.makeText(getActivity(), "播放链接错误，无法播放", Toast.LENGTH_SHORT).show();
                    return;
                }
                Uri uri = Uri.parse(videoElement.getURL());
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(uri, "video/*");
                try {
                    getActivity().startActivity(intent);
                } catch (Exception e) {
                    //没有播放器可以使用
                    e.printStackTrace();
                }
            } else if(bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_FILE){
                Toast.makeText(getActivity(), "暂不支持文件预览", Toast.LENGTH_SHORT).show();
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

    private void loadMore() {
        Log.i(TAG, "bimMessageType: " + bimMessageType + " loadMore()");
        if (msgListViewModel.isHasMore()) {
            msgListViewModel.loadMore(new BIMResultCallback<List<BIMMessage>>() {
                @Override
                public void onSuccess(List<BIMMessage> messageList) {
                    if (messageList != null) {
                        Log.i(TAG, "loadMore onSuccess" + bimMessageType + " messageList: " + messageList.size());
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
                        Log.i(TAG, "loadMore onSuccess" + bimMessageType + " messageList: " + null);
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
