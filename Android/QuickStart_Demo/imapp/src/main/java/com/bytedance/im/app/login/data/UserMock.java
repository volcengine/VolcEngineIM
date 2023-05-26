package com.bytedance.im.app.login.data;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.api.BIMUser;

import java.util.ArrayList;
import java.util.List;

/**
 * 数据mock
 */
public class UserMock {
    private List<BIMUser> data = new ArrayList<>();

    private static final class InstanceHolder {
        private static final UserMock instance = new UserMock();
    }

    private UserMock() {
        data.add(new BIMUser(R.drawable.fake_icon_user_1, "测试用户1", 10001));
        data.add(new BIMUser(R.drawable.fake_icon_user_2, "测试用户2", 10002));
        data.add(new BIMUser(R.drawable.fake_icon_user_3, "测试用户3", 10003));
        data.add(new BIMUser(R.drawable.fake_icon_user_4, "测试用户4", 10004));
        data.add(new BIMUser(R.drawable.fake_icon_user_5, "测试用户5", 10005));
        data.add(new BIMUser(R.drawable.fake_icon_user_6, "测试用户6", 10006));
        data.add(new BIMUser(R.drawable.fake_icon_user_7, "测试用户7", 10007));
        data.add(new BIMUser(R.drawable.fake_icon_user_8, "测试用户8", 10008));
        data.add(new BIMUser(R.drawable.fake_icon_user_9, "测试用户9", 10009));
        data.add(new BIMUser(R.drawable.fake_icon_user_10, "测试用户10", 10010));
    }

    public static UserMock getInstance() {
        return InstanceHolder.instance;
    }

    public List<BIMUser> getMockLoginUserList() {
        return new ArrayList<>(data);
    }

    public BIMUser getUserInfo(long uid) {
        for (BIMUser user : data) {
            if (user.getUserID() == uid) {
                return user;
            }
        }
        return null;
    }

    public void updateName(long uid, String nickName) {
        for (BIMUser user : data) {
            if (user.getUserID() == uid) {
                user.setNickName(nickName);
            }
        }
    }
}
