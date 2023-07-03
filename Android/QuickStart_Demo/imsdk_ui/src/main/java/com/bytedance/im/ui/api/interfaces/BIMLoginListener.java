package com.bytedance.im.ui.api.interfaces;

import com.bytedance.im.ui.api.BIMUser;

public interface BIMLoginListener {
    void doLogin(BIMUser user, String token);
}
