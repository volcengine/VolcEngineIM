package com.bytedance.im.app.search.viewHolder;

import android.graphics.Color;
import androidx.annotation.NonNull;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.search.data.VESearchMsgInfo;
import com.bytedance.im.app.search.data.VESearchMsgWrapper;
import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;
import com.bytedance.im.app.utils.VENameUtils;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.search.api.model.BIMSearchPosition;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

public class VESearchMsgViewHolder extends VESearchViewHolder<VESearchMsgWrapper> {
    private ImageView imageView;
    private TextView title;
    private TextView des;
    private TextView time;
    private OnSearchMsgClickListener listener;


    public VESearchMsgViewHolder(@NonNull View itemView) {
        super(itemView);
        imageView = itemView.findViewById(R.id.iv_conversation_user_img);
        title = itemView.findViewById(R.id.tv_title);
        des = itemView.findViewById(R.id.tv_desc);
        time = itemView.findViewById(R.id.tv_time);
    }

    public void setListener(OnSearchMsgClickListener listener) {
        this.listener = listener;
    }

    @Override
    public void bind(VESearchMsgWrapper t) {
        super.bind(t);
        VESearchMsgInfo veSearchMsgInfo = t.getInfo();
        BIMUserFullInfo userFullInfo = veSearchMsgInfo.getUserFullInfo();
        BIMSearchMsgInfo searchMsgInfo = veSearchMsgInfo.getSearchMsgInfo();
        BIMSearchDetail searchDetail = searchMsgInfo.getSearchDetail();
        String searchKey = searchDetail.getSearchKey();
        List<BIMSearchPosition> positionList = searchDetail.getKeyPositions();
        String searchContent = searchDetail.getSearchContent();
        BIMMessage bimMessage = searchMsgInfo.getMessage();
        SpannableString spannableString = new SpannableString(searchContent);
        for (BIMSearchPosition pos : positionList) {
            spannableString.setSpan(new ForegroundColorSpan(Color.GREEN), pos.getStart(), pos.getEnd(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        des.setText(spannableString);
        title.setText(VENameUtils.getShowName(userFullInfo));
        itemView.setOnClickListener(v -> {
            if (listener != null) {
                listener.onSearchMsgClick(searchMsgInfo);
            }
        });
        Glide.with(imageView.getContext()).load(userFullInfo.getPortraitUrl())
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(imageView);
        time.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimMessage.getCreatedTime()));
    }
}
