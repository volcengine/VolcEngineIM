package com.bytedance.im.ui.message.adapter.ui.inner;

import android.graphics.drawable.Drawable;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMessageStatus;
import com.bytedance.im.core.api.interfaces.BIMDownloadCallback;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMImageElement;
import com.bytedance.im.core.model.inner.msg.image.BIMImage;
import com.bytedance.im.download.api.BIMDownloadExpandService;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.adapter.ui.widget.custom.CircleProgressView;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.utils.media.LoadIMageUtils;
import com.bytedance.im.ui.utils.media.PicturePreviewActivity;

import java.io.File;

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
            if (bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS
                    || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL
                    || bimMessage.getMsgStatus() == BIMMessageStatus.BIM_MESSAGE_STATUS_FAILED) {
                circleProgressView.setVisibility(View.GONE);
                tvUploadStatus.setVisibility(View.GONE);
            } else {
                circleProgressView.setVisibility(View.VISIBLE);
                circleProgressView.setOnClickListener(v -> {
                    BIMClient.getInstance().cancelMediaFileMessageUpload(bimMessage, null);
                });
                tvUploadStatus.setVisibility(View.VISIBLE);
                circleProgressView.setProgress(imageElement.getProgress());
            }
        } else {
            circleProgressView.setVisibility(View.GONE);
            tvUploadStatus.setVisibility(View.GONE);
        }
        ViewGroup.LayoutParams p = imgContent.getLayoutParams();
        BIMImage thumImg = imageElement.getThumbImg();
        if (thumImg != null) {
            p.width = thumImg.getWidth();
            p.height = thumImg.getHeight();
        } else {
            p.width = 200;
            p.height = 200;
        }

        imgContent.setLayoutParams(p);
        if (bimMessage.isSelf() && LoadIMageUtils.loadLocal(imageElement.getLocalPath(), imageElement.getLocalUri(),imgContent)) {
            BIMLog.i(TAG, "load use local path " + imageElement.getLocalPath() + " uri: " + imageElement.getLocalUri() + " uuid: " + bimMessage.getUuid());
            return;
        }
        Drawable placeDrawable = imgContent.getDrawable();
        try {
            BIMImage bimImage = imageElement.getThumbImg();
            if (thumImg != null) {
                String savePath = thumImg.getDownloadPath();
                String url = bimImage.getURL();
                if (bimMessage.getConversationType() != BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT) {
                    if (!new File(savePath).exists()) {
                        holder.getDownloadListener().downLoadMessage(bimMessage, bimImage.getURL(), false, null); //下载
                    } else {
                        Glide.with(imgContent.getContext()).load(savePath).dontAnimate().placeholder(placeDrawable).into(imgContent);   //加载本地文件
                    }
                } else {
                    Glide.with(imgContent.getContext())
                            .load(url)
                            .dontAnimate()
                            .placeholder(placeDrawable)
                            .listener(new RequestListener<Drawable>() {
                                @Override
                                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                                    holder.getOnOutListener().refreshMediaMessage(bimMessage, null);
                                    return true;
                                }

                                @Override
                                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                                    return false;
                                }
                            }).into(imgContent);
                }
            } else {
                imgContent.setImageResource(R.drawable.ic_default_imsdk_emoji_tab);
            }
        } catch (Exception e) {
            Log.i(TAG, "load image exception " + Log.getStackTraceString(e));
            imgContent.setImageResource(R.drawable.bg_record_input_button_normal);
        }
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        BIMImageElement imageElement = (BIMImageElement) messageWrapper.getBimMessage().getElement();
        BIMMessage bimMessage = messageWrapper.getBimMessage();

        if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT) {
            if (TextUtils.isEmpty(imageElement.getOriginImg().getURL())) {
                Toast.makeText(v.getContext(), "图片URL为空", Toast.LENGTH_SHORT).show();
                return;
            }
            holder.getOnOutListener().refreshMediaMessage(messageWrapper.getBimMessage(), new BIMResultCallback<BIMMessage>() {
                @Override
                public void onSuccess(BIMMessage bimMessage) {
                    PicturePreviewActivity.start(v.getContext(), imageElement.getOriginImg().getURL());
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        } else {
            String path = imageElement.getOriginImg().getDownloadPath();
            boolean hasLocalFile = new File(path).exists();
            if (hasLocalFile) {
                PicturePreviewActivity.start(v.getContext(), path);
            } else {
                if (bimMessage.isSelf() && !TextUtils.isEmpty(imageElement.getLocalPath())) {
                    PicturePreviewActivity.start(v.getContext(), imageElement.getLocalPath());
                } else {
                    BIMClient.getInstance().downloadFile(messageWrapper.getBimMessage(), imageElement.getOriginImg().getURL(), new BIMDownloadCallback() {
                        @Override
                        public void onSuccess(BIMMessage bimMessage) {
                            Toast.makeText(v.getContext(), "下载成功", Toast.LENGTH_SHORT).show();
                            PicturePreviewActivity.start(v.getContext(), path);
                        }

                        @Override
                        public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                            if (code == BIMErrorCode.BIM_DOWNLOAD_FILE_DUPLICATE) {
                                Toast.makeText(v.getContext(), "下载中", Toast.LENGTH_SHORT).show();
                            } else {
                                Toast.makeText(v.getContext(), "下载失败，请重试", Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                }
            }
        }
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
