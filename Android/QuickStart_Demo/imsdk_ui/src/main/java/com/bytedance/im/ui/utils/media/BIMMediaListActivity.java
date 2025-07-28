package com.bytedance.im.ui.utils.media;

import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;

import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.widget.TextView;
import android.widget.Toast;


import com.bytedance.im.ui.R;

import java.util.List;


public class BIMMediaListActivity extends Activity implements MediaListAdapter.OnSelectMediaListener {

    public static final String RESULT_KEU = "select_media_info";
    public static final String TYPE_SELECT = "type_select";
    public static final int TYPE_VIDEO = 0;
    public static final int TYPE_IMAGE = 1;
    public static final int TYPE_ALL = 2;

    private int MAX_SIZE = 50 * 1000 * 1000;
    private RecyclerView mRecyclerView;
    private MediaHelper mediaHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bim_activity_media_list);
        mediaHelper = new MediaHelper();
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        ((TextView) findViewById(R.id.tv_title)).setText("图库");
        mRecyclerView = findViewById(R.id.recycler_view_media);
        mRecyclerView.setLayoutManager(new GridLayoutManager(this, 4));
        MediaListAdapter adapter = new MediaListAdapter(this);
        mRecyclerView.setAdapter(adapter);
        int type = getIntent().getIntExtra(TYPE_SELECT, TYPE_ALL);
        if (type == TYPE_ALL) {
            mediaHelper.getAllMedia(this, new MediaHelper.OnMediaLoadListener() {
                @Override
                public void onMediaLoad(List<MediaInfo> mediaInfoList) {
                    adapter.setData(mediaInfoList);
                }

                @Override
                public void onError() {

                }
            });
        } else if (type == TYPE_VIDEO) {
            mediaHelper.getVideoMedia(this, new MediaHelper.OnMediaLoadListener() {
                @Override
                public void onMediaLoad(List<MediaInfo> mediaInfoList) {
                    adapter.setData(mediaInfoList);
                }

                @Override
                public void onError() {

                }
            });
        } else if (type == TYPE_IMAGE) {
            mediaHelper.getImageMedia(this, new MediaHelper.OnMediaLoadListener() {
                @Override
                public void onMediaLoad(List<MediaInfo> mediaInfoList) {
                    adapter.setData(mediaInfoList);
                }

                @Override
                public void onError() {

                }
            });
        }
    }

    public static void startForResultMedia(Fragment fragment, int requestCode) {
        startForResultMedia(fragment, requestCode, TYPE_ALL);
    }

    public static void startForResultMedia(Fragment fragment, int requestCode, int selectType) {
        Intent intent = new Intent(fragment.getActivity(), BIMMediaListActivity.class);
        intent.putExtra(TYPE_SELECT, selectType);
        fragment.startActivityForResult(intent, requestCode);
    }


    @Override
    public void onSelect(MediaInfo info) {
        if (info.getFileSize() > MAX_SIZE) {
            Toast.makeText(BIMMediaListActivity.this, "文件过大", Toast.LENGTH_SHORT).show();
            return;
        }
        Intent intent = new Intent();
        intent.putExtra(RESULT_KEU, info);
        setResult(RESULT_OK, intent);
        finish();
    }
}
