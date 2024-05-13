package com.bytedance.im.app.contact.mainList.viewHolder;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.bytedance.im.app.contact.mainList.ContactListDataInfo;

public class VEContactListBaseViewHolder extends RecyclerView.ViewHolder {
    public VEContactListBaseViewHolder(@NonNull View itemView) {
        super(itemView);
    }
    public void onBind(ContactListDataInfo<?> data, ContactListDataInfo<?> preData) {}
}
