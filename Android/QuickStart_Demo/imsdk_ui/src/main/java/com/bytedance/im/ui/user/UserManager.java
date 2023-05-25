package com.bytedance.im.ui.user;


import java.util.List;

public class UserManager {

    public static UserManager geInstance() {
        return SingleHolder.instance;
    }

    private static final class SingleHolder {
        private static final UserManager instance = new UserManager();
    }

    private UserProvider userProvider;

    public void setUserProvider(UserProvider userProvider) {
        this.userProvider = userProvider;
    }

    public UserProvider getUserProvider() {
        return userProvider;
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
