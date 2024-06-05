package com.bytedance.im.app;

import android.app.Application;
import android.app.Fragment;

import com.bytedance.im.app.in.login.VELoginFragment;
import com.bytedance.im.ui.api.interfaces.BIMAccountProvider;
import com.bytedance.im.ui.api.interfaces.BIMAuthProvider;
import com.bytedance.im.ui.api.interfaces.BIMCancelListener;
import com.bytedance.im.ui.api.interfaces.BIMUserExistChecker;

import java.util.HashMap;
import java.util.Map;

public class VEDefaultAccountProvider implements BIMAccountProvider {
    @Override
    public void init(Application application, int appID, int env) {

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
