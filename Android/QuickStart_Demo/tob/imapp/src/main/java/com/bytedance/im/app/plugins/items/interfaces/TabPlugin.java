package com.bytedance.im.app.plugins.items.interfaces;

import android.app.Fragment;

public interface TabPlugin {
    int getTabIcon();
    String getTabName();
    Fragment getTabFragment();
}
