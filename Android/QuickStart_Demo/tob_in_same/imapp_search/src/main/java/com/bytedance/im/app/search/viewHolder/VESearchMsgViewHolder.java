package com.bytedance.im.app.search.viewHolder;

import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;
import com.bytedance.im.app.search.model.VESearchMsgInfo;
import com.bytedance.im.app.search.model.VESearchMsgWrapper;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.search.api.model.BIMSearchPosition;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

public class VESearchMsgViewHolder extends VESearchViewHolder<VESearchMsgWrapper> {
    private ImageView imageView;
    private TextView title;
    private TextView des;
    private TextView time;

    public VESearchMsgViewHolder(@NonNull View itemView) {
        super(itemView);
        imageView = itemView.findViewById(R.id.iv_conversation_user_img);
        title = itemView.findViewById(R.id.tv_title);
        des = itemView.findViewById(R.id.tv_desc);
        time = itemView.findViewById(R.id.tv_time);
    }

    @Override
    public void bind(VESearchMsgWrapper t) {
        super.bind(t);
        VESearchMsgInfo veSearchMsgInfo = t.getInfo();
        BIMUIUser user = veSearchMsgInfo.getUser();

        BIMSearchMsgInfo searchMsgInfo = veSearchMsgInfo.getSearchMsgInfo();
        BIMMessage bimMessage = searchMsgInfo.getMessage();
        BIMSearchDetail searchDetail = searchMsgInfo.getSearchDetail();
        String searchKey = searchDetail.getSearchKey();
        List<BIMSearchPosition> positionList = searchDetail.getKeyPositions();
        String searchContent = searchDetail.getSearchContent();
        SpannableString spannableString = new SpannableString(searchContent);
        for (BIMSearchPosition pos : positionList) {
            spannableString.setSpan(new ForegroundColorSpan(Color.GREEN), pos.getStart(), pos.getEnd(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        des.setText(spannableString);
        title.setText(BIMUINameUtils.getShowName(user));
        Glide.with(imageView.getContext()).load(user.getPortraitUrl())
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(imageView);
        time.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimMessage.getCreatedTime()));
        itemView.setOnClickListener(v -> {
            if (onSearchMsgClickListener != null) {
                onSearchMsgClickListener.onSearchMsgClick(searchMsgInfo);
            }
        });
    }
}
