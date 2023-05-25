package com.bytedance.im.app.login;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.login.adapter.VEUserSelectAdapter;
import com.bytedance.im.app.main.VEIMMainActivity;
import com.bytedance.im.app.debug.VEEnvSettingActivity;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.user.BIMUser;
import com.bytedance.im.app.login.data.UserMock;
import com.bytedance.im.app.login.data.LoginModel;
import com.bytedance.im.app.login.model.UserToken;
import com.bytedance.im.core.api.interfaces.BIMSyncServerListener;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;

import java.util.List;

public class VELoginActivity extends Activity {
    private static final String TAG = "VELoginActivity";
    private RecyclerView rvUserList;
    private VEUserSelectAdapter adapter;
    private int toDebugCount = 0;
    private ProgressDialog syncDialog;
    private ImageView agreeCheck;
    private View agreeLayout;
    private View loginLayout;
    private boolean isAgree = false;
    private TextView tvProtocol;

    public static void start(Context context) {
        Intent intent = new Intent(context, VELoginActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_login_layout);
        findViewById(R.id.tv_login_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toDebugCount++;
                if (toDebugCount == 3) {
                    VEEnvSettingActivity.start(VELoginActivity.this);
                    toDebugCount = 0;
                }
            }
        });
        rvUserList = findViewById(R.id.rv_login_uid_list);
        rvUserList.setLayoutManager(new LinearLayoutManager(this));
        adapter = new VEUserSelectAdapter(this, UserMock.getInstance().getMockLoginUserList());
        rvUserList.setAdapter(adapter);
        agreeCheck = findViewById(R.id.agree_check);
        agreeLayout = findViewById(R.id.agree);
        loginLayout = findViewById(R.id.login_btn);
        tvProtocol = findViewById(R.id.tv_protocol);
        UserToken lastUserToken = SpUtils.getInstance().getLoginUserInfo();
        Log.i(TAG, "lastUserToken:" + lastUserToken);
        if (lastUserToken != null) {
            loginIM(lastUserToken.getUid(), lastUserToken.getToken());
        }
        agreeLayout.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                isAgree = !isAgree;
                if (isAgree) {
                    agreeCheck.setImageResource(R.drawable.icon_im_radio_checked);
                } else {
                    agreeCheck.setImageResource(R.drawable.icon_im_radio_unchecked);
                }
            }
        });
        loginLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                List<BIMUser> BIMUserList = adapter.getSelectUser();
                if (BIMUserList.size() == 0) {
                    Toast.makeText(VELoginActivity.this, R.string.login_must_select_user, Toast.LENGTH_SHORT).show();
                    return;
                }

                if (!isAgree) {
                    Toast.makeText(VELoginActivity.this, R.string.login_must_agree_proto, Toast.LENGTH_SHORT).show();
                    return;
                }
                doLogin(BIMUserList.get(0));
            }
        });
        initProtoString();
    }

    private void doLogin(BIMUser user) {
        Log.i(TAG, "doLogin() uid: " + user.getUuid());
        LoginModel.getToken(user.getUuid(), new LoginModel.OnGetTokenListener() {
            @Override
            public void onGetToken(String token) {
                loginIM(user.getUuid(), token);
            }

            @Override
            public void onFailed(Throwable t) {
                Toast.makeText(VELoginActivity.this, R.string.login_get_token_error, Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * 登陆 IMSDK
     *
     * @param uid
     * @param token
     */
    private void loginIM(long uid, String token) {
        Log.i(TAG, "loginIM uid:" + uid + " token:" + token);
        syncDialog = ProgressDialog.show(VELoginActivity.this, "稍等", "正在努力加载服务端数据");
        BIMUIClient.getInstance().login(uid, token, new BIMSimpleCallback() {
            @Override
            public void onSuccess() {
                Log.i(TAG, "login success()");
                SpUtils.getInstance().setLoginUserInfo(new UserToken(uid, token));
                Toast.makeText(VELoginActivity.this, "登录成功", Toast.LENGTH_SHORT).show();
                if (syncDialog != null) {
                    syncDialog.dismiss();
                }
                VEIMMainActivity.start(VELoginActivity.this);
                finish();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "login failed() code:" + code + " msg:" + code.getDesc());
                if (syncDialog != null) {
                    syncDialog.dismiss();
                }
                Toast.makeText(VELoginActivity.this, "登录失败", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void initProtoString(){
        String protoStr = getString(R.string.im_login_group_protocol_txt);
        SpannableString spannableString = new  SpannableString(protoStr);
        spannableString.setSpan(new ClickableSpan() {
            @Override
            public void updateDrawState(@NonNull TextPaint ds) {
                super.updateDrawState(ds);
                ds.setColor(getResources().getColor(R.color.business_im_sky_blue));
                ds.setUnderlineText(false);
            }

            @Override
            public void onClick(@NonNull View widget) {
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                Uri content_url = Uri.parse("https://bytedance.feishu.cn/docx/ENHxdrIbJoe3ggx9nq8c9hWXnxy");
                intent.setData(content_url);
                startActivity(intent);
            }
        },7,protoStr.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        tvProtocol.setText(spannableString);
        tvProtocol.setMovementMethod(LinkMovementMethod.getInstance());
        tvProtocol.setHighlightColor(Color.TRANSPARENT);
    }
}
