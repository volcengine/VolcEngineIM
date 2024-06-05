package com.bytedance.im.ui.message.adapter.ui.widget.input.tools;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import androidx.core.content.FileProvider;
import android.view.View;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.utils.BIMPermissionController;
import com.bytedance.im.ui.utils.media.MediaInfo;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class PhotoTooBtn extends BaseToolBtn<MediaInfo> {
    private static final String TAG = "PhotoTooBtn";
    private int REQUEST_CODE_TAKE_PHOTO = 2002;
    private String takePhotoPath = "";
    private Uri uri = null;

    public PhotoTooBtn(BIMResultCallback<MediaInfo> callback) {
        super(callback);
    }

    @Override
    public int getIcon(Context context) {
        return R.drawable.icon_im_input_optional_photo;
    }

    @Override
    public String getTitle(Context context) {
        return "拍照";
    }
    @Override
    public void onClick(Fragment fragment, View view, BIMConversation conversation) {
        BIMPermissionController.checkPermission(fragment.getActivity(), new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.CAMERA}, (isAllGranted, permissions, grantResults) -> {
            if (isAllGranted) {
                startIntentToTakePhoto(fragment);
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_TAKE_PHOTO) {
                //todo 计算文件大小
                MediaInfo mediaInfo = new MediaInfo(takePhotoPath, takePhotoPath, 0, 0, "", "", MediaInfo.MEDIA_TYPE_IMAGE, uri);
                resultCallback.onSuccess(mediaInfo);
            }
        } else {
            resultCallback.onFailed(BIMErrorCode.UNKNOWN);
        }
    }

    private void startIntentToTakePhoto(Fragment fragment) {
        Intent captureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(new Date());
        String imageFileName = String.format("JPEG_%s.jpg", timeStamp);
        File storageDir = fragment.getActivity().getExternalFilesDir(Environment.DIRECTORY_PICTURES);

        File tempFile = new File(storageDir, imageFileName);
        takePhotoPath = tempFile.getAbsolutePath();
        if(Build.VERSION.SDK_INT>=24){
            uri = FileProvider.getUriForFile(fragment.getActivity(), "com.bytedance.im.veapp.fileprovider", tempFile);
        } else {    //  Android 7 以前可以直接在intent中向其他应用分享文件
            uri = Uri.fromFile(tempFile);
        }

        BIMLog.i(TAG, "startIntentToTakePhoto takePhotoPath: " + takePhotoPath + " uri:" + uri);
        captureIntent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        captureIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        fragment.startActivityForResult(captureIntent, REQUEST_CODE_TAKE_PHOTO);
    }
}
