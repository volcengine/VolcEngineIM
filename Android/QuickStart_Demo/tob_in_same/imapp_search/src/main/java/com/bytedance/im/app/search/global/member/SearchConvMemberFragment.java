package com.bytedance.im.app.search.global.member;

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
import com.bytedance.im.app.search.global.member.adapter.SearchConvMemberAdapter;
import com.bytedance.im.app.search.global.member.model.SearchConvMeGWrapper;
import com.bytedance.im.app.search.global.member.model.SearchConvMemberViewModel;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.search.api.model.BIMSearchMemberInfo;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.List;

public class SearchConvMemberFragment extends Fragment {

    private String TAG = "SearchConvMemberFragment";
    protected RecyclerView recyclerView;
    private TextView emptyTextView;
    private SearchConvMemberViewModel viewModel;
    private String searchKey;
    private SearchConvMemberAdapter adapter;



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
                if (SearchUIUtils.isSlideToBottom(recyclerView)) {
                    loadMore(null);
                }
            }
        });
        showEmpty(true);
        Log.i(TAG, "onCreateView recyclerView:" + recyclerView);
        return view;
    }


    public void search(String conversationId, String key, int limit, BIMResultCallback<Integer> callback) {
        Log.i(TAG, "search recyclerView:" + recyclerView);
        this.searchKey = key;
        viewModel = new SearchConvMemberViewModel(conversationId, key, limit);
        adapter = new SearchConvMemberAdapter(wrapper -> {
            BIMSearchMemberInfo searchMemberInfo = wrapper.getSearchMemberInfo();
            BIMMember member = searchMemberInfo.getMember();
            BIMUIClient.getInstance().getModuleStarter().startProfileModule(getActivity(),member.getUserID(),conversationId);
        });
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        recyclerView.setAdapter(adapter);
        loadMore(callback);
    }


    public void loadMore(BIMResultCallback<Integer> callback) {
        Log.i(TAG, "loadMore()");
        if (viewModel != null) {
            viewModel.loadMore(new BIMResultCallback<List<SearchConvMeGWrapper>>() {
                @Override
                public void onSuccess(List<SearchConvMeGWrapper> wraList) {
                    if (callback != null) {
                        callback.onSuccess(wraList.size());
                    }
                    adapter.appendData(wraList);
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

    private void showEmpty(boolean isShowEmpty) { if (isShowEmpty) {
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
