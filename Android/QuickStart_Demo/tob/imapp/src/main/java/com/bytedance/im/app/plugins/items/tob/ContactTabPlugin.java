package com.bytedance.im.app.plugins.items.tob;

import android.app.Fragment;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.contact.mainList.VEContactListFragment;
import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;

public class ContactTabPlugin implements TabPlugin {
    @Override
    public int getTabIcon() {
        return R.drawable.icon_contact;
    }

    @Override
    public String getTabName() {
        return "通讯录";
    }

    @Override
    public Fragment getTabFragment() {
        return new VEContactListFragment();
    }
}
