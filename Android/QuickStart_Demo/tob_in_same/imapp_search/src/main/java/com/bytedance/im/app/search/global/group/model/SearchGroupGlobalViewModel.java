package com.bytedance.im.app.search.global.group.model;

import android.util.Log;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchGroupInfo;
import com.bytedance.im.search.api.model.BIMSearchGroupListResult;

import java.util.ArrayList;
import java.util.List;

public class SearchGroupGlobalViewModel {
    private static String TAG = "SearchGroupGlobalViewModel";
    private String key;
    private long cursor = 0;
    private int limit;
    private boolean hasMore = true;
    private boolean isLoading = false;

    private long emptyConvCursor = 0;
    private boolean emptyConvHasMore = true;
    private boolean includeEmptyGroup = true; //没有消息的会话，sortOrder为0

    public SearchGroupGlobalViewModel(String key, int limit,boolean includeEmptyGroup) {
        this.key = key;
        this.limit = limit;
        this.includeEmptyGroup = includeEmptyGroup;
    }

    public void search(String key) {
        this.key = key;
    }

    public void loadMore(BIMResultCallback<List<SearchGroupGWrapper>> callback) {
        Log.i(TAG, "loadMore() hasMore: " + hasMore + " isLoading: " + isLoading + " cursor: " + cursor);
        if (!hasMore) {
            if (includeEmptyGroup) {
                //业务可选：正常有消息的会话搜索完毕，再搜索无消息的空会话仅命中会话名字即可。
                loadMoreEmptyConv(callback);
            }
            return;
        }
        if (isLoading) {
            return;
        }
        isLoading = true;
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalGlobalGroup(key, cursor, limit, new BIMResultCallback<BIMSearchGroupListResult>() {
            @Override
            public void onSuccess(BIMSearchGroupListResult result) {
                hasMore = result.isHasMore();
                cursor = result.getNextCursor();
                List<SearchGroupGWrapper> gList = genWrapper(result.getGroupInfoList());

                if (includeEmptyGroup && !hasMore && gList.size() < limit) {
                    //使用空会话补全(如果存在)
                    BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalGlobalEmptyGroup(key, 0, limit - gList.size(), new BIMResultCallback<BIMSearchGroupListResult>() {
                        @Override
                        public void onSuccess(BIMSearchGroupListResult result) {
                            emptyConvHasMore = result.isHasMore();
                            emptyConvCursor = result.getNextCursor();
                            List<BIMSearchGroupInfo> emptyConvList = result.getGroupInfoList();
                            gList.addAll(genWrapper(emptyConvList));
                            callback.onSuccess(gList);
                            isLoading = false;
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            isLoading = false;
                        }
                    });
                } else {
                    callback.onSuccess(gList);
                    isLoading = false;
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                isLoading = false;
            }

        });
    }

    /**
     * 搜索没有消息的空会话
     */
    public void loadMoreEmptyConv(BIMResultCallback<List<SearchGroupGWrapper>> callback) {
        if (!emptyConvHasMore) {
            return;
        }
        if (isLoading) {
            return;
        }
        isLoading = true;
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalGlobalEmptyGroup(key, emptyConvCursor, limit, new BIMResultCallback<BIMSearchGroupListResult>() {
            @Override
            public void onSuccess(BIMSearchGroupListResult result) {
                emptyConvHasMore = result.isHasMore();
                emptyConvCursor = result.getNextCursor();
                List<SearchGroupGWrapper> gList = genWrapper(result.getGroupInfoList());
                callback.onSuccess(gList);
                isLoading = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                isLoading = false;
            }
        });
    }

    private List<SearchGroupGWrapper> genWrapper(List<BIMSearchGroupInfo> emptyConvList) {
        List<SearchGroupGWrapper> gList = new ArrayList<>();
        if (emptyConvList != null) {
            for (BIMSearchGroupInfo info : emptyConvList) {
                gList.add(new SearchGroupGWrapper(info.getConversation(), info));
            }
        }
        return gList;
    }
}
