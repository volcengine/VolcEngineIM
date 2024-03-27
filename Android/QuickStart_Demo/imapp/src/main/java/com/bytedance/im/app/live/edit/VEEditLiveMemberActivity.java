package com.bytedance.im.app.live.edit;

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;

import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.user.VEUserAddActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.interfaces.BIMUserExistChecker;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VEEditLiveMemberActivity extends VEUserAddActivity {
    public static final String RESULT_IDS = "result_ids";

    private TextView tvTitle;
    private EditText editText;
    private TextView tvAdd;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        tvTitle = findViewById(R.id.tv_title);
        tvTitle.setText("添加用户");

        tvAdd = findViewById(R.id.add);
        editText = findViewById(R.id.edit);
        tvAdd.setOnClickListener(v -> {
            try {
                long uid = Long.parseLong(editText.getText().toString());

                //服务检查用户是否存在
                BIMUserExistChecker checker = Constants.accountProvider.createUserExistChecker();
                if (checker != null) {
                    List<Long> uidList = new ArrayList<>();
                    uidList.add(uid);
                    checker.check(uidList, new BIMResultCallback<Map<Long, Boolean>>() {
                        @Override
                        public void onSuccess(Map<Long, Boolean> map) {
                            if (map.get(uid)) {
                                insertUserToSelected(uid);
                            } else {
                                Toast.makeText(VEEditLiveMemberActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
                            }
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VEEditLiveMemberActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
                        }
                    });
                } else {
                    insertUserToSelected(uid);
                }
            } catch (Exception e) {
                Toast.makeText(this, "请输入数字", Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    protected void onConfirmClick(List<Long> uidList) {
        super.onConfirmClick(uidList);

        Intent intent = new Intent();
        long[] result = new long[uidList.size()];

        for (int i = 0; i < uidList.size(); i++) {
            result[i] = uidList.get(i);
        }

        intent.putExtra(RESULT_IDS, result);
        setResult(RESULT_OK, intent);
        finish();
    }
}
