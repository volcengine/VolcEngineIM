package com.bytedance.im.app.live.member;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveMemberListResult;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

/**
 * 在线成员
 */
public class VELiveMarksMemberListViewModel {
    private long conversationId;
    private Set<BIMMember> adminSet = new HashSet<>();
    private int LOAD_TYPE_ADMIN = 0;
    private int LOAD_TYPE_ONLINE = 1;
    private int loadType = LOAD_TYPE_ADMIN;
    private String markType;
    private long cursor = -1;
    private long pageSize = 20;
    private boolean hasMore = true;
    private OnLoadMemberListener listener;
    public interface OnLoadMemberListener {
        void onLoadMore(List<BIMMember> memberList);
    }

    public VELiveMarksMemberListViewModel(long conversationId, String markType, OnLoadMemberListener listener) {
        this.conversationId = conversationId;
        this.listener = listener;
        this.markType = markType;
    }

    private void loadOnline() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberOnlineList(conversationId, cursor, pageSize, markType, new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult resultMemberList) {
                cursor = resultMemberList.getNextCursor();
                hasMore = resultMemberList.isHasMore();
                List<BIMMember> onlineMemberList = resultMemberList.getMemberList();
                if (onlineMemberList != null && adminSet != null) {
                    Iterator<BIMMember> iterator = onlineMemberList.iterator();
                    while (iterator.hasNext()) {
                        BIMMember member = iterator.next();
                        if (adminSet.contains(member)) {
                            iterator.remove();
                        }
                    }
                }
                if (listener != null) {
                    listener.onLoadMore(onlineMemberList);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    public boolean loadMore() {
        if (hasMore) {
            loadOnline();
            return true;
        }
        return false;
    }
}
