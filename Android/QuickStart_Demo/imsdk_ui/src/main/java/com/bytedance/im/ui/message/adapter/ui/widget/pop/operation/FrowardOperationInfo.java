package com.bytedance.im.ui.message.adapter.ui.widget.pop.operation;

import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.widget.Toast;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.forward.ForwardActivity;
import com.bytedance.im.core.api.model.BIMMessage;

public class FrowardOperationInfo extends OperationInfo {
    private static final String TAG = "FrowardOperationInfo";
    private int requestForwardCode = 0;
    private BIMMessage bimMessage;
    public FrowardOperationInfo() {
        super(R.drawable.icon_msg_option_menu_open_emoji, "转发");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        requestForwardCode = (int) bimMessage.getServerMsgId();
        this.bimMessage = bimMessage;
        if (requestForwardCode > 0) {
            ForwardActivity.startForResult(veMessageListFragment, requestForwardCode);
        } else {
            Toast.makeText(v.getContext(), "转发失败，mesId 不存在！", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestForwardCode == requestCode) {
                String conversationId = data.getStringExtra(ForwardActivity.FORWARD_CONVERSATION_ID);
                //todo send Forward message
            }
        }
    }
}
