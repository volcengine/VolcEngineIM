package com.bytedance.im.app.user;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.app.user.adapter.VEUserHorizonAdapter;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.interfaces.BIMUserExistChecker;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VEUserAddActivity extends Activity {
    private static final String TAG = "VECreateGroupActivity";
    private static final int REQUEST_CODE_REMOVE = 100;
    private RecyclerView recyclerView;
    private EditText editText;
    private TextView tvAdd;
    private List<BIMUIUser> data = new ArrayList<>();
    private VEUserHorizonAdapter adapter;
    private View horizonLayout;
    private TextView tvUserCount;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_create_conversation_group);
        recyclerView = findViewById(R.id.recycler_view_member);
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapter = new VEUserHorizonAdapter(this);
        recyclerView.setAdapter(adapter);
        editText = findViewById(R.id.edit);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        tvAdd = findViewById(R.id.add);
        horizonLayout = findViewById(R.id.horizon_user_layout);
        tvUserCount = findViewById(R.id.user_count);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        findViewById(R.id.tv_confirm).setOnClickListener(v -> {
            onConfirmClick(adapter.getUserIDList());
        });
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> {
            BIMUserSelectActivity.startForResult(this, adapter.getUserIDList(), REQUEST_CODE_REMOVE);
        });
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s == null || s.length() == 0) {
                    tvAdd.setVisibility(View.GONE);
                } else {
                    tvAdd.setVisibility(View.VISIBLE);
                }
            }
        });
        tvAdd.setOnClickListener(v -> {
            try {
                long uid = Long.parseLong(editText.getText().toString());
                BIMUIUser user = VEIMApplication.accountProvider.getUserProvider().getUserInfo(uid);
                //用户已经在群组
                if (checkMemberExist(user)) {
                    return;
                }

                if (BIMUIClient.getInstance().getCurUserId() == uid) {
                    Toast.makeText(VEUserAddActivity.this, "您已在群聊中", Toast.LENGTH_SHORT).show();
                    return;
                }

                if (adapter.getUserIDList().size() >= 20) {
                    Toast.makeText(this, "已添加 20 个用户", Toast.LENGTH_SHORT).show();
                    return;
                }

                if(adapter.getUserIDList().contains(uid)){
                    Toast.makeText(this, "群成员已添加", Toast.LENGTH_SHORT).show();
                    return;
                }
                //服务检查用户是否存在
                BIMUserExistChecker checker = VEIMApplication.accountProvider.createUserExistChecker();
                if (checker != null) {
                    List<Long> uidList = new ArrayList<>();
                    uidList.add(user.getUserID());
                    checker.check(uidList, new BIMResultCallback<Map<Long, Boolean>>() {
                        @Override
                        public void onSuccess(Map<Long, Boolean> map) {
                            if (map.get(user.getUserID())) {
                                insertUser(user);
                            } else {
                                Toast.makeText(VEUserAddActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
                            }
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VEUserAddActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
                        }
                    });
                } else {
                    insertUser(user);
                }
            } catch (Exception e) {
                Toast.makeText(this, "请输入数字", Toast.LENGTH_SHORT).show();
            }
        });
        updateHorizonView();
    }

    private void insertUser(BIMUIUser user) {
        if (adapter.getUserIDList().contains(user.getUserID())) {
            return;
        }
        adapter.insertData(user);
        updateHorizonView();
        editText.setText("");
    }

    private void updateHorizonView() {
        List<BIMUIUser> userList = adapter.getUserList();
        tvUserCount.setText(userList.size() + " 人");
        if (userList.isEmpty()) {
            horizonLayout.setVisibility(View.GONE);
        } else {
            horizonLayout.setVisibility(View.VISIBLE);
        }
    }

    protected void onConfirmClick(List<Long> uidList) {

    }

    protected boolean checkMemberExist(BIMUIUser user) {
        return false;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_REMOVE) {
            ArrayList<Long> removedList = (ArrayList<Long>) data.getSerializableExtra(BIMUserSelectActivity.SELECT_RESULT);
            adapter.removeData(removedList);
            updateHorizonView();
        }
    }
}
