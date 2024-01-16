package com.bytedance.im.app.main.edit;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bytedance.im.app.R;
import com.bytedance.im.app.live.create.VEEditCommonActivity;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.user.api.model.BIMUserProfile;

import java.util.HashMap;
import java.util.Map;


public class VEUserProfileEditActivity extends Activity {
    private static final String TAG = "VEMineEditActivity";
    private static final int REQUEST_CODE_EDIT_PORTRAIT = 0;
    private static final int REQUEST_CODE_EDIT_NICK_NAME = 1;
    private static final int REQUEST_CODE_EDIT_EXT = 2;
    private static final String UID = "uid";
    private static final String MEMBER_NAME = "member_name";
    private static final String MEMBER_PORTRAIT_URL = "member_portrait_url";
    private static final String EDIT_ABLE = "edit_able";


    private View portraitLayout;
    private View nickNameLayout;
    private View aliasNameLayout;
    private View memberNameLayout;
    private View customLayout;
    private ImageView ivPortrait;
    private TextView tvNickName;
    private TextView tvMemberName;
    private TextView tvAliasName;
    private TextView tvCustom;
    private BIMUserFullInfo userFullInfo;
    private long showUid;
    private String memberName;
    private String memberPortraitUrl;
    public static void start(Activity activity, long uid){
        start(activity,  uid, null, null);
    }

    public static void start(Activity activity, long uid, String memberName, String memberPortraitUrl) {
        start(activity, false, uid, memberName, memberPortraitUrl);
    }

    public static void start(Activity activity, boolean editable, long uid, String memberName, String memberPortraitUrl) {
        Intent intent = new Intent(activity, VEUserProfileEditActivity.class);
        intent.putExtra(UID,uid);
        intent.putExtra(EDIT_ABLE, editable);
        if (!TextUtils.isEmpty(memberName)) {
            intent.putExtra(MEMBER_NAME, memberName);
        }
        if (!TextUtils.isEmpty(memberPortraitUrl)) {
            intent.putExtra(MEMBER_PORTRAIT_URL, memberPortraitUrl);
        }
        activity.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_mine_edit_layout);
        showUid = getIntent().getLongExtra(UID,0);
        boolean editAble = getIntent().getBooleanExtra(EDIT_ABLE,false);
        memberName = getIntent().getStringExtra(MEMBER_NAME);
        memberPortraitUrl = getIntent().getStringExtra(MEMBER_PORTRAIT_URL);
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        portraitLayout = findViewById(R.id.cl_mine_portrait);
        nickNameLayout = findViewById(R.id.cl_mine_name);
        memberNameLayout = findViewById(R.id.cl_member_name);
        ivPortrait = findViewById(R.id.iv_mine_portrait);
        tvNickName = findViewById(R.id.tv_mine_name);
        aliasNameLayout = findViewById(R.id.cl_alias_name);
        tvAliasName = findViewById(R.id.tv_alias_name);
        tvMemberName = findViewById(R.id.tv_member_name);
        tvCustom = findViewById(R.id.tv_mine_custom_1);
        portraitLayout.setOnClickListener(v -> VEMinePortraitEditActivity.startForResult(VEUserProfileEditActivity.this, REQUEST_CODE_EDIT_PORTRAIT));
        nickNameLayout.setOnClickListener(v -> {
            if (userFullInfo == null) {
                return;
            }
            VEEditCommonActivity.startForResult(VEUserProfileEditActivity.this, "修改昵称", userFullInfo.getNickName(), 10, REQUEST_CODE_EDIT_NICK_NAME);
        });
        customLayout = findViewById(R.id.cl_custom);
        customLayout.setOnClickListener(v -> {
            if (userFullInfo == null) {
                return;
            }
            BIMUserProfile userProfile = userFullInfo.getUserProfile();
            String extStr = VEUtils.mapToString(userProfile.getExt());
            VEEditCommonActivity.startForResult(VEUserProfileEditActivity.this, "自定义字段", extStr, Integer.MAX_VALUE, REQUEST_CODE_EDIT_EXT);
        });
        refreshUserProfile();
        if (!editAble) {
            portraitLayout.setEnabled(false);
            nickNameLayout.setEnabled(false);
            customLayout.setEnabled(false);
        }
    }

    private void updateUI(BIMUserFullInfo userFullInfo) {
        if(this.isFinishing()){
            return;
        }
        BIMUIClient.getInstance().getUserProvider().reloadUserInfo(showUid);   //刷新数据到内存
        this.userFullInfo = userFullInfo;
        String portraitUrl = userFullInfo.getPortraitUrl();
        if(!TextUtils.isEmpty(memberPortraitUrl)){
            portraitUrl = memberPortraitUrl;
        }
        Glide.with(ivPortrait.getContext())
                .load(portraitUrl)
                .dontAnimate()
                .placeholder(R.drawable.icon_recommend_user_default)
                .error(R.drawable.icon_recommend_user_default)
                .into(ivPortrait);
        String name = "用户" + userFullInfo.getUid();         //用户ID
        if (!TextUtils.isEmpty(userFullInfo.getNickName())) { //用户资料名
            name = userFullInfo.getNickName();
        }
        tvNickName.setText(name);
        tvAliasName.setText(userFullInfo.getAlias());
        tvMemberName.setText(memberName);
        tvCustom.setText(VEUtils.mapToString(userFullInfo.getUserProfile().getExt()));
        if (TextUtils.isEmpty(userFullInfo.getAlias())) {
            aliasNameLayout.setVisibility(View.GONE);
        } else {
            aliasNameLayout.setVisibility(View.VISIBLE);
//            aliasNameLayout.setVisibility(View.GONE);
        }

        if (TextUtils.isEmpty(memberName)) {
            memberNameLayout.setVisibility(View.GONE);
        } else {
            memberNameLayout.setVisibility(View.GONE);//暂时屏蔽
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (REQUEST_CODE_EDIT_NICK_NAME == requestCode) {
                String resultText = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
                updateUserNickName(resultText);
            } else if (REQUEST_CODE_EDIT_PORTRAIT == requestCode) {
                String resultText = data.getStringExtra(VEMinePortraitEditActivity.RESULT_PORTRAIT_URL);
                updateUserPortrait(resultText);
            } else if (REQUEST_CODE_EDIT_EXT == requestCode) {
                String resultExtStr = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
                Map<String, String> ext = VEUtils.stringToMap(resultExtStr, new HashMap<>());
                updateUserExt(ext);
            }
        }
    }

    /**
     * 获取用户信息
     */
    private void refreshUserProfile() {
        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfo(showUid, true,new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo fullInfo) {
                updateUI(fullInfo);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEUserProfileEditActivity.this, "获取成员资料失败", Toast.LENGTH_SHORT).show();
            }
        });
    }

    /**
     * 设置用户头像
     *
     * @param nickName
     */
    private void updateUserNickName(String nickName) {
        if (TextUtils.isEmpty(nickName) || nickName.trim().length() == 0) {
            Toast.makeText(VEUserProfileEditActivity.this, "昵称不可为空", Toast.LENGTH_SHORT).show();
            return;
        }
        BIMClient.getInstance().getService(BIMContactExpandService.class).setUserSelfNickName(nickName, new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo bimUserProfile) {
                Toast.makeText(VEUserProfileEditActivity.this, "设置昵称成功", Toast.LENGTH_SHORT).show();
                updateUI(bimUserProfile);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEUserProfileEditActivity.this, "设置昵称失败", Toast.LENGTH_SHORT).show();
            }
        });
    }


    /**
     * 更新自己的用户头像
     */
    private void updateUserPortrait(String url) {
        if (TextUtils.isEmpty(url) || url.trim().length() == 0) {
            Toast.makeText(VEUserProfileEditActivity.this, "头像不可为空", Toast.LENGTH_SHORT).show();
            return;
        }

        BIMClient.getInstance().getService(BIMContactExpandService.class).setUserSelfPortrait(url, new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo bimUserProfile) {
                Toast.makeText(VEUserProfileEditActivity.this, "更新头像成功", Toast.LENGTH_SHORT).show();
                updateUI(bimUserProfile);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                if (code == BIMErrorCode.BIM_PARAMETER_ERROR) {

                } else {
                    Toast.makeText(VEUserProfileEditActivity.this, "更新头像失败！code:" + code, Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void updateUserExt(Map<String, String> ext) {
        if (ext == null || ext.isEmpty()) {
//            Toast.makeText(VEUserProfileEditActivity.this, "额外信息不可为空", Toast.LENGTH_SHORT).show();
            return;
        }
        BIMClient.getInstance().getService(BIMContactExpandService.class).setUserSelfExt(ext, new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo bimUserProfile) {
                Toast.makeText(VEUserProfileEditActivity.this, "更新额外信息成功！", Toast.LENGTH_SHORT).show();
                updateUI(bimUserProfile);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEUserProfileEditActivity.this, "更新额外信息失败！", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
