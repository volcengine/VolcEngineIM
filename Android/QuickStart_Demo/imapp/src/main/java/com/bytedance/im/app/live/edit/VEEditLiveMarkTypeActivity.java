package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.live.BIMLiveExpandService;

import java.util.ArrayList;
import java.util.List;

public class VEEditLiveMarkTypeActivity extends Activity {
    public static final String RESULT_TEXT = "result_text";
    private static final String INIT_TEXT = "init_text";
    private static final String INIT_EDIT_LIMIT = "init_edit_limit";
    private static final String CONV_SHORT_ID = "conv_short_id";
    private static final String TITLE = "title";
    private EditText editText;
    protected long conversationId;
    private TextView tvTitle;
    private View confirm;
    private Button btnConfirmMark;
    private Spinner spinnerMark;
    private ArrayAdapter<String> adapter;
    private long conversationShortId;
    private List<String> marks = new ArrayList<>();

    public static void startForResult(Activity activity, String title, String initText, long conversationShortId, int limit, int requestCode) {
        Intent intent = new Intent(activity, VEEditLiveMarkTypeActivity.class);
        intent.putExtra(TITLE, title);
        intent.putExtra(INIT_TEXT, initText);
        intent.putExtra(INIT_EDIT_LIMIT, limit);
        intent.putExtra(CONV_SHORT_ID, conversationShortId);
        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String initText = getIntent().getStringExtra(INIT_TEXT);
        String title = getIntent().getStringExtra(TITLE);
        conversationShortId = getIntent().getLongExtra(CONV_SHORT_ID, 0L);
        int maxEditLength = getIntent().getIntExtra(INIT_EDIT_LIMIT,100);
        setContentView(R.layout.ve_im_activity_edit_mark_type);
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
        spinnerMark = findViewById(R.id.spinner_mark);
        btnConfirmMark = findViewById(R.id.btn_confirm_select);

        adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, marks);
        spinnerMark.setAdapter(adapter);

        btnConfirmMark.setOnClickListener(v -> {
            if (spinnerMark.getSelectedItem() != null) {
                String selectedMark = spinnerMark.getSelectedItem().toString();
                if (!TextUtils.isEmpty(selectedMark)) {
                    if (!TextUtils.isEmpty(editText.getText())) {
                        editText.append(" " + selectedMark);
                    } else {
                        editText.append(selectedMark);
                    }
                }
            }
        });

        BIMClient.getInstance().getService(BIMLiveExpandService.class).getLiveGroupMarkTypeList(conversationShortId, new BIMResultCallback<List<String>>() {
            @Override
            public void onSuccess(List<String> strings) {
                marks.clear();
                marks.addAll(strings);
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEEditLiveMarkTypeActivity.this, "获取标签列表失败", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
