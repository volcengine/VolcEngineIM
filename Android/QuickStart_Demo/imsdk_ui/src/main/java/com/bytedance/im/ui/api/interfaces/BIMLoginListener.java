package com.bytedance.im.ui.api.interfaces;

import com.bytedance.im.ui.api.BIMUIUser;

public interface BIMLoginListener {
    void doLogin(BIMUIUser user, String token);
}
