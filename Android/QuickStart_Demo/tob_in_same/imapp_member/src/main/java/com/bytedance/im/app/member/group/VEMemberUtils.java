package com.bytedance.im.app.member.group;

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
