package com.bytedance.im.ui.utils.media;

import android.net.Uri;
import android.os.Build;
import androidx.core.content.FileProvider;
import android.text.TextUtils;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bytedance.im.ui.log.BIMLog;

import java.io.File;

public class LoadIMageUtils {

    public static boolean loadLocal(String localPath,Uri uri, ImageView imageView) {
        BIMLog.i("LoadIMageUtils", "loadLocal path:" + localPath + " uri: " + uri);
        if (!TextUtils.isEmpty(localPath)) {
                //优先加载本地
            Glide.with(imageView.getContext()).load(localPath).into(imageView);
            return true;
        } else if (uri != null) {
            Glide.with(imageView.getContext()).load(uri).into(imageView);
            return true;
        }
        return false;
    }
}
