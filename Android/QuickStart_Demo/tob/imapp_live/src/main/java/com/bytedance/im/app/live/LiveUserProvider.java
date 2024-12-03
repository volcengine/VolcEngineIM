package com.bytedance.im.app.live;

import android.app.Application;
import android.text.TextUtils;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 代理 defaultUserProvider 单例，拼接了直播群内用户备注
 */
public class LiveUserProvider implements BIMUserProvider {

    private Map<Long, LiveUserInfo> map = new HashMap<>();

    public LiveUserProvider() {
    }

    @Override
    public BIMUIUser getUserInfo(long uid) {
        BIMUIUser bimuiUser = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid);
        return interceptBIMUIUser(bimuiUser);
    }

    @Override
    public void getUserInfoAsync(long uid, BIMResultCallback<BIMUIUser> callback) {
        BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(uid, new BIMResultCallback<BIMUIUser>() {
            @Override
            public void onSuccess(BIMUIUser bimuiUser) {
                if (callback != null) {
                    callback.onSuccess(interceptBIMUIUser(bimuiUser));
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

    @Override
    public void getUserInfoListAsync(List<Long> uidList, BIMResultCallback<List<BIMUIUser>> callback) {
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList, new BIMResultCallback<List<BIMUIUser>>() {

            @Override
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                List<BIMUIUser> resultList = new ArrayList<>();
                if (callback != null) {
                    if (bimuiUsers != null && !bimuiUsers.isEmpty()) {
                        for (BIMUIUser user : bimuiUsers) {
                            resultList.add(interceptBIMUIUser(user));
                        }
                        callback.onSuccess(resultList);
                    }
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (callback != null) {
                    callback.failed(null, code);
                }
            }
        });
    }

    @Override
    public void reloadUserInfo(long uid) {
        BIMUIClient.getInstance().getUserProvider().reloadUserInfo(uid);
    }

    @Override
    public void addUserUpdateListener(OnUserInfoUpdateListener listener) {
        BIMUIClient.getInstance().getUserProvider().addUserUpdateListener(listener);
    }

    @Override
    public void removeUserUpdateListener(OnUserInfoUpdateListener listener) {
        BIMUIClient.getInstance().getUserProvider().removeUserUpdateListener(listener);
    }

    @Override
    public void init(Application application) {

    }

    /**
     * 加上群相关资料
     *
     * @param bimuiUser
     * @return
     */
    public BIMUIUser interceptBIMUIUser(BIMUIUser bimuiUser) {
        if (bimuiUser != null && map.containsKey(bimuiUser.getUid())) {
            LiveUserInfo liveUserInfo = map.get(bimuiUser.getUid());
            bimuiUser.setMemberAlias(liveUserInfo.getLiveAlias());
            if (!TextUtils.isEmpty(liveUserInfo.getLivePortraitUrl())) {
                bimuiUser.setPortraitUrl(liveUserInfo.getLivePortraitUrl());
            }
        }
        return bimuiUser;
    }

    public void cacheLiveUserInfo(LiveUserInfo userInfo) {
        map.put(userInfo.uid, userInfo);
    }

    public boolean isCachedLiveInfo(long uid) {
        return map.containsKey(uid);
    }

    public static class LiveUserInfo {
        private long uid;
        private String liveAlias;
        private String livePortraitUrl;

        public LiveUserInfo(long uid, String liveAlias, String liveUrl) {
            this.uid = uid;
            this.liveAlias = liveAlias;
            this.livePortraitUrl = liveUrl;
        }

        public String getLiveAlias() {
            return liveAlias;
        }

        public String getLivePortraitUrl() {
            return livePortraitUrl;
        }
    }
}
