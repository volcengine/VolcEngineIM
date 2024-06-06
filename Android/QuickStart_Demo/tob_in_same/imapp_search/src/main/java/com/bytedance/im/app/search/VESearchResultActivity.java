package com.bytedance.im.app.search;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.bytedance.im.app.search.tab.SearchTab;
import com.bytedance.im.app.search.types.SearchFileFragment;
import com.bytedance.im.app.search.types.SearchTextFragment;
import com.bytedance.im.app.search.types.TypeMediaFragment;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.enums.BIMPullDirection;
import com.bytedance.im.ui.starter.ModuleStarter;
import com.bytedance.im.ui.utils.BIMUIUtils;

import java.util.ArrayList;
import java.util.List;

public class VESearchResultActivity extends Activity {
    public static final String TAG = "VESearchConvResultActivity";

    private String KEY_DIRECTION = "pull_direction";
    private String conversationID;
    private VESearchAdapter searchAdapter;
    private LinearLayout tabLinearLayout;
    private List<SearchTab> searchTabList;
    private Fragment curShowFragment;
    private BIMPullDirection pullDirection = BIMPullDirection.DESC;
    private TextView tvOrder;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_search_conv_layout);
        findViewById(R.id.iv_back).setOnClickListener(v -> onBackPressed());
        conversationID = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        int direction = getIntent().getIntExtra(KEY_DIRECTION, BIMPullDirection.DESC.getValue());
        pullDirection = BIMPullDirection.getType(direction);
        initFragment();
        if (BuildConfig.DEBUG) {
            testCode();
        }
    }

    private void initFragment() {
        searchTabList = new ArrayList<>();
        searchTabList.add(new SearchTab(this, "消息", BIMMessageType.BIM_MESSAGE_TYPE_TEXT, SearchTextFragment.create(conversationID, BIMMessageType.BIM_MESSAGE_TYPE_TEXT, pullDirection)));
        searchTabList.add(new SearchTab(this, "文件", BIMMessageType.BIM_MESSAGE_TYPE_FILE, SearchFileFragment.create(conversationID, BIMMessageType.BIM_MESSAGE_TYPE_FILE, pullDirection)));
        searchTabList.add(new SearchTab(this, "图片", BIMMessageType.BIM_MESSAGE_TYPE_IMAGE, TypeMediaFragment.create(conversationID, BIMMessageType.BIM_MESSAGE_TYPE_IMAGE, pullDirection)));
        searchTabList.add(new SearchTab(this, "视频", BIMMessageType.BIM_MESSAGE_TYPE_VIDEO, TypeMediaFragment.create(conversationID, BIMMessageType.BIM_MESSAGE_TYPE_VIDEO, pullDirection)));
        tabLinearLayout = findViewById(R.id.tab_container);
        tabLinearLayout.setWeightSum(4);
        FragmentTransaction fragmentTransaction = getFragmentManager()
                .beginTransaction();
        for (SearchTab searchTab : searchTabList) {
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            lp.weight = 1;
            searchTab.setLayoutParams(lp);
            tabLinearLayout.addView(searchTab);
            searchTab.setOnClickListener(v -> switchTab(searchTab));
            Fragment fragment = searchTab.getFragment();
            fragmentTransaction.add(R.id.fragment_container, fragment).hide(fragment);
        }
        fragmentTransaction.commit();
        switchTab(searchTabList.get(0));
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                BIMUIUtils.showKeyBoard(getSearchEditText());
            }
        },500);
    }

    private void switchTab(SearchTab searchTab) {
        FragmentTransaction fragmentTransaction = getFragmentManager()
                .beginTransaction();
        if (curShowFragment != null) {
            fragmentTransaction.hide(curShowFragment);
        }
        for (SearchTab tab : searchTabList) {
            tab.updateSelect(searchTab);
            if (tab == searchTab) {
                fragmentTransaction.show(searchTab.getFragment());
                curShowFragment = tab.getFragment();
            }
        }
        fragmentTransaction.commit();
    }

    private void updateOrderText() {
        if (pullDirection == BIMPullDirection.DESC) {
            tvOrder.setText("逆序");
        } else if (pullDirection == BIMPullDirection.ASC) {
            tvOrder.setText("顺序");
        }
    }

    /**
     * 测试代码,测试顺序
     */
    private void testCode() {
        tvOrder = findViewById(R.id.order);
        tvOrder.setVisibility(View.VISIBLE);
        updateOrderText();
        tvOrder.setOnClickListener(v -> {
            Intent intent = new Intent(VESearchResultActivity.this, VESearchResultActivity.class);
            intent.putExtra("cid", conversationID);
            intent.putExtra(KEY_DIRECTION, BIMPullDirection.ASC.getValue());
            startActivity(intent);
        });
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (ev.getAction() == MotionEvent.ACTION_DOWN) {
            EditText editText = getSearchEditText();
            if (editText != null) {
                BIMUIUtils.hideKeyBoard(editText);
            }
        }
        return super.dispatchTouchEvent(ev);
    }

    private EditText getSearchEditText(){
        EditText editText = null;
        if (curShowFragment instanceof SearchTextFragment) {
            editText = ((SearchTextFragment) curShowFragment).getSearchEditText();
        } else if (curShowFragment instanceof SearchFileFragment) {
            editText = ((SearchFileFragment) curShowFragment).getSearchEditText();
        }
        return editText;
    }
}
