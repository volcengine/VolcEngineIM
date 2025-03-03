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
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.live.R;
import com.bytedance.im.app.live.member.adapter.VELiveUserHorizonAdapter;
import com.bytedance.im.ui.api.BIMUIUser;

import java.util.ArrayList;
import java.util.List;

public class VELiveUserStringAddActivity extends Activity {
    private static final String TAG = "VECreateGroupActivity";
    public static String RESULT_UID_STR_LIST = "result_uid_str_list";
    public static String ACTION_TITLE = "action_title";
    private static final int REQUEST_CODE_REMOVE = 100;
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
        editText.setHint("请输入用户ID[字符串类型]");
        editText.setInputType(EditorInfo.TYPE_CLASS_TEXT);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(100)});
        tvAdd = findViewById(R.id.add);
        horizonLayout = findViewById(R.id.horizon_user_layout);
        tvUserCount = findViewById(R.id.user_count);
        findViewById(R.id.back).setOnClickListener(v -> finish());
        findViewById(R.id.tv_confirm).setOnClickListener(v -> {
            onConfirmClick(adapter.getUserStrIDList());
        });
        findViewById(R.id.iv_goto_member).setOnClickListener(v -> {
            VELiveUserSelectActivity.startForStrResult(this, adapter.getUserStrIDList(), REQUEST_CODE_REMOVE);
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
        tvAdd.setOnClickListener(v -> onAddClick());
        updateHorizonView();
    }

    protected void onAddClick() {
        String uidStr = editText.getText().toString();
        if (TextUtils.isEmpty(uidStr)) {
            Toast.makeText(this, "请输入uid", Toast.LENGTH_SHORT).show();
            return;
        }
        if (adapter.getItemCount() >= 20) {
            Toast.makeText(this, "已添加 20 个用户", Toast.LENGTH_SHORT).show();
            return;
        }
        if (adapter.getUserStrIDList().contains(uidStr)) {
            Toast.makeText(this, "群成员已添加", Toast.LENGTH_SHORT).show();
            return;
        }
        insertUidStr(uidStr);
    }

    private void insertUidStr(String uidStr) {
        if (adapter.getUserStrIDList().contains(uidStr)) {
            return;
        }
        BIMUIUser user = new BIMUIUser();
        user.setUidString(uidStr);
        user.setNickName("用户" + uidStr);
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

    protected void onConfirmClick(ArrayList<String> uidList) {
        hideKeyBoard(editText);
        if (!uidList.isEmpty()) {
            Intent intent = new Intent();
            intent.putExtra(RESULT_UID_STR_LIST, uidList);
            setResult(RESULT_OK, intent);
        }
        finish();
    }

    protected boolean checkMemberExist(long uid) {
        return false;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_CODE_REMOVE) {
            ArrayList<String> removedList = data.getStringArrayListExtra(VELiveUserSelectActivity.SELECT_RESULT);
            adapter.removeDataStr(removedList);
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
