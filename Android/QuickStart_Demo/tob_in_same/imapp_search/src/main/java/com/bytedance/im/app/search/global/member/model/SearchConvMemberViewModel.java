package com.bytedance.im.app.search.global.member.model;

import android.util.Log;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchMemberInfo;
import com.bytedance.im.search.api.model.BIMSearchGroupMemberListResult;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SearchConvMemberViewModel {
    private static String TAG = "SearchConvMemberViewModel";
    private String key;
    private long cursor = 0;
    private int limit;
    private boolean hasMore = true;
    private boolean isLoading = false;
    private String conversationId = "";


    public SearchConvMemberViewModel(String conversationId, String key, int limit) {
        this.key = key;
        this.limit = limit;
        this.conversationId = conversationId;
    }

    public void search(String key) {
        this.key = key;

    }

    public void loadMore(BIMResultCallback<List<SearchConvMeGWrapper>> callback) {
        Log.i(TAG, "loadMore() hasMore: " + hasMore + " isLoading: " + isLoading);
        if (!hasMore) {
            return;
        }
        if (isLoading) {
            return;
        }
        isLoading = true;
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalGroupMember(conversationId, key, cursor, limit, new BIMResultCallback<BIMSearchGroupMemberListResult>() {

            @Override
            public void onSuccess(BIMSearchGroupMemberListResult result) {
                hasMore = result.isHasMore();
                cursor = result.getNextCursor();
                List<BIMSearchMemberInfo> memberInfoList = result.getMemberInfoList();
                if (memberInfoList != null) {
                    getSearchMemberWrapperList(memberInfoList, new BIMResultCallback<List<SearchConvMeGWrapper>>() {
                        @Override
                        public void onSuccess(List<SearchConvMeGWrapper> searchConvMeGWrappers) {
                            callback.onSuccess(searchConvMeGWrappers);
                            isLoading = false;
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            isLoading = false;
                        }
                    });

                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                isLoading = false;
            }

        });
    }

    /**
     * 拼接成员和用户资料
     */
    public static void getSearchMemberWrapperList(List<BIMSearchMemberInfo> searchMemberInfoList, BIMResultCallback<List<SearchConvMeGWrapper>> callback) {
        if (searchMemberInfoList == null) {
            callback.onFailed(BIMErrorCode.BIM_PARAMETER_ERROR);
            return;
        }
        List<Long> uidList = new ArrayList<>();
        for (BIMSearchMemberInfo info : searchMemberInfoList) {
            uidList.add(info.getMember().getUserID());
        }
        if (uidList.isEmpty()) {
            callback.onSuccess(new ArrayList<>());
            return;
        }
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimUserFullInfos) {
                List<SearchConvMeGWrapper> data = new ArrayList<>();
                if (bimUserFullInfos != null) {
                    Map<Long, BIMUIUser> map = new HashMap<>();
                    for (BIMUIUser user : bimUserFullInfos) {
                        map.put(user.getUid(), user);
                    }
                    for (BIMSearchMemberInfo info : searchMemberInfoList) {
                        data.add(new SearchConvMeGWrapper(info, map.get(info.getMember().getUserID())));
                    }
                }
                if (callback != null) {
                    callback.onSuccess(data);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (callback != null) {
                    callback.onFailed(code);
                }
            }
        });
    }
}
