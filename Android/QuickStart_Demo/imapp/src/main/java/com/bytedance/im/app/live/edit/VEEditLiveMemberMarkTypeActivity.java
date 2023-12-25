package com.bytedance.im.app.live.edit;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.common.utility.Lists;
import com.bytedance.im.app.R;
import com.bytedance.im.app.live.create.VEEditCommonActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.live.BIMLiveExpandService;
import com.bytedance.im.live.api.enmus.BIMLiveGroupMarkTypeAction;
import com.bytedance.im.live.api.model.BIMLiveGroupMarkMemberFailedInfo;

import java.util.ArrayList;
import java.util.List;

public class VEEditLiveMemberMarkTypeActivity extends Activity {
    public static String TAG = "VEEditLiveMemberMarkTypeActivity";
    public static String ARGS_CONVERSATION_SHORT_ID = "conversation_short_id";
    public static int REQUEST_EDIT_UID = 0;
    public static int REQUEST_EDIT_MARK_TYPE = 1;

    private TextView tvConfirm;
    private Switch swMarkOption;
    private View tvAddUser, tvAddMarkType;

    private long conversationShortId;
    private BIMLiveExpandService service;
    private List<Long> addUser = new ArrayList<>();
    private List<String> addMarkType = new ArrayList<>();

    public static void start(Activity activity, long conversationShortId) {
        Intent intent = new Intent(activity, VEEditLiveMemberMarkTypeActivity.class);
        intent.putExtra(ARGS_CONVERSATION_SHORT_ID, conversationShortId);
        activity.startActivity(intent);
    }

    @Override
    protected void onStart() {
        super.onStart();
        conversationShortId = getIntent().getLongExtra(ARGS_CONVERSATION_SHORT_ID, -1L);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_activity_edit_live_member_mark_type);

        tvAddUser = findViewById(R.id.cl_add_user);
        tvConfirm = findViewById(R.id.tv_confirm);
        swMarkOption = findViewById(R.id.sw_mark_option);
        tvAddMarkType = findViewById(R.id.cl_add_mark_type);
        service = BIMClient.getInstance().getServiceManager().getService(BIMLiveExpandService.class);
        tvConfirm.setOnClickListener(v -> {
            if (service != null) {
                if (!Lists.isEmpty(addUser)) {
                    service.markLiveGroupMemberList(conversationShortId, addUser, swMarkOption.isChecked() ? BIMLiveGroupMarkTypeAction.ADD : BIMLiveGroupMarkTypeAction.DELETE,
                            addMarkType, new BIMResultCallback<List<BIMLiveGroupMarkMemberFailedInfo>>() {
                                @Override
                                public void onSuccess(List<BIMLiveGroupMarkMemberFailedInfo> bimLiveGroupMarkMemberFailedInfos) {
                                    addUser.clear();
                                    addMarkType.clear();
                                    Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "标记成功", Toast.LENGTH_SHORT).show();
                                }

                                @Override
                                public void onFailed(BIMErrorCode code) {
                                    Log.e(TAG, "" + code);
                                    Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "标记失败: " + code, Toast.LENGTH_SHORT).show();
                                }
                            });
                } else {
                    if (swMarkOption.isChecked()) {
                        service.manageLiveGroupMarkTypes(conversationShortId, BIMLiveGroupMarkTypeAction.ADD, addMarkType, new BIMSimpleCallback() {
                            @Override
                            public void onSuccess() {
                                addMarkType.clear();
                                Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "添加标记成功", Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Log.e(TAG, "" + code);
                                if (code == BIMErrorCode.BIM_SERVER_CONVERSATION_MARK_TYPE_MORE_THAN_LIMIT) {
                                    Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "已设定20个标记类型", Toast.LENGTH_SHORT).show();
                                } else {
                                    Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "添加标记失败: " + code, Toast.LENGTH_SHORT).show();
                                }
                            }
                        });
                    } else {
                        service.manageLiveGroupMarkTypes(conversationShortId, BIMLiveGroupMarkTypeAction.DELETE, addMarkType, new BIMSimpleCallback() {
                            @Override
                            public void onSuccess() {
                                addMarkType.clear();
                                Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "删除标记成功", Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(VEEditLiveMemberMarkTypeActivity.this, "删除标记失败: " + code, Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                }
            }
        });

        findViewById(R.id.iv_back).setOnClickListener(v -> finish());

        tvAddUser.setOnClickListener(v -> {
            Intent intent = new Intent(VEEditLiveMemberMarkTypeActivity.this, VEEditLiveMemberActivity.class);
            startActivityForResult(intent, REQUEST_EDIT_UID);
        });
        tvAddMarkType.setOnClickListener(v -> {
            VEEditLiveMarkTypeActivity.startForResult(this, "添加标记", "", conversationShortId, 2048, REQUEST_EDIT_MARK_TYPE);
        });
    }

    private String splitToken = " ";
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && requestCode == REQUEST_EDIT_UID) {
            long[] ids = data.getLongArrayExtra(VEEditLiveMemberActivity.RESULT_IDS);
            addUser.clear();

            if (ids != null) {
                for (long id : ids) {
                    addUser.add(id);
                }
            }
        } else if (resultCode == RESULT_OK && requestCode == REQUEST_EDIT_MARK_TYPE) {
            try {
                String ids = data.getStringExtra(VEEditCommonActivity.RESULT_TEXT);
                addMarkType.clear();

                String[] tokens = ids.split(splitToken);
                for (String token: tokens) {
                    if (!TextUtils.isEmpty(token)) {
                        addMarkType.add(token);
                    }
                }
            } catch (Exception e) {
                addMarkType.clear();
                Toast.makeText(this, "标记类型错误", Toast.LENGTH_SHORT).show();
            }
        }
    }

}
