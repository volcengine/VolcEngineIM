package com.bytedance.im.app.main;


import android.app.AlertDialog;
import android.app.Fragment;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.BuildConfig;
import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.in.login.VELoginActivity;
import com.bytedance.im.app.in.login.model.UserToken;
import com.bytedance.im.app.utils.VECancelUtils;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConnectStatus;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMConnectListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.utils.BIMUINameUtils;


public class VEMineFragment extends Fragment {
    private static final String TAG = "VEMineFragment";
    private ImageView ivPortrait;
    private TextView tvName;
    private TextView tvUid;
    private TextView tvAppId;
    private TextView tvAppVersionName;
    private TextView tvSDKVersionName;
    private TextView tvConnect;
    private TextView tvDid;
    private View flProto;
    private View flPolicy;
    private View flLogout;
    private View flPermission;
    private View topPanel;
    private View flDId;
    private View govRecord;
    private View flDeleteAccount;

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = View.inflate(container.getContext(), R.layout.ve_im_fragment_mine, null);
        ivPortrait = view.findViewById(R.id.iv_mine_img);
        tvName = view.findViewById(R.id.tv_mine_name);
        tvUid = view.findViewById(R.id.tv_mine_uuid);
        tvAppId = view.findViewById(R.id.tv_appid);
        tvDid = view.findViewById(R.id.tv_sdk_did);
        topPanel = view.findViewById(R.id.cl_user_info);
        tvAppVersionName = view.findViewById(R.id.tv_app_version_name);
        tvSDKVersionName = view.findViewById(R.id.tv_sdk_version_name);
        tvConnect = view.findViewById(R.id.tv_connect_status);
        flLogout = view.findViewById(R.id.fl_logout);
        flProto = view.findViewById(R.id.fl_proto);
        flPolicy = view.findViewById(R.id.fl_privacy_policy);
        flPermission = view.findViewById(R.id.fl_permission);
        flDId = view.findViewById(R.id.fl_sdk_did);
        govRecord = view.findViewById(R.id.gov_record_number);
        flDeleteAccount = view.findViewById(R.id.fl_delete_account);
        if (VEUtils.isSourceCode()) {
            flProto.setVisibility(View.GONE);
            flPolicy.setVisibility(View.GONE);
            flPermission.setVisibility(View.GONE);
            govRecord.setVisibility(View.GONE);
            flDeleteAccount.setVisibility(View.GONE);
        }

        Log.i(TAG, "uikit version: " + BIMUIClient.getInstance().getVersion());
        Log.i(TAG, " imSdk version: " + BIMClient.getInstance().getVersion());

        String uidStr = BIMClient.getInstance().getCurrentUserIDString();
        if (TextUtils.isEmpty(uidStr)) {
            tvUid.setText(String.valueOf(BIMClient.getInstance().getCurrentUserID())); //数字uid
        } else {
            tvUid.setText(uidStr);  //字符串uid
        }

        tvAppId.setText(String.valueOf(BIMUIClient.getInstance().getAppId()));
        tvAppVersionName.setText(BuildConfig.VERSION_NAME);
        tvSDKVersionName.setText(BIMUIClient.getInstance().getVersion());
        flLogout.setOnClickListener(v -> doLogout());
        topPanel.setOnClickListener(v -> BIMUIClient.getInstance().getModuleStarter().startProfileModule(getActivity(),BIMClient.getInstance().getCurrentUserID()));
        topPanel.setOnLongClickListener(v -> {
            copyUidToBoard(v.getContext());
            return true;
        });
        flDId.setOnClickListener(v -> copyDidToBoard(v.getContext()));
        initCancelItem(view, this::doLogout);
        updateConnectStatus(BIMUIClient.getInstance().getConnectStatus());
        BIMUIClient.getInstance().addConnectListenerListener(connectListener);
        flProto.setOnClickListener(v -> toProtocol("https://www.volcengine.com/docs/6348/975891"));
        flPolicy.setOnClickListener(v -> toProtocol("https://www.volcengine.com/docs/6348/975890"));
        flPermission.setOnClickListener(v -> toProtocol("https://www.volcengine.com/docs/6348/975909"));
        govRecord.setOnClickListener(v -> toProtocol("https://beian.miit.gov.cn/#/Integrated/index"));
        BIMClient.getInstance().getSDKDid(new BIMResultCallback<String>() {
            @Override
            public void onSuccess(String s) {
                tvDid.setText(s);
            }

            @Override
            public void onFailed(BIMErrorCode code) {

            }
        });
        BIMUIClient.getInstance().getUserProvider().addUserUpdateListener((uid, user) -> {
            if (uid == BIMClient.getInstance().getCurrentUserID()) {
                updateMyProfileUI(user);
            }
        });
        initTag(view);
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(BIMClient.getInstance().getCurrentUserID(), new BIMResultCallback<BIMUIUser>() {
            @Override
            public void onSuccess(BIMUIUser bimuiUser) {
                updateMyProfileUI(bimuiUser);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "onFailed code: " + code);
            }
        });
        BIMUIClient.getInstance().getUserProvider().reloadUserInfo(BIMUIClient.getInstance().getCurUserId());
    }

    private void updateMyProfileUI(BIMUIUser user) {
        if (user == null) return;
        Log.i(TAG, "onSuccess nickName" + user.getNickName());
        if (isAdded()) {
            Glide.with(getActivity()).load(user.getPortraitUrl())
                    .placeholder(R.drawable.icon_recommend_user_default)
                    .error(R.drawable.icon_recommend_user_default)
                    .into(ivPortrait);
            tvName.setText(BIMUINameUtils.getShowNickName(user));
        }
    }

    private BIMConnectListener connectListener = new BIMConnectListener() {
        @Override
        public void onConnectStatusChanged(BIMConnectStatus status) {
            Log.i(TAG, "onConnectStatusChanged() status: " + status + " thread:" + Thread.currentThread());
            updateConnectStatus(status);
        }

        @Override
        public void onTokenInvalid(BIMErrorCode code) {
//            Toast.makeText(getActivity(), "token 过期,请重新登录", Toast.LENGTH_SHORT).show();
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setMessage("账号已过期，请重新登录");
            builder.setPositiveButton("确定", new DialogInterface.OnClickListener() {

                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    doLogout();
                }
            });
            builder.setCancelable(false);
            builder.show();
        }
    };

    private void doLogout() {
        BIMUIClient.getInstance().logout();
        SpUtils.getInstance().setLoginUserInfo(null);
        SpUtils.getInstance().setLoginUserStrInfo(null);
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

    private void copyUidToBoard(Context context) {
        String uidStr = BIMClient.getInstance().getCurrentUserIDString();
        String mineUid = "";
        if (TextUtils.isEmpty(uidStr)) {
            mineUid = "" + BIMClient.getInstance().getCurrentUserID();//数字uid
        } else {
            mineUid = uidStr;   //字符串uid
        }
        ClipData mClipData = ClipData.newPlainText("UID", mineUid);
        ((ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(mClipData);
        Toast.makeText(getActivity(), "已复制 uid: " + mineUid, Toast.LENGTH_SHORT).show();
    }

    private void copyDidToBoard(Context context) {
        String did = tvDid.getText().toString();
        ClipData mClipData = ClipData.newPlainText("DID", did);
        ((ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(mClipData);
        Toast.makeText(getActivity(), "已复制 did: " + did, Toast.LENGTH_SHORT).show();
    }

    private void initCancelItem(View view, VECancelUtils.CancelAccountCallback callback) {
        FrameLayout flDeleteAccount = view.findViewById(R.id.fl_delete_account);
        flDeleteAccount.setOnClickListener(fl -> {
            VECancelUtils.showCancelDialog(view.getContext(), callback);
        });
    }

    private void toProtocol(String url) {
        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        Uri content_url = Uri.parse(url);
        intent.setData(content_url);
        startActivity(intent);
    }

    /**
     * 提供环境，打包等调试信息
     *
     * @param view
     */
    private void initTag(View view) {
        TextView tag = view.findViewById(R.id.tag);
        String label = view.getContext().getResources().getString(R.string.im_app_app_tag) + "\n";
        label += "env: "+BIMClient.getInstance().getEnv()+"\n";
        UserToken userToken = SpUtils.getInstance().getLoginUserInfo();
        if (userToken != null) {
            label += userToken.getUid();
        }
        tag.setText(label);
        boolean isQA = TextUtils.isEmpty(label.trim());
        if (isQA) {
            tag.setVisibility(View.GONE);
        } else {
            tag.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }
}
