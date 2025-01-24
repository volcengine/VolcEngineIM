package com.bytedance.im.app.search.global.member.adapter;

import android.graphics.Color;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.SearchUIUtils;
import com.bytedance.im.app.search.global.member.model.SearchConvMeGWrapper;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMemberInfo;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SearchConvMemberViewHolder extends RecyclerView.ViewHolder {
    private ImageView userHeadImg;
    private TextView nickName, tvOnline, tvMarks;
    protected ImageView ivSilent;
    private TextView tvTags;

    public SearchConvMemberViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);
        ivSilent = itemView.findViewById(R.id.iv_silent);
        tvTags = itemView.findViewById(R.id.tv_tag_list);
        tvMarks = itemView.findViewById(R.id.tv_marks);
        tvOnline = itemView.findViewById(R.id.tv_online);
    }

    public void bind(SearchConvMeGWrapper memberWrapper) {
        BIMSearchMemberInfo searchMemberInfo = memberWrapper.getSearchMemberInfo();
        BIMUIUser user = memberWrapper.getUser();
        BIMMember member = searchMemberInfo.getMember();
        BIMSearchDetail friendAliasDetail = searchMemberInfo.getFriendAliasDetail();
        BIMSearchDetail memberAliasDetail = searchMemberInfo.getMemberAliasDetail();
        BIMSearchDetail nickNameDetail = searchMemberInfo.getNickNameDetail();
        BIMSearchDetail uidNameDetail = searchMemberInfo.getUidDetail();
        SpannableString name = null;
         if (memberAliasDetail != null) {
            name = SearchUIUtils.getSearchSpanString(memberAliasDetail, memberAliasDetail.getSearchContent());
        } else if (friendAliasDetail != null) {
            name = SearchUIUtils.getSearchSpanString(friendAliasDetail, friendAliasDetail.getSearchContent());
        } else if (nickNameDetail != null) {
            name = SearchUIUtils.getSearchSpanString(nickNameDetail, nickNameDetail.getSearchContent());
        } else if (uidNameDetail != null) {
            name = SearchUIUtils.getSearchSpanString(uidNameDetail, uidNameDetail.getSearchContent());
        } else {
            name = new SpannableString("用户" + user.getUid());
        }
        //名称
        nickName.setText(name);
        String tags = "";
        if (memberWrapper.isShowTag()) {
            if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
                tags += "[群主]";
            } else if (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
                tags += "[管理员]";
            }
        }
        tvTags.setText(tags);

        String marks = "";
        if (member.getMarkTypes() != null && !member.getMarkTypes().isEmpty()) {
            List<String> markTypes = new ArrayList<>(member.getMarkTypes());
            Collections.sort(markTypes);
            for (String mark : markTypes) {
                marks += "[" + mark + "]";
            }
        }
        tvMarks.setText(marks);

        String onlineText = "";
        boolean showOnlineTag = memberWrapper.isShowOnline() && (member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
        if (showOnlineTag) {
            if (member.isOnline()) {
                onlineText += " 在线";
            } else {
                onlineText += " 离线";
            }
        }

        SpannableString nameSpannableStr = new SpannableString(onlineText);
        if (showOnlineTag && nameSpannableStr.length() >= 2) {
            nameSpannableStr.setSpan(new ForegroundColorSpan(Color.LTGRAY), nameSpannableStr.length() - 2, nameSpannableStr.length(), 0);
        }
        tvOnline.setText(nameSpannableStr);
        if (TextUtils.isEmpty(tags)) {
            tvTags.setVisibility(View.GONE);
        } else {
            tvTags.setVisibility(View.VISIBLE);
            tvTags.setText(tags);
        }
        //头像
        Glide.with(userHeadImg.getContext()).load(BIMUINameUtils.getPortraitUrl(member, memberWrapper.getUser()))
                .dontAnimate()
                .error(R.drawable.icon_recommend_user_default)
                .placeholder(R.drawable.icon_recommend_user_default)
                .into(userHeadImg);

        //禁言标签
        if (memberWrapper.isShowSilent()) {
            if (member.getSilentStatus() == BIMBlockStatus.BIM_BLOCK_STATUS_BLOCK) {
                ivSilent.setVisibility(View.VISIBLE);
            } else {
                ivSilent.setVisibility(View.GONE);
            }
        } else {
            ivSilent.setVisibility(View.GONE);
        }
    }
}
