package com.bytedance.im.app.search;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.app.message.VEMessageListActivity;
import com.bytedance.im.app.search.data.VESearchDivWrapper;
import com.bytedance.im.app.search.data.VESearchMsgInfo;
import com.bytedance.im.app.search.data.VESearchMsgWrapper;
import com.bytedance.im.app.search.data.VESearchWrapper;
import com.bytedance.im.app.search.interfaces.OnSearchMsgClickListener;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.search.api.BIMSearchExpandService;
import com.bytedance.im.search.api.model.BIMSearchDetail;
import com.bytedance.im.search.api.model.BIMSearchMsgInfo;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VESearchResultActivity extends Activity {

    public static final String TAG = "VESearchConvResultActivity";

    private static final String CONVERSATION_ID = "conversation_id";
    private String conversationID;
    private EditText editText;
    private ImageView ivClose;
    private RecyclerView recyclerView;
    private VESearchAdapter searchAdapter;
    private TextView emptyTextView;

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VESearchResultActivity.class);
        intent.putExtra(CONVERSATION_ID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_search_conv_layout);
        findViewById(R.id.iv_back).setOnClickListener(v -> onBackPressed());
        conversationID = getIntent().getStringExtra(CONVERSATION_ID);
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
                List<Long> uidList = new ArrayList<>();
                Map<Long, BIMSearchMsgInfo> map = new HashMap<>();
                for (BIMSearchMsgInfo info : bimSearchMsgInfos) {
                    long uid = info.getMessage().getSenderUID();
                    uidList.add(uid);
                    map.put(uid, info);
                }
                BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfoList(uidList, new BIMResultCallback<List<BIMUserFullInfo>>() {
                    @Override
                    public void onSuccess(List<BIMUserFullInfo> bimUserFullInfos) {
                        if(bimSearchMsgInfos!=null && !bimSearchMsgInfos.isEmpty()){
                            List<VESearchWrapper> searchWrapperList = new ArrayList<>();
                            searchWrapperList.add(new VESearchDivWrapper(R.layout.ve_im_item_search_div_layout, "消息记录"));
                            for(BIMUserFullInfo info:bimUserFullInfos){
                                BIMSearchMsgInfo searchMsgInfo = map.get(info.getUid());
                                searchWrapperList.add(new VESearchMsgWrapper(R.layout.ve_im_item_search_msg_layout,new VESearchMsgInfo(searchMsgInfo,info)));
                            }
                            searchAdapter = new VESearchAdapter(searchWrapperList, new OnSearchMsgClickListener() {
                                @Override
                                public void onSearchMsgClick(BIMSearchMsgInfo searchDetail) {
                                    onBackPressed();
                                    BIMMessage bimMessage = searchDetail.getMessage();
                                    VEMessageListActivity.start(VESearchResultActivity.this, bimMessage.getConversationID(), bimMessage.getUUId());
                                }
                            });
                            recyclerView.setAdapter(searchAdapter);
                        }
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
