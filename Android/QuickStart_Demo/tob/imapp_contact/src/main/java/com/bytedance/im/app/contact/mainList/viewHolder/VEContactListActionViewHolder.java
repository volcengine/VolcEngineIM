package com.bytedance.im.app.contact.mainList.viewHolder;

import androidx.annotation.NonNull;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.contact.R;
import com.bytedance.im.app.contact.mainList.item.ContactListActionItem;
import com.bytedance.im.app.contact.mainList.ContactListDataInfo;

public class VEContactListActionViewHolder extends VEContactListBaseViewHolder {
    private ImageView ivIcon;
    private TextView tvUnread;
    private TextView tvNickName;

    public VEContactListActionViewHolder(@NonNull View itemView) {
        super(itemView);

        ivIcon = itemView.findViewById(R.id.iv_head);
        tvUnread = itemView.findViewById(R.id.tv_unread_num);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
    }

    public void onBind(ContactListDataInfo<?> dataInfo, ContactListDataInfo<?> preData, boolean isOnline) {
        if (dataInfo.getData() instanceof ContactListActionItem) {
            ContactListActionItem contactListActionItem = (ContactListActionItem) dataInfo.getData();

            tvNickName.setText(contactListActionItem.getName());
            ivIcon.setImageResource(contactListActionItem.getIconResourceId());

            if (contactListActionItem.getUnreadCount() <= 0) {
                tvUnread.setVisibility(View.GONE);
            } else if (contactListActionItem.getUnreadCount() > 99) {
                tvUnread.setVisibility(View.VISIBLE);
                tvUnread.setText("99+");
            } else {
                tvUnread.setVisibility(View.VISIBLE);
                tvUnread.setText("" + contactListActionItem.getUnreadCount());
            }
        }
    }
}
