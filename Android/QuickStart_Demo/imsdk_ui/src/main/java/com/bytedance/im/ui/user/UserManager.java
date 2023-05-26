package com.bytedance.im.ui.user;


import com.bytedance.im.ui.api.BIMUser;

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
        BIMUser BIMUser = getUserProvider().getUserInfo(uid);
        String name = "" + uid;
        if (BIMUser != null) {
            name = BIMUser.getNickName();
        }
        return name;
    }

    public String builderNamelist(List<Long> uidList) {
        if (uidList == null || uidList.isEmpty()) return "";
        StringBuilder builder = new StringBuilder();
        for (long uid : uidList) {
            builder.append(getUserName(uid));
            builder.append(",");
        }
        return builder.substring(0, builder.length() - 1);
    }
}
