package com.bytedance.im.app.search.global.contact;

import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.OnPanelSearchEndListener;
import com.bytedance.im.app.search.global.message.SearchGlobalMessageActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.utils.BIMUIUtils;

public class SearchContactPanel extends Fragment {

    private String searchKey;
    private View searchContactList;
    private TextView searchContactTitle;
    private TextView searchContactMore;
    private View searchContactContainer;
    private SearchGlobalContactFragment searchGlobalContactFragment;
    private static final int MAX_ITEM_COUNT = 3;
    private OnPanelSearchEndListener onPanelSearchEndListener;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_search_global_panel, container, false);
        initPanel(view);
        return view;
    }

    private void initPanel(View rootView) {
        searchContactList = rootView.findViewById(R.id.search_panel);
        searchContactList.setVisibility(View.GONE);
        searchContactTitle = rootView.findViewById(R.id.search_panel_title);
        searchContactMore = rootView.findViewById(R.id.search_more);
        searchContactTitle.setText("联系人");
        searchContactMore.setText("查看更多");
        searchContactContainer = rootView.findViewById(R.id.search_container);
        searchGlobalContactFragment = new SearchGlobalContactFragment();
        FragmentManager fragmentManager = getChildFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.search_container, searchGlobalContactFragment)
                .commitAllowingStateLoss();

        searchContactMore.setOnClickListener(v -> SearchGlobalFriendActivity.start(getActivity(), searchKey));
    }

    public void search(String searchKey) {
        this.searchKey = searchKey;
        searchGlobalContactFragment.search(searchKey, MAX_ITEM_COUNT + 1, false, new BIMResultCallback<Integer>() {
            @Override
            public void onSuccess(Integer count) {
                if (onPanelSearchEndListener != null) {
                    onPanelSearchEndListener.onSearchCount(count,"friend");
                }
                if (count > 0) {
                    searchContactList.setVisibility(View.VISIBLE);
                    ViewGroup.LayoutParams lp = searchContactContainer.getLayoutParams();
                    lp.height = Math.min(60 * 30, Math.min(MAX_ITEM_COUNT,count) * BIMUIUtils.dpToPx(getActivity(), 60));
                    searchContactContainer.setLayoutParams(lp);
                } else {
                    searchContactList.setVisibility(View.GONE);
                }
                if (count > MAX_ITEM_COUNT) {
                    searchContactMore.setVisibility(View.VISIBLE);
                } else {
                    searchContactMore.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                searchContactList.setVisibility(View.GONE);
            }
        });
    }

    public void setOnPanelSearchEndListener(OnPanelSearchEndListener onPanelSearchEndListener) {
        this.onPanelSearchEndListener = onPanelSearchEndListener;
    }
}
