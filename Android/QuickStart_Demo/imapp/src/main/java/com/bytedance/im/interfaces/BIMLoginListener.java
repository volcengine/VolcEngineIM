package com.bytedance.im.interfaces;

import com.bytedance.im.ui.api.BIMUIUser;

public interface BIMLoginListener {
    void onProtoAgree();
    void doLogin(BIMUIUser user, String token);
    void onDebugClick();
}
