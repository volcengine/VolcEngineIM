package com.bytedance.im.app.search.viewHolder;

import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

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

public class VESearchFileMsgViewHolder extends VESearchViewHolder<VESearchMsgWrapper> {

    public TextView tvTitle;
    public TextView tvDesc;
    public TextView tvTime;
    public TextView tvSize;


    public VESearchFileMsgViewHolder(@NonNull View itemView) {
        super(itemView);
        tvTitle = itemView.findViewById(R.id.tv_title);
        tvDesc = itemView.findViewById(R.id.tv_desc);
        tvTime = itemView.findViewById(R.id.tv_time);
        tvSize = itemView.findViewById(R.id.tv_file_size);
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
        tvTitle.setText(spannableString);
        tvDesc.setText(BIMUINameUtils.getShowName(user));
        tvTime.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimMessage.getCreatedTime()));
        tvSize.setText(getFileSize(fileElement.getFileSize()));
        itemView.setOnClickListener(v -> {
            if (onSearchMsgClickListener != null) {
                onSearchMsgClickListener.onSearchMsgClick(searchMsgInfo);
            }
        });
    }


    private String getFileSize(long length) {
        long fileKb = length / 1024;
        if (fileKb >= 1024) {
            return fileKb / 1024 + "MB";
        }
        return fileKb + "KB";
    }
}
