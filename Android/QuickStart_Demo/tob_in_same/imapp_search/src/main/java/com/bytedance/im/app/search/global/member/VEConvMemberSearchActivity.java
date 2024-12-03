package com.bytedance.im.app.search.global.member;

import android.app.Activity;
import android.app.FragmentManager;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.KeySearchConst;
import com.bytedance.im.app.search.types.widget.SearchBar;
import com.bytedance.im.ui.starter.ModuleStarter;

public class VEConvMemberSearchActivity extends Activity {
    private static final String TAG = "GSMember";
    private static final int LIMIT = 20;
    private SearchBar searchBar;
    private SearchConvMemberFragment searchConvMemberFragment;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String conversationId = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        setContentView(R.layout.ve_im_search_conv_member_layout);
        TextView title = findViewById(R.id.search_title);
        title.setText("群成员列表");
        findViewById(R.id.back).setOnClickListener(v -> finish());
        String keyword = getIntent().getStringExtra(KeySearchConst.KEY_SEARCH_WORD);
        Log.i(TAG, "onCreate keyword:" + keyword);
        searchBar = findViewById(R.id.search_bar);
        searchConvMemberFragment = new SearchConvMemberFragment();
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.container, searchConvMemberFragment)
                .commitAllowingStateLoss();
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchConvMemberFragment.search(conversationId, key, LIMIT, null);
            }

            @Override
            public void onClose() {
                searchConvMemberFragment.search(conversationId, "", LIMIT, null);
            }
        });
    }
}
