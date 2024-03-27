package com.bytedance.im.app.live.member;

import static com.bytedance.im.app.live.member.VELiveMemberListActivity.DEFAULT_MARK_TYPE;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.app.detail.member.VEMemberUtils;
import com.bytedance.im.app.detail.member.adapter.MemberWrapper;
import com.bytedance.im.app.detail.member.adapter.VEMemberListAdapter;
import com.bytedance.im.app.live.utils.VELiveUtils;
import com.bytedance.im.app.main.edit.VEUserProfileEditActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.BIMLiveGroupMarkTypeListener;
import com.bytedance.im.live.api.model.BIMLiveGroupMarkTypeChangeInfo;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VELiveMemberListActivity extends Activity {
    public static final String DEFAULT_MARK_TYPE = "全部";
    private static final String TAG = "VELiveMemberList";
    protected static final String CONVERSATION_ID = "conversation_id";

    private boolean isFirst = true;
    private long conversationId, needRefreshId;
    private RecyclerView rvMarkType, rvMemberList;
    private VEMemberListAdapter memberListAdapter;
    private MarkTypeListAdapter markTypeListAdapter;
    private List<String> markTypes = new ArrayList<>();
    private String currentMarkType = DEFAULT_MARK_TYPE;
    private Map<String, Fragment> markTypeFragmentMap = new HashMap();

    private VELiveAllMemberListViewModel allMemberModel;
    private VELiveMarksMemberListViewModel marksMemberModel;

    public static void start(Activity activity, long conversationId) {
        Intent intent = new Intent(activity, VELiveMemberListActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_mark_member_list_layout);
        conversationId = getIntent().getLongExtra(CONVERSATION_ID, 0);

        rvMarkType = findViewById(R.id.mark_type_list);
        markTypeListAdapter = new MarkTypeListAdapter();
        findViewById(R.id.back).setOnClickListener(v -> finish());
        LinearLayoutManager layoutManager = new LinearLayoutManager(VELiveMemberListActivity.this);
        layoutManager.setOrientation(LinearLayout.HORIZONTAL);
        rvMarkType.setLayoutManager(layoutManager);
        rvMarkType.setAdapter(markTypeListAdapter);

        rvMemberList = findViewById(R.id.member_list);
        rvMemberList.setLayoutManager(new LinearLayoutManager(this));
        memberListAdapter = new VEMemberListAdapter(this, this::onMemberClick, false, true);
        rvMemberList.setAdapter(memberListAdapter);
        rvMemberList.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
            }

            @Override
            public void onScrolled(@NonNull RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                if (VELiveUtils.isScrollToBottom(recyclerView)) {
                    loadMore();
                }
            }
        });

        markTypeListAdapter.setOnClickListener(this::switchTab);
        BIMClient.getInstance().getService(BIMLiveExpandService.class)
                .addLiveGroupMarkTypeListener(markTypeListener);
    }

    BIMLiveGroupMarkTypeListener markTypeListener = new BIMLiveGroupMarkTypeListener() {
        @Override
        public void onMarkTypesAdd(BIMConversation conversation, BIMLiveGroupMarkTypeChangeInfo changeInfo) {
            markTypes.addAll(changeInfo.getMarkType());
            refreshTab(markTypes);
        }

        @Override
        public void onMarkTypesDeleted(BIMConversation conversation, BIMLiveGroupMarkTypeChangeInfo changeInfo) {
            if (changeInfo.getMarkType() != null && !changeInfo.getMarkType().isEmpty()) {
                boolean needSwitchToDefault = false;
                for (String deleteMarkType: changeInfo.getMarkType()) {
                    for (int i = 1; i < markTypes.size(); i++) {
                        if (markTypes.get(i).equals(deleteMarkType)) {
                            markTypes.remove(i);

                            if (!needSwitchToDefault && markTypeListAdapter.getSelectedMarkType().equals(deleteMarkType)) {
                                needSwitchToDefault = true;
                            }

                            break;
                        }
                    }
                }
                refreshTab(markTypes);
                if (needSwitchToDefault) {
                    switchToDefault();
                }
            }
        }
    };

    @Override
    protected void onResume() {
        super.onResume();
        getMarkTypeFromNet(isFirst);
        refreshMemberUserInfo();
        isFirst = false;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        BIMClient.getInstance().getService(BIMLiveExpandService.class)
                .removeLiveGroupMarkTypeListener(markTypeListener);
    }

    protected void appendMemberList(List<BIMMember> list) {
        if (rvMemberList != null) {
            VEMemberUtils.getMemberWrapperList(list, new BIMResultCallback<List<MemberWrapper>>() {
                @Override
                public void onSuccess(List<MemberWrapper> wrapperList) {
                    memberListAdapter.appendMemberList(wrapperList);
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
    }

    private void getMarkTypeFromNet(boolean isFirst) {
        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMarkTypeList(conversationId, new BIMResultCallback<List<String>>() {
            @Override
            public void onSuccess(List<String> list) {
                markTypes.clear();
                markTypes.addAll(list);
                markTypes.add(0, DEFAULT_MARK_TYPE);

                refreshTab(markTypes);
                if (isFirst) {
                    switchTab(DEFAULT_MARK_TYPE);
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.e(TAG, "getMarkTypeFromNet error " + code);
            }
        });
    }

    private void loadMore() {
        if (allMemberModel != null) {
            allMemberModel.loadMore();
        } else if (marksMemberModel != null) {
            marksMemberModel.loadMore();
        }
    }

    private void refreshTab(List<String> markTypeList) {
        markTypeListAdapter.updateData(markTypeList);
    }

    private void switchTab(String markType) {
        memberListAdapter.clear();
        memberListAdapter.notifyDataSetChanged();

        currentMarkType = markType;
        if (DEFAULT_MARK_TYPE.equals(markType)) {
            marksMemberModel = null;
            allMemberModel = new VELiveAllMemberListViewModel(conversationId, this::appendMemberList);
        } else {
            allMemberModel = null;
            marksMemberModel = new VELiveMarksMemberListViewModel(conversationId, currentMarkType, this::appendMemberList);
        }
        loadMore();
    }

    private void switchToDefault() {
        switchTab(DEFAULT_MARK_TYPE);
        rvMarkType.scrollToPosition(0);
        markTypeListAdapter.switchToDefault();
    }

    protected void onMemberClick(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        needRefreshId = member.getUserID();
        VEUserProfileEditActivity.start(VELiveMemberListActivity.this, member.getUserID(), member.getAlias(), member.getAvatarUrl()); //打开个人页面后会同步服务端用户资料
    }

    private void refreshMemberUserInfo(){
        if (needRefreshId > 0) {
            BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfo(needRefreshId, new BIMResultCallback<BIMUserFullInfo>() {
                @Override
                public void onSuccess(BIMUserFullInfo userFullInfo) {
                    memberListAdapter.updateUserInfo(userFullInfo);
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
            needRefreshId = 0;
        }
    }
}

class MarkTypeListAdapter extends RecyclerView.Adapter<MarkTypeListViewHolder> {
    private OnClickListener listener;
    private String selectedMarkType = DEFAULT_MARK_TYPE;
    private List<String> markTypeList= new ArrayList<>();
    private final OnClickListener wrapperListener = new OnClickListener() {
        @Override
        public void onClick(String markType) {
            selectedMarkType = markType;
            notifyDataSetChanged();
            if (listener != null) {
                listener.onClick(markType);
            }
        }
    };

    @NonNull
    @Override
    public MarkTypeListViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View v = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.ve_item_text, viewGroup, false);
        return new MarkTypeListViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull MarkTypeListViewHolder markTypeListViewHolder, int i) {
        markTypeListViewHolder.bind(markTypeList.get(i), wrapperListener, selectedMarkType);
    }

    @Override
    public int getItemCount() {
        return markTypeList.size();
    }

    public void updateData(List<String> markTypeList) {
        this.markTypeList = markTypeList;
        this.notifyDataSetChanged();
    }

    public void setOnClickListener(OnClickListener listener) {
        this.listener = listener;
    }

    public String getSelectedMarkType() {
        return selectedMarkType;
    }

    public void switchToDefault() {
        selectedMarkType = DEFAULT_MARK_TYPE;
        this.notifyDataSetChanged();
    }

    interface OnClickListener {
        void onClick(String markType);
    }
}

class MarkTypeListViewHolder extends RecyclerView.ViewHolder {
    private TextView textView;

    public MarkTypeListViewHolder(@NonNull View itemView) {
        super(itemView);
        textView = itemView.findViewById(R.id.tv_main);
    }

    public void bind(String markType, MarkTypeListAdapter.OnClickListener listener, String selectedMarkType) {
        textView.setText(markType);
        itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onClick(markType);
            }
        });

        if (markType.equals(selectedMarkType)) {
            textView.setTextColor(Color.BLUE);
        } else {
            textView.setTextColor(Color.BLACK);
        }
    }
}
