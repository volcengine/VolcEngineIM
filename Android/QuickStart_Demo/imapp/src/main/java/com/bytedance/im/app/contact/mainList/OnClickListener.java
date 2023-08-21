package com.bytedance.im.app.contact.mainList;

import android.view.View;

public interface OnClickListener{
    void onClick(View v, ContactListDataInfo<?> data);
    void onLongClick(View v, ContactListDataInfo<?> data);
}