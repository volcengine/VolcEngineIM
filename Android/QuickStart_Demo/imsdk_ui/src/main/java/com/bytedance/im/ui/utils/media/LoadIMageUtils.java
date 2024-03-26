package com.bytedance.im.ui.utils.media;

import android.net.Uri;
import android.os.Build;
import androidx.core.content.FileProvider;
import android.text.TextUtils;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

import java.io.File;

public class LoadIMageUtils {

    public static boolean loadLocal(String localPath, ImageView imageView) {
        if (!TextUtils.isEmpty(localPath)) {
            Uri localUri = null;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                localUri = FileProvider.getUriForFile(imageView.getContext(), "com.bytedance.im.veapp.fileprovider", new File(localPath));
            } else {
                localUri = Uri.fromFile(new File(localPath));
            }
            if (localUri != null) {
                //优先加载本地
                Glide.with(imageView.getContext()).load(localUri).into(imageView);
                return true;
            }
        }
        return false;
    }
}
