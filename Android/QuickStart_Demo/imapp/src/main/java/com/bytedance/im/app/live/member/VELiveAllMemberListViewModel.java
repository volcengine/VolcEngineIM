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
 * 拼接常驻成员和在线成员
 */
public class VELiveAllMemberListViewModel {
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

    public VELiveAllMemberListViewModel(long conversationId, OnLoadMemberListener listener) {
        this.conversationId = conversationId;
        this.listener = listener;
    }

    private void loadAdmin() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberList(conversationId, cursor, pageSize, new BIMResultCallback<BIMLiveMemberListResult>() {
            @Override
            public void onSuccess(BIMLiveMemberListResult bimLiveMemberListResult) {
                cursor = bimLiveMemberListResult.getNextCursor();
                hasMore = bimLiveMemberListResult.isHasMore();
                adminSet.addAll(bimLiveMemberListResult.getMemberList());
                if (listener != null) {
                    listener.onLoadMore(bimLiveMemberListResult.getMemberList());
                }
                if (!hasMore) {
                    loadType = LOAD_TYPE_ONLINE;
                    cursor = -1;
                    hasMore = true;
                    loadOnline();
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    private void loadOnline() {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMemberOnlineList(conversationId, cursor, pageSize, new BIMResultCallback<BIMLiveMemberListResult>() {
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
            if (loadType == LOAD_TYPE_ADMIN) {
                loadAdmin();
            } else if (loadType == LOAD_TYPE_ONLINE) {
                loadOnline();
            }
            return true;
        }
        return false;
    }
}
