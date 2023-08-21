package com.bytedance.im.app.user;

import android.app.Application;
import android.app.Fragment;

import com.bytedance.im.app.R;
import com.bytedance.im.app.login.VELoginFragment;
import com.bytedance.im.interfaces.BIMAccountProvider;
import com.bytedance.im.interfaces.BIMAuthProvider;
import com.bytedance.im.interfaces.BIMUserExistChecker;
import com.bytedance.im.ui.api.BIMUser;
import com.bytedance.im.ui.api.interfaces.BIMCancelListener;
import com.bytedance.im.ui.user.BIMUserProvider;

import java.util.HashMap;
import java.util.Map;

public class VEDefaultAccountProvider implements BIMAccountProvider {
    @Override
    public void init(Application application, int appID, int env) {

    }

    @Override
    public BIMUserProvider getUserProvider() {
        return uid -> new BIMUser(R.drawable.icon_recommend_user_default, "用户" + uid, uid);
    }

    @Override
    public BIMUserExistChecker createUserExistChecker() {
        return (idList, callback) -> {
            //不做检查直接成功
            Map<Long, Boolean> map = new HashMap<>();
            for (long id : idList) {
                map.put(id, true);
            }
            callback.onSuccess(map);
        };
    }

    @Override
    public <T extends Fragment & BIMAuthProvider> T createLoginFragment() {
        return (T) new VELoginFragment();
    }

    @Override
    public void unregister(BIMCancelListener listener, long timeout) {
        listener.onFailed(-1, "not implement");
    }
}
