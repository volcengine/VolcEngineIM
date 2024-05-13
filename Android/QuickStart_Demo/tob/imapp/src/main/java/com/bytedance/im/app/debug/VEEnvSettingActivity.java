package com.bytedance.im.app.debug;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.View;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.Switch;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.utils.VEUtils;

public class VEEnvSettingActivity extends Activity {

    private EditText etSwimlane;
    private RadioGroup mEnvGroup;
    private boolean resetLoginDelay = false;
    private View llSwimEdit;
    private TextView confirm;
    private int curEnv;
    private Switch swALog;
    private Switch swAPM;


    public static void start(Context context) {
        Intent intent = new Intent(context, VEEnvSettingActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_env_config_setting);
        findViewById(R.id.iv_common_back).setOnClickListener(v -> finish());
        ((TextView) findViewById(R.id.tv_common_head_title)).setText("配置IM");
        llSwimEdit = findViewById(R.id.ll_change_swim_lane);
        confirm = findViewById(R.id.confirm);
        etSwimlane = findViewById(R.id.et_swim_lane);
        mEnvGroup = findViewById(R.id.env_group);
        swALog = findViewById(R.id.sw_event);
        swAPM = findViewById(R.id.sw_local_log);
        curEnv = SpUtils.getInstance().getEnv();
        initEnvCheck();
        updateSwimLane();
        updateModuleSwitch();
        mEnvGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                if (checkedId == R.id.env_release) {
                    curEnv = Constants.ENV_RELEASE;
                } else if (checkedId == R.id.env_boe) {
                    curEnv = Constants.ENV_BOE;
                } else if (checkedId == R.id.env_boei18n) {
                    curEnv = Constants.ENV_BOEi18n;
                } else if (checkedId == R.id.env_i18n) {
                    curEnv = Constants.ENV_i18n;
                }
                updateSwimLane();
            }
        });
        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveEnv();
                saveModuleSwitch();
                VEUtils.reStarApp(VEEnvSettingActivity.this);
            }
        });
    }

    private void initEnvCheck() {
        if (curEnv == Constants.ENV_RELEASE) {
            mEnvGroup.check(R.id.env_release);
        } else if (curEnv == Constants.ENV_BOE) {
            mEnvGroup.check(R.id.env_boe);
        } else if (curEnv == Constants.ENV_BOEi18n) {
            mEnvGroup.check(R.id.env_boei18n);
        } else if (curEnv == Constants.ENV_i18n) {
            mEnvGroup.check(R.id.env_i18n);
        }
    }

    private void saveEnv() {
        SpUtils.getInstance().setEnv(curEnv);
        if (curEnv == Constants.ENV_BOE) {
            SpUtils.getInstance().setBoeSwimLane(etSwimlane.getText().toString());
        } else if (curEnv == Constants.ENV_PPE) {
            SpUtils.getInstance().setPPeSwimLane(etSwimlane.getText().toString());
        }
    }

    private void updateSwimLane() {
        llSwimEdit.setVisibility(View.VISIBLE);
        if (curEnv == Constants.ENV_PPE) {
            String ppeSwim = SpUtils.getInstance().getPpeSwimLane();
            etSwimlane.setText(ppeSwim);
        } else if (curEnv == Constants.ENV_BOE) {
            String boeSwim = SpUtils.getInstance().getBoeSwimLane();
            etSwimlane.setText(boeSwim);
        } else {
            llSwimEdit.setVisibility(TextView.GONE);
        }
    }

    private void updateModuleSwitch() {
        swALog.setChecked(SpUtils.getInstance().isEnableALog());
        swAPM.setChecked(SpUtils.getInstance().isEnableAPM());
    }
    private void saveModuleSwitch() {
        SpUtils.getInstance().setEnableALog(swALog.isChecked());
        SpUtils.getInstance().setEnableAPM(swAPM.isChecked());
    }
}
