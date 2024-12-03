package com.bytedance.im.app.search.global;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.BuildConfig;
import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.contact.SearchContactPanel;
import com.bytedance.im.app.search.global.group.SearchGroupPanel;
import com.bytedance.im.app.search.global.message.SearchMsgPanel;
import com.bytedance.im.app.search.types.widget.SearchBar;

public class VEGlobalSearchResultActivity extends Activity {
    private String searchKey;
    private SearchBar searchBar;
    private SearchMsgPanel searchMsgPanel;
    private SearchContactPanel searchContactPanel;
    private SearchGroupPanel searchGroupPanel;
    private View panelList;
    private View emptyView;
    private TextView more;
    private long lastTriggerTime = 0;
    private boolean includeEmptyGroup = true; //是否搜索无消息的会话

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_global_search);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        panelList = findViewById(R.id.panel_list);
        emptyView = findViewById(R.id.empty_view);
        searchMsgPanel = new SearchMsgPanel();
        searchContactPanel = new SearchContactPanel();
        searchGroupPanel = new SearchGroupPanel();
        addPanel(R.id.search_contact_container, searchContactPanel);
        addPanel(R.id.search_group_container, searchGroupPanel);
        addPanel(R.id.search_msg_container, searchMsgPanel);

        searchBar = findViewById(R.id.search_bar);
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchKey = key;
                search();
            }

            @Override
            public void onClose() {
                searchKey = "";
            }
        });
        if (BuildConfig.DEBUG) {
            more = findViewById(R.id.tv_more);
            more.setVisibility(View.VISIBLE);
            more.setText("含空会话");
            more.setOnClickListener(v -> {
                includeEmptyGroup = !includeEmptyGroup;
                if (includeEmptyGroup) {
                    more.setText("含空会话");
                } else {
                    more.setText("非空会话");
                }
                search(); //触发刷新
            });
        }
    }

    private void addPanel(int layoutId, Fragment fragment) {
        getFragmentManager().beginTransaction()
                .replace(layoutId, fragment)
                .commitAllowingStateLoss();
    }

    private void search() {
        lastTriggerTime = System.currentTimeMillis();
        SearchCounter searchCounter = new SearchCounter(lastTriggerTime,searchKey);
        searchContactPanel.setOnPanelSearchEndListener(searchCounter);
        searchGroupPanel.setOnPanelSearchEndListener(searchCounter);
        searchMsgPanel.setOnPanelSearchEndListener(searchCounter);
        searchContactPanel.search(searchKey);
        searchGroupPanel.search(searchKey,includeEmptyGroup);
        searchMsgPanel.search(searchKey);
    }

    private class SearchCounter implements OnPanelSearchEndListener {
        long triggerTime = 0;
        private String searchKey;

        public SearchCounter(long triggerTime,String key) {
            this.triggerTime = triggerTime;
            this.searchKey = key;
        }

        int totalTask = 3;
        int sum = 0;

        @Override
        public void onSearchCount(int count,String tag) {

            totalTask--;
            sum += count;
            Log.i("SearchCounter", "onSearchCount tag: " + tag + " count:" + count +" triggerTime: "+triggerTime +" totalTask:"+totalTask +" sum:"+sum +" isUpdateUI:"+(triggerTime == lastTriggerTime));
            if (totalTask == 0 && triggerTime == lastTriggerTime) {
                if (sum == 0) {
                    emptyView.setVisibility(View.VISIBLE);
                    panelList.setVisibility(View.GONE);
                    if (TextUtils.isEmpty(searchKey)) {
                        emptyView.setVisibility(View.GONE);
                        panelList.setVisibility(View.GONE);
                    }
                } else {
                    emptyView.setVisibility(View.GONE);
                    panelList.setVisibility(View.VISIBLE);
                }
            }
        }
    }
}
