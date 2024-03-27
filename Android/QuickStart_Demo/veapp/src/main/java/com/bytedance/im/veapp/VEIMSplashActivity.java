package com.bytedance.im.veapp;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;


public class VEIMSplashActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = new Intent();
        intent.setAction("com.bytedance.im.app.login.VELoginActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        startActivity(intent);
        finish();
    }
}
