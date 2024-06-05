package com.bytedance.im.app.search.types.model;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMGetMessageByTypeOption;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchMessageListResult;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;

import java.util.Collections;
import java.util.List;

public class SearchViewModel {
    private BIMSearchMsgInfo anchorSearchInfo = null;
    private String conversationId;
    private boolean hasMore = true;
    private boolean isPulling;
    private String searchKey;
    private BIMMessageType bimMessageType;
    private BIMPullDirection bimPullDirection;

    public SearchViewModel(String conversationID, BIMMessageType messageType, String searchKey,BIMPullDirection pullDirection) {
        this.conversationId = conversationID;
        this.bimMessageType = messageType;
        this.searchKey = searchKey;
        this.bimPullDirection = pullDirection;
    }

    public void loadMore(BIMResultCallback<List<BIMSearchMsgInfo>> callback) {
        if (isPulling || !hasMore) return;
        isPulling = true;
        BIMMessage anchorMessage = null;
        if (anchorSearchInfo != null) {
            anchorMessage = anchorSearchInfo.getMessage();
        }
        BIMGetMessageByTypeOption option = new BIMGetMessageByTypeOption
                .Builder()
                .anchorMessage(anchorMessage)
                .limit(20)
                .messageTypeList(Collections.singletonList(bimMessageType))
                .direction(bimPullDirection)
                .build();
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalMessageWithMsgType(searchKey, conversationId, option, new BIMResultCallback<BIMSearchMessageListResult>() {

            @Override
            public void onSuccess(BIMSearchMessageListResult bimSearchMessageListResult) {
                hasMore = bimSearchMessageListResult.isHasMore();
                callback.onSuccess(bimSearchMessageListResult.getSearchMsgInfoList());
                anchorSearchInfo = bimSearchMessageListResult.getAnchorSearchMsgInfo();
                isPulling = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                isPulling = false;
                callback.onFailed(code);
            }
        });
    }

    public boolean isHasMore() {
        return hasMore;
    }

    public BIMMessageType getBimMessageType() {
        return bimMessageType;
    }
}
