package com.bytedance.im.app.contact.mainList.viewHolder;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.bytedance.im.app.contact.mainList.ContactListDataInfo;

public class VEContactListBaseViewHolder extends RecyclerView.ViewHolder {
    public VEContactListBaseViewHolder(@NonNull View itemView) {
        super(itemView);
    }
    public void onBind(ContactListDataInfo<?> data, ContactListDataInfo<?> preData) {}
}
