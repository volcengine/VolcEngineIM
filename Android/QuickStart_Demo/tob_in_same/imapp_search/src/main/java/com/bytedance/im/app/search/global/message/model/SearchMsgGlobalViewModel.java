package com.bytedance.im.app.search.global.message.model;

import android.util.Log;

import com.bytedance.im.app.search.global.message.adapter.SearchMsgGWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchMsgInConvInfo;
import com.bytedance.im.search.api.model.BIMSearchMsgInConvListResult;

import java.util.ArrayList;
import java.util.List;

public class SearchMsgGlobalViewModel {
    private static String TAG = "SearchMsgGlobalViewModel";
    private String key;
    private long cursor = 0;
    private int limit;
    private boolean hasMore = true;
    private boolean isLoading = false;

    public SearchMsgGlobalViewModel(String key, int limit) {
        this.key = key;
        this.limit = limit;
    }


    public void loadMore(BIMResultCallback<List<SearchMsgGWrapper>> callback) {
        Log.i(TAG, "loadMore: cursor: " + cursor + " limit: " + limit + " isLoading: "+isLoading +" hasMore: "+hasMore);

        if (isLoading) {
            Log.i(TAG, "loadMore isLoading return!");
            return;
        }
        if (!hasMore) {
            Log.i(TAG, "loadMore not hasMore return!");
            return;
        }
        isLoading = true;
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalGlobalMessage(key, cursor, limit, new BIMResultCallback<BIMSearchMsgInConvListResult>() {
            @Override
            public void onSuccess(BIMSearchMsgInConvListResult bimSearchMsgConvListResult) {
                //搜索结果
                hasMore = bimSearchMsgConvListResult.isHasMore();
                cursor = bimSearchMsgConvListResult.getNextCursor();
                List<BIMSearchMsgInConvInfo> infoList = bimSearchMsgConvListResult.getSearchMsgConvInfoList();
                List<SearchMsgGWrapper> mList = new ArrayList<>();
                if (infoList != null) {
                    for (BIMSearchMsgInConvInfo info : infoList) {
                        mList.add(new SearchMsgGWrapper(info,info.getConversation()));
                    }
                }
                callback.onSuccess(mList);
                isLoading = false;
                Log.i(TAG, "searchGlobalLocalMessage success! hasMore:" + hasMore + " cursor:" + cursor + " convSize:" + bimSearchMsgConvListResult.getSearchMsgConvInfoList().size());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "searchGlobalLocalMessage failed! key:" + key);
                if (callback != null) {
                    callback.onFailed(code);
                }
                isLoading = false;
            }
        });
    }
}
