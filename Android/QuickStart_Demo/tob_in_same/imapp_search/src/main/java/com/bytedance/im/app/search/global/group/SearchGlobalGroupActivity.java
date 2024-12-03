package com.bytedance.im.app.search.global.group;

import android.app.Activity;
import android.app.FragmentManager;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.KeySearchConst;
import com.bytedance.im.app.search.types.widget.SearchBar;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;

public class SearchGlobalGroupActivity extends Activity {
    private static final String TAG = "GSGroup";
    private static final int LIMIT = 4;
    private static final String INCLUDE_EMPTY = "include_empty";
    private SearchBar searchBar;
    private SearchGlobalGroupFragment searchGlobalGroupFragment;

    public static void start(Activity activity, String keyword, boolean includeEmpty) {
        Intent intent = new Intent(activity, SearchGlobalGroupActivity.class);
        intent.putExtra(KeySearchConst.KEY_SEARCH_WORD, keyword);
        intent.putExtra(INCLUDE_EMPTY, includeEmpty);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_search_global_group_activity);
        TextView title = findViewById(R.id.search_title);
        title.setText("群组");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        String keyword = getIntent().getStringExtra(KeySearchConst.KEY_SEARCH_WORD);
        boolean includeEmpty = getIntent().getBooleanExtra(INCLUDE_EMPTY,true);
        Log.i(TAG, "onCreate keyword:" + keyword);
        searchBar = findViewById(R.id.search_bar);
        searchGlobalGroupFragment = new SearchGlobalGroupFragment();
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.search_group_container, searchGlobalGroupFragment)
                .commitAllowingStateLoss();
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchGlobalGroupFragment.search(key, LIMIT, true, includeEmpty, null);
            }

            @Override
            public void onClose() {
                searchGlobalGroupFragment.search("", LIMIT, true, includeEmpty, null);
            }
        });
        searchBar.post(() -> searchBar.setText(keyword));
    }
}
