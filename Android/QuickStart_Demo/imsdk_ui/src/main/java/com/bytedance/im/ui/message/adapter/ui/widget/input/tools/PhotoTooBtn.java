package com.bytedance.im.ui.message.adapter.ui.widget.input.tools;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.content.FileProvider;
import android.view.View;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.utils.BIMPermissionController;
import com.bytedance.im.ui.utils.media.BIMMediaListActivity;
import com.bytedance.im.ui.utils.media.MediaInfo;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class PhotoTooBtn extends BaseToolBtn<String> {
    private int REQUEST_CODE_TAKE_PHOTO = 2002;
    private String takePhotoPath = "";

    public PhotoTooBtn(BIMResultCallback<String> callback) {
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
                Manifest.permission.WRITE_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
            if (isAllGranted) {
                startIntentToTakePhoto(fragment);
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_TAKE_PHOTO) {
                resultCallback.onSuccess(takePhotoPath);
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
        Uri uri = FileProvider.getUriForFile(fragment.getActivity(), "com.bytedance.im.app.fileprovider", tempFile);
        captureIntent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        captureIntent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        fragment.startActivityForResult(captureIntent, REQUEST_CODE_TAKE_PHOTO);
    }
}
