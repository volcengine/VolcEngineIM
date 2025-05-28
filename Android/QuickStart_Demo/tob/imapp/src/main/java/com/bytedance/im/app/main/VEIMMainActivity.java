package com.bytedance.im.app.main;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;

import com.bytedance.im.app.R;
import com.bytedance.im.app.plugins.TabPluginManager;
import com.bytedance.im.app.plugins.items.interfaces.TabPlugin;
import com.bytedance.im.app.plugins.widget.TabView;

import com.bytedance.im.ui.api.interfaces.BIMSupportUnread;

import java.util.HashMap;
import java.util.Map;

public class VEIMMainActivity extends Activity {

    private static final String TAG = "VEIMMainActivity";
    private int currentTab = -1;
    private LinearLayout tabLayout;
    private Map<TabView, Fragment> tapMap = new HashMap<>();
    private TabView curTab;

    public static void start(Context context) {
        Intent intent = new Intent(context, VEIMMainActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i(TAG, "onCreate()");
        setContentView(R.layout.ve_im_activity_main_list);
        tabLayout = findViewById(R.id.cl_menu);

        TabPluginManager tabPluginManager = new TabPluginManager();
        tabLayout.setWeightSum(tabPluginManager.getTabPluginList().size());
        TabView defaultTab = null;
        for (TabPlugin tabPlugin : tabPluginManager.getTabPluginList()) {
            TabView tabView = new TabView(this);
            tabView.setIcon(tabPlugin.getTabIcon());
            tabView.setTitle(tabPlugin.getTabName());
            Fragment fragment = tabPlugin.getTabFragment();
            if(fragment instanceof BIMSupportUnread){
                ((BIMSupportUnread) fragment).setUnReadListener(tabView);
            }
            tapMap.put(tabView, fragment);
            FragmentTransaction transaction = getFragmentManager().beginTransaction();
            transaction.add(R.id.page_container, fragment);
            transaction.commit();
            tabView.setOnClickListener(v -> {
                selectTab((TabView) v);
            });
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            params.weight = 1;
            tabLayout.addView(tabView, params);
            if (defaultTab == null) {
                defaultTab = tabView;
            }
        }
        selectTab(defaultTab);
        
    }

    private void selectTab(TabView v) {
        if (curTab == v) {
            return;
        }
        curTab = v;
        for (TabView tabView : tapMap.keySet()) {
            tabView.updateTitleColor(curTab);
        }
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        for (Fragment fragment : tapMap.values()) {
            ft.hide(fragment);
        }
        Fragment selectFragment = tapMap.get(v);
        ft.show(selectFragment);
        ft.commit();
    }

    @Override
    public void onBackPressed() {
        if ("com.bytedance.im.veapp".equals(getPackageName())) {
            return;
        }
        super.onBackPressed();
    }
}
