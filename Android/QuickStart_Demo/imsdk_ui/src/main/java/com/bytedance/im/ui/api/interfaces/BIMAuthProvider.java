package com.bytedance.im.ui.api.interfaces;

public interface BIMAuthProvider {
    //    void init(Application application, int appId, int env);
    void setLoginListener(BIMLoginListener listener);

    void setLoginUidStrListener(BIMUidStrLoginListener listener);
}
