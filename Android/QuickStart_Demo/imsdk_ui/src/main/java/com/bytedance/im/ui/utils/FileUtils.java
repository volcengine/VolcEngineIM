package com.bytedance.im.ui.utils;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.ParcelFileDescriptor;
import android.provider.OpenableColumns;
import androidx.core.content.FileProvider;
import android.text.TextUtils;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

public class FileUtils {
    public static final String ROOT_DIR_NAME = "im-demo";
    public static final String AUDIO_DIR_NAME = "audio";
    public static final String IMAGE_DIR_NAME = "image";
    public static final String TEMP_DIR_NAME = "temp";
    public static final String FILE_DIR_NAME = "file";

    private static String sRootPath;
    private static String sExternalRootPath;
    private static String sImagePath;
    private static String sAudioPath;
    private static String sFilePath;
    private static String sTempDir;
    private static Context mContext;
    public static void initDir(Context context) {
        if (context == null) {
            return;
        }
        mContext = context;
        sRootPath = context.getDir(ROOT_DIR_NAME, Context.MODE_PRIVATE).getAbsolutePath();
        if (hasSDCard()) {
            sExternalRootPath = getExternalRootPath() + File.separator + ROOT_DIR_NAME;
        } else {
            sExternalRootPath = "";
        }
        String mediaStoreRootPath = TextUtils.isEmpty(sExternalRootPath) ? sRootPath : sExternalRootPath;
        sImagePath = mediaStoreRootPath + File.separator + IMAGE_DIR_NAME;
        sAudioPath = mediaStoreRootPath + File.separator + AUDIO_DIR_NAME;
        sFilePath = mediaStoreRootPath + File.separator + FILE_DIR_NAME;
        sTempDir = mediaStoreRootPath + File.separator + TEMP_DIR_NAME;

        File rootDir = new File(sRootPath);
        if (!rootDir.exists()) {
            rootDir.mkdirs();
        }
        File externalRootDir = new File(sExternalRootPath);
        if (!externalRootDir.exists()) {
            externalRootDir.mkdirs();
        }
        File imageDir = new File(sImagePath);
        if (!imageDir.exists()) {
            imageDir.mkdirs();
        }
        File audioDir = new File(sAudioPath);
        if (!audioDir.exists()) {
            audioDir.mkdirs();
        }
        File tempDir = new File(sTempDir);
        if (!tempDir.exists()) {
            tempDir.mkdirs();
        }
        File fileDir = new File(sFilePath);
        if (!fileDir.exists()) {
            fileDir.mkdirs();
        }
    }

    public static boolean hasSDCard() {
        String status = Environment.getExternalStorageState();
        return status.equals(Environment.MEDIA_MOUNTED);
    }

    public static String getExternalRootPath() {
        if (hasSDCard()) {
            return Environment.getExternalStorageDirectory().getAbsolutePath(); // filePath:  /sdcard/
        } else {
            return Environment.getDataDirectory().getAbsolutePath() + "/data"; // filePath:  /data/data/
        }
    }

    public static String getAudioPath() {
        return sAudioPath;
    }

    public static String getImagePath() {
        return sImagePath;
    }

    public static String getFilePath() {
        return sFilePath;
    }

    public static String getTempDir() {
        return sTempDir;
    }

    public static String getRootDir() {
        return sRootPath;
    }

    public static boolean makeFile(String path, String name) {
        File file = new File(path + "/" + name);
        File dir = new File(path);
        if (dir.exists() && file.exists()) {
            return true;
        } else if (dir.exists() && !file.exists()) {
            try {
                file.createNewFile();
                return true;
            } catch (IOException e) {
                e.printStackTrace();
                return false;
            }
        } else if (!dir.exists()) {
            if (dir.mkdirs()) {
                try {
                    file.createNewFile();
                    return true;
                } catch (IOException e) {
                    e.printStackTrace();
                    return false;
                }
            } else {
                return false;
            }
        }
        return false;
    }

    public static boolean deleteFile(String path) {
        File file = new File(path);
        if (file.exists()) {
            return file.delete();
        } else {
            return true;
        }
    }

    public static Uri getFileUri(Context context, File file) {
        if (context == null || file == null) {
            return null;
        }
        Uri uri = null;
        if (Build.VERSION.SDK_INT >= 24) {
            String provider_name = mContext.getPackageName() + ".fileprovider";
            uri = FileProvider.getUriForFile(context, provider_name, file);
        } else {
            uri = Uri.fromFile(file);
        }
        return uri;
    }

    public static int getAudioFileDuration(Context context, String path) {
        if (context == null || TextUtils.isEmpty(path)) {
            return 0;
        }
        MediaPlayer player = MediaPlayer.create(context, FileUtils.getFileUri(context, new File(path)));
        if (player == null) {
            return 0;
        }
        return Math.round(player.getDuration() / ((float) 1000));
    }
    

    public static long getLengthFromUri(Context context, Uri uri) {
        if (ContentResolver.SCHEME_FILE.equals(uri.getScheme())) {
            return new File(uri.getPath()).length();
        } else {
            try {
                ParcelFileDescriptor fileDescriptor = context.getContentResolver().openFileDescriptor(uri, "r");
                return fileDescriptor == null ? 0 : fileDescriptor.getStatSize();
            } catch (Exception e) {
                return 0;
            }
        }
    }

    public static String getFileNameFromUri(Context context, Uri uri) {
        if (ContentResolver.SCHEME_FILE.equals(uri.getScheme())) {
            return new File(uri.getPath()).getName();
        } else {
            try {
                Cursor cursor = context.getContentResolver().query(uri, null, null, null, null, null);
                if (cursor != null) {
                    cursor.moveToFirst();
                    String fileName = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                    cursor.close();
                    return fileName;
                } else {
                    return "";
                }
            } catch (Exception e) {
                return "";
            }
        }
    }

    /**
     * 转义正则特殊字符 （$()*+.[]?\^{}
     * \\需要第一个替换，否则replace方法替换时会有逻辑bug
     */
    public static String makeQueryStringAllRegExp(String str) {
        if (TextUtils.isEmpty(str)) {
            return str;
        }

        return str.replace("\\", "\\\\").replace("*", "\\*")
                .replace("+", "\\+").replace("|", "\\|")
                .replace("{", "\\{").replace("}", "\\}")
                .replace("(", "\\(").replace(")", "\\)")
                .replace("^", "\\^").replace("$", "\\$")
                .replace("[", "\\[").replace("]", "\\]")
                .replace("?", "\\?").replace(",", "\\,")
                .replace(".", "\\.").replace("&", "\\&");
    }

    /**
     * 重名 自动添加（1）
     *
     * @param title      文件名 （不包含后缀） 例：测试文档
     * @param suffixName 文件后缀 例：txt
     * @return
     */
    public static String changeSameName(String title, String suffixName, String sFilePath) {
        // 如果不对文件名做正则特殊字符的转义在下面的正则判断会出问题
        String finalTitle = makeQueryStringAllRegExp(title);
        File file = new File(sFilePath);

        File folder = file.getParentFile();

        // 文件不存在 就不用做重名处理了
        if (!file.exists()) {
            return title;
        }

        // 获取符合 文件名（序号）.后缀 的文件
        FileFilter filter = pathname -> {
            String name = pathname.getName();
            String pattern = finalTitle + "(\\([1-9]\\d*\\))?" + "." + suffixName;
            return Pattern.matches(pattern, name);
        };
        File[] files = folder.listFiles(filter);

        // 获取所有序号
        int num = 1;
        List<Integer> nums = new ArrayList<>();
        for (int i = 0; i < files.length; i++) {
            String name = files[i].getName();
            if (!TextUtils.isEmpty(suffixName)) {
                if ((finalTitle + "." + suffixName).equals(name)) {
                    continue;
                }
            } else {
                if (finalTitle.equals(name)) {
                    continue;
                }
            }
            if (name.lastIndexOf("(") > 0 && name.lastIndexOf(")") > 0) {
                String numItem = name.substring(name.lastIndexOf("(") + 1, name.lastIndexOf(")"));
                nums.add(Integer.parseInt(numItem));
            }
        }

        // 对序号进行排序
        Collections.sort(nums);
        if (nums.isEmpty() || nums.get(nums.size() - 1) + 1 == files.length) {
            num = files.length;
        } else {
            for (int i = 1; i <= nums.size(); i++) {
                if (nums.get(i - 1) != i) {
                    num = i;
                    break;

                }
            }

        }
        return title + "(" + num + ")";

    }

    /**
     * 复制文件
     *
     * @param is 数据源 流
     * @param os 数据目标 流
     */
    public static void copyFile(InputStream is, OutputStream os) {
        try {
            byte[] buffer = new byte[1024];
            int len;
            while ((len = is.read(buffer)) > 0) {
                os.write(buffer, 0, len);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (is != null) {
                    is.close();
                }
                if (os != null) {
                    os.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static String getMimeType(Context context, Uri uri) {
        if (uri == null) {
            return "";
        }
        ContentResolver resolver = context.getContentResolver();
        return resolver.getType(uri);
    }

}
