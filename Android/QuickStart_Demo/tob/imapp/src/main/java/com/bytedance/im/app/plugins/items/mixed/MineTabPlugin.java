package com.bytedance.im.app.plugins.items.mixed;

import android.app.Fragment;

import com.bytedance.im.app.R;
import com.bytedance.im.app.main.VEMineFragment;
import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;

public class MineTabPlugin implements TabPlugin {
    @Override
    public int getTabIcon() {
        return R.drawable.icon_main_menu_mine_unclicked;
    }

    @Override
    public String getTabName() {
        return "我的";
    }

    @Override
    public Fragment getTabFragment() {
        return new VEMineFragment();
    }
}
