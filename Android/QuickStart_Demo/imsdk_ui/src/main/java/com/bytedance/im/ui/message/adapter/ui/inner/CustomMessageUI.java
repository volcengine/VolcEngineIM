package com.bytedance.im.ui.message.adapter.ui.inner;

import android.view.View;

import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;

public class CustomMessageUI extends BaseCustomElementUI {
    @Override
    public int getLayoutId() {
        return 0;
    }

    @Override
    public void onBindView(View v, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {

    }

    @Override
    public boolean onLongClickListener(View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(View v, BIMMessageWrapper messageWrapper) {

    }
}
