package com.bytedance.im.app.message.detail;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;

import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.BIMUIClient;

public class VEMessageDetailActivity extends Activity {

    private static final String MSG_ID = "message_id";
    private static final String CONV_SHORT_ID = "conv_short_id";

    private TextView tvServerMsg;
    private TextView tvLocalMsg;

    public static void start(Context context, long msgId, long shortId) {
        Intent intent = new Intent(context, VEMessageDetailActivity.class);
        intent.putExtra(MSG_ID, msgId);
        intent.putExtra(CONV_SHORT_ID, shortId);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_message_detail);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        long msgId = getIntent().getLongExtra(MSG_ID, -1);
        long shortId = getIntent().getLongExtra(CONV_SHORT_ID, -1);
        tvServerMsg = findViewById(R.id.tv_msg_server_detail);
        tvLocalMsg = findViewById(R.id.tv_msg_local);
        EditText editMsgId = findViewById(R.id.edit_msgId);
        EditText editShortId = findViewById(R.id.edit_shortId);
        TextView query = findViewById(R.id.query);
        editMsgId.setText("" + msgId);
        editShortId.setText("" + shortId);
        query.setOnClickListener(v -> {
            if (editMsgId.getEditableText() == null || editShortId.getEditableText() == null) {
                return;
            }
            try {
                long messageServerId = Long.parseLong(editMsgId.getEditableText().toString());
                long conversationShortId = Long.parseLong(editShortId.getEditableText().toString());
                queryMessage(messageServerId, conversationShortId);
            } catch (Exception e) {
                Toast.makeText(this, "请输入合法参数", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void queryMessage(long messageServerId, long conversationShortId) {
        BIMUIClient.getInstance().getMessageByServerID(messageServerId, conversationShortId, true, new BIMResultCallback<BIMMessage>() {
            @Override
            public void onSuccess(BIMMessage bimMessage) {
                if (bimMessage == null) {
                    return;
                }
                tvServerMsg.setText("服务端详情:\n" + bimMessage.toString());
            }

            @Override
            public void onFailed(BIMErrorCode code) {

                tvServerMsg.setText("查询消息失败");

            }
        });

        BIMUIClient.getInstance().getMessageByServerID(messageServerId, conversationShortId, false, new BIMResultCallback<BIMMessage>() {

            @Override
            public void onSuccess(BIMMessage bimMessage) {
                if (bimMessage == null) {
                    return;
                }
                tvLocalMsg.setText("本地详情:\n" + bimMessage.toString());
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                tvServerMsg.setText("查询消息失败");
            }
        });
    }
}
