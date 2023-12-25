package com.bytedance.im.app.detail.member;

import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VEMemberUtils {
    /**
     * 拉取成员信息+用户全资料
     *
     * @param conversationId
     * @param callback
     */
    public static void getGroupMemberList(String conversationId, BIMResultCallback<List<MemberWrapper>> callback) {
        BIMClient.getInstance().getConversationMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> members) {
                getMemberWrapperList(members,callback);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (callback != null) {
                    callback.onFailed(code);
                }
            }
        });
    }

    /**
     * 拼接成员和用户资料
     * @param members
     * @param callback
     */
    public static void getMemberWrapperList(List<BIMMember> members, BIMResultCallback<List<MemberWrapper>> callback){
        if (members == null) {
            callback.onFailed(BIMErrorCode.BIM_PARAMETER_ERROR);
            return;
        }
        List<Long> uidList = new ArrayList<>();
        for (BIMMember member : members) {
            uidList.add(member.getUserID());
        }
        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfoList(uidList,false, new BIMResultCallback<List<BIMUserFullInfo>>() {
            @Override
            public void onSuccess(List<BIMUserFullInfo> bimUserFullInfos) {
                List<MemberWrapper> data = new ArrayList<>();
                if (bimUserFullInfos != null) {
                    Map<Long, BIMUserFullInfo> map = new HashMap<>();
                    for (BIMUserFullInfo userFullInfo : bimUserFullInfos) {
                        map.put(userFullInfo.getUid(), userFullInfo);
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
