package com.bytedance.im.app.main;

import android.app.Fragment;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.live.conversation.VELiveGroupListActivity;
import com.bytedance.im.app.live.conversation.VELiveGroupListAdapter;
import com.bytedance.im.app.live.create.VECreateJoinLiveGroupActivity;
import com.bytedance.im.app.live.create.VECreateLiveGroupActivity;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.model.BIMLiveGroupListResult;
import com.bytedance.im.ui.log.BIMLog;

public class VELiveGroupFragment extends Fragment {
    private static String TAG = "VELiveGroupFragment";
    private RecyclerView recyclerView;
    private Long cursor = 0L;
    private Boolean hasMore = true;
    private Boolean loadFailed = false;
    private VELiveGroupListAdapter adapter;
    private View clEmpty;
    private View rootView;
    private ImageView ivCreate;
    private SwipeRefreshLayout swipeRefreshLayout;
    private boolean isSyncing;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        BIMLog.i(TAG, "onCreateView() this: $this");
        rootView = inflater.inflate(R.layout.ve_im_fragment_live_group, container, false);
        ivCreate = rootView.findViewById(R.id.iv_create);
        clEmpty = rootView.findViewById(R.id.cl_empty);
        recyclerView = rootView.findViewById(R.id.live_group_list);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        swipeRefreshLayout = rootView.findViewById(R.id.swipe);
        adapter = new VELiveGroupListAdapter(getActivity());
        recyclerView.setItemAnimator(null);
        recyclerView.setAdapter(adapter);
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (VELiveUtils.isScrollToBottom(recyclerView) && hasMore) {
                    Toast.makeText(getActivity(), "加载更多", Toast.LENGTH_SHORT).show();
                    loadData(null);
                }
            }
        });
        adapter.setOnItemClickListener((wrapper, position) -> {
            if (wrapper.getInfo() != null && wrapper.getInfo() instanceof BIMConversation) {
                BIMConversation bimConversation = (BIMConversation) wrapper.getInfo();
                VECreateJoinLiveGroupActivity.start(getActivity(), bimConversation.getConversationShortID());
            }
        });
        ivCreate.setOnClickListener(v -> showPopUpWindow(v));
        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                if(isSyncing){
                    swipeRefreshLayout.setRefreshing(false);
                    Toast.makeText(getActivity(), "操作过快", Toast.LENGTH_SHORT).show();
                    return;
                }
                Toast.makeText(getActivity(),"刷新列表",Toast.LENGTH_SHORT).show();
                refreshData();
            }
        });
        BIMLog.i(TAG, "finish onCreateView");
        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();
        refreshData();
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

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        if (!hidden && adapter.getItemCount() == 0 && loadFailed) {
            loadFailed = false;
            loadData(null);
        }
    }

    private void loadData(BIMSimpleCallback callback) {
        BIMLog.i(TAG, "loadData()");
        if (isSyncing) {
            Toast.makeText(getActivity(), "操作过快", Toast.LENGTH_SHORT).show();
            return;
        }
        isSyncing = true;
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getOwnerLiveGroupList(cursor, 20, new BIMResultCallback<BIMLiveGroupListResult>() {
            @Override
            public void onSuccess(BIMLiveGroupListResult BIMLiveGroupListResult) {
                if(callback!=null){
                    callback.onSuccess();
                }
                BIMLog.i(TAG, "getConversationList() onSuccess() conversationList size:" + BIMLiveGroupListResult.getConversationList().size() + ", nextCursor: " + BIMLiveGroupListResult.getNextCursor());
                adapter.appendConversation(BIMLiveGroupListResult.getConversationList());
                cursor = BIMLiveGroupListResult.getNextCursor();
                loadFailed = false;
                refreshView();
                isSyncing = false;
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (callback != null) {
                    callback.onFailed(code);
                }
                refreshView();
                BIMLog.i(TAG, "getConversationList() code:"+code);
                Toast.makeText(getActivity(), "加载会话列表失败: " + code, Toast.LENGTH_SHORT).show();
                isSyncing = false;
            }
        });
    }

    private void showPopUpWindow(View createBtn) {
        View contentView = LayoutInflater.from(getActivity()).inflate(R.layout.ve_im_popup_window_live_group_create_chat, null);
        LinearLayout showAll = contentView.findViewById(R.id.ll_show_all);
        LinearLayout createGroup = contentView.findViewById(R.id.ll_create_group);
        PopupWindow popupWindow = new PopupWindow(contentView, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setOutsideTouchable(true);
        popupWindow.showAsDropDown(createBtn, 0, 10);
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int id = v.getId();
                if (id == R.id.ll_show_all) {
                    VELiveGroupListActivity.start(getActivity());
                } else if (id == R.id.ll_create_group) {
                    VECreateLiveGroupActivity.start(getActivity());
                }
                popupWindow.dismiss();
            }
        };
        showAll.setOnClickListener(listener);
        createGroup.setOnClickListener(listener);

        WindowManager.LayoutParams lp = getActivity().getWindow().getAttributes();
        lp.alpha = 0.7f;
        getActivity().getWindow().setAttributes(lp);

        popupWindow.setOnDismissListener(() -> {
            WindowManager.LayoutParams attrLp = getActivity().getWindow().getAttributes();
            attrLp.alpha = 1f;
            getActivity().getWindow().setAttributes(attrLp);
        });
    }

    private void refreshView() {
        if (adapter.getItemCount() == 0) {
            recyclerView.setVisibility(View.GONE);
            clEmpty.setVisibility(View.VISIBLE);
        } else {
            recyclerView.setVisibility(View.VISIBLE);
            clEmpty.setVisibility(View.GONE);
        }
    }
}
