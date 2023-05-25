package com.bytedance.im.app.live.conversation;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.live.chatRoom.VELiveGroupChatRoomActivity;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveGroupListResult;
import com.bytedance.im.ui.conversation.adapter.VEConversationListAdapter;
import com.bytedance.im.ui.conversation.model.VEConvBaseWrapper;
import com.bytedance.im.ui.log.BIMLog;

import java.util.ArrayList;
import java.util.List;

public class VELiveGroupListActivity extends Activity {
    private static String TAG = "VELiveGroupConversationListActivity";
    private static String CONVERSATION_SHORT_ID = "conversation_short_id";

    private View ivBack;
    private View clEmpty;
    private TextView etSearch;
    private Long cursor = 0L;
    private boolean hasMore = true;
    private boolean inSearch = false;
    private RecyclerView rvConversations;
    private SwipeRefreshLayout swipeRefreshLayout;
    private List<BIMConversation> allConversations = new ArrayList<>();

    private String searchStr = "";
    private VELiveGroupListAdapter adapter;
    private Handler mainHandler = new Handler(Looper.getMainLooper());
    private boolean isSyncing = false;

    public static void start(Activity activity) {
        Intent intent = new Intent(activity, VELiveGroupListActivity.class);
        activity.startActivity(intent);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_live_group_conversations);
        adapter = new VELiveGroupListAdapter(this);
    }

    @Override
    protected void onStart() {
        super.onStart();

        ivBack = findViewById(R.id.iv_back);
        clEmpty = findViewById(R.id.cl_empty);
        etSearch = findViewById(R.id.et_live_group_search);
        rvConversations = findViewById(R.id.rv_live_group_conversations);
        swipeRefreshLayout = findViewById(R.id.swipe);
        etSearch.addTextChangedListener(new TextWatcher() {

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                searchStr = s.toString();
                String tempStr = s.toString();
                mainHandler.postDelayed(() -> {
                    if (!TextUtils.isEmpty(tempStr) && tempStr.equals(searchStr)) {
                        showSearchConversation(tempStr);
                    } else if (TextUtils.isEmpty(searchStr) && TextUtils.isEmpty(tempStr)) {
                        showSearchConversation("");
                    }
                }, 300);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        ivBack.setOnClickListener(v -> finish());
        rvConversations.setAdapter(adapter);
        rvConversations.setLayoutManager(new LinearLayoutManager(this));
        rvConversations.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (VELiveUtils.isScrollToBottom(recyclerView) && hasMore) {
                    Toast.makeText(VELiveGroupListActivity.this, "加载更多", Toast.LENGTH_SHORT).show();
                    loadData(null);
                }
            }
        });

        adapter.setOnItemClickListener(new VEConversationListAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(VEConvBaseWrapper wrapper, int position) {
                if (wrapper != null && wrapper.getInfo() != null && wrapper.getInfo() instanceof BIMConversation) {
                    BIMConversation conv = (BIMConversation) wrapper.getInfo();
                    Intent intent = new Intent(VELiveGroupListActivity.this, VELiveGroupChatRoomActivity.class);
                    intent.putExtra(CONVERSATION_SHORT_ID, conv.getConversationShortID());
                    startActivity(intent);
                }
            }
        });

        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                if(isSyncing){
                    swipeRefreshLayout.setRefreshing(false);
                    Toast.makeText(VELiveGroupListActivity.this, "操作过快", Toast.LENGTH_SHORT).show();
                    return;
                }
                refreshData();
            }
        });
        loadData(null);
    }

    private void refreshData(){
        cursor = -1L;
        hasMore = true;
        loadData(new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                adapter.clearConversation();
                swipeRefreshLayout.setRefreshing(false);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                swipeRefreshLayout.setRefreshing(false);
            }
        });
    }

    private void loadData(BIMSimpleCallback callback) {
        BIMLog.i(TAG, "loadData()");
        if (isSyncing) {
            Toast.makeText(VELiveGroupListActivity.this, "操作过快", Toast.LENGTH_SHORT).show();
            return;
        }
        isSyncing = true;
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getAllLiveGroupList(cursor, 20,new BIMResultCallback<BIMLiveGroupListResult>() {
            @Override
            public void onSuccess(BIMLiveGroupListResult BIMLiveGroupListResult) {
                BIMLog.i(TAG, "onSuccess() nextCursor: " + BIMLiveGroupListResult.getNextCursor() + " conversationList size:" + BIMLiveGroupListResult.getConversationList().size());
                if (callback != null) {
                    callback.onSuccess();
                }
                allConversations.addAll(BIMLiveGroupListResult.getConversationList());
                appendConversation(BIMLiveGroupListResult.getConversationList());
                cursor = BIMLiveGroupListResult.getNextCursor();
                hasMore = BIMLiveGroupListResult.isHasMore();
                refreshView();
                isSyncing = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "onFailed() code: " + code);
                if (callback != null) {
                    callback.onFailed(code);
                }
                refreshView();
                isSyncing = false;
            }
        });
    }

    public void showSearchConversation(String key) {
        if (!TextUtils.isEmpty(key)) {
            inSearch = true;
            List<BIMConversation> result = new ArrayList<>();
            for (BIMConversation conv: allConversations) {
                if (conv.getConversationID().contains(key) || conv.getName().contains(key)) {
                    result.add(conv);
                }
            }

            adapter.clearConversation();
            adapter.appendConversation(result);
        } else {
            inSearch = false;
            adapter.clearConversation();
            adapter.appendConversation(allConversations);
        }
    }

    private void refreshView() {
        if (adapter.getItemCount() == 0) {
            rvConversations.setVisibility(View.GONE);
            clEmpty.setVisibility(View.VISIBLE);
        } else {
            rvConversations.setVisibility(View.VISIBLE);
            clEmpty.setVisibility(View.GONE);
        }
    }

    private void appendConversation(List<BIMConversation> list) {
        if (inSearch) {
            showSearchConversation(searchStr);
        } else {
            adapter.appendConversation(list);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
    }
}
