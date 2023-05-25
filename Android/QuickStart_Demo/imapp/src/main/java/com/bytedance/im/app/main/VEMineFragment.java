package com.bytedance.im.app.main;


import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.BuildConfig;
import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.core.api.enums.BIMConnectStatus;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.app.login.VELoginActivity;
import com.bytedance.im.ui.user.BIMUser;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.core.api.interfaces.BIMConnectListener;


public class VEMineFragment extends Fragment {
    private static final String TAG = "VEMineFragment";
    private ImageView ivPortrait;
    private TextView tvName;
    private TextView tvUid;
    private TextView tvAppId;
    private TextView tvAppVersionName;
    private TextView tvSDKVersionName;
    private TextView tvConnect;
    private View flLogout;

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = View.inflate(container.getContext(), R.layout.ve_im_fragment_mine, null);
        ivPortrait = view.findViewById(R.id.iv_mine_img);
        tvName = view.findViewById(R.id.tv_mine_name);
        tvUid = view.findViewById(R.id.tv_mine_uuid);
        tvAppId = view.findViewById(R.id.tv_appid);
        tvAppVersionName = view.findViewById(R.id.tv_app_version_name);
        tvSDKVersionName = view.findViewById(R.id.tv_sdk_version_name);
        tvConnect = view.findViewById(R.id.tv_connect_status);
        flLogout = view.findViewById(R.id.fl_logout);
        BIMUser user = UserManager.geInstance().getUserProvider().getUserInfo(BIMUIClient.getInstance().getCurUserId());
        if (user == null) {
            ivPortrait.setImageResource(R.drawable.icon_recommend_user_default);
        } else {
            ivPortrait.setImageResource(user.getHeadImg());
        }
        tvName.setText(user.getNickName());
        tvUid.setText(String.valueOf(user.getUuid()));
        tvAppId.setText(String.valueOf(BIMUIClient.getInstance().getAppId()));
        tvAppVersionName.setText(BuildConfig.VERSION_NAME);
        tvSDKVersionName.setText(BIMUIClient.getInstance().getVersion());
        flLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                doLogout();
            }
        });

        updateConnectStatus(BIMUIClient.getInstance().getConnectStatus());
        BIMUIClient.getInstance().addConnectListenerListener(connectListener);
        return view;
    }

    private BIMConnectListener connectListener = new BIMConnectListener() {
        @Override
        public void onConnectStatusChanged(BIMConnectStatus status) {
            Log.i(TAG, "onConnectStatusChanged() status: " + status + " thread:" + Thread.currentThread());
            updateConnectStatus(status);
        }

        @Override
        public void onTokenInvalid(BIMErrorCode code) {
            Toast.makeText(getActivity(), "token 过期,请重新登录", Toast.LENGTH_SHORT).show();
            doLogout();
        }
    };

    private void doLogout() {
        BIMUIClient.getInstance().logout();
        SpUtils.getInstance().setLoginUserInfo(null);
        VELoginActivity.start(getActivity());
        getActivity().finish();
    }

    private void updateConnectStatus(BIMConnectStatus status) {
        if (status == BIMConnectStatus.BIM_CONNECT_STATUS_CONNECTED) {
            tvConnect.setText(R.string.im_connected);
        } else if (status == BIMConnectStatus.BIM_CONNECT_STATUS_CONNECTING) {
            tvConnect.setText(R.string.im_connecting);
        } else {
            tvConnect.setText(R.string.im_disconnected);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        BIMUIClient.getInstance().removeConnectListener(connectListener);
    }
}
