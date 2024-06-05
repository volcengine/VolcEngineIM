package com.bytedance.im.app.member.receipt;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.user.BIMUserListAdapter;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageReadReceipt;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class VEReadReceiptListActivity extends Activity implements View.OnClickListener {
    private static final String KEY_MSG_UUID = "key_msg_uuid";
    private static int TYPE_READ = 0;
    private static int TYPE_UNREAD = 1;
    private View tabRead;
    private View tabUnread;
    private TextView tvRead;
    private TextView tvUnRead;
    private View underRead;
    private View underUnread;
    private RecyclerView recyclerView;
    private BIMUserListAdapter adapter;
    private int type = TYPE_READ;
    private BIMMessage message;
    private List<BIMUIUser> readList = new ArrayList<>();
    private List<BIMUIUser> unReadList = new ArrayList<>();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_receipt_list_layout);
        String uuid = getIntent().getStringExtra(ModuleStarter.MODULE_MSG_UUID);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        tabRead = findViewById(R.id.tab_read);
        tabUnread = findViewById(R.id.tab_un_read);
        tvRead = findViewById(R.id.tv_read);
        tvUnRead = findViewById(R.id.tv_un_read);
        recyclerView = findViewById(R.id.userList);
        underRead = findViewById(R.id.read_under);
        underUnread = findViewById(R.id.un_read_under);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        tabRead.setOnClickListener(this);
        tabUnread.setOnClickListener(this);
        BIMClient.getInstance().getMessage(uuid, new BIMResultCallback<BIMMessage>() {
            @Override
            public void onSuccess(BIMMessage bimMessage) {
                message = bimMessage;
                initReceiptList(message);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    //初始化列表展示
    private void initReceiptList(BIMMessage message) {
        if (message == null) {
            return;
        }
        BIMClient.getInstance().getMessagesReadReceipt(Collections.singletonList(message), new BIMResultCallback<List<BIMMessageReadReceipt>>() {
            @Override
            public void onSuccess(List<BIMMessageReadReceipt> bimMessageReadReceipts) {
                if (bimMessageReadReceipts == null || bimMessageReadReceipts.isEmpty()) {
                    Toast.makeText(VEReadReceiptListActivity.this, "消息回执查询为空", Toast.LENGTH_SHORT).show();
                    return;
                }
                BIMMessageReadReceipt readReceipt = bimMessageReadReceipts.get(0);
                int readCount = 0;
                List<Long> readIdList = readReceipt.getReadMemberUidList();
                if (readIdList != null) {
                    readCount = readIdList.size();
                }
                int unReadCount = 0;
                List<Long> unReadIdList = readReceipt.getUnreadMemberUidList();
                if (unReadList != null) {
                    unReadCount = unReadIdList.size();
                }
                tvRead.setText("已读(" + readCount + ")");
                tvUnRead.setText("未读(" + unReadCount + ")");
                if (type == TYPE_READ) {
                    underRead.setVisibility(View.VISIBLE);
                    underUnread.setVisibility(View.GONE);
                    initUserInfo(readIdList);
                } else if (type == TYPE_UNREAD) {
                    underRead.setVisibility(View.GONE);
                    underUnread.setVisibility(View.VISIBLE);
                    initUserInfo(readReceipt.getUnreadMemberUidList());
                }
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (code == BIMErrorCode.BIM_SERVER_CONVERSATION_NOT_EXIST) {
                    Toast.makeText(VEReadReceiptListActivity.this, "已解散的会话无法查看消息阅读详情", Toast.LENGTH_SHORT).show();
                } else if (code == BIMErrorCode.BIM_SERVER_MESSAGE_EXPIRE) {
                    Toast.makeText(VEReadReceiptListActivity.this, "该消息已过期，不支持查看已读未读成员列表", Toast.LENGTH_SHORT).show();
                } else if (code == BIMErrorCode.BIM_SERVER_MESSAGE_RECEIPT_DISABLE) {
                    Toast.makeText(VEReadReceiptListActivity.this, "已读回执功能未开通", Toast.LENGTH_SHORT).show();
                } else if (code == BIMErrorCode.BIM_SERVER_READ_RECEIPT_GROUP_MEMBER_MORE_THAN_LIMIT) {
                    Toast.makeText(VEReadReceiptListActivity.this, "群人数超过已读回执支持人数", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(VEReadReceiptListActivity.this, "出现错误 code: " + code, Toast.LENGTH_SHORT).show();
                }
                finish();
            }
        });
    }

    private void initUserInfo(List<Long> uidList) {
        if (uidList == null || uidList.isEmpty()) {
            updateData(new ArrayList<>());
            return;
        }
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                updateData(bimuiUsers);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }


    private void updateData(List<BIMUIUser> date) {
        adapter = new BIMUserListAdapter(this, date, user -> {
            BIMUIClient.getInstance().getModuleStarter().startProfileModule(this, user.getUid());
        });
        recyclerView.setAdapter(adapter);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.tab_read) {
            type = TYPE_READ;
        } else if (v.getId() == R.id.tab_un_read) {
            type = TYPE_UNREAD;
        }

        initReceiptList(message);
    }
}
