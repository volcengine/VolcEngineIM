package com.bytedance.im.app.in.login;

import android.app.Fragment;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.ui.api.interfaces.BIMAuthProvider;
import com.bytedance.im.ui.api.interfaces.BIMLoginListener;
import com.bytedance.im.ui.api.interfaces.BIMUidStrLoginListener;


public class VELoginFragment extends Fragment implements BIMAuthProvider {
    private static final String TAG = "VELoginFragment";
    private View loginLayout;
    private View initLayout;
    private TextView tvAppId;
    private TextView tvUId;
    private TextView tvToken;

    private BIMLoginListener loginListener;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.ve_im_activity_login_layout, container, false);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        view.findViewById(R.id.tv_login_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (loginListener != null) {
                    loginListener.onDebugClick();
                }
            }
        });
        tvUId = view.findViewById(R.id.tv_uid);
        tvToken = view.findViewById(R.id.tv_token);
        initLayout = view.findViewById(R.id.init_layout);
        loginLayout = view.findViewById(R.id.login_btn);
        tvAppId = view.findViewById(R.id.tv_app_id);
        if (Constants.APP_ENV == Constants.ENV_DEFAULT) {
            tvAppId.setText("APPID:" + Constants.APP_ID);   //默认国内
        } else if (Constants.APP_ENV == Constants.ENV_i18n) {
            tvAppId.setText("APPID:" + Constants.APP_ID_I18N);  //海外
        }
        tvUId.setText("用户ID:" + Constants.uid);
        tvToken.setText("token:" + Constants.token);
        loginLayout.setEnabled(false);
        loginLayout.setBackgroundResource(R.drawable.shape_im_conversation_msg_send_disable_bg);
        initLayout.setOnClickListener(v -> {
            if (null != loginListener) {
                loginListener.doInit();
                loginLayout.setEnabled(true);
                loginLayout.setBackgroundResource(R.drawable.shape_im_conversation_msg_send_bg);
            }
        });
        loginLayout.setOnClickListener(v -> {
            if (null != loginListener) {
                loginListener.doLogin(Constants.uid, Constants.token);
            }
        });
    }

    @Override
    public void setLoginListener(BIMLoginListener listener) {
        loginListener = listener;
    }

    @Override
    public void setLoginUidStrListener(BIMUidStrLoginListener listener) {

    }
}
