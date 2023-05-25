package com.bytedance.im.app.live.chatRoom.operation;

import android.view.View;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.operation.OperationInfo;

public class VELiveDeleteOperationInfo extends OperationInfo {

    public VELiveDeleteOperationInfo() {
        super(R.drawable.icon_msg_option_menu_delete, "删除");
    }

    public VELiveDeleteOperationInfo(int resId, String name) {
        super(resId, name);
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
//        BIMClient.getInstance().getService(BIMLiveGroupExpandService.class).deleteMessage(bimMessage, new BIMSimpleCallback() {
//            @Override
//            public void onSuccess() {
//                Toast.makeText(v.getContext(), "删除成功", Toast.LENGTH_SHORT).show();
//            }
//
//            @Override
//            public void onFailed(BIMErrorCode code) {
//                Toast.makeText(v.getContext(), "删除失败", Toast.LENGTH_SHORT).show();
//            }
//        });
    }
}
