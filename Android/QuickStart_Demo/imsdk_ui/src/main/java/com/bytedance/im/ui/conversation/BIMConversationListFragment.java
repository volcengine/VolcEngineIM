package com.bytedance.im.ui.conversation;

import static com.bytedance.im.core.api.enums.BIMClearConversationMessageType.BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_ALL_MY_DEVICE;
import static com.bytedance.im.core.api.enums.BIMClearConversationMessageType.BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_LOCAL_DEVICE;
import static com.bytedance.im.ui.message.adapter.ui.widget.pop.DialogUtil.showClearConversationMsgDialog;

import android.app.AlertDialog;
import android.app.Fragment;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMClearConversationMessageType;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.interfaces.BIMStrangeBoxListener;
import com.bytedance.im.core.api.interfaces.BIMStrangeConversationListener;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMConversationListResult;
import com.bytedance.im.core.api.model.BIMStrangeBox;
import com.bytedance.im.core.service.BIMINService;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.conversation.adapter.VEConversationListAdapter;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class BIMConversationListFragment extends Fragment {
    private static final String TAG = "VEConversationListFragment";
    private static StickTopConversationChecker checker = null;
    private RecyclerView recyclerView;
    private long cursor = -1;
    private boolean hasMore = true;
    private VEConversationListAdapter adapter;
    private View rootView;
    private OnConversationClickListener onItemClickListener;
    private List<BIMConversation> initNeedDeleteConversation;

    public interface OnConversationClickListener {
        void onConversationClick(BIMConversation conversation);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        BIMLog.i(TAG, "onCreateView() this: " + this);
        rootView = inflater.inflate(R.layout.bim_im_fragment_conversation_list, container, false);
        BIMClient.getInstance().addConversationListener(createConversationListener());
        BIMClient.getInstance().getService(BIMINService.class).addStrangeConversationListener(strangeConversationListener);
        recyclerView = rootView.findViewById(R.id.conversation_list);
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        adapter = new VEConversationListAdapter(getActivity(), recyclerView);
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
        adapter.setOnItemClickListener(new VEConversationListAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(VEConvBaseWrapper wrapper, int position) {
                Object o = wrapper.getInfo();
                if(o == null){
                    return;
                }
                if (o instanceof BIMConversation) {
                    BIMConversation conversation = (BIMConversation) o;
                    if (onItemClickListener != null) {
                        //优先代理外部
                        onItemClickListener.onConversationClick(conversation);
                    } else {
                        //内部默认处理
                        if (conversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT
                                || conversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_GROUP_CHAT
                                || conversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LITE_LIVE_CHAT) {
                            startChat(conversation.getConversationID());
                        }
                    }
                } else if (o instanceof BIMStrangeBox) {
                    BIMUIClient.getInstance().getModuleStarter().startStrangeConvListActivity(getActivity());
                }
            }
        });
        adapter.setOnItemLongClickListener(new VEConversationListAdapter.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(VEConvBaseWrapper wrapper, int position) {
                BIMLog.i(TAG, "onItemLongClick() position: " + position);
                if (wrapper.getInfo() instanceof BIMConversation) {
                    BIMConversation conversation = (BIMConversation) wrapper.getInfo();
                    showConversationOperation(conversation);
                } else if (wrapper.getInfo() instanceof BIMStrangeBox) {
                    showStrangeBoxOperation();
                }
                return false;
            }
        });
        adapter.setConversationInsertListener(new VEConversationListAdapter.ConversationInsertListener() {
            @Override
            public void afterConversationInsert(BIMConversation conversation, int position) {
                if (!recyclerView.canScrollVertically(-1) && position == 0) {
                    //recyclerview 顶部 && 顶部插入会话
                    recyclerView.scrollToPosition(0);
                }
            }
        });
        initStrangeBox();
        loadData();
        addUserListener();
        return rootView;
    }

    private void refreshStrangeBox(){
        if (BIMClient.getInstance().isToB()) {
            return;
        }
        BIMClient.getInstance().getService(BIMINService.class).getStrangeBoxConversation(new BIMResultCallback<BIMStrangeBox>() {
            @Override
            public void onSuccess(BIMStrangeBox strangeBox) {
                BIMLog.i(TAG,"getStrangeBoxConversation onSuccess strangeBox: "+strangeBox);
                if (strangeBox == null) {
                    strangeBox = new BIMStrangeBox(null, 0); //假的占位
                }
                adapter.insertOrUpdateStrangeBox(strangeBox);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
        refreshStrangeBox();
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
        removeUserListener();
    }

    private void loadData() {
        BIMLog.i(TAG, "loadData()");
        BIMClient.getInstance().getConversationList(cursor, 20, new BIMResultCallback<BIMConversationListResult>() {
            @Override
            public void onSuccess(BIMConversationListResult bimConversationListResult) {
                BIMLog.i(TAG, "onSuccess() hasMore: " + bimConversationListResult.isHasMore() + " nextCursor: " + bimConversationListResult.getNextCursor() + " conversationList size:" + bimConversationListResult.getConversationList().size());
                List<BIMConversation> conversationList = bimConversationListResult.getConversationList();

                for (BIMConversation conversation : conversationList) {
                    if (isStickTopConversation(conversation)) {
                        conversationList.remove(conversation);
                        adapter.insertOrUpdateTopConversation(conversation);
                        break;
                    }
                }

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
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "onFailed() code: " + code);
            }
        });
    }
    private boolean isInitStrangeBox = true;
    private void initStrangeBox(){
        if (BIMClient.getInstance().isToB()) {
            return;
        }
        BIMClient.getInstance().getService(BIMINService.class).getStrangeBoxConversation(new BIMResultCallback<BIMStrangeBox>() {
            @Override
            public void onSuccess(BIMStrangeBox strangeBox) {
                BIMLog.i(TAG,"getStrangeBoxConversation onSuccess strangeBox: "+strangeBox);
                if (strangeBox == null) {
                    strangeBox = new BIMStrangeBox(null, 0); //假的占位
                }
                adapter.insertOrUpdateStrangeBox(strangeBox);
                if (isInitStrangeBox) { //初始化陌生人
                    recyclerView.scrollToPosition(0);
                    isInitStrangeBox = false;
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
        BIMClient.getInstance().getService(BIMINService.class).addStrangeBoxListener(new BIMStrangeBoxListener() {
            @Override
            public void onStrangeBoxChanged(BIMStrangeBox strangeBox) {
                BIMLog.i(TAG,"getStrangeBoxConversation onStrangeBoxChanged strangeBox: "+strangeBox +" thread: "+Thread.currentThread());
                if (strangeBox == null) {
                    strangeBox = new BIMStrangeBox(null, 0); //假的占位
                }
                adapter.insertOrUpdateStrangeBox(strangeBox);
            }
        });
    }

    private boolean isSlideToBottom(RecyclerView recyclerView) {
        if (recyclerView == null) return false;
        if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                >= recyclerView.computeVerticalScrollRange())
            return true;
        return false;
    }

    private BIMStrangeConversationListener strangeConversationListener = new BIMStrangeConversationListener() {
        @Override
        public void onStrangeConversationUpdate(BIMConversation bimConversation) {
            if (bimConversation.isStranger()) {
                adapter.removeConversation(Collections.singletonList(bimConversation));
            }
        }

        @Override
        public void onNewStrangeConversation(BIMConversation bimConversation) {

        }

        @Override
        public void onStrangeConversationTransfer(BIMConversation bimConversation) {

        }

        @Override
        public void onStrangeConversationDelete(BIMConversation bimConversation) {

        }

        @Override
        public void onStrangeConversationListMarkReadAll() {

        }

        @Override
        public void onStrangeConversationListDeleteAll() {

        }
    };

    /**
     * 注册会话列表相关监听
     */
    private BIMConversationListListener createConversationListener() {
        return new BIMConversationListListener() {
            @Override
            public void onNewConversation(List<BIMConversation> conversationList) {
                BIMLog.i(TAG, "onNewConversation()");

                for (BIMConversation conversation : conversationList) {
                    if (isStickTopConversation(conversation)) {
                        adapter.insertOrUpdateTopConversation(conversation);
                        conversationList.remove(conversation);
                        break;
                    }
                }
                adapter.addNewConversation(conversationList);
            }

            @Override
            public void onConversationChanged(List<BIMConversation> conversationList) {
                BIMLog.i(TAG, "onConversationChanged()");
                BIMConversation stickTopConversation = null;
                boolean isRecyclerViewTop = recyclerView.canScrollVertically(1);
                List<BIMConversation> updateList = new ArrayList<>();
                if (conversationList != null) {
                    for (BIMConversation conversation : conversationList) {
                        if (conversation != null && !isStickTopConversation(conversation)) {
                            updateList.add(conversation);
                        } else if (isStickTopConversation(conversation)) {
                            stickTopConversation = conversation;
                        }
                    }
                }
                adapter.updateConversation(updateList);

                if (stickTopConversation != null) {
                    adapter.insertOrUpdateTopConversation(stickTopConversation);
                }
            }

            @Override
            public void onConversationDelete(List<BIMConversation> conversationList) {
                BIMLog.i(TAG, "onConversationDelete()");
                if (cursor == -1) {
                    //首次拉取还没完成时收到删除cmd
                    initNeedDeleteConversation = conversationList;
                }
                adapter.removeConversation(conversationList);
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
                "清空会话消息"
        };
        new AlertDialog.Builder(getActivity())
                .setItems(conversationOptionType, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (which == 0) {
                            BIMClient.getInstance().deleteConversation(conversation.getConversationID(), new BIMSimpleCallback() {
                                @Override
                                public void onSuccess() {
                                    Toast.makeText(getActivity(), "删除成功", Toast.LENGTH_SHORT).show();

                                    BIMUIUser user = BIMUIClient.getInstance().getUserProvider().getUserInfo(conversation.getOppositeUserID());
                                    if (user != null && user.getIsRobot()) {
                                        BIMClient.getInstance().markNewChat(conversation.getConversationID(), false, null);
                                    }
                                }

                                @Override
                                public void onFailed(BIMErrorCode code) {
                                    Toast.makeText(getActivity(), "删除失败", Toast.LENGTH_SHORT).show();

                                }
                            });
                        } else if (which == 1) {
                            showClearConversationMsgDialog(getActivity(), new BIMResultCallback<Boolean>() {
                                @Override
                                public void onSuccess(Boolean deleteFromServer) {
                                    BIMClearConversationMessageType deleteType = deleteFromServer ? BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_ALL_MY_DEVICE : BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_LOCAL_DEVICE;
                                    BIMClient.getInstance().clearConversationMessage(conversation.getConversationID(), deleteType, new BIMSimpleCallback() {
                                        @Override
                                        public void onSuccess() {
                                            if (BIMConversationListFragment.this.isAdded()) {
                                                Toast.makeText(getActivity(), "操作成功", Toast.LENGTH_SHORT).show();
                                            }
                                        }

                                        @Override
                                        public void onFailed(BIMErrorCode code) {
                                            if (BIMConversationListFragment.this.isAdded()) {
                                                Toast.makeText(getActivity(), "操作失败：" + code.getValue(), Toast.LENGTH_SHORT).show();
                                            }
                                        }
                                    });
                                }

                                @Override
                                public void onFailed(BIMErrorCode code) {

                                }
                            });
                        }
                    }
                })
                .create().show();
    }

    private void showStrangeBoxOperation() {
        BIMLog.i(TAG, "showStrangeBoxOperation");
        String[] conversationOptionType = new String[]{
                "删除",
        };
        new AlertDialog.Builder(getActivity())
                .setItems(conversationOptionType, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        BIMClient.getInstance().getService(BIMINService.class).deleteAllStrangeConversationList(new BIMSimpleCallback() {
                            @Override
                            public void onSuccess() {
                                Toast.makeText(getActivity(),"删除陌生人盒子成功",Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {

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

    /**
     * 设置会话列表 item 监听
     *
     * @param onItemClickListener item 点击监听
     */
    public void setOnItemClickListener(OnConversationClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }


    private OnUserInfoUpdateListener listener;

    /**
     * 好友信息更新监听
     */
    public void addUserListener() {
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

    public void removeUserListener() {
        if (listener != null) {
            BIMUIClient.getInstance().getUserProvider().removeUserUpdateListener(listener);
        }
    }

    public interface StickTopConversationChecker {
        boolean isStickTopConversation(BIMConversation conversation);
    }

    public boolean isStickTopConversation(BIMConversation conversation) {
        if (checker != null && conversation != null) {
            return checker.isStickTopConversation(conversation);
        } else {
            return false;
        }
    }

    public static void injectStickTopConversationChecker(StickTopConversationChecker stickTopConversationChecker) {
        checker = stickTopConversationChecker;
    }
}
