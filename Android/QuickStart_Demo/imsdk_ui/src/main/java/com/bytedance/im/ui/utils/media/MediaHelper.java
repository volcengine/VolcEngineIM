package com.bytedance.im.ui.utils.media;

import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContentResolverCompat;
import androidx.core.content.FileProvider;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class MediaHelper {
    public MediaHelper() {
    }

    public interface OnMediaLoadListener {
        void onMediaLoad(List<MediaInfo> mediaInfoList);

        void onError();
    }

    /**
     * 获取所有图片
     *
     * @param context
     * @return
     */
    public void getAllMedia(Context context, OnMediaLoadListener listener) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                List<MediaInfo> allList = new ArrayList<>();
                allList.addAll(getImages(context));
                allList.addAll(getVideos(context));
                Collections.sort(allList, new Comparator<MediaInfo>() {
                    @Override
                    public int compare(MediaInfo o1, MediaInfo o2) {
                        return (int) (o2.getFileLastModified() - o1.getFileLastModified());
                    }
                });

                new Handler(Looper.getMainLooper()).post(() -> {
                    if (allList == null) {
                        listener.onError();
                    } else {
                        listener.onMediaLoad(allList);
                    }
                });
            }
        }).start();
    }

    private List<MediaInfo> getImages(Context context) {
        Cursor cursor = null;
        List<MediaInfo> result = new ArrayList<>();
        try {
            cursor = ContentResolverCompat.query(context.getContentResolver(),
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null, null, null,
                    MediaStore.Images.Media.DATE_MODIFIED + " DESC", null);
            if (cursor == null) {
                return result;
            }
            while (cursor.moveToNext()) {
                String imageName = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME));
                String imagePath = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.DATA));
                long imageSize = cursor.getLong(cursor.getColumnIndex(MediaStore.Images.Media.SIZE));
                long lastModified = cursor.getLong(cursor.getColumnIndex(MediaStore.Images.Media.DATE_MODIFIED));
                String imageWidth = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.WIDTH));
                String imageHeight = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media.HEIGHT));
                long id = cursor.getLong(cursor.getColumnIndex(MediaStore.Files.FileColumns._ID));
                Uri uri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id);
                result.add(new MediaInfo(imageName, imagePath, imageSize, lastModified, imageWidth, imageHeight, MediaInfo.MEDIA_TYPE_IMAGE, uri));
            }
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return result;
    }


    private List<MediaInfo> getVideos(Context context){
        Cursor cursor = null;
        List<MediaInfo> result = new ArrayList<>();
        try {
            cursor = context.getContentResolver().query(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, null, null, null,
                    MediaStore.Video.Media.DATE_MODIFIED + " DESC");
            if (cursor == null) {
                return result;
            }
            while (cursor.moveToNext()) {
                String videoName = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DISPLAY_NAME));
                String videoPath = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DATA));
                long videoSize = cursor.getLong(cursor.getColumnIndex(MediaStore.Video.Media.SIZE));
                long lastModified = cursor.getLong(cursor.getColumnIndex(MediaStore.Video.Media.DATE_MODIFIED));
                String videoWidth = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.WIDTH));
                String videoHeight = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.HEIGHT));
                long videoDuration = cursor.getLong(cursor.getColumnIndex(MediaStore.Video.VideoColumns.DURATION));
                long id = cursor.getLong(cursor.getColumnIndex(MediaStore.Files.FileColumns._ID));
                Uri uri = ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, id);
                MediaInfo mediaInfo = new MediaInfo(videoName, videoPath, videoSize, lastModified, videoWidth, videoHeight, MediaInfo.MEDIA_TYPE_VIDEO, uri);
                mediaInfo.setVideoDuration(videoDuration);
                result.add(mediaInfo);
            }
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return result;
    }

}
