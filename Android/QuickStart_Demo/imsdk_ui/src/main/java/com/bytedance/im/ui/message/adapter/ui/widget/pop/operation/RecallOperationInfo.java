package com.bytedance.im.ui.message.adapter.ui.widget.pop.operation;

import android.view.View;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

public class RecallOperationInfo extends BIMMessageOperation {

    public RecallOperationInfo() {
        super(R.drawable.icon_msg_option_menu_recall, "撤回");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        BIMClient.getInstance().recallMessage(bimMessage, new BIMResultCallback<BIMMessage>() {
            @Override
            public void onSuccess(BIMMessage message) {
                Toast.makeText(v.getContext(), "你撤回了一条消息", Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if(code == BIMErrorCode.BIM_SERVER_RECALL_TIMEOUT){
                    Toast.makeText(v.getContext(), "超过2分钟的消息无法撤回", Toast.LENGTH_SHORT).show();
                }else {
                    Toast.makeText(v.getContext(), "撤回失败 code :" + code, Toast.LENGTH_SHORT).show();
                }
            }
        });

    }
}
