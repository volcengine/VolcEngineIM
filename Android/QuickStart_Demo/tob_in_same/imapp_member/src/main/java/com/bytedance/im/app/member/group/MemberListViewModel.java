package com.bytedance.im.app.member.group;

import android.util.Log;

import com.bytedance.im.app.member.group.adapter.MemberUtils;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MemberListViewModel {
    private static final String TAG = "MemberListViewModel";
    private String conversationId;
    private List<List<BIMMember>> memberPages = new ArrayList<>();
    private int pageSize = 20;
    private int curPage = 0;
    private boolean isInit = false;
    private boolean isLoading = false;

    public MemberListViewModel(String conversationId, int pageSize) {
        this.conversationId = conversationId;
        this.pageSize = pageSize;

    }

    public boolean hasMore() {
        int max = memberPages.size();
        boolean hasMore = curPage < max;
        Log.i(TAG, "hasMore() curPage: " + curPage + " max: " + max + " hasMore:" + hasMore);
        return hasMore;
    }

    /**
     * 加载更多,拉取成员信息+用户全资料
     */
    public void loadMore(BIMResultCallback<List<MemberWrapper>> callback) {
        Log.i(TAG, "loadMore() page: " + curPage);
        if (isLoading) {
            return;
        }
        isLoading = true;
        if (!isInit) {
            BIMClient.getInstance().getConversationMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
                @Override
                public void onSuccess(List<BIMMember> members) {
                    if (members != null) {
                        MemberUtils.sortMember(members);
                        List<BIMMember> list = new ArrayList<>();
                        for (int i = 0; i < members.size(); i++) {
                            if (i % pageSize == 0) {
                                list = new ArrayList<>();
                                memberPages.add(list);
                            }
                            list.add(members.get(i));
                        }
                    }
                    realLoadMore(callback);
                    isInit = true;
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    if (callback != null) {
                        callback.onFailed(code);
                    }
                }
            });
        } else {
            realLoadMore(callback);
        }
    }

    private void realLoadMore(BIMResultCallback<List<MemberWrapper>> callback) {
        List<BIMMember> members = memberPages.get(curPage);
        getMemberWrapperList(members, new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> memberWrappers) {
                if (memberWrappers != null) {
                    StringBuilder idStr = new StringBuilder("[");

                    for (MemberWrapper w : memberWrappers) {
                        idStr.append(",").append(w.getMember().getUserID());
                    }
                    idStr.append("]");

                    Log.i(TAG, "realLoadMore() onSuccess memberIds: " + idStr.toString());
                }
                callback.onSuccess(memberWrappers);
                curPage++;
                isLoading = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                callback.onFailed(code);
                isLoading = false;
            }
        });

    }

    /**
     * 拼接成员和用户资料
     *
     * @param members
     * @param callback
     */
    public static void getMemberWrapperList(List<BIMMember> members, BIMResultCallback<List<MemberWrapper>> callback) {
        if (members == null) {
            callback.onFailed(BIMErrorCode.BIM_PARAMETER_ERROR);
            return;
        }
        List<Long> uidList = new ArrayList<>();
        for (BIMMember member : members) {
            uidList.add(member.getUserID());
        }
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimUserFullInfos) {
                List<MemberWrapper> data = new ArrayList<>();
                if (bimUserFullInfos != null) {
                    Map<Long, BIMUIUser> map = new HashMap<>();
                    for (BIMUIUser user : bimUserFullInfos) {
                        map.put(user.getUid(), user);
                    }
                    for (BIMMember bimMember : members) {
                        data.add(new MemberWrapper(bimMember, map.get(bimMember.getUserID()), MemberWrapper.TYPE_NORMAL));
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
