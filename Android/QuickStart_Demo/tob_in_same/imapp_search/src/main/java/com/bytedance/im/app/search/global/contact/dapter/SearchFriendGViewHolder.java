package com.bytedance.im.app.search.global.contact.dapter;

import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.SearchUIUtils;
import com.bytedance.im.app.search.global.contact.model.SearchFriendGWrapper;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchFriendInfo;
import com.bytedance.im.search.api.model.BIMUserBaseInfo;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import org.w3c.dom.Text;

public class SearchFriendGViewHolder extends RecyclerView.ViewHolder {
    private ImageView imageView;
    private TextView title;
    private TextView tvDesc;
    private View tvDescPanel;

    public SearchFriendGViewHolder(@NonNull View itemView) {
        super(itemView);
        imageView = itemView.findViewById(R.id.iv_img);
        title = itemView.findViewById(R.id.tv_title);
        tvDesc = itemView.findViewById(R.id.tv_desc);
        tvDescPanel = itemView.findViewById(R.id.tv_desc_panel);
    }

    public void update(SearchFriendGWrapper wrapper) {
        BIMUserBaseInfo userInfo = wrapper.getUserInfo();
        BIMSearchFriendInfo friendInfo = wrapper.getBimSearchFriendInfo();
        Glide.with(imageView.getContext()).load(userInfo.getPortraitUrl())
                .placeholder(com.bytedance.im.ui.R.drawable.icon_recommend_user_default)
                .error(com.bytedance.im.ui.R.drawable.icon_recommend_user_default)
                .into(imageView);
        BIMSearchDetail nickNameSearchDetail = friendInfo.getNickNameDetail();
        BIMSearchDetail aliasNameSearchDetail = friendInfo.getFriendAliasDetail();
        BIMSearchDetail uidSearchDetail = friendInfo.getUidDetail();
        tvDescPanel.setVisibility(View.GONE);
        if (aliasNameSearchDetail != null) {
            title.setText(SearchUIUtils.getSearchSpanString(aliasNameSearchDetail, userInfo.getAliasName()));
        } else if (nickNameSearchDetail != null) {
            title.setText(SearchUIUtils.getSearchSpanString(nickNameSearchDetail, userInfo.getNickName()));
        } else if (uidSearchDetail != null) {
            if (!TextUtils.isEmpty(userInfo.getAliasName())) {
                title.setText(userInfo.getAliasName());
            } else if (!TextUtils.isEmpty(userInfo.getNickName())) {
                title.setText(userInfo.getNickName());
            } else {
                title.setText("用户" + userInfo.getUid());
            }
            tvDesc.setText(SearchUIUtils.getSearchSpanString(uidSearchDetail, userInfo.getNickName()));
            tvDescPanel.setVisibility(View.VISIBLE);
        }else {
            title.setText("用户" + userInfo.getUid());
        }
    }


}
