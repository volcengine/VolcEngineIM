package com.bytedance.im.app.user;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import com.bytedance.im.app.R;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class BIMUserSelectActivity extends Activity implements View.OnClickListener {
    private static final String TAG = "VEUserSelectActivity";
    public static final String TITLE = "title";
    public static final String SELECT_RESULT = "select_result";
    public static final String ALL_LIST = "all_id_list";
    private RecyclerView recyclerView;
    private TextView confirm;
    private BIMUserSelectAdapter adapter;
    private ImageView back;

    public static void startForResult(Activity activity, ArrayList<Long> allList, int requestCode) {
        if (allList.isEmpty()) {
            return;
        }
        Intent intent = new Intent(activity, BIMUserSelectActivity.class);
        intent.putExtra(ALL_LIST, allList);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_user_select_layout);
        //以下不会同时传
        List<Long> allArray = (List<Long>) getIntent().getSerializableExtra(ALL_LIST);
        recyclerView = findViewById(R.id.user_list);
        confirm = findViewById(R.id.tv_confirm);
        back = findViewById(R.id.back);
        back.setOnClickListener(this);
        confirm.setOnClickListener(this);
        List<BIMUIUser> data = new ArrayList<>();
        if (allArray != null) {
            for (long id : allArray) {
                data.add(VEIMApplication.accountProvider.getUserProvider().getUserInfo(id));
            }
        }
        adapter = new BIMUserSelectAdapter(this, data, isSinglePick(), isShowUid());
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.back) {
            setResult(RESULT_CANCELED);
            finish();
        } else if (id == R.id.tv_confirm) {
            List<BIMUIUser> result = adapter.getSelectUser();
            ArrayList<Long> uidList = new ArrayList<>();
            ArrayList<Long> confirmList = new ArrayList<>();
            for (BIMUIUser user : result) {
                confirmList.add(user.getUserID());
                uidList.add(user.getUserID());
            }
            if (!uidList.isEmpty() && !onConfirmClick(confirmList)) {
                Intent data = new Intent();
                data.putExtra(SELECT_RESULT, uidList);
                setResult(RESULT_OK, data);
                finish();
            }
        }
    }

    protected boolean onConfirmClick(List<Long> uidList) {
        return false;
    }

    protected boolean isSinglePick() {
        return false;
    }

    protected boolean isShowUid() {
        return false;
    }
}
