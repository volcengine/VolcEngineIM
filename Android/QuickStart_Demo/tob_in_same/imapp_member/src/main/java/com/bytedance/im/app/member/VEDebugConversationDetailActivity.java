package com.bytedance.im.app.member;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;

import java.util.ArrayList;
import java.util.List;

public class VEDebugConversationDetailActivity extends Activity {
    private static final String CONVERSATION_SHORT_ID = "conversation_short_id";

    private TextView tvServerMsg;
    private TextView tvLocalMsg;

    public static void start(Context context, long shortId) {
        Intent intent = new Intent(context, VEDebugConversationDetailActivity.class);
        intent.putExtra(CONVERSATION_SHORT_ID, shortId);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_conv_detail);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        long shortId = getIntent().getLongExtra(CONVERSATION_SHORT_ID, -1);
        tvServerMsg = findViewById(R.id.tv_msg_server_detail);
        tvLocalMsg = findViewById(R.id.tv_msg_local);
        EditText editShortId = findViewById(R.id.edit_shortId);
        TextView query = findViewById(R.id.query);
        editShortId.setText("" + shortId);
        query.setOnClickListener(v -> {
            if (editShortId.getEditableText() == null) {
                return;
            }
            try {
                String str = editShortId.getEditableText().toString();
                if (str.contains(",")) {
                    String[] strings = str.split(",");
                    List<Long> shorIdList = new ArrayList<>();
                    for (String s : strings) {
                        shorIdList.add(Long.parseLong(s));
                    }
                    queryConversationList(shorIdList);
                } else {
                    long conversationShortId = Long.parseLong(str);
                    queryConversation(conversationShortId);
                }
            } catch (Exception e) {
                Toast.makeText(this, "请输入合法参数", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void queryConversation(long conversationShortId) {
        BIMUIClient.getInstance().getConversationByShortID(conversationShortId, true, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation bimConversation) {
                if (bimConversation == null) {
                    return;
                }
                tvServerMsg.setText("服务端详情:\n" + bimConversation.getConversation().toString());
            }

            @Override
            public void onFailed(BIMErrorCode code) {

                tvServerMsg.setText("服务端:查询会话失败");

            }
        });

        BIMUIClient.getInstance().getConversationByShortID(conversationShortId, false, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation bimConversation) {
                if (bimConversation == null) {
                    return;
                }
                tvLocalMsg.setText("客户端详情:\n" + bimConversation.getConversation().toString());
            }

            @Override
            public void onFailed(BIMErrorCode code) {

                tvLocalMsg.setText("客户端:查询会话失败");

            }
        });
    }

    private void queryConversationList(List<Long> shorIdList) {
        BIMUIClient.getInstance().getConversationByShortIDList(shorIdList, true, new BIMResultCallback<List<BIMConversation>>() {
            @Override
            public void onSuccess(List<BIMConversation> bimConversations) {
                if (bimConversations == null) {
                    return;
                }
                tvServerMsg.setText("服务端详情:\n" + buildConvString(bimConversations));
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                tvServerMsg.setText("服务端:查询会话失败");

            }
        });

        BIMUIClient.getInstance().getConversationByShortIDList(shorIdList, false, new BIMResultCallback<List<BIMConversation>>() {
            @Override
            public void onSuccess(List<BIMConversation> bimConversations) {
                if (bimConversations == null) {
                    return;
                }
                tvLocalMsg.setText("客户端详情:\n" + buildConvString(bimConversations));
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                tvLocalMsg.setText("客户端:查询会话失败");
            }
        });
    }

    private String buildConvString(List<BIMConversation> bimConversationList){
        StringBuilder builder = new StringBuilder();
        for(BIMConversation bimConversation:bimConversationList){
            builder.append(bimConversation.getConversation().toString())
            .append(",\n-----------\n");
        }
        return builder.toString();
    }
}
