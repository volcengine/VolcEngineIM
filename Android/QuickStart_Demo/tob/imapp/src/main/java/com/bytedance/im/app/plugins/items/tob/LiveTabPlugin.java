package com.bytedance.im.app.plugins.items.tob;

import android.app.Fragment;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.live.VELiveGroupFragment;
import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;

public class LiveTabPlugin implements TabPlugin {
    @Override
    public int getTabIcon() {
        return R.drawable.icon_main_menu_live_group;
    }

    @Override
    public String getTabName() {
        return "直播群";
    }

    @Override
    public Fragment getTabFragment() {
        return new VELiveGroupFragment();
    }
}
