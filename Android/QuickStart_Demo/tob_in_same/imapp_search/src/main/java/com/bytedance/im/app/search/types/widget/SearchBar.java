package com.bytedance.im.app.search.types.widget;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bytedance.im.app.search.R;

public class SearchBar extends FrameLayout {
    private EditText editText;
    private ImageView ivClose;
    private View searchBar;

    private OnSearchListener searchListener;

    public SearchBar(@NonNull Context context) {
        super(context);
        init(context);
    }

    public SearchBar(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public SearchBar(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        LayoutInflater.from(context).inflate(R.layout.ve_im_search_bar, this, true);
        editText = findViewById(R.id.et_input_search_msg);
        ivClose = findViewById(R.id.iv_search_clear);
        searchBar = findViewById(R.id.msg_search_bar);
        ivClose.setOnClickListener(v -> {
            editText.setText("");
            if (searchListener != null) {
                searchListener.onClose();
            }
        });
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s != null && s.length() > 0) {
                    ivClose.setVisibility(View.VISIBLE);
                } else {
                    ivClose.setVisibility(View.GONE);
                }
                if (searchListener != null) {
                    searchListener.onSearch(s.toString());
                }
            }
        });
    }

    public EditText getEditText() {
        return editText;
    }

    public void setSearchListener(OnSearchListener searchListener) {
        this.searchListener = searchListener;
    }

    public interface OnSearchListener {
        void onSearch(String key);

        void onClose();
    }
}
