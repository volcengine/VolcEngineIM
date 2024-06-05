package com.bytedance.im.app.live;

import com.bytedance.im.app.live.member.adapter.VELiveMemberWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VELiveMemberUtils {
    /**
     * 拉取成员信息+用户全资料
     *
     * @param conversationId
     * @param callback
     */
    public static void getGroupMemberList(String conversationId, BIMResultCallback<List<VELiveMemberWrapper>> callback) {
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
    public static void getMemberWrapperList(List<BIMMember> members, BIMResultCallback<List<VELiveMemberWrapper>> callback){
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
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                List<VELiveMemberWrapper> data = new ArrayList<>();
                if (bimuiUsers != null) {
                    Map<Long, BIMUIUser> map = new HashMap<>();
                    for (BIMUIUser userFullInfo : bimuiUsers) {
                        map.put(userFullInfo.getUid(), userFullInfo);
                    }
                    for (BIMMember bimMember : members) {
                        data.add(new VELiveMemberWrapper(bimMember, map.get(bimMember.getUserID()), VELiveMemberWrapper.TYPE_NORMAL));
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

    /**
     * 群成员排序
     *
     * @param data
     */
    public static void sort(List<VELiveMemberWrapper> data) {
        Collections.sort(data, (o1, o2) -> {
            int tr = o1.getOrder() - o2.getOrder();
            if (tr == 0) {
                return (int) (o1.getMember().getUserID() - (int)o2.getMember().getUserID());
            } else {
                return tr;
            }
        });
    }
}
