package com.bytedance.im.app.search.global.contact.model;

import android.util.Log;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchFriendInfo;
import com.bytedance.im.search.api.model.BIMSearchFriendListResult;

import java.util.ArrayList;
import java.util.List;

public class SearchFriendGlobalViewModel {
    private static String TAG = "SearchGroupGlobalViewModel";
    private String key;
    private long cursor = 0;
    private int limit;
    private List<BIMMessageType> typeList;
    private boolean hasMore = true;
    private boolean isLoading = false;


    public SearchFriendGlobalViewModel(String key, int limit) {
        this.key = key;
        this.limit = limit;
    }

    public void search(String key) {
        this.key = key;

    }

    public void loadMore(BIMResultCallback<List<SearchFriendGWrapper>> callback) {
        Log.i(TAG, "loadMore() hasMore: " + hasMore + " isLoading: " + isLoading + " cursor: " + cursor + " limit: " + limit);
        if (!hasMore) {
            return;
        }
        if (isLoading) {
            return;
        }
        isLoading = true;
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalGlobalFriend(key, cursor, limit, new BIMResultCallback<BIMSearchFriendListResult>() {

            @Override
            public void onSuccess(BIMSearchFriendListResult result) {
                hasMore = result.isHasMore();
                cursor = result.getNextCursor();
                List<BIMSearchFriendInfo> friendInfoList = result.getFriendInfoList();
                List<SearchFriendGWrapper> wList = new ArrayList<>();
                if (friendInfoList != null) {
                    for (BIMSearchFriendInfo info : friendInfoList) {
                        wList.add(new SearchFriendGWrapper(info, info.getUserInfo()));
                    }
                }
                callback.onSuccess(wList);
                isLoading = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                isLoading = false;
            }
        });
    }
}
