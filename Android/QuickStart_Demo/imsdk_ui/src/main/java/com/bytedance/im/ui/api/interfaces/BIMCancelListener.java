package com.bytedance.im.ui.api.interfaces;

public interface BIMCancelListener {
    void onSuccess();
    void onFailed(int errorCode, String errorMsg);
}
