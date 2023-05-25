package com.bytedance.im.ui.utils.media;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.utils.FileUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class MediaListAdapter extends RecyclerView.Adapter<MediaListAdapter.MediaListHolder> {
    private List<MediaInfo> mMediaInfoList = new ArrayList<>();
    private OnSelectMediaListener mMediaListener;

    public MediaListAdapter(OnSelectMediaListener onSelectMediaListener) {
        mMediaListener = onSelectMediaListener;
    }

    public void setData(List<MediaInfo> list) {
        mMediaInfoList = list;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public MediaListHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.bim_recycler_view_item_media, null, false);
        return new MediaListHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MediaListHolder mediaListHolder, int position) {
        ImageView imageView = mediaListHolder.mImageView;
        MediaInfo info = mMediaInfoList.get(position);
        if (info.getFileType() == MediaInfo.MEDIA_TYPE_VIDEO) {
            mediaListHolder.videoBtn.setVisibility(View.VISIBLE);
        } else {
            mediaListHolder.videoBtn.setVisibility(View.GONE);
        }
//        Uri imageUri = FileUtils.getFileUri(imageView.getContext(), new File(info.getFilePath()));
        Glide.with(imageView.getContext()).load(info.getUri()).apply(RequestOptions.placeholderOf(R.drawable.icon_im_placehodler)).into(imageView);
        //选中的文件信息
        mediaListHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mMediaListener.onSelect(info);
            }
        });
    }

    @Override
    public int getItemCount() {
        return mMediaInfoList != null ? mMediaInfoList.size() : 0;
    }

    public static class MediaListHolder extends RecyclerView.ViewHolder {

        private ImageView mImageView;
        private ImageView videoBtn;

        public MediaListHolder(@NonNull View itemView) {
            super(itemView);
            mImageView = itemView.findViewById(R.id.iv_all_media);
            videoBtn = itemView.findViewById(R.id.iv_media_video);
        }
    }

    public interface OnSelectMediaListener {
        void onSelect(MediaInfo info);
    }
}
