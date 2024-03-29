package com.bytedance.im.app.create;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.InputFilter;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.message.VEMessageListActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.interfaces.BIMUserExistChecker;
import com.bytedance.im.ui.BIMUIClient;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VECreateSingleActivity extends Activity {
    private static final String TAG = "VECreateSingleConversationActivity";
    private EditText editText;

    public static void start(Context context) {
        Intent intent = new Intent(context, VECreateSingleActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_create_conversaiton_single);
        editText = findViewById(R.id.edit);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        findViewById(R.id.back).setOnClickListener(v -> finish());
        TextView tvConfirm = findViewById(R.id.tv_confirm);
        tvConfirm.setOnClickListener(v -> {
            try {
                if (editText.getText() == null || editText.getText().length() == 0) {
                    Toast.makeText(VECreateSingleActivity.this, "请输入用户ID", Toast.LENGTH_SHORT).show();
                    return;
                }
                long uid = Long.parseLong(editText.getText().toString());
                BIMUserExistChecker checker = Constants.accountProvider.createUserExistChecker();
                List<Long> uidList = new ArrayList<>();
                uidList.add(uid);
                checker.check(uidList, new BIMResultCallback<Map<Long, Boolean>>() {
                    @Override
                    public void onSuccess(Map<Long, Boolean> longBooleanMap) {
                        if (longBooleanMap.get(uid)) {
                            createSingleConversationAndStart(uid);
                        } else {
                            Toast.makeText(VECreateSingleActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
                        }
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {

                    }
                });
            } catch (Exception e) {
                Toast.makeText(this, "请输入数字", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void createSingleConversationAndStart(Long uid) {
        BIMUIClient.getInstance().createSingleConversation(uid, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation bimConversation) {
                VEMessageListActivity.start(VECreateSingleActivity.this, bimConversation.getConversationID());
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VECreateSingleActivity.this, "创建单聊失败 code: " + code, Toast.LENGTH_SHORT).show();
            }
        });
    }
}
