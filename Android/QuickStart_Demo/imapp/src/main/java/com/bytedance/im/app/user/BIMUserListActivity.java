package com.bytedance.im.app.user;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class BIMUserListActivity extends Activity {
    private static final String TAG = "VEUserListActivity";
    public static final String EXCLUDE_ID_LIST = "exclude_id_list";
    public static final String INCLUDE_ID_LIST = "include_id_list";
    private RecyclerView userListV;
    private BIMUserListAdapter adapter;

    private static void start(Activity activity) {
        Intent intent = new Intent(activity, BIMUserListActivity.class);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_user_list_layout);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        userListV = findViewById(R.id.user_list);
        List<BIMUIUser> all = new ArrayList<>();//todo 用户系统
        //以下不会同时传
        List<Integer> excludeList = getIntent().getIntegerArrayListExtra(EXCLUDE_ID_LIST);  //排除的id
        List<Integer> includeList = getIntent().getIntegerArrayListExtra(INCLUDE_ID_LIST);  //包含的id
        List<BIMUIUser> date = filter(all, excludeList, includeList);
        adapter = new BIMUserListAdapter(this, date, user -> onUserClick(user));
        userListV.setLayoutManager(new LinearLayoutManager(this));
        userListV.setAdapter(adapter);
    }

    protected void onUserClick(BIMUIUser user) {
        Toast.makeText(BIMUserListActivity.this, "敬请期待", Toast.LENGTH_SHORT).show();
    }
    private List<BIMUIUser> filter(List<BIMUIUser> all, List<Integer> excludeList, List<Integer> includeList) {
        if (excludeList != null && includeList == null) {
            Iterator<BIMUIUser> iterator = all.iterator();
            while (iterator.hasNext()) {
                BIMUIUser user = iterator.next();
                if (excludeList.contains((int) user.getUid())) {
                    iterator.remove();
                }
            }
        } else if (excludeList == null && includeList != null) {
            Iterator<BIMUIUser> iterator = all.iterator();
            while (iterator.hasNext()) {
                BIMUIUser user = iterator.next();
                if (!includeList.contains((int) user.getUid())) {
                    iterator.remove();
                }
            }
        }
        return all;
    }

}
