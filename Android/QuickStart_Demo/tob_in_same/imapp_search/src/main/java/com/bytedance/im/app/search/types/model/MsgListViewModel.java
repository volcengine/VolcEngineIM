package com.bytedance.im.app.search.types.model;

import android.util.Log;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMGetMessageByTypeOption;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageListResult;

import java.util.Collections;
import java.util.List;

public class MsgListViewModel {
    private static final String TAG = "MsgListViewModel";
    private BIMMessage anchor = null;
    private String conversationId;
    private BIMMessageType messageType;
    private boolean hasMore = true;
    private boolean isPulling;
    private BIMPullDirection bimPullDirection;

    public MsgListViewModel(String conversationID, BIMMessageType messageType,BIMPullDirection bimPullDirection) {
        this.conversationId = conversationID;
        this.messageType = messageType;
        this.bimPullDirection = bimPullDirection;
    }

    public void loadMore(BIMResultCallback<List<BIMMessage>> callback) {
        if (isPulling || !hasMore) {
            return;
        }
        isPulling = true;
        BIMGetMessageByTypeOption option = new BIMGetMessageByTypeOption
                .Builder()
                .anchorMessage(anchor)
                .limit(32)
                .messageTypeList(Collections.singletonList(messageType))
                .direction(bimPullDirection)
                .build();
        BIMClient.getInstance().getLocalMessageListByType(conversationId, option, new BIMResultCallback<BIMMessageListResult>() {
            @Override
            public void onSuccess(BIMMessageListResult bimMessageListResult) {
                hasMore = bimMessageListResult.isHasMore();
                anchor = bimMessageListResult.getAnchorMessage();
                Log.i(TAG, "loadMore onSuccess messageType: " + messageType + " hasMore: " + hasMore);
                isPulling = false;
                callback.onSuccess(bimMessageListResult.getMessageList());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                isPulling = false;
            }
        });
    }

    public boolean isHasMore() {
        return hasMore;
    }

    public boolean isPulling() {
        return isPulling;
    }

    public BIMMessageType getMessageType() {
        return messageType;
    }
}
