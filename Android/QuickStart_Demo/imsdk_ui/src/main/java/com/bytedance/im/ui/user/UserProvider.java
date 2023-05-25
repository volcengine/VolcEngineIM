package com.bytedance.im.ui.user;

import java.util.List;

public interface UserProvider {
    BIMUser getUserInfo(long uid);
    List<BIMUser> getAllUserInfo();
}
