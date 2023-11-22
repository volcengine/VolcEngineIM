package com.bytedance.im.ui.message.adapter.ui.widget.input.tools;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.View;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.R;
import com.bytedance.im.ui.utils.BIMPermissionController;
import com.bytedance.im.ui.utils.FilePathUtils;
import com.bytedance.im.ui.utils.FileUtils;

public class FileToolBtn extends BaseToolBtn<FileToolBtn.SelectFileInfo> {
    private int REQUEST_CODE_SELECT_FILE = 2003;
    private Fragment fragment;

    public FileToolBtn(BIMResultCallback<SelectFileInfo> callback) {
        super(callback);
    }

    @Override
    public int getIcon(Context context) {
        return R.drawable.icon_im_input_optional_file;
    }

    @Override
    public String getTitle(Context context) {
        return "文件";
    }

    @Override
    public void onClick(Fragment fragment, View view) {
        this.fragment = fragment;
        BIMPermissionController.checkPermission(fragment.getActivity(), new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
            if (isAllGranted) {
                Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                intent.setType("*/*");//设置类型，我这里是任意类型，任意后缀的可以这样写。
                intent.addCategory(Intent.CATEGORY_OPENABLE);
                fragment.startActivityForResult(intent, REQUEST_CODE_SELECT_FILE);
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_SELECT_FILE) {
                if (data != null && data.getData() != null) {
                    Uri uri = data.getData();
                    //需要给权限，不然关闭页面不会继续上传
                    fragment.getActivity().grantUriPermission(fragment.getActivity().getPackageName(), uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    //存在获取不到path的情况，所以直接用uri上传
                    String path = FilePathUtils.getPath(fragment.getActivity(), uri);
                    long length = FileUtils.getLengthFromUri(fragment.getActivity(), uri);
                    String name = FileUtils.getFileNameFromUri(fragment.getActivity(), uri);
                    resultCallback.onSuccess(new SelectFileInfo(uri,path, length, name));
                }
            }
        } else {
            resultCallback.onFailed(BIMErrorCode.UNKNOWN);
        }
    }

    public static class SelectFileInfo {
        private String path;
        private long length;
        private String name;
        private Uri uri;

        public SelectFileInfo(Uri uri, String path, long length, String name) {
            this.uri = uri;
            this.path = path;
            this.length = length;
            this.name = name;
        }

        public String getPath() {
            return path;
        }

        public long getLength() {
            return length;
        }

        public String getName() {
            return name;
        }

        public Uri getUri() {
            return uri;
        }
    }

}
