package com.bytedance.im.app.search.types;

import android.app.Fragment;
import android.app.FragmentManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import androidx.annotation.ArrayRes;
import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.types.widget.SearchBar;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;

import java.util.ArrayList;

public class SearchFileFragment extends Fragment {
    private SearchBar searchBar;
    private SearchMsgFragment searchMsgFragment;
    private TypeMediaFragment typeMediaFragment;
    private String conversationID;
    private BIMMessageType bimMessageType;
    private BIMPullDirection bimPullDirection;

    public static SearchFileFragment create(String conversationID, BIMMessageType bimMessageType, BIMPullDirection pullDirection){
        SearchFileFragment searchFileFragment = new SearchFileFragment();
        Bundle bundle = new Bundle();
        bundle.putString("search_cid", conversationID);
        bundle.putInt("search_msgType", bimMessageType.getValue());
        bundle.putInt("pull_direction", pullDirection.getValue());
        searchFileFragment.setArguments(bundle);
        return searchFileFragment;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_item_search_page_fragment, container, false);
        conversationID = getArguments().getString("search_cid");
        int msgType = getArguments().getInt("search_msgType", BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.getValue());
        int direction = getArguments().getInt("pull_direction", BIMPullDirection.DESC.getValue());
        bimPullDirection = BIMPullDirection.getType(direction);
        bimMessageType = BIMMessageType.getType(msgType);
        searchBar = view.findViewById(R.id.search_bar);
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                if (TextUtils.isEmpty(key)) {
                    showFileList(true);
                } else {
                    showFileList(false);
                    searchMsgFragment.search(key, conversationID, bimMessageType, bimPullDirection);
                }
            }

            @Override
            public void onClose() {

            }
        });
        searchMsgFragment = new SearchMsgFragment();    //搜索fragment
        ArrayList<BIMMessageType> fileTypeList = new ArrayList<>();
        fileTypeList.add(bimMessageType);
        typeMediaFragment = TypeMediaFragment.create(conversationID, fileTypeList, bimPullDirection);    //媒体列表fragment
        FragmentManager fragmentManager = getChildFragmentManager();
        fragmentManager.beginTransaction().add(R.id.frame_layout, searchMsgFragment)
                .add(R.id.frame_layout, typeMediaFragment)
                .hide(searchMsgFragment)
                .show(typeMediaFragment)
                .commitAllowingStateLoss();
        showFileList(true);
        return view;
    }

    public EditText getSearchEditText() {
        return searchBar.getEditText();
    }

    private void showFileList(boolean isShow) {
        FragmentManager fragmentManager = getChildFragmentManager();
        if (isShow) {
            fragmentManager.beginTransaction().show(typeMediaFragment).hide(searchMsgFragment).commitAllowingStateLoss();
        } else {
            fragmentManager.beginTransaction().show(searchMsgFragment).hide(typeMediaFragment).commitAllowingStateLoss();
        }
    }
}
