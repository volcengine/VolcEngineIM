package com.bytedance.im.app.live.create;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.InputFilter;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.bytedance.im.app.live.R;


public class VEEditCommonActivity extends Activity {
    public static final String RESULT_TEXT = "result_text";
    private static final String INIT_TEXT = "init_text";
    private static final String INIT_EDIT_LIMIT = "init_edit_limit";
    private static final String TITLE = "title";
    private EditText editText;
    protected long conversationId;
    private TextView tvTitle;
    private View confirm;

    public static void startForResult(Activity activity, String title, String initText, int limit, int requestCode) {
        Intent intent = new Intent(activity, VEEditCommonActivity.class);
        intent.putExtra(TITLE, title);
        intent.putExtra(INIT_TEXT, initText);
        intent.putExtra(INIT_EDIT_LIMIT, limit);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String initText = getIntent().getStringExtra(INIT_TEXT);
        String title = getIntent().getStringExtra(TITLE);
        int maxEditLength = getIntent().getIntExtra(INIT_EDIT_LIMIT,100);
        setContentView(R.layout.ve_im_live_activity_edit_group_name);
        tvTitle = findViewById(R.id.tv_title);
        editText = findViewById(R.id.edit_text);
        editText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(maxEditLength)});
        confirm = findViewById(R.id.tv_confirm);
        findViewById(R.id.back).setOnClickListener(v -> {
            finish();
        });
        confirm.setOnClickListener(v -> {
            Intent data = new Intent();
            data.putExtra(RESULT_TEXT, editText.getText().toString());
            setResult(RESULT_OK, data);
            finish();
        });
        tvTitle.setText(title);
        editText.setText(initText);
    }
}
