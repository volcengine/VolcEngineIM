package com.bytedance.im.ui.message.adapter.ui.widget.input.tools;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;

public class CustomToolBtn extends BaseToolBtn<Boolean> {

    public CustomToolBtn(BIMResultCallback<Boolean> callback) {
        super(callback);
    }

    @Override
    public int getIcon(Context context) {
        return R.drawable.icon_im_input_optional_img;
    }

    @Override
    public String getTitle(Context context) {
        return "自定义";
    }

    @Override
    public void onClick(Fragment fragment, View view, BIMConversation conversation) {
        resultCallback.onSuccess(true);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

    }

}
