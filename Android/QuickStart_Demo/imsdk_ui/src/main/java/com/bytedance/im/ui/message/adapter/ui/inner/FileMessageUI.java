package com.bytedance.im.ui.message.adapter.ui.inner;

import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMFileElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.adapter.ui.widget.custom.CircleProgressView;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;

import java.text.DecimalFormat;


@CustomUIType(contentCls = BIMFileElement.class)
public class FileMessageUI extends BaseCustomElementUI {


    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_file;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View itemView, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        View mFileContent = itemView.findViewById(R.id.cl_file_content);
        TextView mTvFileName = itemView.findViewById(R.id.tv_file_content);
        TextView mTvFileLength = itemView.findViewById(R.id.tv_file_size);
        CircleProgressView circleProgressView = itemView.findViewById(R.id.pv_circle_view);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        BIMFileElement fileElement = (BIMFileElement) bimMessage.getElement();
        boolean isSelf = bimMessage.isSelf();
        String mFileName = fileElement.getFileName();
        long fileLength = fileElement.getFileSize();
        BIMLog.e("FileMsg", "file name : " + mFileName + " file length: " + fileLength);
        if (!TextUtils.isEmpty(mFileName) && fileLength != 0) {
            mTvFileName.setText(mFileName);
            mTvFileLength.setText(getFileSizeDescription(fileLength));
            mTvFileName.setVisibility(View.VISIBLE);
            mTvFileLength.setVisibility(View.VISIBLE);
        }
        TextView tvUploadStatus = itemView.findViewById(R.id.tv_upload_status);
        if (!isSelf) {
            circleProgressView.setVisibility(View.GONE);
            tvUploadStatus.setVisibility(View.GONE);
            //do something
        } else {
            if (fileElement.getProgress() > 0 && (bimMessage.getMsgStatus() != BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS
                    || bimMessage.getMsgStatus() != BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL)) {
                circleProgressView.setVisibility(View.VISIBLE);
                tvUploadStatus.setVisibility(View.VISIBLE);
                circleProgressView.setProgress(fileElement.getProgress());
            } else {
                circleProgressView.setVisibility(View.GONE);
                tvUploadStatus.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        Toast.makeText(v.getContext(), "暂不支持文件预览", Toast.LENGTH_SHORT).show();
        return;
//        BIMFileElement fileElement = (BIMFileElement) messageWrapper.getBimMessage().getElement();
//        if (fileElement.isExpired()) {
//            holder.getOnOutListener().refreshMediaMessage(messageWrapper.getBimMessage(), new BIMResultCallback<BIMMessage>() {
//                @Override
//                public void onSuccess(BIMMessage bimMessage) {
//                    //todo download
//                }
//
//                @Override
//                public void onFailed(BIMErrorCode code) {
//
//                }
//            });
//        } else {
//            //todo download
//        }
    }

    public static String getFileSizeDescription(long size) {
        StringBuilder bytes = new StringBuilder();
        DecimalFormat format = new DecimalFormat("###.0");
        if (size >= 1024 * 1024 * 1024) {
            double i = (size / (1024.0 * 1024.0 * 1024.0));
            bytes.append(format.format(i)).append("GB");
        } else if (size >= 1024 * 1024) {
            double i = (size / (1024.0 * 1024.0));
            bytes.append(format.format(i)).append("MB");
        } else if (size >= 1024) {
            double i = (size / (1024.0));
            bytes.append(format.format(i)).append("KB");
        } else {
            if (size <= 0) {
                bytes.append("0B");
            } else {
                bytes.append((int) size).append("B");
            }
        }
        return bytes.toString();
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return bimMessage.isSelf() && bimMessage.getServerMsgId() > 0;
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return bimMessage.getServerMsgId() > 0;
    }
}
