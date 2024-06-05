package com.bytedance.im.app.member.user;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
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
        setContentView(R.layout.ve_im_message_activity_user_select_layout);
        //以下不会同时传
        List<Long> allArray = (List<Long>) getIntent().getSerializableExtra(ALL_LIST);
        recyclerView = findViewById(R.id.user_list);
        confirm = findViewById(R.id.tv_confirm);
        back = findViewById(R.id.back);
        back.setOnClickListener(this);
        confirm.setOnClickListener(this);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        initUserData(allArray);
    }

    private void initUserData(List<Long> uidList){
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList,new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> userList) {
                adapter = new BIMUserSelectAdapter(BIMUserSelectActivity.this, userList, isSinglePick(), isShowUid());
                recyclerView.setAdapter(adapter);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
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
                confirmList.add(user.getUid());
                uidList.add(user.getUid());
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
