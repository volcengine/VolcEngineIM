package com.bytedance.im.interfaces;

import com.bytedance.im.ui.api.BIMUser;

public interface BIMLoginListener {
    void onProtoAgree();
    void doLogin(BIMUser user, String token);
    void onDebugClick();
}
