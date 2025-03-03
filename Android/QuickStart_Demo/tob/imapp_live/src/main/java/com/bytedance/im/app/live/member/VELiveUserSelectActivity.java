package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.member.adapter.VELiveUserSelectAdapter;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class VELiveUserSelectActivity extends Activity implements View.OnClickListener {
    private static final String TAG = "VEUserSelectActivity";
    public static final String TITLE = "title";
    public static final String SELECT_RESULT = "select_result";
    public static final String ALL_LIST = "all_id_list";
    public static final String ALL_STR_LIST = "all_id_str_list";
    private RecyclerView recyclerView;
    private TextView confirm;
    private VELiveUserSelectAdapter adapter;
    private ImageView back;
    private boolean useStrUid = false;

    public static void startForResult(Activity activity, ArrayList<Long> allList, int requestCode) {
        if (allList.isEmpty()) {
            return;
        }
        Intent intent = new Intent(activity, VELiveUserSelectActivity.class);
        intent.putExtra(ALL_LIST, allList);
        activity.startActivityForResult(intent, requestCode);
    }

    public static void startForStrResult(Activity activity, ArrayList<String> allStrList, int requestCode) {
        if (allStrList.isEmpty()) {
            return;
        }
        Intent intent = new Intent(activity, VELiveUserSelectActivity.class);
        intent.putExtra(ALL_STR_LIST, allStrList);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_user_select_layout);
        //以下不会同时传
        List<Long> allArray = (List<Long>) getIntent().getSerializableExtra(ALL_LIST);
        List<String> allStrArray = getIntent().getStringArrayListExtra(ALL_STR_LIST);
        recyclerView = findViewById(R.id.user_list);
        confirm = findViewById(R.id.tv_confirm);
        back = findViewById(R.id.back);
        back.setOnClickListener(this);
        confirm.setOnClickListener(this);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        if (allStrArray != null) {
            useStrUid = true;
            insertUserData(allStrArray);//字符串uid
        } else {
            useStrUid = false;
            initUserData(allArray); //数字uid
        }
    }

    private void initUserData(List<Long> uidList) {
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                adapter = new VELiveUserSelectAdapter(VELiveUserSelectActivity.this, bimuiUsers, isSinglePick(), isShowUid());
                recyclerView.setAdapter(adapter);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    private void insertUserData(List<String> uidStrList) {
        List<BIMUIUser> data = new ArrayList<>();
        for (String s : uidStrList) {
            BIMUIUser u = new BIMUIUser();
            u.setUidString(s);
            u.setNickName("用户" + s);
            data.add(u);
        }
        adapter = new VELiveUserSelectAdapter(VELiveUserSelectActivity.this, data, isSinglePick(), isShowUid());
        recyclerView.setAdapter(adapter);
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
            ArrayList<String> uidStrList = new ArrayList<>();
            ArrayList<Long> confirmList = new ArrayList<>();
            for (BIMUIUser user : result) {
                confirmList.add(user.getUid());
                uidList.add(user.getUid());
                uidStrList.add(user.getUidString());
            }
            if (!uidList.isEmpty() && !onConfirmClick(confirmList)) {
                Intent data = new Intent();
                if (useStrUid) {
                    data.putExtra(SELECT_RESULT, uidStrList);
                } else {
                    data.putExtra(SELECT_RESULT, uidList);
                }
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
