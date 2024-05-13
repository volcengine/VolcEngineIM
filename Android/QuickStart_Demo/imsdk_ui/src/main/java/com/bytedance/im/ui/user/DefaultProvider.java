package com.bytedance.im.ui.user;

import android.app.Application;

import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class DefaultProvider implements BIMUserProvider{
    @Override
    public BIMUIUser getUserInfo(long uid) {
        BIMUIUser bimuiUser = new BIMUIUser();
        bimuiUser.setAlias(String.valueOf(uid));
        return bimuiUser;
    }

    @Override
    public void getUserInfoAsync(long uid, BIMResultCallback<BIMUIUser> callback) {

    }

    @Override
    public void getUserInfoListAsync(List<Long> uidList, BIMResultCallback<List<BIMUIUser>> callback) {
        if(callback==null){
            return;
        }
        List<BIMUIUser> result = new ArrayList<>();
        if (uidList != null && !uidList.isEmpty()) {
            for (Long uid : uidList) {
                BIMUIUser bimuiUser = new BIMUIUser();
                bimuiUser.setNickName(String.valueOf(uid));
                result.add(bimuiUser);
            }
        }
        callback.onSuccess(result);
    }

    @Override
    public void reloadUserInfo(long uid) {

    }

    @Override
    public void addUserUpdateListener(OnUserInfoUpdateListener listener) {

    }

    @Override
    public void removeUserUpdateListener(OnUserInfoUpdateListener listener) {

    }

    @Override
    public void init(Application application) {

    }
}
