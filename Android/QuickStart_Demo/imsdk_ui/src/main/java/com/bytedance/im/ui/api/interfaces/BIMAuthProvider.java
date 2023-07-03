package com.bytedance.im.ui.api.interfaces;

import android.app.Application;

public interface BIMAuthProvider {
    void init(Application application, int appId, int env);
    void setLoginListener(BIMLoginListener listener);
}
