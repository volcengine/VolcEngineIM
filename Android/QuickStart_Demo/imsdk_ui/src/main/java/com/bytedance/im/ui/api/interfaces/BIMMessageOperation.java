package com.bytedance.im.ui.api.interfaces;

import android.app.Fragment;
import android.content.Intent;
import android.view.View;
import com.bytedance.im.core.api.model.BIMMessage;

public abstract class BIMMessageOperation {
    private int resId;
    private String name;
    protected Fragment veMessageListFragment;

    public void setVeMessageListFragment(Fragment veMessageListFragment) {
        this.veMessageListFragment = veMessageListFragment;
    }

    public BIMMessageOperation(int resId, String name) {
        this.resId = resId;
        this.name = name;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {

    }

    public int getResId() {
        return resId;
    }

    public String getName() {
        return name;
    }

    public abstract void onClick(View v, BIMMessage bimMessage);
}
