package com.bytedance.im.app.custom.operations;

import android.content.Intent;
import android.view.View;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMTextElement;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;

/**
 * 查看消息详情
 */
public class VEUnreadMessageDetailOperationInfo extends BIMMessageOperation {
    public VEUnreadMessageDetailOperationInfo() {
        super(com.bytedance.im.ui.R.drawable.icon_msg_option_menu_read_callback, "未读");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        Intent intent = new Intent(v.getContext(), VEUnreadMessageDetailActivity.class);
        if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_TEXT) {
            String msgID = ((BIMTextElement) bimMessage.getElement()).getText();
            long msgServerId = -1;
            try {
                msgServerId = Long.parseLong(msgID);
            } catch (Exception e) {

            }

            if (msgServerId > 0) {
                BIMClient.getInstance().getMessageByServerID(msgServerId, 0, false, new BIMResultCallback<BIMMessage>() {
                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        if (bimMessage != null) {
                            intent.putExtra(VEUnreadMessageDetailActivity.MSG_ID, "" + bimMessage.getServerMsgId());
                            intent.putExtra(VEUnreadMessageDetailActivity.CID, bimMessage.getConversationID());
                        }
                        v.getContext().startActivity(intent);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        v.getContext().startActivity(intent);
                    }
                });
            } else {
                v.getContext().startActivity(intent);
            }
        } else {
            v.getContext().startActivity(intent);
        }
    }
}
