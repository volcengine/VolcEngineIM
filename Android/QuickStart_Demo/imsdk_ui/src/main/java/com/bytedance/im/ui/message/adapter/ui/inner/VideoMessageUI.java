package com.bytedance.im.ui.message.adapter.ui.inner;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import androidx.annotation.Nullable;
import androidx.core.content.FileProvider;

import android.text.TextUtils;
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
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.model.inner.msg.image.BIMImage;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.BIMMessageViewHolder;
import com.bytedance.im.ui.message.convert.base.annotations.CustomUIType;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.ui.message.adapter.ui.model.BIMMessageWrapper;
import com.bytedance.im.ui.message.adapter.ui.widget.custom.CircleProgressView;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.model.inner.msg.BIMVideoElement;
import com.bytedance.im.ui.utils.BIMUIUtils;
import com.bytedance.im.ui.utils.media.LoadIMageUtils;

import java.io.File;
import java.util.Collections;

@CustomUIType(contentCls = BIMVideoElement.class)
public class VideoMessageUI extends BaseCustomElementUI {
    private static final String TAG = "VideoMessageUI";

    @Override
    public int getLayoutId() {
        return R.layout.bim_im_item_message_video;
    }

    @Override
    public void onBindView(BIMMessageViewHolder holder,View itemView, BIMMessageWrapper messageWrapper, BIMMessageWrapper preMessageWrapper) {
        ImageView videoCover = itemView.findViewById(R.id.iv_video_cover);
        ImageView videoPlayIcon = itemView.findViewById(R.id.iv_play);
        TextView tvUploadStatus = itemView.findViewById(R.id.tv_upload_status);
        BIMMessage msg = messageWrapper.getBimMessage();
        BIMVideoElement videoElement = (BIMVideoElement) msg.getElement();
        CircleProgressView circleProgressView = itemView.findViewById(R.id.pv_circle_view);
        if (msg.isSelf()) {
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
        } else {
            circleProgressView.setVisibility(View.GONE);
            tvUploadStatus.setVisibility(View.GONE);
            videoPlayIcon.setVisibility(View.VISIBLE);
        }
        BIMImage coverImage = videoElement.getCoverImg();
        int width = 200;
        int height = 200;
        if (coverImage != null) {
            width = coverImage.getWidth();
            height = coverImage.getHeight();
        }
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
        if (msg.isSelf() && LoadIMageUtils.loadLocal(videoElement.getLocalPath(),videoElement.getLocalUri(), videoCover)) {
            return;
        }
        if (msg.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT) {
            showRemote(videoCover, msg);
        } else {
            showByDownload(holder,videoCover, msg);
        }
    }

    private void showByDownload(BIMMessageViewHolder holder,ImageView imageView, BIMMessage msg) {
        BIMVideoElement videoElement = (BIMVideoElement) msg.getElement();
        BIMImage coverImg = videoElement.getCoverImg();

        if (coverImg != null && new File(coverImg.getDownloadPath()).exists()) {
            Drawable placeDrawable = imageView.getDrawable();
            Glide.with(imageView.getContext()).load(coverImg.getDownloadPath()).dontAnimate().placeholder(placeDrawable).into(imageView);   //加载本地文件
        } else {
            if (coverImg != null) {
                holder.getDownloadListener().downLoadMessage(msg, coverImg.getURL(), false, null);   //下载
            }
        }
    }

    @Override
    public void onClick(BIMMessageViewHolder holder, View v, BIMMessageWrapper messageWrapper) {
        BIMVideoElement videoElement = (BIMVideoElement) messageWrapper.getBimMessage().getElement();
        BIMClient.getInstance().sendMessageReadReceipts(Collections.singletonList(messageWrapper.getBimMessage()), new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                BIMLog.i(TAG, "sendMessageReadReceipts success");
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.e(TAG, "sendMessageReadReceipts failed: " + code);
            }
        });

        BIMMessage bimMessage = messageWrapper.getBimMessage();
        boolean hasLocalFile = new File(videoElement.getDownloadPath()).exists();
        if (messageWrapper.getBimMessage().isSelf() && !TextUtils.isEmpty(videoElement.getLocalPath())) {
            Uri uri = convertUri(v.getContext(), videoElement.getLocalPath());
            startPlay(v.getContext(), uri);
        } else {
            if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_LIVE_CHAT) {
                if (videoElement.isExpired()) {
                    holder.getOnOutListener().refreshMediaMessage(messageWrapper.getBimMessage(), new BIMResultCallback<BIMMessage>() {
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
            } else {
                if (!hasLocalFile) {
                    startPlay(v.getContext(), videoElement.getURL());
                    BIMClient.getInstance().downloadFile(bimMessage, videoElement.getURL(), new BIMDownloadCallback() {
                        @Override
                        public void onSuccess(BIMMessage bimMessage) {
                            Toast.makeText(v.getContext(), "下载成功", Toast.LENGTH_SHORT).show();
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
                } else {
                    Uri contentUri = convertUri(v.getContext(), videoElement.getDownloadPath());
                    startPlay(v.getContext(), contentUri);
                }
            }
        }
    }

    private Uri convertUri(Context context, String filePath) {
        String packageName = context.getPackageName();
        Uri contentUri = null;
        try {
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(packageName, PackageManager.GET_PROVIDERS);
            ProviderInfo[] providers = packageInfo.providers;
            for (ProviderInfo providerInfo: providers) {
                try {
                    contentUri = FileProvider.getUriForFile(context, providerInfo.authority, new File(filePath));
                    context.getContentResolver().openInputStream(contentUri);
                    break;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return contentUri;
    }

    private void startPlay(Context context, String playUrl) {
        startPlay(context, Uri.parse(playUrl));
    }

    private void startPlay(Context context, Uri uri) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(uri, "video/*");
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        try {
            context.startActivity(intent);
        } catch (Exception e) {
            //没有播放器可以使用
            e.printStackTrace();
        }
    }

    private void showRemote(ImageView imageView, BIMMessage msg) {
        BIMVideoElement videoElement = (BIMVideoElement) msg.getElement();
        Drawable placeDrawable = imageView.getDrawable();
        BIMImage coverImg = videoElement.getCoverImg();
        if (coverImg == null){
            imageView.setImageResource(R.drawable.ic_default_imsdk_emoji_tab);
        }else {
            Glide.with(imageView.getContext())
                    .load(coverImg.getURL())
                    .dontAnimate()
                    .placeholder(placeDrawable)
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
