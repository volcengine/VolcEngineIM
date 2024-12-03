package com.bytedance.im.app.profile;

import android.app.Activity;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.Nullable;

import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.user.api.model.BIMUserProfile;
import com.bytedance.im.ui.starter.ModuleStarter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class VEUserProfileEditActivity extends Activity {
    private static final String TAG = "VEMineEditActivity";
    private static final int REQUEST_CODE_EDIT_PORTRAIT = 0;
    private static final int REQUEST_CODE_EDIT_NICK_NAME = 1;
    private static final int REQUEST_CODE_EDIT_EXT = 2;


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
    private String conversationId;
    private BIMMember bimMember;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_mine_edit_layout);
        showUid = getIntent().getLongExtra(ModuleStarter.MODULE_KEY_UID, 0);
        conversationId = getIntent().getStringExtra(ModuleStarter.MODULE_KEY_CID);
        boolean editAble = BIMClient.getInstance().getCurrentUserID() == showUid;
        findViewById(R.id.iv_back).setOnClickListener(v -> finish());
        findViewById(R.id.action_title).setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                copyUidToBoard();
                return false;
            }
        });
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
            VEProfileEditCommonActivity.startForResult(VEUserProfileEditActivity.this, "修改昵称", userFullInfo.getNickName(), 10, REQUEST_CODE_EDIT_NICK_NAME);
        });
        customLayout = findViewById(R.id.cl_custom);
        customLayout.setOnClickListener(v -> {
            if (userFullInfo == null) {
                return;
            }
            BIMUserProfile userProfile = userFullInfo.getUserProfile();
            String extStr = VEProfileUtils.mapToString(userProfile.getExt());
            VEProfileEditCommonActivity.startForResult(VEUserProfileEditActivity.this, "自定义字段", extStr, Integer.MAX_VALUE, REQUEST_CODE_EDIT_EXT);
        });
        refreshUserProfile();
        if (!editAble) {
            portraitLayout.setEnabled(false);
            nickNameLayout.setEnabled(false);
            customLayout.setEnabled(false);
        }
    }

    private void updateUI(BIMUserFullInfo userFullInfo, BIMMember member) {
        if (this.isFinishing()) {
            return;
        }
        BIMUIClient.getInstance().getUserProvider().reloadUserInfo(showUid);   //刷新数据到内存
        this.userFullInfo = userFullInfo;
        String portraitUrl = userFullInfo.getPortraitUrl();
        String memberName = "";
        if (member != null) {
            if (!TextUtils.isEmpty(member.getAvatarUrl())) {
                portraitUrl = member.getAvatarUrl();
            }
            memberName = member.getAlias();
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
        tvCustom.setText(VEProfileUtils.mapToString(userFullInfo.getUserProfile().getExt()));
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
                String resultText = data.getStringExtra(VEProfileEditCommonActivity.RESULT_TEXT);
                updateUserNickName(resultText);
            } else if (REQUEST_CODE_EDIT_PORTRAIT == requestCode) {
                String resultText = data.getStringExtra(VEMinePortraitEditActivity.RESULT_PORTRAIT_URL);
                updateUserPortrait(resultText);
            } else if (REQUEST_CODE_EDIT_EXT == requestCode) {
                String resultExtStr = data.getStringExtra(VEProfileEditCommonActivity.RESULT_TEXT);
                Map<String, String> ext = VEProfileUtils.stringToMap(resultExtStr, new HashMap<>());
                updateUserExt(ext);
            }
        }
    }

    /**
     * 获取用户信息
     */
    private void refreshUserProfile() {

        BIMClient.getInstance().getService(BIMContactExpandService.class).getUserFullInfo(showUid, true, new BIMResultCallback<BIMUserFullInfo>() {
            @Override
            public void onSuccess(BIMUserFullInfo fullInfo) {
                if (!TextUtils.isEmpty(conversationId)) {
                    BIMClient.getInstance().getConversationMemberList(conversationId, new BIMResultCallback<List<BIMMember>>() {
                        @Override
                        public void onSuccess(List<BIMMember> memberList) {
                            for (BIMMember member : memberList) {
                                if (member.getUserID() == showUid) {
                                    bimMember = member;
                                    break;
                                }
                            }
                            updateUI(fullInfo, bimMember);

                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {

                        }
                    });
                } else {
                    updateUI(fullInfo, bimMember);
                }
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
                updateUI(bimUserProfile, bimMember);
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
                updateUI(bimUserProfile, bimMember);
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
                updateUI(bimUserProfile, bimMember);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VEUserProfileEditActivity.this, "更新额外信息失败！", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void copyUidToBoard() {
        ClipData mClipData = ClipData.newPlainText("showUid", "" + showUid);
        ((ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(mClipData);
        Toast.makeText(this, "已复制uid: " + showUid, Toast.LENGTH_SHORT).show();
    }
}
