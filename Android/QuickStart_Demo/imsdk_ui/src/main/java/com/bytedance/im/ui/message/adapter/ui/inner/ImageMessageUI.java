package com.bytedance.im.ui.message.adapter.ui.inner;

import android.graphics.drawable.Drawable;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.internal.utils.IMLog;
import com.bytedance.im.core.model.inner.msg.BIMImageElement;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.adapter.ui.widget.custom.CircleProgressView;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.utils.media.LoadIMageUtils;
import com.bytedance.im.ui.utils.media.PicturePreviewActivity;

@CustomUIType(contentCls = BIMImageElement.class)
public class ImageMessageUI extends BaseCustomElementUI {
    private static final String TAG = "ImageMessageUI";
    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_image;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder, View itemView, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        BIMLog.i(TAG, "onBindView()");
        ImageView imgContent = itemView.findViewById(R.id.iv_msg_img_content);
        BIMMessage bimMessage = messageWrapper.getBimMessage();
        BIMImageElement imageElement = (BIMImageElement) bimMessage.getElement();
        CircleProgressView circleProgressView = itemView.findViewById(R.id.pv_circle_view);
        TextView tvUploadStatus = itemView.findViewById(R.id.tv_upload_status);
        if (bimMessage.isSelf()) {
            if (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL) {
                circleProgressView.setVisibility(View.GONE);
                tvUploadStatus.setVisibility(View.GONE);
            } else {
                circleProgressView.setVisibility(View.VISIBLE);
                tvUploadStatus.setVisibility(View.VISIBLE);
                circleProgressView.setProgress(imageElement.getProgress());
            }
        } else {
            circleProgressView.setVisibility(View.GONE);
            tvUploadStatus.setVisibility(View.GONE);
        }
        ViewGroup.LayoutParams p = imgContent.getLayoutParams();
        p.width = imageElement.getThumbImg().getWidth();
        p.height = imageElement.getThumbImg().getHeight();
        imgContent.setLayoutParams(p);
        if (bimMessage.isSelf() && LoadIMageUtils.loadLocal(imageElement.getLocalPath(), imgContent)) {
            BIMLog.i(TAG, "load use local path " + imageElement.getLocalPath() + " uuid: " + bimMessage.getUuid());
            return;
        }
        Drawable placeDrawable = imgContent.getDrawable();
        Glide.with(imgContent.getContext())
                .load(imageElement.getThumbImg().getURL())
                .dontAnimate()
                .placeholder(placeDrawable)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        holder.getOnOutListener().refreshMediaMessage(bimMessage,null);
                        return true;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        return false;
                    }
                }).into(imgContent);
    }

    @Override
    public boolean onLongClickListener(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        BIMImageElement imageElement = (BIMImageElement) messageWrapper.getBimMessage().getElement();
        holder.getOnOutListener().refreshMediaMessage(messageWrapper.getBimMessage(), new BIMResultCallback<BIMMessage>() {
            @Override
            public void onSuccess(BIMMessage bimMessage) {
                PicturePreviewActivity.start(v.getContext(), imageElement.getOriginImg().getURL());
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
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
