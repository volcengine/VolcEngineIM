package com.bytedance.im.ui.user;


import com.bytedance.im.ui.api.BIMUIUser;

import java.util.List;

public class UserManager {

    public static UserManager geInstance() {
        return SingleHolder.instance;
    }

    private static final class SingleHolder {
        private static final UserManager instance = new UserManager();
    }

    private BIMUserProvider BIMUserProvider;

    public void setUserProvider(BIMUserProvider BIMUserProvider) {
        this.BIMUserProvider = BIMUserProvider;
    }

    public BIMUserProvider getUserProvider() {
        return BIMUserProvider;
    }

    public String getUserName(long uid){
        BIMUIUser BIMUIUser = getUserProvider().getUserInfo(uid);
        String name = "" + uid;
        if (BIMUIUser != null) {
            name = BIMUIUser.getNickName();
        }
        return name;
    }

    public String builderNamelist(List<Long> uidList) {
        if (uidList == null || uidList.isEmpty()) return "";
        StringBuilder builder = new StringBuilder();
        for (long uid : uidList) {
            builder.append("用户" + uid);
            builder.append(",");
        }
        return builder.substring(0, builder.length() - 1);
    }
}
