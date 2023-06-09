package com.bytedance.im.ui.message.adapter.ui.inner;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.support.annotation.Nullable;
import android.text.TextUtils;
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
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.adapter.ui.widget.custom.CircleProgressView;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMVideoElement;
import com.bytedance.im.ui.utils.BIMUIUtils;
import com.bytedance.im.ui.utils.media.LoadIMageUtils;

@CustomUIType(contentCls = BIMVideoElement.class)
public class VideoMessageUI extends BaseCustomElementUI {
    private static final String TAG = "VideoMessageUI";

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_video;
    }

    @Override
    public void onBindView(View itemView, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        ImageView videoCover = itemView.findViewById(R.id.iv_video_cover);
        ImageView videoPlayIcon = itemView.findViewById(R.id.iv_play);
        TextView tvUploadStatus = itemView.findViewById(R.id.tv_upload_status);
        BIMMessage msg = messageWrapper.getBimMessage();
        videoCover.setImageResource(R.drawable.icon_im_placehodler);
        BIMVideoElement videoElement = (BIMVideoElement) msg.getElement();
        if (msg.isSelf()) {
            CircleProgressView circleProgressView = itemView.findViewById(R.id.pv_circle_view);
            Log.i("qinxue","progress: "+videoElement.getProgress());
            if (videoElement.getProgress() > 0 && (msg.getMsgStatus() != BIMMessageStatus.BIM_MESSAGE_STATUS_SUCCESS
                    || msg.getMsgStatus() != BIMMessageStatus.BIM_MESSAGE_STATUS_NORMAL)) {
                circleProgressView.setVisibility(View.VISIBLE);
                circleProgressView.setProgress(videoElement.getProgress());
                tvUploadStatus.setVisibility(View.VISIBLE);
                videoPlayIcon.setVisibility(View.GONE);
            } else {
                circleProgressView.setVisibility(View.GONE);
                tvUploadStatus.setVisibility(View.GONE);
                videoPlayIcon.setVisibility(View.VISIBLE);
            }
        }

        int width = videoElement.getCoverImg().getWidth();
        int height = videoElement.getCoverImg().getHeight();
        int maxWidth = BIMUIUtils.dpToPx(itemView.getContext(),120);
        ViewGroup.LayoutParams p = videoCover.getLayoutParams();
        if (width > 0 & height > 0) {
            p.width = width;
            p.height = height;
            if (width > 0 && width > maxWidth) {
                p.width = maxWidth;
                p.height = height * maxWidth / width;
            }
        } else {
            p.width = 300;
            p.height = 300;
        }
        videoCover.setLayoutParams(p);
        if (msg.isSelf() && LoadIMageUtils.loadLocal(videoElement.getLocalPath(), videoCover)) {
            return;
        }
        showRemote(videoCover, msg);
    }

    @Override
    public boolean onLongClickListener(View v, BIMMessageWrapper messageWrapper) {
        return false;
    }

    @Override
    public void onClick(View v, BIMMessageWrapper messageWrapper) {
        BIMVideoElement videoElement = (BIMVideoElement) messageWrapper.getBimMessage().getElement();
        if (messageWrapper.getBimMessage().isSelf() && !TextUtils.isEmpty(videoElement.getLocalPath())) {
            startPlay(v.getContext(), videoElement.getLocalPath());
        } else {
            if (videoElement.isExpired()) {
                BIMClient.getInstance().refreshMediaMessage(messageWrapper.getBimMessage(), new BIMResultCallback<BIMMessage>() {
                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        startPlay(v.getContext(),videoElement.getURL());
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {

                    }
                });
            } else {
                startPlay(v.getContext(), videoElement.getURL());
            }
        }
    }


    private void startPlay(Context context, String playUrl) {
        Uri uri = Uri.parse(playUrl);
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(uri, "video/*");
        try {
            context.startActivity(intent);
        } catch (Exception e) {
            //没有播放器可以使用
            e.printStackTrace();
        }
    }

    private void showRemote(ImageView imageView, BIMMessage msg) {
        BIMVideoElement videoElement = (BIMVideoElement) msg.getElement();
        Glide.with(imageView.getContext())
                .load(videoElement.getCoverImg().getURL())
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        BIMLog.i(TAG, "load failed! " + " uuid: " + msg.getUuid());
                        return true;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        BIMLog.i(TAG, "load success!" + " uuid: " + msg.getUuid());
                        return false;
                    }
                }).into(imageView);
    }

    @Override
    public boolean isEnableRecall(BIMMessage bimMessage) {
        return bimMessage.isSelf();
    }

    @Override
    public boolean isEnableRef(BIMMessage bimMessage) {
        return bimMessage.getServerMsgId() > 0;
    }
}
