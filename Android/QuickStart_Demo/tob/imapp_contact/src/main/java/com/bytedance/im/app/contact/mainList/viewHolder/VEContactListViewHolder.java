package com.bytedance.im.app.contact.mainList.viewHolder;

import androidx.annotation.NonNull;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.contact.R;
import com.bytedance.im.app.contact.mainList.ContactListDataInfo;
import com.bytedance.im.app.contact.mainList.ContactListItemType;

import com.bytedance.im.app.contact.utils.ContactNameUtils;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

public class VEContactListViewHolder extends VEContactListBaseViewHolder {
    private static final String TAG = "VEContactListViewHolder";

    private ImageView ivIcon;
    private TextView tvNickName, tvContactTitle;

    public VEContactListViewHolder(@NonNull View itemView) {
        super(itemView);

        ivIcon = itemView.findViewById(R.id.iv_head);
        tvNickName = itemView.findViewById(R.id.tv_nick_name);
        tvContactTitle = itemView.findViewById(R.id.tv_contact_title);
    }

    public void onBind(ContactListDataInfo<?> dataInfo, ContactListDataInfo<?> preData) {
        if (dataInfo.getData() instanceof BIMUserFullInfo) {
            BIMUserFullInfo fullInfo = (BIMUserFullInfo) dataInfo.getData();

            tvNickName.setText(ContactNameUtils.getShowName(fullInfo));
            ivIcon.setImageResource(R.drawable.icon_recommend_user_default);
            Glide.with(ivIcon.getContext())
                    .load(fullInfo.getPortraitUrl())
                    .placeholder(R.drawable.icon_recommend_user_default)
                    .error(R.drawable.icon_recommend_user_default).into(ivIcon);
            if (preData == null || preData.getType() != ContactListItemType.TYPE_CONTACT || dataInfo.getFirstChar() != preData.getFirstChar()) {
                Log.d(TAG, "first char is " + dataInfo.getFirstChar());
                tvContactTitle.setVisibility(View.VISIBLE);
                tvContactTitle.setText("" + dataInfo.getFirstChar());
            } else {
                tvContactTitle.setVisibility(View.GONE);
            }
        }
    }
}
