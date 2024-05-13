package com.bytedance.im.app.member.detail.ext;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.Nullable;


import com.bytedance.im.app.member.R;
import com.bytedance.im.app.member.detail.VEMessageEditCommonActivity;
import com.bytedance.im.app.member.detail.utils.VEMsgUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;

import java.util.HashMap;
import java.util.Map;

public class VEDebugExtActivity extends Activity {
    private static final String TAG = "VEDebugExtActivity";
    private static final String CID = "conversation_id";
    private static final int REQUEST_CODE_EDIT_EXT_LOCAL = 100;
    private static final int REQUEST_CODE_EDIT_EXT_CORE = 101;
    private static final int REQUEST_CODE_EDIT_EXT_MY = 102;
    private String conversationId;
    String localStr;
    String convStr;
    String myStr;

    public static void start(Activity activity, String conversationId) {
        Intent intent = new Intent(activity, VEDebugExtActivity.class);
        intent.putExtra(CID, conversationId);
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_debug_ext_layout);
        conversationId = getIntent().getStringExtra(CID);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.local_ext).setOnClickListener(v -> VEMessageEditCommonActivity.startForResult(VEDebugExtActivity.this, "本地字段", localStr, Integer.MAX_VALUE, REQUEST_CODE_EDIT_EXT_LOCAL));
        findViewById(R.id.conv_ext).setOnClickListener(v -> VEMessageEditCommonActivity.startForResult(VEDebugExtActivity.this, "公共字段", convStr, Integer.MAX_VALUE, REQUEST_CODE_EDIT_EXT_CORE));
        findViewById(R.id.my_ext).setOnClickListener(v -> VEMessageEditCommonActivity.startForResult(VEDebugExtActivity.this, "私有字段", myStr, Integer.MAX_VALUE, REQUEST_CODE_EDIT_EXT_MY));
        if (TextUtils.isEmpty(conversationId)) {
            Toast.makeText(this, "会话 ID 非法 id:" + conversationId, Toast.LENGTH_SHORT);
            return;
        }
        BIMClient.getInstance().getConversation(conversationId, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation conversation) {
                updateByConversation(conversation);

            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
    }

    private void updateByConversation(BIMConversation conversation){
        localStr = VEMsgUtils.mapToString(conversation.getLocalExt());
        convStr = VEMsgUtils.mapToString(conversation.getCoreExt());
        myStr = VEMsgUtils.mapToString(conversation.getMyExt());
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            String resultExtStr = data.getStringExtra(VEMessageEditCommonActivity.RESULT_TEXT);
            Map<String, String> ext = VEMsgUtils.stringToMap(resultExtStr, new HashMap<>());

            if (requestCode == REQUEST_CODE_EDIT_EXT_LOCAL) {
                BIMClient.getInstance().setConversationLocalExt(conversationId, ext, new BIMResultCallback<BIMConversation>() {
                    @Override
                    public void onSuccess(BIMConversation conversation) {
                        Toast.makeText(VEDebugExtActivity.this,"自定义本地信息成功",Toast.LENGTH_SHORT).show();
                        updateByConversation(conversation);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Toast.makeText(VEDebugExtActivity.this,"自定义本地信息失败 code: "+code,Toast.LENGTH_SHORT).show();
                    }
                });
            } else if (requestCode == REQUEST_CODE_EDIT_EXT_CORE) {
                BIMClient.getInstance().setConversationCoreExt(conversationId, ext, new BIMResultCallback<BIMConversation>() {
                    @Override
                    public void onSuccess(BIMConversation conversation) {
                        Toast.makeText(VEDebugExtActivity.this,"自定义公共信息成功",Toast.LENGTH_SHORT).show();
                        updateByConversation(conversation);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Toast.makeText(VEDebugExtActivity.this,"自定义公共信息失败 code: "+code,Toast.LENGTH_SHORT).show();
                    }
                });
            } else if (requestCode == REQUEST_CODE_EDIT_EXT_MY) {
                BIMClient.getInstance().setConversationMyExt(conversationId, ext, new BIMResultCallback<BIMConversation>() {
                    @Override
                    public void onSuccess(BIMConversation conversation) {
                        Toast.makeText(VEDebugExtActivity.this,"自定义私有信息成功",Toast.LENGTH_SHORT).show();
                        updateByConversation(conversation);
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Toast.makeText(VEDebugExtActivity.this,"自定义私有信息失败 code: "+code,Toast.LENGTH_SHORT).show();
                    }
                });
            }
        }
    }
}
