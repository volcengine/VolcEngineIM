package com.bytedance.im.app.member.detail;

import static com.bytedance.im.core.api.enums.BIMClearConversationMessageType.BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_ALL_MY_DEVICE;
import static com.bytedance.im.core.api.enums.BIMClearConversationMessageType.BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_LOCAL_DEVICE;
import static com.bytedance.im.ui.message.adapter.ui.widget.pop.DialogUtil.showClearConversationMsgDialog;

import android.app.Activity;
import android.os.Bundle;
import android.util.Pair;
import android.view.View;
import android.widget.Switch;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.BuildConfig;
import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.group.VEDetailController;
import com.bytedance.im.app.member.VEDebugConversationDetailActivity;
import com.bytedance.im.app.member.detail.ext.VEDebugExtActivity;
import com.bytedance.im.app.member.group.MemberListViewModel;
import com.bytedance.im.app.member.group.VESingleMemberListActivity;
import com.bytedance.im.app.member.group.adapter.MemberWrapper;
import com.bytedance.im.app.member.group.adapter.VEMemberHozionAdapter;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMClearConversationMessageType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMClearConversationOption;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.List;

public class VEDetailSingleConversationActivity extends Activity {
    private static final String TAG = "VEDetailSingleConversationActivity";
    private RecyclerView recyclerView;
    private View customLayout;
    private View queryConv;
    private View clearConv;
    private BIMConversation bimConversation;
    private View btnMore;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_detail_singel_chat);
        String conversationId = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        recyclerView = findViewById(R.id.recycler_view_member);
        customLayout = findViewById(R.id.fl_custom);
        clearConv = findViewById(R.id.clear_conv);
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        VEMemberHozionAdapter adapter = new VEMemberHozionAdapter(this, new VEMemberHozionAdapter.OnClickListener() {
            @Override
            public void onAddClick() {

            }

            @Override
            public void onDeleteClick() {

            }

            @Override
            public void onMemberClick(BIMMember member) {
                BIMUIClient.getInstance().getModuleStarter().startProfileModule(VEDetailSingleConversationActivity.this, member.getUserID(), conversationId);
            }
        });
        recyclerView.setAdapter(adapter);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> VESingleMemberListActivity.start(VEDetailSingleConversationActivity.this, conversationId));
        findViewById(R.id.fl_search_msg).setOnClickListener(v -> BIMUIClient.getInstance().getModuleStarter().startSearchModule(VEDetailSingleConversationActivity.this,conversationId));
        customLayout.setOnClickListener(v -> VEDebugExtActivity.start(VEDetailSingleConversationActivity.this, conversationId));
        BIMUIClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                bimConversation = conversation;
                Switch topSwitch = findViewById(R.id.switch_top);
                Switch muteSwitch = findViewById(R.id.switch_mute);
                VEDetailController.initStickSwitch(topSwitch, conversation, VEDetailSingleConversationActivity.this);
                VEDetailController.initMuteSwitch(muteSwitch, conversation, VEDetailSingleConversationActivity.this);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEDetailSingleConversationActivity.this, "会话不存在", Toast.LENGTH_SHORT).show();
                finish();
            }
        });
        //单聊就两个成员
        new MemberListViewModel(conversationId, 2).loadMore(new BIMResultCallback<List<MemberWrapper>>() {
            @Override
            public void onSuccess(List<MemberWrapper> wrapperList) {
                if (wrapperList != null
                        && wrapperList.size() >= 2
                        && wrapperList.get(0).getMember().getUserID() == BIMClient.getInstance().getCurrentUserID()
                        && wrapperList.get(1).getMember().getUserID() == BIMClient.getInstance().getCurrentUserID()) {
                    //自己和自己发起聊天
                    wrapperList.remove(1);
                }
                adapter.updateUserInfoList(wrapperList, false, false);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
        queryConv = findViewById(R.id.query_conv);
        queryConv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (bimConversation != null) {
                    VEDebugConversationDetailActivity.start(VEDetailSingleConversationActivity.this, bimConversation.getConversationShortID());
                }
            }
        });
        btnMore = findViewById(R.id.btn_more);
        if (!BIMUIClient.getInstance().getModuleStarter().checkExistInDetailGroupActivity(VEDetailSingleConversationActivity.this)) {
            btnMore.setVisibility(View.GONE);
        }
        btnMore.setOnClickListener(v -> {
            BIMUIClient.getInstance().getModuleStarter().startInDetailGroupActivity(VEDetailSingleConversationActivity.this, conversationId);
        });
        if (BuildConfig.DEBUG) {
            queryConv.setVisibility(View.VISIBLE);
        } else {
            queryConv.setVisibility(View.GONE);
        }

        BIMClearConversationOption option = new BIMClearConversationOption.Builder()
                .conversationId(conversationId)
                .deleteFromServer(false)
                .build();
        clearConv.setOnClickListener(v -> showClearConversationMsgDialog(VEDetailSingleConversationActivity.this, new BIMResultCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean deleteFromServer) {
                BIMClearConversationMessageType deleteType = deleteFromServer ? BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_ALL_MY_DEVICE : BIM_CLEAR_CONVERSATION_MESSAGE_TYPE_LOCAL_DEVICE;
                BIMClient.getInstance().clearConversationMessage(conversationId, deleteType, new BIMSimpleCallback() {
                    @Override
                    public void onSuccess() {
                        Toast.makeText(VEDetailSingleConversationActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Toast.makeText(VEDetailSingleConversationActivity.this, "操作失败：" + code.getValue(), Toast.LENGTH_SHORT).show();
                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        }));
    }


}
