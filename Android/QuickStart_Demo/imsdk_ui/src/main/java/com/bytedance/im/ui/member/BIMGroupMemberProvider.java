package com.bytedance.im.ui.member;

import android.util.LruCache;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMGroupMemberListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.log.BIMLog;

import java.util.Collections;
import java.util.List;

public class BIMGroupMemberProvider {
    private static final int DEFAULT_CACHE_SIZE = 20;
    private final LruCache<String, LruCache<Long, BIMMember>> lruCache = new LruCache<>(40);

    public void init() {
        BIMClient.getInstance().addGroupMemberListener(new BIMGroupMemberListener() {
            @Override
            public void onBatchMemberInfoChanged(BIMConversation conversation, List<BIMMember> members) {
                LruCache<Long, BIMMember> map = lruCache.get(conversation.getConversationID());
                if (map != null) {
                    for (BIMMember member: members) {
                        map.put(member.getUserID(), member);
                    }
                    lruCache.put(conversation.getConversationID(), map);
                }
            }
        });
    }

    private BIMMember getMemberInner(String conversationId, long uid) {
        LruCache<Long, BIMMember> map = lruCache.get(conversationId);
        if (map == null) {
            return null;
        } else {
            return map.get(uid);
        }
    }

    public BIMMember getMember(String conversationId, long uid) {
        BIMMember ret = getMemberInner(conversationId, uid);
        if (ret == null) {
            getMemberAsync(conversationId, uid, null);
        }
        return ret;
    }

    public void getMemberAsync(String conversationId, long uid, BIMResultCallback<BIMMember> callback) {
        BIMClient.getInstance().getConversationMemberList(conversationId, Collections.singletonList(uid), new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> members) {
                LruCache<Long, BIMMember> map = lruCache.get(conversationId);
                if (map == null) {
                    map = new LruCache<>(DEFAULT_CACHE_SIZE);
                }
                if (members != null && members.size() > 0) {
                    BIMMember member = members.get(0);
                    if (member != null) {
                        map.put(member.getUserID(), member);
                        lruCache.put(conversationId, map);
                    }
                    if (callback != null) {
                        callback.onSuccess(member);
                    }
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

    public void initGroupMembers(String conversationId) {
        BIMClient.getInstance().getConversationMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
            @Override
            public void onSuccess(List<BIMMember> members) {
                if (members != null && !members.isEmpty()) {
                    LruCache<Long, BIMMember> map = new LruCache<>(members.size());
                    for (BIMMember member: members) {
                        if (member != null) {
                            map.put(member.getUserID(), member);
                        }
                    }
                    lruCache.put(conversationId, map);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.e("BIMMemberProvider", "load member list failed");
            }
        });
    }
}
