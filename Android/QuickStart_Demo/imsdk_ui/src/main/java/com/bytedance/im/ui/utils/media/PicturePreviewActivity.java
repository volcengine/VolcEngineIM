package com.bytedance.im.ui.utils.media;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bytedance.im.ui.R;

public class PicturePreviewActivity extends Activity {
    private static final String PREVIEW_URL = "preview_url";
    private ImageView previewImage;

    public static void start(Context context, String url) {
        Intent intent = new Intent(context, PicturePreviewActivity.class);
        intent.putExtra(PREVIEW_URL, url);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bim_im_activity_picture_preview);
        String url = getIntent().getStringExtra(PREVIEW_URL);
        previewImage = findViewById(R.id.preview);
        Glide.with(this).load(url).into(previewImage);
        findViewById(R.id.iv_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
