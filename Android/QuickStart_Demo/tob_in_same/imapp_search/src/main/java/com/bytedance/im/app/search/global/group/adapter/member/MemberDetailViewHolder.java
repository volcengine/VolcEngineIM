package com.bytedance.im.app.search.global.group.adapter.member;

import android.text.SpannableString;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.SearchUIUtils;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMemberInfo;

public class MemberDetailViewHolder extends RecyclerView.ViewHolder {
    private TextView textView;

    public MemberDetailViewHolder(@NonNull View itemView) {
        super(itemView);
        textView = itemView.findViewById(R.id.detail);
    }

    public void update(BIMSearchMemberInfo searchMemberInfo) {
        BIMMember member = searchMemberInfo.getMember();
        BIMSearchDetail memberAliasDetail = searchMemberInfo.getMemberAliasDetail();
        BIMSearchDetail aliasDetail = searchMemberInfo.getFriendAliasDetail();
        BIMSearchDetail nickDetail = searchMemberInfo.getNickNameDetail();
        BIMSearchDetail uidDetail = searchMemberInfo.getUidDetail();
        SpannableString spannableString = null;
        if (memberAliasDetail != null) {
            spannableString = SearchUIUtils.getSearchSpanString(memberAliasDetail, memberAliasDetail.getSearchContent());
        } else if (aliasDetail != null) {
            spannableString = SearchUIUtils.getSearchSpanString(aliasDetail, aliasDetail.getSearchContent());
        } else if (nickDetail != null) {
            spannableString = SearchUIUtils.getSearchSpanString(nickDetail, nickDetail.getSearchContent());
        } else if (uidDetail != null) {
            spannableString = SearchUIUtils.getSearchSpanString(uidDetail, uidDetail.getSearchContent());
        } else {
            spannableString = new SpannableString(""+member.getUserID());
        }
        textView.setText(spannableString);
    }
}
