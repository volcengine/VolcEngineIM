package com.bytedance.im.app.search.media;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.bytedance.im.app.search.R;
import com.bytedance.im.app.search.media.viewholder.VEMediaBaseViewHolder;
import com.bytedance.im.app.search.media.viewholder.VEMediaDefaultViewHolder;
import com.bytedance.im.app.search.media.viewholder.VEMediaFileViewHolder;
import com.bytedance.im.app.search.media.viewholder.VEMediaImageViewHolder;
import com.bytedance.im.app.search.media.viewholder.VEMediaVideoViewHolder;
import com.bytedance.im.app.search.model.VEMediaWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMMessageListener;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMMessageReadReceipt;
import com.bytedance.im.core.api.model.BIMReadReceipt;
import com.bytedance.im.core.model.inner.msg.BIMFileElement;
import com.bytedance.im.core.model.inner.msg.BIMImageElement;
import com.bytedance.im.core.model.inner.msg.BIMVideoElement;
import com.bytedance.im.core.model.inner.msg.image.BIMImage;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class VESearchMediaAdapter extends RecyclerView.Adapter<VEMediaBaseViewHolder> {
    private List<VEMediaWrapper> data;
    private int itemWidth;
    private OnMediaClickListener onMediaClickListener;

    public interface OnMediaClickListener {
        void onMediaClick(VEMediaWrapper veMediaWrapper);
    }

    public VESearchMediaAdapter(Context context,OnMediaClickListener onMediaClickListener) {
        this.onMediaClickListener = onMediaClickListener;
        this.data = new ArrayList<>();
        itemWidth = getScreenWidth(context) / 4;
        BIMClient.getInstance().addMessageListener(new BIMMessageListener() {
            @Override
            public void onReceiveMessage(BIMMessage message) {

            }

            @Override
            public void onSendMessage(BIMMessage message) {

            }

            @Override
            public void onDeleteMessage(BIMMessage message) {

            }

            @Override
            public void onRecallMessage(BIMMessage message) {

            }

            @Override
            public void onUpdateMessage(BIMMessage message) {
                for (int i = 0; i < data.size(); i++) {
                    VEMediaWrapper old = data.get(i);
                    if (message.getUuid().equals(old.getBimMessage().getUuid())) {
                        data.set(i, new VEMediaWrapper(message, old.getBimuiUser()));
                        notifyItemChanged(i);
                        break;
                    }
                }
            }

            @Override
            public void onReceiveMessagesReadReceipt(List<BIMMessageReadReceipt> receiptList) {

            }

            @Override
            public void onReceiveReadReceipt(List<BIMReadReceipt> readReceiptList) {

            }

            @Override
            public void onConversationClearMessage(List<String> conversationIdList) {

            }
        });
    }

    @NonNull
    @Override
    public VEMediaBaseViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = null;
        VEMediaBaseViewHolder viewHolder;
        if (viewType == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO.getValue()) {
            v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_msg_video_layout, parent, false);
            viewHolder = new VEMediaVideoViewHolder(v);
        } else if (viewType == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.getValue()) {
            v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_msg_image_layout, parent, false);
            viewHolder = new VEMediaImageViewHolder(v);
        } else if (viewType == BIMMessageType.BIM_MESSAGE_TYPE_FILE.getValue()) {
            v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_media_file_layout, parent, false);
            viewHolder = new VEMediaFileViewHolder(v);
        } else {
            v = LayoutInflater.from(parent.getContext()).inflate(R.layout.ve_im_item_search_msg_video_layout, parent, false);
            viewHolder = new VEMediaDefaultViewHolder(v);
        }
        return viewHolder;
    }

    @Override
    public int getItemViewType(int position) {
        BIMMessage msg = data.get(position).getBimMessage();
        return msg.getMsgType().getValue();
    }

    @Override
    public void onBindViewHolder(@NonNull VEMediaBaseViewHolder holder, int position) {
        VEMediaWrapper mediaWrapper = data.get(position);
        BIMMessage bimMessage = mediaWrapper.getBimMessage();
        BIMUIUser user = mediaWrapper.getBimuiUser();
        int type = bimMessage.getMsgType().getValue();
        if (type == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO.getValue()) {
            VEMediaVideoViewHolder videoViewHolder = (VEMediaVideoViewHolder) holder;
            loadImageUrl(videoViewHolder.imageView, bimMessage);
        } else if (type == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE.getValue()) {
            VEMediaImageViewHolder imageViewHolder = (VEMediaImageViewHolder) holder;
            loadImageUrl(imageViewHolder.imageView, bimMessage);
        } else if (type == BIMMessageType.BIM_MESSAGE_TYPE_FILE.getValue()) {
            VEMediaFileViewHolder fileViewHolder = (VEMediaFileViewHolder) holder;
            BIMFileElement fileElement = (BIMFileElement) bimMessage.getElement();
            fileViewHolder.tvTitle.setText(fileElement.getFileName());
            fileViewHolder.tvDesc.setText(BIMUINameUtils.getShowName(user));
            fileViewHolder.tvTime.setText(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.US).format(bimMessage.getCreatedTime()));
            fileViewHolder.tvSize.setText(getFileSize(fileElement.getFileSize()));
        }

        holder.itemView.setOnClickListener(v -> {
            if (onMediaClickListener != null) {
                onMediaClickListener.onMediaClick(data.get(position));
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

    private void loadImageUrl(ImageView imageView, BIMMessage bimMessage) {
        ViewGroup.LayoutParams lp = imageView.getLayoutParams();
        lp.width = itemWidth;
        lp.height = itemWidth;
        imageView.setLayoutParams(lp);
        String url = "";
        if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_VIDEO) {
            BIMVideoElement videoElement = (BIMVideoElement) bimMessage.getElement();
            BIMImage bimImage = videoElement.getCoverImg();
            if (bimImage != null) {
                String localFile = bimImage.getDownloadPath();
                if (new File(localFile).exists()) {
                    url = localFile;
                } else {
                    url = bimImage.getURL();
                }
            }
        } else if (bimMessage.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_IMAGE) {
            BIMImageElement imageElement = (BIMImageElement) bimMessage.getElement();
            BIMImage bimImage = imageElement.getThumbImg();
            if (bimImage != null) {
                String localFile = bimImage.getDownloadPath();
                if (new File(localFile).exists()) {
                    url = localFile;
                } else {
                    url = bimImage.getURL();
                }
            }
        }
        Glide.with(imageView.getContext()).load(url).listener(new RequestListener<Drawable>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                BIMClient.getInstance().refreshMediaMessage(bimMessage, null);
                return false;
            }

            @Override
            public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                return false;
            }
        }).into(imageView);
    }

    public void appendData(List<VEMediaWrapper> msgList) {
        data.addAll(msgList);
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public static int getScreenWidth(Context context) {
        WindowManager windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics metrics = new DisplayMetrics();
        windowManager.getDefaultDisplay().getMetrics(metrics);
        return metrics.widthPixels;
    }
}
