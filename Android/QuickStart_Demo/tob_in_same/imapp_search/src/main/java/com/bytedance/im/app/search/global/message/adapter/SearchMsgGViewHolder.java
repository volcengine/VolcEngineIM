package com.bytedance.im.app.search.global.message.adapter;

import android.graphics.Color;
import android.text.Spannable;
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
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMsgInConvInfo;
import com.bytedance.im.search.api.model.BIMSearchPosition;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.util.List;

public class SearchMsgGViewHolder extends RecyclerView.ViewHolder {
    private ImageView icon;
    private TextView title;
    private TextView time;
    private TextView detail;

    public SearchMsgGViewHolder(@NonNull View itemView) {
        super(itemView);
        icon = itemView.findViewById(R.id.icon);
        title = itemView.findViewById(R.id.tv_title);
        detail = itemView.findViewById(R.id.tv_desc);
        time = itemView.findViewById(R.id.tv_time);
    }

    public void update(SearchMsgGWrapper wrap) {
        BIMConversation bimConversation = wrap.getConversation();
        String name = "";
        if (bimConversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
            long oppositeUID = bimConversation.getOppositeUserID();
            BIMUIUser user = getBIMUIUSerOrAsyncRefresh(oppositeUID); //获取用户信息
            if (user == null) {
                return;
            }
            name = BIMUINameUtils.getShowName(user);
            if (!TextUtils.isEmpty(user.getPortraitUrl())) {
                Glide.with(icon.getContext()).load(user.getPortraitUrl())
                        .placeholder(com.bytedance.im.ui.R.drawable.icon_recommend_user_default)
                        .error(com.bytedance.im.ui.R.drawable.icon_recommend_user_default)
                        .into(icon);
            } else {
                icon.setImageResource(com.bytedance.im.ui.R.drawable.icon_recommend_user_default);
            }
        } else {
            if (!TextUtils.isEmpty(bimConversation.getName())) {
                name = bimConversation.getName();
            } else {
                name = "未命名群聊";
            }
            icon.setImageResource(com.bytedance.im.ui.R.drawable.default_icon_group);
        }
        title.setText(name);
        int textColor = com.bytedance.im.ui.R.color.business_im_222;
        if (bimConversation.isDissolved()) {
            textColor = com.bytedance.im.ui.R.color.business_im_999;
        }
        time.setTextColor(itemView.getContext().getResources().getColor(textColor));

        BIMSearchMsgInConvInfo info = wrap.getSearchInfo();

        if (info.getCount() > 1) {
            detail.setText(info.getCount() + " 条聊天记录");
        } else {
            BIMSearchDetail searchDetail = info.getMessageInfo().getSearchDetail();
            if (searchDetail != null) {
                List<BIMSearchPosition> positionList = searchDetail.getKeyPositions();
                String searchContent = searchDetail.getSearchContent();
                SpannableString spannableString = new SpannableString(searchContent);
                for (BIMSearchPosition pos : positionList) {
                    spannableString.setSpan(new ForegroundColorSpan(Color.GREEN), pos.getStart(), pos.getEnd(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
                }
                detail.setText(spannableString);
            } else {
                detail.setText(info.getCount() + " 条聊天记录");
            }
        }
    }

    private BIMUIUser getBIMUIUSerOrAsyncRefresh(long uid) {
        BIMUIUser user = BIMUIClient.getInstance().getUserProvider().getUserInfo(uid);
        if (user == null) {
            BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(uid, new BIMResultCallback<BIMUIUser>() {
                @Override
                public void onSuccess(BIMUIUser bimuiUser) {
                    ((RecyclerView) itemView.getParent()).getAdapter().notifyItemChanged(getAdapterPosition());
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        }
        return user;
    }

}
