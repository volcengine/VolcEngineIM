package com.bytedance.im.app.search.global.group.adapter;

import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.SearchUIUtils;
import com.bytedance.im.app.search.global.group.adapter.member.MemberDetailAdapter;
import com.bytedance.im.app.search.global.group.model.SearchGroupGWrapper;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchGroupInfo;
import com.bytedance.im.search.api.model.BIMSearchMemberInfo;

import java.util.List;

public class SearchGroupGViewHolder extends RecyclerView.ViewHolder {
    private ImageView icon;
    private TextView title;
    private RecyclerView descRev;
    private TextView userPrefix;

    public SearchGroupGViewHolder(@NonNull View itemView) {
        super(itemView);
        icon = itemView.findViewById(R.id.iv_conversation_img);
        title = itemView.findViewById(R.id.tv_title);
        descRev = itemView.findViewById(R.id.tv_desc);
        userPrefix = itemView.findViewById(R.id.user_prefix);
    }

    public void update(SearchGroupGWrapper info) {
        BIMConversation conv = info.getConversation();
        BIMSearchGroupInfo searchInfo = info.getSearchGroupInfo();
        Glide.with(icon.getContext()).load(conv.getPortraitURL())
                .placeholder(com.bytedance.im.ui.R.drawable.default_icon_group)
                .error(com.bytedance.im.ui.R.drawable.default_icon_group)
                .into(icon);
        BIMSearchDetail convNameSearchDetail = searchInfo.getNameDetail();
        BIMSearchDetail cidDetail = searchInfo.getCidDetail();
        if (convNameSearchDetail != null) {
            title.setText(SearchUIUtils.getSearchSpanString(convNameSearchDetail, convNameSearchDetail.getSearchContent()));
        } else {
            if (TextUtils.isEmpty(conv.getName())) {
                title.setText("未命名群聊");
            } else {
                title.setText(conv.getName());
            }
        }
        title.append("(" + conv.getMemberCount() + ")");
        List<BIMSearchMemberInfo> memberList = searchInfo.getMemberInfoList();
        if (memberList != null && !memberList.isEmpty()) {
            descRev.setVisibility(View.VISIBLE);
            descRev.setEnabled(false);
            descRev.setLayoutManager(new LinearLayoutManager(descRev.getContext(), LinearLayoutManager.HORIZONTAL, false));
            descRev.setAdapter(new MemberDetailAdapter(memberList));
            userPrefix.setVisibility(View.VISIBLE);
        } else {
            descRev.setVisibility(View.GONE);
            if(cidDetail!=null){
                userPrefix.setVisibility(View.VISIBLE);
                userPrefix.setText(SearchUIUtils.getSearchSpanString(cidDetail, cidDetail.getSearchContent()));

            }else {
                userPrefix.setVisibility(View.GONE);

            }

        }
    }
}
