package com.bytedance.im.app.custom.toolbtn;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.bytedance.im.app.custom.data.BIMCouponElement;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;
import com.bytedance.im.core.service.manager.BIMMessageManager;

public class CouponToolBtn extends BaseToolBtn<Boolean> {
    public CouponToolBtn() {
    }

    public CouponToolBtn(BIMResultCallback<Boolean> callback) {
        super(callback);
    }

    @Override
    public int getIcon(Context context) {
        return R.drawable.icon_im_input_optional_img;
    }

    @Override
    public String getTitle(Context context) {
        return "优惠券";
    }

    @Override
    public void onClick(Fragment fragment, View view, BIMConversation conversation) {
        BIMCouponElement couponElement = new BIMCouponElement();
        String detailStr = "这是一张优惠券,点击此处领取";
        couponElement.setCouponDetail(detailStr);
        couponElement.setRange(detailStr.indexOf(",") + 1, detailStr.length());
        BIMMessage customMessage = BIMClient.getInstance().createCustomMessage(BIMMessageManager.getInstance().encode(couponElement));
        BIMUIClient.getInstance().sendMessage(customMessage, conversation.getConversationID(), new BIMSendCallback() {
            @Override
            public void onSuccess(BIMMessage bimMessage) {

            }

            @Override
            public void onError(BIMMessage bimMessage, BIMErrorCode code) {

            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

    }
}
