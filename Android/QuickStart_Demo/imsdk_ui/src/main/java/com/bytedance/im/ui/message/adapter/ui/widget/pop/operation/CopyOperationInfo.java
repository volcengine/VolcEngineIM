package com.bytedance.im.ui.message.adapter.ui.widget.pop.operation;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.view.View;

import com.bytedance.im.ui.R;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.core.api.model.BIMMessage;

public class CopyOperationInfo extends OperationInfo {
    public CopyOperationInfo() {
        super(R.drawable.icon_msg_option_menu_copy, "复制");
    }

    @Override
    public void onClick(View v, BIMMessage bimMessage) {
        BaseCustomElementUI baseCustomElementUI = BIMMessageUIManager.getInstance().getMessageUI(bimMessage.getElement().getClass());
        ClipData mClipData = ClipData.newPlainText("Label", baseCustomElementUI.getCopy(bimMessage));
        ((ClipboardManager) v.getContext().getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(mClipData);
    }
}