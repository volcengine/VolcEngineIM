package com.bytedance.im.ui.api.interfaces;

import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;

import java.util.List;

public interface BIMFilterToolBtnInterceptor {
    List<BaseToolBtn> onFilterToolBtn(List<BaseToolBtn> toolBtnList);
}
