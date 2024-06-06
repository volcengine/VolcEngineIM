package com.bytedance.im.app;

import android.app.Application;
import android.util.LruCache;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.BIMFriendListener;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * 用户资料提供者默认写法，可复制使用。搭配 IMSDK 用户资料功能(BIMContactExpandService)。
 */
public class BIMDefaultUserProvider implements BIMUserProvider {


    private List<OnUserInfoUpdateListener> listenerList = new CopyOnWriteArrayList<>();
    private LruCache<Long, BIMUIUser> lruCache;

    public BIMDefaultUserProvider(int capacity) {
        lruCache = new LruCache<>(capacity);
    }

    @Override
    public BIMUIUser getUserInfo(long uid) {
        BIMUIUser userClone = lruCache.get(uid);
        if (userClone != null) {
            return userClone.clone();
        }
        return null;
    }

    @Override
    public void getUserInfoAsync(long uid, BIMResultCallback<BIMUIUser> callback) {
        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfo(uid, new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo bimUserFullInfo) {
                if (callback != null) {
                    BIMUIUser bimuiUser = convert(bimUserFullInfo);
                    if (bimuiUser != null) {
                        BIMUIUser userClone = bimuiUser.clone();
                        lruCache.put(userClone.getUid(), userClone);
                        callback.onSuccess(userClone);
                    }
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    @Override
    public void getUserInfoListAsync(List<Long> uidList, BIMResultCallback<List<BIMUIUser>> callback) {
        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfoList(uidList, new BIMResultCallback<List<BIMUserFullInfo>>() {
            @Override
            public void onSuccess(List<BIMUserFullInfo> infoList) {
                if (callback != null) {
                    List<BIMUIUser> result = new ArrayList<>();
                    if (infoList != null && !infoList.isEmpty()) {
                        for (BIMUserFullInfo fullInfo : infoList) {
                            BIMUIUser bimuiUser = convert(fullInfo);
                            if (bimuiUser != null) {
                                BIMUIUser userClone = bimuiUser.clone();
                                lruCache.put(userClone.getUid(), userClone);
                                result.add(userClone);
                            }
                        }
                    }
                    callback.onSuccess(result);
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
    public void reloadUserInfo(long uid) {
        getUserInfoAsync(uid, reloadCallback);   //通知外部更新
    }

    private BIMUIUser convert(BIMUserFullInfo fullInfo) {
        if (fullInfo == null) {
            return null;
        }
        BIMUIUser user = new BIMUIUser();
        user.setUid(fullInfo.getUid());
        user.setNickName(fullInfo.getNickName());
        if (fullInfo.isFriend()) {
            user.setAlias(fullInfo.getAlias());
        } else {
            user.setAlias("");
        }
        user.setPortraitUrl(fullInfo.getPortraitUrl());
        user.setFriend(user.isFriend());
        user.setBlock(fullInfo.isBlock());
        return user;
    }

    public void clear() {
        lruCache.evictAll();
    }

    private BIMResultCallback<BIMUIUser> reloadCallback = new BIMResultCallback<BIMUIUser>() {
        @Override
        public void onSuccess(BIMUIUser user) {
            for (OnUserInfoUpdateListener listener : listenerList) {
                listener.onUpdate(user.getUid(), user);
            }
        }

        @Override
        public void onFailed(BIMErrorCode code) {

        }
    };

    public void addUserUpdateListener(OnUserInfoUpdateListener listener) {
        listenerList.add(listener);
    }

    public void removeUserUpdateListener(OnUserInfoUpdateListener listener) {
        listenerList.remove(listener);
    }

    @Override
    public void init(Application application) {
        //集成好友关系
        BIMClient.getInstance().getService(BIMContactExpandService.class).addFriendListener(createFriendListener());
    }

    private BIMFriendListener createFriendListener() {
        return new BIMFriendListener() {
            @Override
            public void onFriendApply(BIMFriendApplyInfo applyInfo) {

            }

            @Override
            public void onFriendDelete(BIMUserFullInfo userFullInfo) {
                reloadUserInfo(userFullInfo.getUid());
            }

            @Override
            public void onFriendUpdate(BIMUserFullInfo userFullInfo) {
                reloadUserInfo(userFullInfo.getUid());//最新信息刷到内存
            }

            @Override
            public void onFriendAdd(BIMUserFullInfo userFullInfo) {
                reloadUserInfo(userFullInfo.getUid());//最新信息刷到内存
            }

            @Override
            public void onFriendAgree(BIMFriendApplyInfo applyInfo) {
                reloadUserInfo(applyInfo.getUserFullInfo().getUid());//最新信息刷到内存
            }

            @Override
            public void onFriendRefuse(BIMFriendApplyInfo applyInfo) {

            }

            @Override
            public void onFriendApplyUnreadCountChanged(int count) {

            }

            @Override
            public void onBlackListAdd(BIMUserFullInfo userFullInfo) {
                reloadUserInfo(userFullInfo.getUid());//最新信息刷到内存
            }

            @Override
            public void onBlackListDelete(BIMUserFullInfo userFullInfo) {
                //黑名单删除
            }

            @Override
            public void onBlackListUpdate(BIMUserFullInfo userFullInfo) {
                reloadUserInfo(userFullInfo.getUid());//最新信息刷到内存
            }

            @Override
            public void onUserProfileUpdate(BIMUserFullInfo userFullInfo) {
                reloadUserInfo(userFullInfo.getUid());//最新信息刷到内存
            }
        };
    }
}
