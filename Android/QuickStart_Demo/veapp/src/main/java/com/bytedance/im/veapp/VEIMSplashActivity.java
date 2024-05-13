package com.bytedance.im.veapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.bytedance.im.core.api.BIMClient;


public class VEIMSplashActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (BIMClient.getInstance().isToB()) {
            startToBDemo();
        } else {
            startToINDemo();
        }
        finish();
    }

    /**
     * tob 业务
     */
    private void startToBDemo() {
        Intent intent = new Intent();
        intent.setAction("com.bytedance.im.app.in.login.VELoginActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        startActivity(intent);
    }

    /**
     * 内部 业务
     */
    private void startToINDemo() {
        Intent intent = new Intent();
        intent.setAction("com.bytedance.im.app.in.login.IMINLoginActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        startActivity(intent);
    }
}
