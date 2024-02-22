package com.bytedance.im.ui.message.adapter.ui.widget.input.tools;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.utils.BIMPermissionController;
import com.bytedance.im.ui.utils.media.BIMMediaListActivity;
import com.bytedance.im.ui.utils.media.MediaInfo;

public class ImageToolBtn extends BaseToolBtn<MediaInfo> {
    private int REQUEST_CODE_SELECT_MEDIA = 2000;

    public ImageToolBtn(BIMResultCallback<MediaInfo> callback) {
        super(callback);
    }

    @Override
    public int getIcon(Context context) {
        return R.drawable.icon_im_input_optional_img;
    }

    @Override
    public String getTitle(Context context) {
        return "图片";
    }

    @Override
    public void onClick(Fragment fragment, View view, BIMConversation conversation) {
        BIMPermissionController.checkPermission(fragment.getActivity(), new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
            if (isAllGranted) {
                BIMMediaListActivity.startForResultMedia(fragment, REQUEST_CODE_SELECT_MEDIA);
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        //选图片
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_SELECT_MEDIA) {
                MediaInfo info = (MediaInfo) data.getParcelableExtra(BIMMediaListActivity.RESULT_KEU);
                resultCallback.onSuccess(info);
            }
        } else {
            resultCallback.onFailed(BIMErrorCode.UNKNOWN);
        }
    }
}
