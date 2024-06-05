package com.bytedance.im.app.search.types;

import android.app.Fragment;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.VESearchAdapter;
import com.bytedance.im.app.search.model.VESearchDivWrapper;
import com.bytedance.im.app.search.model.VESearchMsgInfo;
import com.bytedance.im.app.search.model.VESearchMsgWrapper;
import com.bytedance.im.app.search.model.VESearchWrapper;
import com.bytedance.im.app.search.types.model.SearchViewModel;
import com.bytedance.im.app.search.types.widget.SearchBar;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SearchMsgFragment extends Fragment {
    private static final String TAG = "SearchTextFragment";
    protected RecyclerView recyclerView;
    private TextView emptyTextView;
    private SearchViewModel searchViewModel;
    private VESearchAdapter searchAdapter;
    private String searchKey;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_fragment_search_by_type, container, false);
        recyclerView = view.findViewById(R.id.recycler_view);
        emptyTextView = view.findViewById(R.id.empty_msg);
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
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
        recyclerView.setAdapter(searchAdapter);
        showEmpty(true);
        return view;
    }


    protected void loadMore() {
        searchViewModel.loadMore(new BIMResultCallback<List<BIMSearchMsgInfo>>() {
            @Override
            public void onSuccess(List<BIMSearchMsgInfo> bimSearchMsgInfos) {
                Set<Long> uidList = new HashSet<Long>();
                for (BIMSearchMsgInfo info : bimSearchMsgInfos) {
                    uidList.add(info.getMessage().getSenderUID());
                }
                BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(new ArrayList<>(uidList), new BIMResultCallback<List<BIMUIUser>>() {
                    @Override
                    public void onSuccess(List<BIMUIUser> bimuiUsers) {
                        Map<Long, BIMUIUser> map = new HashMap<>();
                        for (BIMUIUser user : bimuiUsers) {
                            map.put(user.getUid(), user);
                        }
                        List<VESearchWrapper> searchWrapperList = new ArrayList<>();
                        for (BIMSearchMsgInfo searchMsgInfo : bimSearchMsgInfos) {
                            if (BIMMessageType.BIM_MESSAGE_TYPE_FILE == searchMsgInfo.getMessage().getMsgType()) {
                                searchWrapperList.add(new VESearchMsgWrapper(R.layout.ve_im_item_media_file_layout, new VESearchMsgInfo(searchMsgInfo, map.get(searchMsgInfo.getMessage().getSenderUID()))));
                            } else if (BIMMessageType.BIM_MESSAGE_TYPE_TEXT == searchMsgInfo.getMessage().getMsgType()) {
                                searchWrapperList.add(new VESearchMsgWrapper(R.layout.ve_im_item_search_msg_layout, new VESearchMsgInfo(searchMsgInfo, map.get(searchMsgInfo.getMessage().getSenderUID()))));
                            }
                        }
                        if (searchAdapter.getItemCount() == 0 && searchWrapperList.size() == 0) {
                            showEmpty(true);
                        } else {
                            showEmpty(false);
                            if (searchViewModel.getBimMessageType() == BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
                                searchAdapter.appendData(Collections.singletonList(new VESearchDivWrapper(R.layout.ve_im_item_search_div_layout, "消息记录")));
                            }
                            searchAdapter.appendData(searchWrapperList);
                        }

                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Log.i(TAG, "getUserInfoListAsync onFailed code: " + code);
                        showEmpty(true);
                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "loadMore onFailed code: " + code);
                showEmpty(true);
            }
        });
    }

    public void search(String key, String conversationID, BIMMessageType bimMessageType, BIMPullDirection pullDirection) {
        BIMLog.i(TAG, "search key: " + key);    //搜索
        searchKey = key;
        showEmpty(TextUtils.isEmpty(key));
        searchViewModel = new SearchViewModel(conversationID, bimMessageType, key, pullDirection);
        searchAdapter = new VESearchAdapter(searchDetail -> {
            BIMMessage message = searchDetail.getMessage();
            if (message.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_FILE) {
                Toast.makeText(getActivity(), "暂不支持文件预览", Toast.LENGTH_SHORT).show();
            } else if (message.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
                BIMUIClient.getInstance().getModuleStarter().startMessageModule(getActivity(), searchDetail.getMessage().getUuid(), conversationID);
            }
        });
        recyclerView.setAdapter(searchAdapter);
        loadMore();
    }

    private void showEmpty(boolean isShowEmpty) {
        if (isShowEmpty) {
            emptyTextView.setVisibility(View.VISIBLE);
            recyclerView.setVisibility(View.GONE);
        } else {
            emptyTextView.setVisibility(View.GONE);
            recyclerView.setVisibility(View.VISIBLE);
        }
        if (TextUtils.isEmpty(searchKey)) {
            emptyTextView.setVisibility(View.GONE);
        }
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        return !recyclerView.canScrollVertically(1);
    }
}
