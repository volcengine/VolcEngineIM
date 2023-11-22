package com.bytedance.im.ui.message.adapter.ui.widget.input.tools;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.bytedance.im.core.api.interfaces.BIMResultCallback;

public abstract class BaseToolBtn<T> {
    protected BIMResultCallback<T> resultCallback;

    public BaseToolBtn(BIMResultCallback<T> callback) {
        this.resultCallback = callback;
    }

    abstract public int getIcon(Context context);

    abstract public String getTitle(Context context);

    abstract public void onClick(Fragment fragment, View view);

    abstract public void onActivityResult(int requestCode, int resultCode, Intent data);
}
