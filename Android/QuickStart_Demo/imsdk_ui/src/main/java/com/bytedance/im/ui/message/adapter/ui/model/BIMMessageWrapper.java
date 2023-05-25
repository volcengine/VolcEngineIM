package com.bytedance.im.ui.message.adapter.ui.model;

import android.util.Log;

import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMBaseElement;
import com.bytedance.im.ui.log.BIMLog;

public class BIMMessageWrapper {
    private static final String TAG = "VEMessageWrapper";
    boolean isSelect;
    private BIMMessage bimMessage;

    public BIMMessageWrapper(BIMMessage bimMessage) {
        if (bimMessage == null) {
            throw new RuntimeException("VEMessageWrapper constuctor bimMessage is null!");
        }
        this.bimMessage = bimMessage;
        Log.i(TAG,"content: "+bimMessage.getElement());
    }

    public BIMMessage getBimMessage() {
        return bimMessage;
    }

    public Class<? extends BIMBaseElement> getContentClass() {
        BIMBaseElement content = bimMessage.getElement();
        if (content == null) {
            BIMLog.i(TAG, "content is null! type "+bimMessage.getMsgType() + " contentStr: "+bimMessage.getContentData());
        }
        return content.getClass();
    }

}
