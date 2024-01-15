package com.bytedance.im.app.login;

import android.app.Fragment;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
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
import com.bytedance.im.interfaces.BIMAuthProvider;
import com.bytedance.im.interfaces.BIMLoginListener;
import com.bytedance.im.ui.api.BIMUIUser;

public class VELoginFragment extends Fragment implements BIMAuthProvider {
    private static final String TAG = "VELoginFragment";
    private ImageView agreeCheck;
    private View agreeLayout;
    private View loginLayout;
    private boolean isAgree = false;
    private TextView tvProtocol;
    private TextView tvAppId;
    private TextView tvUId;
    private TextView tvNickName;
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
        tvNickName = view.findViewById(R.id.tv_nick_name);
        agreeCheck = view.findViewById(R.id.agree_check);
        agreeLayout = view.findViewById(R.id.agree);
        loginLayout = view.findViewById(R.id.login_btn);
        tvProtocol = view.findViewById(R.id.tv_protocol);
        tvAppId = view.findViewById(R.id.tv_app_id);
        if (Constants.APP_ENV == Constants.ENV_DEFAULT) {
            tvAppId.setText("APPID:" + Constants.APP_ID);   //默认国内
        } else if (Constants.APP_ENV == Constants.ENV_i18n) {
            tvAppId.setText("APPID:" + Constants.APP_ID_I18N);  //海外
        }
        tvUId.setText("用户ID:" + Constants.uid);
        tvNickName.setText("用户名称:" + Constants.uid);
        tvToken.setText("token:" + Constants.token);
        agreeLayout.setOnClickListener(new View.OnClickListener() {

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
                if (!isAgree) {
                    Toast.makeText(getActivity(), R.string.login_must_agree_proto, Toast.LENGTH_SHORT).show();
                    return;
                }
                if (null != loginListener) {
                    loginListener.doLogin(Constants.uid, Constants.token);
                }
            }
        });
        initProtoString();
        if (loginListener != null) {
            loginListener.onProtoAgree(false, Constants.uid, Constants.token);
        }
    }

    private void initProtoString() {
        String protoStr = getString(R.string.im_login_group_protocol_txt);
        SpannableString spannableString = new SpannableString(protoStr);
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
                Uri content_url = Uri.parse("https://www.volcengine.com/docs/6348/975891");
                intent.setData(content_url);
                startActivity(intent);
            }
        }, 7, 11, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

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
                Uri content_url = Uri.parse("https://www.volcengine.com/docs/6348/975890");
                intent.setData(content_url);
                startActivity(intent);
            }
        }, 14, protoStr.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        tvProtocol.setText(spannableString);
        tvProtocol.setMovementMethod(LinkMovementMethod.getInstance());
        tvProtocol.setHighlightColor(Color.TRANSPARENT);
    }

    @Override
    public void setLoginListener(BIMLoginListener listener) {
        loginListener = listener;
    }
}
