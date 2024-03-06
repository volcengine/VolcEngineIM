package com.bytedance.im.app.main;

import android.app.AlertDialog;
import android.app.Fragment;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMConversationListResult;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.conversation.adapter.VEConversationListAdapter;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;
import com.bytedance.im.user.BIMContactExpandService;

import java.util.ArrayList;
import java.util.List;

public class VEFriendConversationFragment extends Fragment {
    private static final String TAG = "VEFriendConversationFragment";
    private RecyclerView recyclerView;
    private long cursor = -1;
    private boolean hasMore = true;
    private FriendConversationAdapter adapter;
    private View rootView, emptyView;
    private List<BIMConversation> initNeedDeleteConversation;

    protected void loadData() {
        BIMLog.i(TAG, "loadData()");
        BIMClient.getInstance().getService(BIMContactExpandService.class)
                .getFriendConversationList(cursor, 20, new BIMResultCallback<BIMConversationListResult>() {
            @Override
            public void onSuccess(BIMConversationListResult bimConversationListResult) {
                BIMLog.i(TAG, "onSuccess() hasMore: " + bimConversationListResult.isHasMore() + " nextCursor: " + bimConversationListResult.getNextCursor() + " conversationList size:" + bimConversationListResult.getConversationList().size());
                List<BIMConversation> conversationList = bimConversationListResult.getConversationList();
                adapter.appendConversation(conversationList);
                if (cursor == -1) {
                    //首次查询前收到delete信息
                    if (initNeedDeleteConversation != null) {
                        adapter.removeConversation(initNeedDeleteConversation);
                    }
                    initNeedDeleteConversation = null;
                }
                cursor = bimConversationListResult.getNextCursor();
                hasMore = bimConversationListResult.isHasMore();
                checkShowEmpty();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "onFailed() code: " + code);
                checkShowEmpty();
            }
        });
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        BIMLog.i(TAG, "onCreateView() this: " + this);
        BIMClient.getInstance().getService(BIMContactExpandService.class).addFriendConversationListener(createConversationListener());
        rootView = inflater.inflate(R.layout.ve_im_fragment_friend_conv_list, container, false);
        recyclerView = rootView.findViewById(R.id.friend_conv_list);
        emptyView = rootView.findViewById(R.id.empty);
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        adapter = new FriendConversationAdapter(getActivity(), recyclerView);
        recyclerView.setAdapter(adapter);
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                boolean isSlideToBottom = isSlideToBottom(recyclerView);
                if (isSlideToBottom && hasMore) {
                    loadData();
                }
            }
        });
        adapter.setOnItemClickListener((wrapper, position) -> {
            Object o = wrapper.getInfo();
            if (o != null && o instanceof BIMConversation) {
                BIMConversation conversation = (BIMConversation) o;
                if (conversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT
                        || conversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT) {
                    startChat(conversation.getConversationID());
                }
            }
        });
        adapter.setOnItemLongClickListener((wrapper, position) -> {
            BIMLog.i(TAG, "onItemLongClick() position: " + position);
            if (wrapper.getInfo() instanceof BIMConversation) {
                BIMConversation conversation = (BIMConversation) wrapper.getInfo();
                showConversationOperation(conversation);
            }
            return false;
        });
        adapter.setConversationInsertListener((conversation, position) -> {
            if (!recyclerView.canScrollVertically(-1) && position == 0) {
                //recyclerview 顶部 && 顶部插入会话
                recyclerView.scrollToPosition(0);
            }
        });
        loadData();
        addUserListener();
        return rootView;
    }

    private OnUserInfoUpdateListener listener;
    public void addUserListener(){
        if (listener == null) {
            listener = new OnUserInfoUpdateListener() {
                @Override
                public void onUpdate(long uid, BIMUIUser user) {
                    if (adapter != null) {
                        adapter.notifyDataSetChanged();
                    }
                }
            };
        }
        BIMUIClient.getInstance().getUserProvider().addUserUpdateListener(listener);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        BIMLog.i(TAG, "onViewCreated()");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        BIMLog.i(TAG, "onDestroy()");
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                >= recyclerView.computeVerticalScrollRange())
            return true;
        return false;
    }

    /**
     * 注册会话列表相关监听
     */
    private BIMConversationListListener createConversationListener() {
        return new BIMConversationListListener() {
            @Override
            public void onNewConversation(List<BIMConversation> conversationList) {
                BIMLog.i(TAG, "onNewConversation()");
                adapter.addNewConversation(conversationList);
                BIMLog.i(TAG, "now count: " + adapter.getItemCount());
                checkShowEmpty();
            }

            @Override
            public void onConversationChanged(List<BIMConversation> conversationList) {
                BIMLog.i(TAG, "onConversationChanged()");
                boolean isRecyclerViewTop = recyclerView.canScrollVertically(1);
                List<BIMConversation> updateList = new ArrayList<>();
                if (conversationList != null) {
                    for (BIMConversation conversation : conversationList) {
                        if (conversation != null) {
                            updateList.add(conversation);
                        }
                    }
                }
                adapter.updateConversation(updateList);
                checkShowEmpty();
            }

            @Override
            public void onConversationDelete(List<BIMConversation> conversationList) {
                BIMLog.i(TAG, "onConversationDelete()");
                if (cursor == -1) {
                    //首次拉取还没完成时收到删除cmd
                    initNeedDeleteConversation = conversationList;
                }
                adapter.removeConversation(conversationList);
                checkShowEmpty();
            }

            @Override
            public void onTotalUnreadMessageCountChanged(int unreadCount) {
                BIMLog.i(TAG, "onTotalUnreadMessageCountChanged() totalUnreadCount: " + unreadCount);
            }

            @Override
            public void onConversationRead(String conversationId, long fromUid) {

            }
        };
    }

    private void showConversationOperation(BIMConversation conversation) {
        BIMLog.i(TAG, "showConversationOperation cid: " + conversation.getConversationID() + " name: " + conversation.getName());
        String[] conversationOptionType = new String[]{
                "删除",
        };
        new AlertDialog.Builder(getActivity())
                .setItems(conversationOptionType, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        BIMClient.getInstance().deleteConversation(conversation.getConversationID(), new BIMSimpleCallback() {
                            @Override
                            public void onSuccess() {
                                Toast.makeText(getActivity(), "删除成功", Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(getActivity(), "删除失败: " + code, Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                })
                .create().show();
    }

    public void startChat(String cid) {
        Intent intent = new Intent();
        intent.setAction(BIMMessageListFragment.ACTION);
        intent.putExtra(BIMMessageListFragment.TARGET_CID, cid);
        getActivity().startActivity(intent);
    }

    private void checkShowEmpty() {
        if (adapter.getItemCount() == 0) {
            recyclerView.setVisibility(View.INVISIBLE);
            emptyView.setVisibility(View.VISIBLE);
        } else {
            recyclerView.setVisibility(View.VISIBLE);
            emptyView.setVisibility(View.INVISIBLE);
        }
    }
}

class FriendConversationAdapter extends VEConversationListAdapter {

    public FriendConversationAdapter(Context context, RecyclerView recyclerView) {
        super(context, recyclerView);
    }

    @Override
    public void updateConversation(List<BIMConversation> list) {
        super.updateConversation(list);
        for (BIMConversation c: list) {
            checkExist(c.getConversationID());
        }
    }
}