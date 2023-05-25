package com.bytedance.im.app.debug;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.login.VELoginActivity;
import com.bytedance.im.app.utils.VEUtils;

public class VEEnvSettingActivity extends Activity {

    private EditText etSwimlane;
    private RadioGroup mEnvGroup;
    private boolean resetLoginDelay = false;
    private View llSwimEdit;
    private TextView confirm;
    private int curEnv;

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
        curEnv = SpUtils.getInstance().getEnv();
        initEnvCheck();
        updateSwimLane();
        mEnvGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                if (checkedId == R.id.env_release) {
                    curEnv = Constants.ENV_RELEASE;
                } else if (checkedId == R.id.env_ppe) {
                    curEnv = Constants.ENV_PPE;
                } else if (checkedId == R.id.env_boe) {
                    curEnv = Constants.ENV_BOE;
                } else if (checkedId == R.id.env_boei18n) {
                    curEnv = Constants.ENV_BOEi18n;
                }
                updateSwimLane();
            }
        });
        confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SpUtils.getInstance().setEnv(curEnv);
                if (curEnv == Constants.ENV_BOE) {
                    SpUtils.getInstance().setBoeSwimLane(etSwimlane.getText().toString());
                } else if (curEnv == Constants.ENV_PPE) {
                    SpUtils.getInstance().setPPeSwimLane(etSwimlane.getText().toString());
                }
                VEUtils.reStarApp(VEEnvSettingActivity.this);
            }
        });
    }

    private void initEnvCheck() {
        if (curEnv == Constants.ENV_RELEASE) {
            mEnvGroup.check(R.id.env_release);
        } else if (curEnv == Constants.ENV_PPE) {
            mEnvGroup.check(R.id.env_ppe);
        } else if (curEnv == Constants.ENV_BOE) {
            mEnvGroup.check(R.id.env_boe);
        } else if (curEnv == Constants.ENV_BOEi18n) {
            mEnvGroup.check(R.id.env_boei18n);
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
}
