package com.bytedance.im.app.user;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


import com.bytedance.im.app.R;
import com.bytedance.im.app.login.data.UserMock;
import com.bytedance.im.ui.api.BIMUser;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class BIMUserSelectActivity extends Activity implements View.OnClickListener {
    private static final String TAG = "VEUserSelectActivity";
    public static final String SELECT_RESULT = "select_result";
    public static final String EXCLUDE_ID_LIST = "exclude_id_list";
    public static final String INCLUDE_ID_LIST = "include_id_list";
    private RecyclerView recyclerView;
    private TextView confirm;
    private BIMUserSelectAdapter adapter;
    private ImageView back;

    public static void startForResult(Fragment fragment, int requestCode) {
        if (!fragment.isAdded()) {
            return;
        }
        Intent intent = new Intent(fragment.getActivity(), BIMUserSelectActivity.class);
        fragment.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_user_select_layout);
        //以下不会同时传
        List<Integer> excludeList = getIntent().getIntegerArrayListExtra(EXCLUDE_ID_LIST);  //排除的id
        List<Integer> includeList = getIntent().getIntegerArrayListExtra(INCLUDE_ID_LIST);  //包含的id

        recyclerView = findViewById(R.id.user_list);
        confirm = findViewById(R.id.tv_confirm);
        back = findViewById(R.id.back);
        back.setOnClickListener(this);
        confirm.setOnClickListener(this);
        List<BIMUser> data = filter(UserMock.getInstance().getMockLoginUserList(),excludeList,includeList);
        adapter = new BIMUserSelectAdapter(this, data, isSinglePick(), isShowUid());
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(adapter);
    }

    private List<BIMUser> filter(List<BIMUser> all, List<Integer> excludeList, List<Integer> includeList) {
        if (excludeList != null && includeList == null) {
            Iterator<BIMUser> iterator = all.iterator();
            while (iterator.hasNext()) {
                BIMUser user = iterator.next();
                if (excludeList.contains((int) user.getUserID())) {
                    iterator.remove();
                }
            }
        } else if (excludeList == null && includeList != null) {
            Iterator<BIMUser> iterator = all.iterator();
            while (iterator.hasNext()) {
                BIMUser user = iterator.next();
                if (!includeList.contains((int) user.getUserID())) {
                    iterator.remove();
                }
            }
        }
        return all;
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.back) {
            setResult(RESULT_CANCELED);
            finish();
        } else if (id == R.id.tv_confirm) {
            List<BIMUser> result = adapter.getSelectUser();
            ArrayList<Integer> uidList = new ArrayList<>();
            ArrayList<Long> confirmList = new ArrayList<>();
            for (BIMUser user : result) {
                confirmList.add(user.getUserID());
                uidList.add((int) user.getUserID());
            }

            if (!uidList.isEmpty() && !onConfirmClick(confirmList)) {
                Intent data = new Intent();
                data.putIntegerArrayListExtra(SELECT_RESULT, uidList);
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

    protected boolean isShowUid(){
        return false;
    }
}
