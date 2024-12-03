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
import com.bytedance.im.app.search.model.VESearchMsgWrapper;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMFileElement;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.search.api.model.BIMSearchPosition;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

/**
 * 文件item的另一种UI
 */
public class VESearchFileMsgViewHolder2 extends VESearchViewHolder<VESearchMsgWrapper> {

    public TextView tvTitle;
    public TextView tvDesc;
    public TextView tvTime;
    private ImageView imageView;


    public VESearchFileMsgViewHolder2(@NonNull View itemView) {
        super(itemView);
        imageView = itemView.findViewById(R.id.iv_conversation_user_img);
        tvTitle = itemView.findViewById(R.id.tv_title);
        tvDesc = itemView.findViewById(R.id.tv_desc);
        tvTime = itemView.findViewById(R.id.tv_time);
    }

    @Override
    public void bind(VESearchMsgWrapper veSearchMsgWrapper) {
        super.bind(veSearchMsgWrapper);
        BIMSearchMsgInfo searchMsgInfo = veSearchMsgWrapper.getInfo().getSearchMsgInfo();
        BIMMessage bimMessage = searchMsgInfo.getMessage();
        BIMUIUser user = veSearchMsgWrapper.getInfo().getUser();
        BIMFileElement fileElement = (BIMFileElement) bimMessage.getElement();
        BIMSearchDetail searchDetail = searchMsgInfo.getSearchDetail();
        List<BIMSearchPosition> positionList = searchDetail.getKeyPositions();
        String searchContent = searchDetail.getSearchContent();
        SpannableString spannableString = new SpannableString(searchContent);
        for (BIMSearchPosition pos : positionList) {
            spannableString.setSpan(new ForegroundColorSpan(Color.GREEN), pos.getStart(), pos.getEnd(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        }
        tvTitle.setText(BIMUINameUtils.getShowName(user));
        tvDesc.setText(spannableString);
        tvTime.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimMessage.getCreatedTime()));
        Glide.with(imageView.getContext()).load(user.getPortraitUrl())
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(imageView);
        itemView.setOnClickListener(v -> {
            if (onSearchMsgClickListener != null) {
                onSearchMsgClickListener.onSearchMsgClick(searchMsgInfo);
            }
        });
    }
}
