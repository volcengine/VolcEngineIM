package com.bytedance.im.app.search.global.message;


import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.OnPanelSearchEndListener;
import com.bytedance.im.app.search.global.message.adapter.SearchMsgGWrapper;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.utils.BIMUIUtils;

import org.w3c.dom.Text;

import java.util.List;

public class SearchMsgPanel extends Fragment {
    private String searchKey;
    private View searchMsgList;
    private TextView searchTitle;
    private TextView searchMsgMore;
    private View searchMsgContainer;
    private SearchGlobalMsgFragment searchGlobalMsgFragment;
    private static final int MAX_ITEM_COUNT = 3;
    private static final String TAG = "SearchMsgPanel";
    private OnPanelSearchEndListener onPanelSearchEndListener;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_search_global_panel, container, false);
        initPanel(view);
        return view;
    }

    private void initPanel(View rootView) {
        searchMsgList = rootView.findViewById(R.id.search_panel);
        searchMsgList.setVisibility(View.GONE);
        searchTitle = rootView.findViewById(R.id.search_panel_title);
        searchMsgMore = rootView.findViewById(R.id.search_more);
        searchTitle.setText("聊天记录");
        searchMsgMore.setText("查看更多");
        searchMsgContainer = rootView.findViewById(R.id.search_container);
        searchGlobalMsgFragment = new SearchGlobalMsgFragment();
        Log.i(TAG, "initPanel searchGlobalMsgFragment: " + searchGlobalMsgFragment);
        FragmentManager fragmentManager = getChildFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.search_container, searchGlobalMsgFragment)
                .commitAllowingStateLoss();

        searchMsgMore.setOnClickListener(v -> SearchGlobalMessageActivity.start(getActivity(), searchKey));
    }

    public void search(String searchKey) {
        Log.i(TAG, "search searchGlobalMsgFragment: " + searchGlobalMsgFragment);
        this.searchKey = searchKey;
        searchGlobalMsgFragment.search(searchKey, MAX_ITEM_COUNT + 1, false, new BIMResultCallback<List<SearchMsgGWrapper>>() {
            @Override
            public void onSuccess(List<SearchMsgGWrapper> searchMsgGWrappers) {
                if (onPanelSearchEndListener != null) {
                    onPanelSearchEndListener.onSearchCount(searchMsgGWrappers.size(),"message");
                }
                if (searchMsgGWrappers.size() > 0) {
                    searchMsgList.setVisibility(View.VISIBLE);
                    ViewGroup.LayoutParams lp = searchMsgContainer.getLayoutParams();
                    lp.height = Math.min(60 * 30, Math.min(MAX_ITEM_COUNT, searchMsgGWrappers.size()) * BIMUIUtils.dpToPx(getActivity(), 60));
                    searchMsgContainer.setLayoutParams(lp);
                } else {
                    searchMsgList.setVisibility(View.GONE);
                }
                if (searchMsgGWrappers.size() > MAX_ITEM_COUNT) {
                    searchMsgMore.setVisibility(View.VISIBLE);
                } else {
                    searchMsgMore.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                searchMsgList.setVisibility(View.GONE);
            }
        });
    }

    public void setOnPanelSearchEndListener(OnPanelSearchEndListener onPanelSearchEndListener) {
        this.onPanelSearchEndListener = onPanelSearchEndListener;
    }
}
