package com.bytedance.im.app.member.user;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.im.app.member.R;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.interfaces.BIMUserExistChecker;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class VESelectSingleActivity extends Activity {
    private static final String TAG = "VECreateSingleConversationActivity";
    private EditText editText;

    public static void start(Context context) {
        Intent intent = new Intent(context, VESelectSingleActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_create_select_single);
        editText = findViewById(R.id.edit);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        findViewById(R.id.back).setOnClickListener(v -> finish());
        TextView tvConfirm = findViewById(R.id.tv_confirm);
        tvConfirm.setOnClickListener(v -> {
            try {
                if (editText.getText() == null || editText.getText().length() == 0) {
                    Toast.makeText(VESelectSingleActivity.this, "请输入用户ID", Toast.LENGTH_SHORT).show();
                    return;
                }
                long uid = Long.parseLong(editText.getText().toString());
                BIMUserExistChecker checker = BIMUIClient.getInstance().getUserExistChecker();
                List<Long> uidList = new ArrayList<>();
                uidList.add(uid);
                checker.check(uidList, new BIMResultCallback<Map<Long, Boolean>>() {
                    @Override
                    public void onSuccess(Map<Long, Boolean> longBooleanMap) {
                        if (longBooleanMap.get(uid)!=null && true == longBooleanMap.get(uid)) {
                            Intent intent  = new Intent();
                            intent.putExtra(ModuleStarter.MODULE_KEY_UID, uid);
                            setResult(RESULT_OK,intent);
                            finish();
                        } else {
                            Toast.makeText(VESelectSingleActivity.this, "该用户不存在", Toast.LENGTH_SHORT).show();
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
}
