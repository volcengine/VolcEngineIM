package com.bytedance.im.app.search.global.message;

import android.app.Fragment;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.SearchUIUtils;
import com.bytedance.im.app.search.global.message.adapter.SearchMessageGlobalAdapter;
import com.bytedance.im.app.search.global.message.adapter.SearchMsgGWrapper;
import com.bytedance.im.app.search.global.message.model.SearchMsgGlobalViewModel;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;

import java.util.List;

public class SearchGlobalMsgFragment extends Fragment {
    private String TAG = "SearchGlobalMsgFragment";
    protected RecyclerView recyclerView;
    private TextView emptyTextView;
    private SearchMsgGlobalViewModel viewModel;
    private String searchKey;
    private SearchMessageGlobalAdapter adapter;
    private boolean enableLoadMore = true;


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_fragment_search_by_type, container, false);
        recyclerView = view.findViewById(R.id.recycler_view);
        emptyTextView = view.findViewById(R.id.empty_msg);
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (SearchUIUtils.isSlideToBottom(recyclerView) && enableLoadMore) {
                    loadMore(null);
                }
            }
        });
        showEmpty(true);
        Log.i(TAG, "onCreateView recyclerView:" + recyclerView);
        return view;
    }


    public void search(String key, int limit, boolean enableLoadMore, BIMResultCallback<List<SearchMsgGWrapper>> callback) {
        Log.i(TAG, "search recyclerView:" + recyclerView);
        this.searchKey = key;
        this.enableLoadMore = enableLoadMore;
        viewModel = new SearchMsgGlobalViewModel(key, limit);
        adapter = new SearchMessageGlobalAdapter();
        adapter.setOnItemClickListener(wrapper -> {
            BIMConversation conversation = wrapper.getConversation();
            String searchKey = wrapper.getSearchInfo().getMessageInfo().getSearchDetail().getSearchKey();
            SearchMsgInConvActivity.start(getActivity(), conversation.getConversationID(), searchKey);
        });
        recyclerView.setItemAnimator(null);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()){
            @Override
            public boolean canScrollVertically() {
                return enableLoadMore;
            }
        });
        loadMore(callback);
    }


    public void loadMore(BIMResultCallback<List<SearchMsgGWrapper>> callback) {
        Log.i(TAG, "loadMore()");
        if (viewModel != null) {
            viewModel.loadMore(new BIMResultCallback<List<SearchMsgGWrapper>>() {
                @Override
                public void onSuccess(List<SearchMsgGWrapper> searchMsgGWrappers) {
                    if (callback != null) {
                        callback.onSuccess(searchMsgGWrappers);
                    }
                    adapter.appendData(searchMsgGWrappers);
                    updateEmpty();
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    updateEmpty();
                    if (callback != null) {
                        callback.onFailed(code);
                    }
                }
            });
        }
    }

    private void updateEmpty() {
        if (adapter.getItemCount() > 0) {
            showEmpty(false);
        } else {
            showEmpty(true);
        }
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
}
