package com.bytedance.im.app.uidstr;

import android.app.Fragment;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.uidstr.token.TokenHelper;
import com.bytedance.im.imcloud.internal.utils.IMLog;
import com.bytedance.im.ui.api.interfaces.BIMAuthProvider;
import com.bytedance.im.ui.api.interfaces.BIMLoginListener;
import com.bytedance.im.ui.api.interfaces.BIMUidStrLoginListener;

public class VEUidDebugLoginFragment extends Fragment implements BIMAuthProvider, CompoundButton.OnCheckedChangeListener {
    private static final String TAG = "VEUidDebugLoginFragment";
    private EditText editText;
    private View loginBtn;
    private RadioGroup radioGroup;
    private int CHECK_NUMBER_LOGIN = 0;
    private int CHECK_STRING_LOGIN = 1;
    private int curCheckID = CHECK_STRING_LOGIN;
    private RadioButton radioNumber;
    private RadioButton radioString;

    private BIMUidStrLoginListener uidStrLoginListener;
    private BIMLoginListener loginListener;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i(TAG,"onCreate()"+this);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        Log.i(TAG,"onCreateView()"+this);
        View v = inflater.inflate(R.layout.ve_im_uid_str_activity_login_layout, container, false);
        editText = v.findViewById(R.id.et_phone);
        v.findViewById(R.id.ll_login).setOnClickListener(v12 -> {
            if (uidStrLoginListener != null) {
                uidStrLoginListener.onDebugClick();
            }
        });
        radioNumber = v.findViewById(R.id.radio_btn_number);
        radioString = v.findViewById(R.id.radio_btn_string);
        radioNumber.setOnCheckedChangeListener(this);
        radioString.setOnCheckedChangeListener(this);
        curCheckID = CHECK_STRING_LOGIN;
        loginBtn = v.findViewById(R.id.btn_login);
        radioGroup = v.findViewById(R.id.radio_group);
        loginBtn.setOnClickListener(v1 -> {
            String text = editText.getText().toString();
            if (TextUtils.isEmpty(text)) {
                Toast.makeText(getActivity(), "请输入uid", Toast.LENGTH_SHORT).show();
                return;
            }
            if (curCheckID == CHECK_NUMBER_LOGIN) {
                logInUidNumber(text);
            } else if (curCheckID == CHECK_STRING_LOGIN) {
                loginUidStr(text);
            }
            SpUtils.getInstance().setLoginUidType(curCheckID);
        });
        return v;
    }

    @Override
    public void onResume() {
        super.onResume();
        Log.i(TAG,"onResume()"+this);
        if (loginListener != null) {
            loginListener.doInit();
        }
        curCheckID = SpUtils.getInstance().getLastLoginUidType();
        radioNumber.setChecked(curCheckID == CHECK_NUMBER_LOGIN);
        radioString.setChecked(curCheckID == CHECK_STRING_LOGIN);
        updateCheck();
        //缓存登录
        if (curCheckID == CHECK_NUMBER_LOGIN) {
            if (loginListener != null) {
                loginListener.onProtoAgree(true, -1, "");
            }
        } else if (curCheckID == CHECK_STRING_LOGIN) {
            if (uidStrLoginListener != null) {
                uidStrLoginListener.onProtoAgree("", "");
            }
        }
    }

    private void logInUidNumber(String text) {
        Log.i(TAG,"logInUidNumber: "+text);
        long uid = -1;
        try {
            uid = Long.parseLong(text);
        } catch (Exception e) {
            Toast.makeText(getActivity(), "请输入数字", Toast.LENGTH_SHORT).show();
        }
        if (uid <= 0) {
            return;
        }

        TokenHelper tokenHelper = new TokenHelper(getActivity().getApplicationContext(), SpUtils.getInstance().getEnv(), SpUtils.getInstance().getPpeSwimLane());
        long finalUid = uid;
        tokenHelper.getToken(uid, VEUidStringAccountProvider.appID, new TokenHelper.GetTokenListener() {

            @Override
            public void onGetToken(String token) {
                Log.i(TAG, "onGetToken token: " + token);
                loginListener.doLogin(finalUid, token);
            }

            @Override
            public void onFailed(Throwable e) {
                if(isAdded()){
                    Toast.makeText(getActivity(), "获取token失败", Toast.LENGTH_SHORT).show();
                }
            }
        });

    }


    private void loginUidStr(String uidStr) {
        Log.i(TAG,"loginUidStr: "+uidStr);
        TokenHelper tokenHelper = new TokenHelper(getActivity().getApplicationContext(), SpUtils.getInstance().getEnv(), SpUtils.getInstance().getPpeSwimLane());
        tokenHelper.getTokenWithStrUid(uidStr, VEUidStringAccountProvider.appID, new TokenHelper.GetTokenListener() {

            @Override
            public void onGetToken(String token) {
                Log.i(TAG, "onGetToken token: " + token);
                uidStrLoginListener.doLogin(uidStr, token);

            }

            @Override
            public void onFailed(Throwable e) {
                Toast.makeText(getActivity(), "获取token失败", Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    public void setLoginListener(BIMLoginListener listener) {
        loginListener = listener;
    }

    @Override
    public void setLoginUidStrListener(BIMUidStrLoginListener listener) {
        uidStrLoginListener = listener;
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        if (isChecked) {
            int id = buttonView.getId();
            if (id == R.id.radio_btn_number) {
                curCheckID = CHECK_NUMBER_LOGIN;
            } else if (id == R.id.radio_btn_string) {
                curCheckID = CHECK_STRING_LOGIN;
            }
        }
        updateCheck();
    }


    private void updateCheck() {
        if (curCheckID == CHECK_NUMBER_LOGIN) {
            editText.setHint("请输入用户 uid [数字类型]");
        } else if (curCheckID == CHECK_STRING_LOGIN) {
            editText.setHint("请输入用户 uid [字符类型]");
        }
    }
}
