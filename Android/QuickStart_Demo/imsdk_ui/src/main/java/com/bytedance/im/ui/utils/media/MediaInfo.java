package com.bytedance.im.ui.utils.media;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;

public class MediaInfo implements Parcelable {
    public static final int MEDIA_TYPE_IMAGE = 0x1001;
    public static final int MEDIA_TYPE_VIDEO = 0x1002;

    private String fileName;
    private String filePath;
    private long fileSize;
    private long fileLastModified;
    private String fileWidth;
    private String fileHeight;
    private int fileType;
    private Uri uri;
    private long videoDuration;

    public MediaInfo(String fileName, String filePath, long fileSize, long fileLastModified, String fileWidth,
                     String fileHeight, int fileType, Uri uri) {
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.fileLastModified = fileLastModified;
        this.fileWidth = fileWidth;
        this.fileHeight = fileHeight;
        this.fileType = fileType;
        this.uri = uri;

    }

    protected MediaInfo(Parcel in) {
        fileName = in.readString();
        filePath = in.readString();
        fileSize = in.readLong();
        fileLastModified = in.readLong();
        fileWidth = in.readString();
        fileHeight = in.readString();
        fileType = in.readInt();
        uri = in.readParcelable(Uri.class.getClassLoader());
        videoDuration = in.readLong();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(fileName);
        dest.writeString(filePath);
        dest.writeLong(fileSize);
        dest.writeLong(fileLastModified);
        dest.writeString(fileWidth);
        dest.writeString(fileHeight);
        dest.writeInt(fileType);
        dest.writeParcelable(uri, flags);
        dest.writeLong(videoDuration);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<MediaInfo> CREATOR = new Creator<MediaInfo>() {
        @Override
        public MediaInfo createFromParcel(Parcel in) {
            return new MediaInfo(in);
        }

        @Override
        public MediaInfo[] newArray(int size) {
            return new MediaInfo[size];
        }
    };

    public long getVideoDuration() {
        return videoDuration;
    }

    public void setVideoDuration(long videoDuration) {
        this.videoDuration = videoDuration;
    }

    public String getFileName() {
        return fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public long getFileSize() {
        return fileSize;
    }

    public long getFileLastModified() {
        return fileLastModified;
    }

    public String getFileWidth() {
        return fileWidth;
    }

    public String getFileHeight() {
        return fileHeight;
    }

    public int getFileType() {
        return fileType;
    }

    public Uri getUri() {
        return uri;
    }

}
