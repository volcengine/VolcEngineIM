package com.bytedance.im.app.plugins.items.tob;

import android.app.Fragment;

import com.bytedance.im.app.R;
import com.bytedance.im.app.conversation.VEConversationListFragment;
import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;
import com.bytedance.im.app.utils.VEUtils;

public class ConverTabPlugin implements TabPlugin {
    @Override
    public int getTabIcon() {
        return R.drawable.icon_main_menu_conversation_unclicked;
    }

    @Override
    public String getTabName() {
        return "消息";
    }

    @Override
    public Fragment getTabFragment() {
        VEConversationListFragment convFragment = new VEConversationListFragment();
        VEConversationListFragment.IS_SHILED = VEUtils.isShield();
        return convFragment;
    }
}
