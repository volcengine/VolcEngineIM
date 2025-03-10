package com.bytedance.im.app.live.member;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.member.adapter.VELiveUserHorizonAdapter;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.api.interfaces.BIMUserExistChecker;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VELiveUserAddActivity extends Activity {
    private static final String TAG = "VECreateGroupActivity";
    private static final int REQUEST_CODE_REMOVE = 100;
    public static String ACTION_TITLE = "action_title";
    public static final String RESULT_IDS = "result_ids";
    private RecyclerView recyclerView;
    private EditText editText;
    private TextView tvAdd;
    private List<BIMUIUser> data = new ArrayList<>();
    private VELiveUserHorizonAdapter adapter;
    private View horizonLayout;
    private TextView tvUserCount;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_live_activity_create_conversation_group);
        String title = getIntent().getStringExtra(ACTION_TITLE);
        if (!TextUtils.isEmpty(title)) {
            TextView tvTitle = findViewById(R.id.tv_title);
            tvTitle.setText(title);
        }
        recyclerView = findViewById(R.id.recycler_view_member);
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        adapter = new VELiveUserHorizonAdapter(this);
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
            VELiveUserSelectActivity.startForResult(this, adapter.getUserIDList(), REQUEST_CODE_REMOVE);
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

//                if (BIMUIClient.getInstance().getCurUserId() == uid) {
//                    Toast.makeText(VELiveUserAddActivity.this, "您已在群聊中", Toast.LENGTH_SHORT).show();
//                    return;
//                }

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
                                Toast.makeText(VELiveUserAddActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
                            }
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VELiveUserAddActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
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

    protected void onConfirmClick(List<Long> uidList) {
        hideKeyBoard(editText);
        Intent intent = new Intent();
        long[] result = new long[uidList.size()];

        for (int i = 0; i < uidList.size(); i++) {
            result[i] = uidList.get(i);
        }

        intent.putExtra(RESULT_IDS, result);
        setResult(RESULT_OK, intent);
        finish();

    }

    protected boolean checkMemberExist(long uid) {
        return false;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_REMOVE) {
            ArrayList<Long> removedList = (ArrayList<Long>) data.getSerializableExtra(VELiveUserSelectActivity.SELECT_RESULT);
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
