package com.bytedance.im.app.contact.inviteList;

import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_FRIEND_MORE_THAN_LIMIT;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_FROM_USER_FRIEND_MORE_THAN_LIMIT;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.widget.ImageView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.BIMFriendListener;
import com.bytedance.im.user.api.enums.BIMFriendReplyType;
import com.bytedance.im.user.api.model.BIMBlackListFriendInfo;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.user.api.model.BIMFriendInfo;
import com.bytedance.im.user.api.model.BIMReplyInfo;

public class VEContactInviteActivity extends Activity {
    private static int PAGE_SIZE = 20;
    public static String TAG = "VEContactInviteActivity";

    private ImageView ivBack;
    private boolean mHasMore = true;
    private SwipeRefreshLayout swipe;
    private boolean mIsLoading = false;
    private RecyclerView rvContactList;
    private long mCursor = Long.MAX_VALUE;
    private final VEContactInviteAdapter adapter = new VEContactInviteAdapter();
    private final InviteContactClickListener listener = new InviteContactClickListener() {
        @Override
        public void onAgree(BIMFriendApplyInfo friendApplyInfo) {
            applyFriend(friendApplyInfo, true);
        }

        @Override
        public void onReject(BIMFriendApplyInfo friendApplyInfo) {
            applyFriend(friendApplyInfo, false);
        }
    };
    private BIMContactExpandService service = BIMClient.getInstance().getService(BIMContactExpandService.class);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_fragment_contact_invite_list);

        ivBack = findViewById(R.id.iv_back);
        ivBack.setOnClickListener(v -> finish());
        rvContactList = findViewById(R.id.rv_contact_list);
        rvContactList.setLayoutManager(new LinearLayoutManager(this));
        rvContactList.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                        >= recyclerView.computeVerticalScrollRange()) {
                    loadData();
                }
            }
        });

        rvContactList.setItemAnimator(null);
        adapter.setListener(this.listener);
        rvContactList.setAdapter(adapter);
        swipe = findViewById(R.id.swipe);
        swipe.setEnabled(false);
        loadData();

        if (null != service) {
            service.addFriendListener(this.friendListener);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (null != service) {
            service.removeFriendListener(this.friendListener);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (null != service) {
            service.markFriendApplyRead(null);
        }
    }

    private void loadData() {
        Log.d(TAG, " loadData, cursor " + mCursor + ", hasMore " + mHasMore);
        if (null != service && !mIsLoading && mHasMore) {
            mIsLoading = true;
            service.getFriendApplyList(this.mCursor, PAGE_SIZE, new BIMResultCallback<com.bytedance.im.user.api.model.BIMFriendApplyListResult>() {
                @Override
                public void onSuccess(com.bytedance.im.user.api.model.BIMFriendApplyListResult bimFriendApplyListResult) {
                    mIsLoading = false;
                    boolean isFirstPage = mCursor == Long.MAX_VALUE;
                    mHasMore = bimFriendApplyListResult.isHasMore();
                    mCursor = bimFriendApplyListResult.getNextCursor();
                    adapter.appendData(bimFriendApplyListResult.getApplyFriendList(), isFirstPage);
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    mIsLoading = false;
                    Log.e(TAG, " loadData, error " + code);
                }
            });
        }
    }

    private void applyFriend(BIMFriendApplyInfo friendApplyInfo, boolean isConfirm) {
        BIMReplyInfo apply = new BIMReplyInfo();
        apply.setUid(friendApplyInfo.getFromUid());
        apply.setReplyType(isConfirm ? BIMFriendReplyType.BIM_FRIEND_REPLY_AGREE : BIMFriendReplyType.BIM_FRIEND_REPLY_REFUSE);
        if (null != service) {
            service.replyFriendApply(apply, new BIMResultCallback<BIMFriendApplyInfo>() {
                @Override
                public void onSuccess(BIMFriendApplyInfo friendApplyInfo) {
                    Log.d(TAG, "apply success, " + friendApplyInfo.getFromUid());
                    Toast.makeText(VEContactInviteActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                    if (isConfirm) {
                        afterApplyFriend(friendApplyInfo);
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Log.d(TAG, "apply failed, " + friendApplyInfo.getFromUid() + ", error " + code);
                    if (code == BIM_SERVER_FRIEND_MORE_THAN_LIMIT) {
                        Toast.makeText(VEContactInviteActivity.this, "你的好友数量已到上限，请删除部分好友后重试", Toast.LENGTH_SHORT).show();
                    } else if (code == BIM_SERVER_FROM_USER_FRIEND_MORE_THAN_LIMIT) {
                        Toast.makeText(VEContactInviteActivity.this, "操作失败，对方的好友数量已到上限", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(VEContactInviteActivity.this, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }
    }

    private void afterApplyFriend(BIMFriendApplyInfo friendApplyInfo) {
        BIMClient.getInstance().createSingleConversation(friendApplyInfo.getFromUid(), new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                Log.d(TAG, "create conv success, convId " + conversation.getConversationID());
                BIMClient.getInstance().sendMessage(BIMClient.getInstance().createTextMessage("我已通过你的好友申请"), conversation.getConversationID(), new BIMSendCallback() {
                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        Log.d(TAG, "send msg to new conv success");
                    }

                    @Override
                    public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                        Log.e(TAG, "send msg to new conv failed, error " + code);
                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.e(TAG, "create conv failed, error " + code);
            }
        });
    }

    private final BIMFriendListener friendListener = new BIMFriendListener() {
        @Override
        public void onFriendApply(BIMFriendApplyInfo applyInfo) {
            Log.d(TAG, "insert apply info " + applyInfo.getFromUid());
            int index = adapter.insertOrUpdateData(applyInfo, !mHasMore);

            //insert, scroll to top and mark read
            if (index == 0) {
                rvContactList.smoothScrollToPosition(index);
                service.markFriendApplyRead(null);
            }
        }

        @Override
        public void onFriendDelete(BIMFriendInfo friendInfo) {

        }

        @Override
        public void onFriendAdd(BIMFriendInfo friendInfo) {

        }

        @Override
        public void onFriendAgree(BIMFriendApplyInfo applyInfo) {
            if (applyInfo.getFromUid() != BIMClient.getInstance().getCurrentUserID()) {
                adapter.insertOrUpdateData(applyInfo, false);
            }
        }

        @Override
        public void onFriendRefuse(BIMFriendApplyInfo applyInfo) {
            if (applyInfo.getFromUid() != BIMClient.getInstance().getCurrentUserID()) {
                adapter.insertOrUpdateData(applyInfo, false);
            }
        }

        @Override
        public void onFriendApplyUnreadCountChanged(int count) {
        }

        @Override
        public void onBlackListAdd(BIMBlackListFriendInfo blackListInfo) {

        }

        @Override
        public void onBlackListDelete(BIMBlackListFriendInfo blackListInfo) {

        }

        @Override
        public void onBlackListUpdate(BIMBlackListFriendInfo blackListInfo) {

        }
    };
}
