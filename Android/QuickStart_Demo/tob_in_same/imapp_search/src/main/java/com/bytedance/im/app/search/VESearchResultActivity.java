package com.bytedance.im.app.search;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bytedance.im.app.search.model.VESearchDivWrapper;
import com.bytedance.im.app.search.model.VESearchMsgInfo;
import com.bytedance.im.app.search.model.VESearchMsgWrapper;
import com.bytedance.im.app.search.model.VESearchWrapper;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class VESearchResultActivity extends Activity {

    public static final String TAG = "VESearchConvResultActivity";

    private String conversationID;
    private EditText editText;
    private ImageView ivClose;
    private RecyclerView recyclerView;
    private VESearchAdapter searchAdapter;
    private TextView emptyTextView;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_search_conv_layout);
        findViewById(R.id.iv_back).setOnClickListener(v -> onBackPressed());
        conversationID = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        editText = findViewById(R.id.et_input_search_msg);
        ivClose = findViewById(R.id.iv_search_clear);
        recyclerView = findViewById(R.id.search_result);
        emptyTextView = findViewById(R.id.empty_msg);
        recyclerView.setItemAnimator(null);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        ivClose.setOnClickListener(v -> {
            editText.setText("");
            emptyTextView.setVisibility(View.GONE);
            recyclerView.setVisibility(View.GONE);
            showKeyBoard(editText);
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
                    emptyTextView.setVisibility(View.GONE);
                    recyclerView.setVisibility(View.GONE);
                    ivClose.setVisibility(View.GONE);
                }
                search(s.toString());
            }
        });
    }

    private void search(String key) {
        BIMLog.i(TAG, "search key: " + key);
        if (TextUtils.isEmpty(key)) {
            recyclerView.setVisibility(View.GONE);
            emptyTextView.setVisibility(View.GONE);
            return;
        }
        BIMClient.getInstance().getService(BIMSearchExpandService.class).searchLocalMessage(key, conversationID, new BIMResultCallback<List<BIMSearchMsgInfo>>() {
            @Override
            public void onSuccess(List<BIMSearchMsgInfo> bimSearchMsgInfos) {
                BIMLog.i(TAG, "search onSuccess: " + bimSearchMsgInfos.size());
                if (bimSearchMsgInfos == null || bimSearchMsgInfos.isEmpty()) {
                    recyclerView.setVisibility(View.GONE);
                    emptyTextView.setVisibility(View.VISIBLE);
                    return;
                } else {
                    recyclerView.setVisibility(View.VISIBLE);
                    emptyTextView.setVisibility(View.GONE);
                }

                Set<Long> uidList = new HashSet<Long>();
                for (BIMSearchMsgInfo info : bimSearchMsgInfos) {
                    uidList.add(info.getMessage().getSenderUID());
                }
                BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(new ArrayList<>(uidList), new BIMResultCallback<List<BIMUIUser>>() {
                    @Override
                    public void onSuccess(List<BIMUIUser> bimuiUsers) {
                        Map<Long, BIMUIUser> map = new HashMap<>();
                        for (BIMUIUser user : bimuiUsers) {
                            map.put(user.getUid(), user);
                        }
                        List<VESearchWrapper> searchWrapperList = new ArrayList<>();
                        searchWrapperList.add(new VESearchDivWrapper(R.layout.ve_im_item_search_div_layout, "消息记录"));
                        for (BIMSearchMsgInfo searchMsgInfo : bimSearchMsgInfos) {
                            searchWrapperList.add(new VESearchMsgWrapper(R.layout.ve_im_item_search_msg_layout, new VESearchMsgInfo(searchMsgInfo, map.get(searchMsgInfo.getMessage().getSenderUID()))));
                        }
                        searchAdapter = new VESearchAdapter(searchWrapperList, searchDetail -> {
                            onBackPressed();
                            BIMMessage bimMessage = searchDetail.getMessage();
                            BIMUIClient.getInstance().getModuleStarter().startMessageModule(VESearchResultActivity.this,bimMessage.getUuid(),bimMessage.getConversationID());
                        });
                        recyclerView.setAdapter(searchAdapter);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {

                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                BIMLog.i(TAG, "search onFailed: " + code);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        editText.postDelayed(() -> showKeyBoard(editText),200);
    }

    private void showKeyBoard(EditText editText){
        editText.requestFocus();
        InputMethodManager imm = (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.showSoftInput(editText, InputMethodManager.SHOW_FORCED);
    }
    private void hideKeyBoard(EditText editText){
        InputMethodManager imm = (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(editText.getWindowToken(), 0);
    }



    @Override
    public void onBackPressed() {
        hideKeyBoard(editText);
        super.onBackPressed();
    }
}
