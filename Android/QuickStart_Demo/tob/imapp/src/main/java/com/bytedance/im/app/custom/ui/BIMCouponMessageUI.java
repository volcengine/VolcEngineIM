package com.bytedance.im.app.custom.ui;

import android.content.Context;
import android.graphics.Color;
import androidx.annotation.NonNull;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.view.View;
import android.widget.TextView;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.app.custom.data.BIMCouponElement;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;

import java.util.Map;

@CustomUIType(contentCls = BIMCouponElement.class)
public class BIMCouponMessageUI extends BaseCustomElementUI {
    private static final String TAG = "BIMCouponMessageUI";
    private static final String KEY_COUPON_STATUS = "a:coupon_status";

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_coupon_layout;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        TextView textView = v.findViewById(R.id.detail);
        BIMMessage message = messageWrapper.getBimMessage();
        BIMCouponElement element = (BIMCouponElement) message.getElement();
        String status = message.getExtra().get(KEY_COUPON_STATUS);
        BIMLog.i(TAG, "onBindView() element:" + element + " status: "+status);
        if (TextUtils.isEmpty(status) || !status.equals("1")) {
            textView.setMovementMethod(LinkMovementMethod.getInstance());
            SpannableString spannableString = new SpannableString(element.getCouponDetail());
            spannableString.setSpan(new ClickableSpan() {
                @Override
                public void onClick(@NonNull View widget) {
                    BIMLog.i(TAG, "onClick() element:" + message.getElement());
                    modifyMessage(message, v.getContext());
                }

                @Override
                public void updateDrawState(@NonNull TextPaint ds) {
                    ds.setColor(Color.BLUE);
                }
            }, element.getStart(), element.getEnd(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
            textView.setText(spannableString);
        } else {
            textView.setText("这是一张优惠券，已领取");
        }
        textView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                return holder.performLongClick(v, messageWrapper);
            }
        });
    }


    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {

    }

    private void modifyMessage(BIMMessage message, Context context) {
        BIMLog.i(TAG, "modifyMessage() ext:" + message.getExtra());
        Map<String, String> ext = message.getExtra();
        ext.put(KEY_COUPON_STATUS, "1");
        message.setExtra(ext);
        BIMClient.getInstance().modifyMessage(message, new BIMResultCallback<BIMMessage>() {
            @Override
            public void onSuccess(BIMMessage message) {
                BIMLog.i(TAG, "modifyMessage() onSuccess()");
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "onFailed() code: "+code);
            }
        });
//        modifyByUIClient(message);
    }

    /**
     * 使用BIMClient 修改
     * @param message
     */
    private void modifyByClient(BIMMessage message){

    }

    @Override
    public boolean isEnableDelete(BIMMessage bimMessage) {
        return true;
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return bimMessage.isSelf();
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return true;
    }

    //    /**
//     * 使用 uiClient 修改 message
//     *
//     * @param message
//     */
//    private void modifyByUIClient(BIMMessage message) {
//        BIMUIClient.getInstance().modifyMessage(message, new BIMResultCallback<BIMMessage>() {
//            @Override
//            public void onSuccess(BIMMessage bimMessage) {
//
//            }
//
//            @Override
//            public void onFailed(BIMErrorCode code) {
//
//            }
//        });
//    }

}
