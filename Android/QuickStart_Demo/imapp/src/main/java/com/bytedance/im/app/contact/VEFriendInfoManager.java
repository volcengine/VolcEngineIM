package com.bytedance.im.app.contact;

import android.text.TextUtils;
import android.util.Log;
import android.util.LruCache;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.BIMFriendListener;
import com.bytedance.im.user.api.model.BIMBlackListFriendInfo;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.user.api.model.BIMFriendInfo;

public class VEFriendInfoManager implements BIMUserProvider {
    private static String TAG = "VEFriendInfoManager";
    private static VEFriendInfoManager instance = null;

    private final LruCache<Long, DataWrapper> cache = new LruCache<>(100);

    private VEFriendInfoManager() { }

    public void init() {
        cache.evictAll();
        BIMClient.getInstance().getService(BIMContactExpandService.class).addFriendListener(new BIMFriendListener() {
            @Override
            public void onFriendApply(BIMFriendApplyInfo applyInfo) {

            }

            @Override
            public void onFriendDelete(BIMFriendInfo friendInfo) {
                Log.d(TAG, "onFriendDelete " + friendInfo);
                if (cache.snapshot().containsKey(friendInfo.getUid())) {
                    Log.d(TAG, "onFriendDelete remove");
                    cache.get(friendInfo.getUid()).resetFriendInfo();
                }
            }

            @Override
            public void onFriendUpdate(BIMFriendInfo friendInfo) {
                Log.d(TAG, "onFriendUpdate " + friendInfo);
                if (cache.snapshot().containsKey(friendInfo.getUid())) {
                    Log.d(TAG, "onFriendUpdate update");
                    cache.get(friendInfo.getUid()).setFriendInfo(friendInfo);
                }
            }

            @Override
            public void onFriendAdd(BIMFriendInfo friendInfo) {

            }

            @Override
            public void onFriendAgree(BIMFriendApplyInfo applyInfo) {

            }

            @Override
            public void onFriendRefuse(BIMFriendApplyInfo applyInfo) {

            }

            @Override
            public void onFriendApplyUnreadCountChanged(int count) {

            }

            @Override
            public void onBlackListAdd(BIMBlackListFriendInfo blackListFriendInfo) {

            }

            @Override
            public void onBlackListDelete(BIMBlackListFriendInfo blackListFriendInfo) {

            }

            @Override
            public void onBlackListUpdate(BIMBlackListFriendInfo blackListFriendInfo) {

            }
        });
    }

    public static VEFriendInfoManager getInstance() {
        if (instance == null) {
            synchronized (VEFriendInfoManager.class) {
                if (instance == null) {
                    instance = new VEFriendInfoManager();
                }
            }
        }
        return instance;
    }

    public BIMFriendInfo getFriendInfo(long uid) {
        BIMFriendInfo friendInfo = null;
        DataWrapper dataWrapper = cache.get(uid);
        if (dataWrapper == null) {
            Log.d(TAG, "getFriendInfo dismiss " + uid);
            friendInfo = BIMClient.getInstance().getService(BIMContactExpandService.class).getFriend(uid);
            cache.put(uid, new DataWrapper(friendInfo, uid));
        } else {
            friendInfo = dataWrapper.getFriendInfo();
        }

        Log.d(TAG, "getFriendInfo " + uid + ", " + friendInfo);
        return friendInfo;
    }

    public String getFriendAlias(long uid) {
        BIMFriendInfo friendInfo = getFriendInfo(uid);
        boolean existAlias = friendInfo != null && !TextUtils.isEmpty(friendInfo.getAlias());

        if (existAlias) {
            return friendInfo.getAlias();
        } else {
            return null;
        }
    }

    @Override
    public BIMUIUser getUserInfo(long uid) {
        BIMFriendInfo friendInfo = getFriendInfo(uid);
        boolean existAlias = friendInfo != null && !TextUtils.isEmpty(friendInfo.getAlias());

        String nickName = existAlias ? friendInfo.getAlias() : ("用户" + uid);
        return new BIMUIUser(R.drawable.icon_recommend_user_default, nickName, uid);
    }

    public void reset() {
        cache.evictAll();
    }
}


class DataWrapper {
    private long uid;
    private boolean isValid = false;
    private BIMFriendInfo friendInfo;

    public DataWrapper(BIMFriendInfo friendInfo, long uid) {
        this.uid = uid;
        this.friendInfo = friendInfo;
        isValid = friendInfo != null;
    }

    public boolean isValid() {
        return isValid;
    }

    public BIMFriendInfo getFriendInfo() {
        return friendInfo;
    }

    public void setFriendInfo(BIMFriendInfo friendInfo) {
        this.friendInfo = friendInfo;
        isValid = friendInfo != null;
    }

    public void resetFriendInfo() {
        setFriendInfo(null);
    }
}