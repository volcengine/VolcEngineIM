package com.bytedance.im.ui.message.adapter.ui.widget.pop.operation;

import android.view.View;
import android.widget.Toast;


import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.DialogUtil;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;

public class DeleteOperationInfo extends BIMMessageOperation {
    public DeleteOperationInfo() {
        super(R.drawable.icon_msg_option_menu_delete, "删除");
    }


    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        DialogUtil.showBottomConfirmDialog(v.getContext(), "是否删除该条消息？", "确定",
                new DialogUtil.ConfirmDialogClickListener() {
                    @Override
                    public void onConfirmClick(View view) {
                        BIMClient.getInstance().deleteMessage(bimMessage, new BIMResultCallback<BIMMessage>() {
                            @Override
                            public void onSuccess(BIMMessage bimMessage) {
                                Toast.makeText(v.getContext(), "删除消息成功", Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(v.getContext(), "删除消息失败", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                });
    }
}
