package com.bytedance.im.app.search.global.contact;

import android.app.Activity;
import android.app.FragmentManager;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.KeySearchConst;
import com.bytedance.im.app.search.global.group.SearchGlobalGroupActivity;
import com.bytedance.im.app.search.global.group.SearchGlobalGroupFragment;
import com.bytedance.im.app.search.types.widget.SearchBar;

public class SearchGlobalFriendActivity extends Activity {
    private static final String TAG = "GSFriend";
    private static final int LIMIT = 20;
    private SearchBar searchBar;
    private SearchGlobalContactFragment searchContacFragment;

    public static void start(Activity activity, String keyword) {
        Intent intent = new Intent(activity, SearchGlobalFriendActivity.class);
        intent.putExtra(KeySearchConst.KEY_SEARCH_WORD, keyword);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_search_global_friend_activity);
        TextView title = findViewById(R.id.search_title);
        title.setText("联系人");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        String keyword = getIntent().getStringExtra(KeySearchConst.KEY_SEARCH_WORD);
        Log.i(TAG, "onCreate keyword:" + keyword);
        searchBar = findViewById(R.id.search_bar);

        searchContacFragment = new SearchGlobalContactFragment();
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.friend_container, searchContacFragment)
                .commitAllowingStateLoss();
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchContacFragment.search(key, LIMIT, true,null);
            }

            @Override
            public void onClose() {
                searchContacFragment.search("", LIMIT, true,null);
            }
        });
        searchBar.post(() -> searchBar.setText(keyword));
    }
}
