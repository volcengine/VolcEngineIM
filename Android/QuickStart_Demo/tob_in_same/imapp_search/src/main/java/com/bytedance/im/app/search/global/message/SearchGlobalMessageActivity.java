package com.bytedance.im.app.search.global.message;

import android.app.Activity;
import android.app.FragmentManager;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.KeySearchConst;
import com.bytedance.im.app.search.types.widget.SearchBar;

public class SearchGlobalMessageActivity extends Activity {

    private static final String TAG = "GSMsg";
    private SearchBar searchBar;
    private String keyWord;
    private SearchGlobalMsgFragment searchGlobalMsgFragment;
    private static final int LIMIT = 20;


    public static void start(Activity activity, String keyword) {
        Intent intent = new Intent(activity, SearchGlobalMessageActivity.class);
        intent.putExtra(KeySearchConst.KEY_SEARCH_WORD, keyword);
        activity.startActivity(intent);
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_search_global_msg_activity);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        TextView title = findViewById(R.id.search_title);
        title.setText("消息");
        String initSearchKey = getIntent().getStringExtra(KeySearchConst.KEY_SEARCH_WORD);
        searchBar = findViewById(R.id.search_bar);
        searchGlobalMsgFragment = new SearchGlobalMsgFragment();
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.frame_layout, searchGlobalMsgFragment)
                .commitAllowingStateLoss();
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchGlobalMsgFragment.search(key, LIMIT,true,null);
            }

            @Override
            public void onClose() {
                searchGlobalMsgFragment.search("", LIMIT,true,null);

            }
        });
        searchBar.post(() -> searchBar.getEditText().setText(initSearchKey));
    }
}
