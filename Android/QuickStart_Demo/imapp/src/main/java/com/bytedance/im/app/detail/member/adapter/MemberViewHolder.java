package com.bytedance.im.app.detail.member.adapter;

import android.graphics.Color;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.text.SpannableString;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.common.utility.Lists;
import com.bytedance.im.app.R;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.core.api.enums.BIMBlockStatus;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.model.BIMMember;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class MemberViewHolder extends RecyclerView.ViewHolder {

    private ImageView userHeadImg;
    private TextView nickName, tvOnline, tvMarks;
    protected ImageView ivSilent;
    private TextView tvTags;

    public MemberViewHolder(@NonNull View itemView) {
        super(itemView);
        userHeadImg = itemView.findViewById(R.id.iv_head);
        nickName = itemView.findViewById(R.id.tv_nick_name);
        ivSilent = itemView.findViewById(R.id.iv_silent);
        tvTags = itemView.findViewById(R.id.tv_tag_list);
        tvMarks = itemView.findViewById(R.id.tv_marks);
        tvOnline = itemView.findViewById(R.id.tv_online);
    }

    public void bind(MemberWrapper memberWrapper) {
        BIMMember member = memberWrapper.getMember();
        //名称
        nickName.setText(VENameUtils.getShowNameInGroup(memberWrapper));
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
        if (!Lists.isEmpty(member.getMarkTypes())) {
            List<String> markTypes = new ArrayList<>(member.getMarkTypes());
            Collections.sort(markTypes);
            for (String mark: markTypes) {
                marks += "[" + mark +"]";
            }
        }
        tvMarks.setText(marks);

        String onlineText = "";
        boolean showOnlineTag = memberWrapper.isShowOnline() &&(member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN || member.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER);
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
        Glide.with(userHeadImg.getContext()).load(VENameUtils.getPortraitUrl(memberWrapper))
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
