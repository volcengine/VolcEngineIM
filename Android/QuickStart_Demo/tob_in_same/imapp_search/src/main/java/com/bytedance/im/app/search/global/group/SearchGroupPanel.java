package com.bytedance.im.app.search.global.group;

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
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.utils.BIMUIUtils;

public class SearchGroupPanel extends Fragment {
    private static final String TAG = "SearchGroupPanel";
    private String searchKey;
    private View searchGroupList;
    private TextView searchContactTitle;
    private TextView searchContactMore;
    private View searchContactContainer;
    private SearchGlobalGroupFragment searchGlobalGroupFragment;
    private static final int MAX_ITEM_COUNT = 3;
    private OnPanelSearchEndListener onPanelSearchEndListener;
    private boolean includeEmpty = true;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_search_global_panel, container, false);
        initPanel(view);
        return view;
    }

    private void initPanel(View rootView) {
        searchGroupList = rootView.findViewById(R.id.search_panel);
        searchGroupList.setVisibility(View.GONE);
        searchContactTitle = rootView.findViewById(R.id.search_panel_title);
        searchContactMore = rootView.findViewById(R.id.search_more);
        searchContactTitle.setText("群聊");
        searchContactMore.setText("查看更多");
        searchContactContainer = rootView.findViewById(R.id.search_container);
        searchGlobalGroupFragment = new SearchGlobalGroupFragment();
        FragmentManager fragmentManager = getChildFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.search_container, searchGlobalGroupFragment)
                .commitAllowingStateLoss();

        searchContactMore.setOnClickListener(v -> SearchGlobalGroupActivity.start(getActivity(), searchKey, includeEmpty));
    }

    public void search(String searchKey, boolean includeEmpty) {
        this.searchKey = searchKey;
        this.includeEmpty = includeEmpty;
        searchGlobalGroupFragment.search(searchKey, MAX_ITEM_COUNT + 1, false, includeEmpty, new BIMResultCallback<Integer>() {
            @Override
            public void onSuccess(Integer count) {
                Log.i(TAG, "search count" + count);
                if (count > 0) {
                    searchGroupList.setVisibility(View.VISIBLE);
                    ViewGroup.LayoutParams lp = searchContactContainer.getLayoutParams();
                    lp.height = Math.min(60 * 30, Math.min(MAX_ITEM_COUNT,count) * BIMUIUtils.dpToPx(getActivity(), 60));
                    searchContactContainer.setLayoutParams(lp);
                } else {
                    searchGroupList.setVisibility(View.GONE);
                }
                if (count > MAX_ITEM_COUNT) {
                    searchContactMore.setVisibility(View.VISIBLE);
                } else {
                    searchContactMore.setVisibility(View.GONE);
                }
                if (onPanelSearchEndListener != null) {
                    onPanelSearchEndListener.onSearchCount(count,"group");
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                searchGroupList.setVisibility(View.GONE);
            }
        });
    }

    public void setOnPanelSearchEndListener(OnPanelSearchEndListener onPanelSearchEndListener) {
        this.onPanelSearchEndListener = onPanelSearchEndListener;
    }
}
