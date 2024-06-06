package com.bytedance.im.app.search.types;

import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import androidx.annotation.Nullable;


import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.types.widget.SearchBar;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;

public class SearchTextFragment extends Fragment {
    private static final String TAG = "SearchTextFragment";
    private SearchBar searchBar;
    private SearchMsgFragment searchMsgFragment;
    protected String conversationID;
    private BIMMessageType bimMessageType;
    private BIMPullDirection bimPullDirection;

    public static SearchTextFragment create(String conversationID, BIMMessageType bimMessageType, BIMPullDirection pullDirection){
        SearchTextFragment searchTextFragment = new SearchTextFragment();
        Bundle bundle = new Bundle();
        bundle.putString("search_cid", conversationID);
        bundle.putInt("search_msgType", bimMessageType.getValue());
        bundle.putInt("pull_direction", pullDirection.getValue());
        searchTextFragment.setArguments(bundle);
        return searchTextFragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        Log.i(TAG,"onCreateView()");
        conversationID = getArguments().getString("search_cid");
        int msgType = getArguments().getInt("search_msgType", BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.getValue());
        bimMessageType = BIMMessageType.getType(msgType);
        int direction = getArguments().getInt("pull_direction", BIMPullDirection.DESC.getValue());
        bimPullDirection = BIMPullDirection.getType(direction);
        View view = inflater.inflate(R.layout.ve_im_item_search_page_fragment, container, false);
        searchBar = view.findViewById(R.id.search_bar);
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchMsgFragment.search(key, conversationID, bimMessageType, bimPullDirection);
            }

            @Override
            public void onClose() {

            }
        });
        searchMsgFragment = new SearchMsgFragment();    //只有一个搜索fragmne
        FragmentManager fragmentManager = getChildFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.frame_layout, searchMsgFragment)
                .commitAllowingStateLoss();
        return view;
    }

    public EditText getSearchEditText() {
        return searchBar.getEditText();
    }
}
