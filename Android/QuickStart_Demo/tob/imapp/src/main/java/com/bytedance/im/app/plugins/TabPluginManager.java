package com.bytedance.im.app.plugins;

import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;
import com.bytedance.im.app.plugins.items.mixed.MineTabPlugin;
import com.bytedance.im.app.plugins.items.tob.ContactTabPlugin;
import com.bytedance.im.app.plugins.items.tob.ConverTabPlugin;
import com.bytedance.im.app.plugins.items.tob.LiveTabPlugin;
import com.bytedance.im.app.utils.VEUtils;

import java.util.ArrayList;
import java.util.List;

public class TabPluginManager {
    List<TabPlugin> tabPluginList;

    public TabPluginManager() {
        tabPluginList = new ArrayList<>();
        tabPluginList.add(new ConverTabPlugin());
        if (!VEUtils.isShield()) {
            tabPluginList.add(new LiveTabPlugin());
        }
        tabPluginList.add(new ContactTabPlugin());
        tabPluginList.add(new MineTabPlugin());
    }

    public List<TabPlugin> getTabPluginList() {
        return tabPluginList;
    }
}
