package com.bytedance.im.app.plugins.items.in;

import android.app.Fragment;

import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;

public class INConversationPlugin implements TabPlugin {
    @Override
    public int getTabIcon() {
        return 0;
    }

    @Override
    public String getTabName() {
        return null;
    }

    @Override
    public Fragment getTabFragment() {
        return null;
    }
}
