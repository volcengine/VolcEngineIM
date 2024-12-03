package com.bytedance.im.app.search.global.message;

import android.app.Activity;
import android.app.FragmentManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.global.KeySearchConst;
import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;
import com.bytedance.im.app.search.types.SearchMsgFragment;
import com.bytedance.im.app.search.types.widget.SearchBar;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.starter.ModuleStarter;

public class SearchMsgInConvActivity extends Activity {
    private SearchBar searchBar;

    public static void start(Context context, String cid, String keyWord) {
        Intent intent = new Intent(context, SearchMsgInConvActivity.class);
        intent.putExtra(ModuleStarter.MODULE_KEY_CID, cid);
        intent.putExtra(KeySearchConst.KEY_SEARCH_WORD, keyWord);
        context.startActivity(intent);
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SearchMsgFragment searchMsgFragment = new SearchMsgFragment();
        String cid = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        String keyWord = getIntent().getStringExtra(KeySearchConst.KEY_SEARCH_WORD);
        setContentView(R.layout.ve_im_search_global_msg_activity);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        TextView title = findViewById(R.id.search_title);
        searchBar = findViewById(R.id.search_bar);
        searchBar.setSearchListener(new SearchBar.OnSearchListener() {
            @Override
            public void onSearch(String key) {
                searchMsgFragment.search(key, cid, null, BIMPullDirection.DESC,SearchMsgFragment.FILE_ITEM_TYPE_SENDER_FIST);
            }

            @Override
            public void onClose() {
                searchMsgFragment.search("", cid, null, BIMPullDirection.DESC,SearchMsgFragment.FILE_ITEM_TYPE_SENDER_FIST);
            }
        });
        title.setText("会话中搜索");
        searchMsgFragment.setOnItemClickListener(searchDetail -> {
            BIMUIClient.getInstance().getModuleStarter().startMessageModule(SearchMsgInConvActivity.this, searchDetail.getMessage().getUuid(), cid);
        });
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.frame_layout, searchMsgFragment)
                .commitAllowingStateLoss();
        searchBar.post(() -> searchBar.setText(keyWord));
    }
}
