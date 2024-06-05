package com.bytedance.im.app.member.user;

import static com.bytedance.im.ui.starter.ModuleStarter.MODULE_KEY_TITLE;
import static com.bytedance.im.ui.starter.ModuleStarter.MODULE_KEY_UID_LIST_INVALID;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.user.adapter.VEUserHorizonAdapter;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.api.interfaces.BIMUserExistChecker;
import com.bytedance.im.ui.starter.ModuleStarter;

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
    private List<Long> invalidUidList;
    private TextView tvTitle;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        invalidUidList = (List<Long>) getIntent().getSerializableExtra(MODULE_KEY_UID_LIST_INVALID);
        String title = getIntent().getStringExtra(MODULE_KEY_TITLE);
        setContentView(R.layout.ve_im_activity_create_group);
        tvTitle = findViewById(R.id.tv_title);
        tvTitle.setText(title);
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
                //用户已经在群组
                if (checkMemberExist(uid)) {
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

                if (adapter.getUserIDList().contains(uid)) {
                    Toast.makeText(this, "群成员已添加", Toast.LENGTH_SHORT).show();
                    return;
                }
                //服务检查用户是否存在
                BIMUserExistChecker checker = BIMUIClient.getInstance().getUserExistChecker();
                if (checker != null) {
                    List<Long> uidList = new ArrayList<>();
                    uidList.add(uid);
                    checker.check(uidList, new BIMResultCallback<Map<Long, Boolean>>() {
                        @Override
                        public void onSuccess(Map<Long, Boolean> map) {
                            if (map.get(uid)) {
                                insertUser(uid);
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
                    insertUser(uid);
                }
            } catch (Exception e) {
                Toast.makeText(this, "请输入数字", Toast.LENGTH_SHORT).show();
            }
        });
        updateHorizonView();
    }

    protected void insertUserToSelected(long uid) {
        insertUser(uid);
    }

    private void insertUser(long uid) {
        if (adapter.getUserIDList().contains(uid)) {
            return;
        }
        BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(uid, new BIMResultCallback<BIMUIUser>() {
            @Override
            public void onSuccess(BIMUIUser user) {
                adapter.insertData(user);
                updateHorizonView();
                editText.setText("");
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
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

    protected void onConfirmClick(ArrayList<Long> uidList) {
        if (uidList == null || uidList.isEmpty()) {
            Toast.makeText(this, "请添加用户 id", Toast.LENGTH_SHORT).show();
            return;
        }
        hideKeyBoard(editText);
        Intent intent = new Intent();
        intent.putExtra(ModuleStarter.MODULE_KEY_UID_LIST, uidList);
        setResult(RESULT_OK, intent);
        finish();
    }

    protected boolean checkMemberExist(long uid) {
        if (invalidUidList != null && invalidUidList.contains(uid)) {
            if (uid == BIMUIClient.getInstance().getCurUserId()) {
                Toast.makeText(VEUserAddActivity.this, "您已在群聊中", Toast.LENGTH_SHORT).show();
            } else {
                Toast.makeText(VEUserAddActivity.this, "用户已在群", Toast.LENGTH_SHORT).show();
            }
            return true;
        }
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

    @Override
    public void onBackPressed() {
        hideKeyBoard(editText);
        super.onBackPressed();
    }

    @Override
    public void finish() {
        hideKeyBoard(editText);
        super.finish();
    }


    private void hideKeyBoard(EditText editText) {
        // 隐藏软键盘
        InputMethodManager imm = (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
    }
}
