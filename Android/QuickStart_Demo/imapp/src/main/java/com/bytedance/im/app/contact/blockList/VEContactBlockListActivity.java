package com.bytedance.im.app.contact.blockList;

import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_ADD_SELF_BLACK_NOT_ALLOW;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_AlREADY_IN_BLACK;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_BLACK_MORE_THAN_LIMIT;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.InputFilter;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.main.edit.VEUserProfileEditActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.BIMFriendListener;
import com.bytedance.im.user.api.model.BIMBlackListFriendInfo;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class VEContactBlockListActivity extends Activity {
    private static int PAGE_SIZE = 20;
    public static String TAG = "VEContactBlockListActivity";

    private ImageView ivBack;
    private SwipeRefreshLayout swipe;
    private RecyclerView rvContactList;
    private TextView ivTitle, ivMoreAction;
    private final VEContactBlockListAdapter adapter = new VEContactBlockListAdapter();

    private BIMContactExpandService service = BIMClient.getInstance().getService(BIMContactExpandService.class);

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_fragment_contact_invite_list);

        ivBack = findViewById(R.id.iv_back);
        ivBack.setOnClickListener(v -> finish());

        ivTitle = findViewById(R.id.tv_contact_list_title);
        ivTitle.setText("黑名单");

        ivMoreAction = findViewById(R.id.tv_more_action);
        ivMoreAction.setText("拉黑");
        ivMoreAction.setOnClickListener(v -> {
            showAddContactDialog();
        });
        ivMoreAction.setVisibility(View.VISIBLE);

        rvContactList = findViewById(R.id.rv_contact_list);
        rvContactList.setLayoutManager(new LinearLayoutManager(this));

        rvContactList.setItemAnimator(null);
        adapter.setListener(new BlackListClickListener() {

            @Override
            public void onClick(VEContactBlackListData data) {

            }

            @Override
            public void onLongClick(VEContactBlackListData data) {
                showMenu(data.getUserFullInfo().getBlackListFriendInfo());
            }

            @Override
            public void onPortraitClick(VEContactBlackListData data) {
                VEUserProfileEditActivity.start(VEContactBlockListActivity.this,data.getUserFullInfo().getUid());
            }
        });

        rvContactList.setAdapter(adapter);
        swipe = findViewById(R.id.swipe);
        swipe.setEnabled(false);
        loadData();

        if (null != service) {
            service.addFriendListener(this.friendListener);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (null != service) {
            service.removeFriendListener(this.friendListener);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (null != service) {
            service.markFriendApplyRead(null);
        }
    }

    private void loadData() {
        if (null != service) {
            service.getBlackList(new BIMResultCallback<List<BIMUserFullInfo>>() {
                @Override
                public void onSuccess(List<BIMUserFullInfo> list) {
                    List<VEContactBlackListData> temp = new ArrayList();
                    for (BIMUserFullInfo info: list) {
                        temp.add(VEContactBlackListData.create(info));
                    }
                    Collections.sort(temp, VEContactBlackListData::compare);
                    adapter.appendData(temp, true);
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    Log.i(TAG,"onFailed code:"+code);
                }
            });
        }
    }

    private void showMenu(BIMBlackListFriendInfo data) {
        String[] items = new String[] { "解除拉黑" };
        new AlertDialog.Builder(this).setItems(items, (selectDialog, which) -> {
            if (which == 0) {
                selectDialog.dismiss();
                if (null != service) {
                    service.deleteFromBlackList(data.getUid(), new BIMSimpleCallback() {
                        @Override
                        public void onSuccess() {
                            Toast.makeText(VEContactBlockListActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(VEContactBlockListActivity.this, "操作失败: " + code, Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }
        }).show();
    }

    private void showAddContactDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        AlertDialog dialog = builder.setCancelable(false).show();

        if (dialog.getWindow() != null) {
            Window window = dialog.getWindow();
            window.setContentView(R.layout.ve_item_dialog_add_contact);
            window.clearFlags(WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM);

            EditText et = window.findViewById(R.id.et_uid);
            et.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
            TextView tvMain = window.findViewById(R.id.tv_main);
            TextView tvReject = window.findViewById(R.id.tv_reject);
            TextView tvConfirm = window.findViewById(R.id.tv_confirm);

            tvMain.setText("添加黑名单");

            tvConfirm.setOnClickListener(v -> {
                if (null == et.getText() || TextUtils.isEmpty(et.getText().toString())) {
                    Toast.makeText(VEContactBlockListActivity.this, "请输入uid", Toast.LENGTH_SHORT).show();
                } else {
                    long uid = Long.parseLong(et.getText().toString());
                    Constants.accountProvider.createUserExistChecker().check(Collections.singletonList(uid), new BIMResultCallback<Map<Long, Boolean>>() {
                        @Override
                        public void onSuccess(Map<Long, Boolean> longBooleanMap) {
                            if (!longBooleanMap.containsKey(uid) || !longBooleanMap.get(uid)) {
                                Toast.makeText(VEContactBlockListActivity.this, "uid不存在，请重新输入", Toast.LENGTH_SHORT).show();
                                return;
                            }
                            if (null != service) {
                                BIMBlackListFriendInfo blackListFriendInfo = new BIMBlackListFriendInfo();
                                blackListFriendInfo.setUid(uid);

                                service.checkUserInBlackList(Collections.singletonList(uid), new BIMResultCallback<Map<Long, Boolean>>() {
                                    @Override
                                    public void onSuccess(Map<Long, Boolean> longBooleanMap) {
                                        if (true == longBooleanMap.get(uid)) {
                                            Toast.makeText(VEContactBlockListActivity.this, "TA已经被你拉黑，请重新输入", Toast.LENGTH_SHORT).show();
                                            return;
                                        }
                                        service.addToBlackList(blackListFriendInfo, new BIMResultCallback<BIMUserFullInfo>() {
                                            @Override
                                            public void onSuccess(BIMUserFullInfo fullInfo) {
                                                Toast.makeText(VEContactBlockListActivity.this, "操作成功", Toast.LENGTH_SHORT).show();
                                                dialog.dismiss();
                                            }

                                            @Override
                                            public void onFailed(BIMErrorCode code) {
                                                Activity activity = VEContactBlockListActivity.this;
                                                if (code == BIM_SERVER_BLACK_MORE_THAN_LIMIT) {
                                                    Toast.makeText(activity, "已超出黑名单数量上限", Toast.LENGTH_SHORT).show();
                                                } else if (code == BIM_SERVER_ADD_SELF_BLACK_NOT_ALLOW) {
                                                    Toast.makeText(activity, "自己不能拉黑自己", Toast.LENGTH_SHORT).show();
                                                } else if (code == BIM_SERVER_AlREADY_IN_BLACK) {
                                                    Toast.makeText(activity, "TA已经被你拉黑，请重新输入", Toast.LENGTH_SHORT).show();
                                                } else {
                                                    Toast.makeText(activity, "操作失败：" + code, Toast.LENGTH_SHORT).show();
                                                }
                                            }
                                        });
                                    }

                                    @Override
                                    public void onFailed(BIMErrorCode code) {

                                    }
                                });
                            }
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {

                        }
                    });
                }
            });

            tvReject.setOnClickListener(v -> { dialog.dismiss(); });
        }
    }

    private BIMFriendListener friendListener = new BIMFriendListener() {
        @Override
        public void onFriendApply(BIMFriendApplyInfo applyInfo) {

        }

        @Override
        public void onFriendDelete(BIMUserFullInfo friendInfo) {
            VEContactBlackListData data = adapter.getData(friendInfo.getUid());
            if (data != null) {
                adapter.insertOrUpdateData(VEContactBlackListData.create(data.getUserFullInfo()));
            }
        }

        @Override
        public void onFriendUpdate(BIMUserFullInfo friendInfo) {
            VEContactBlackListData data = adapter.getData(friendInfo.getUid());
            if (data != null) {
                adapter.insertOrUpdateData(VEContactBlackListData.create(data.getUserFullInfo()));
            }
        }

        @Override
        public void onFriendAdd(BIMUserFullInfo friendInfo) {

        }

        @Override
        public void onFriendAgree(BIMFriendApplyInfo applyInfo) {

        }

        @Override
        public void onFriendRefuse(BIMFriendApplyInfo applyInfo) {

        }

        @Override
        public void onFriendApplyUnreadCountChanged(int count) {

        }

        @Override
        public void onBlackListAdd(BIMUserFullInfo userFullInfo) {
            adapter.insertOrUpdateData(VEContactBlackListData.create(userFullInfo));
        }

        @Override
        public void onBlackListDelete(BIMUserFullInfo userFullInfo) {
            adapter.removeData(VEContactBlackListData.create(userFullInfo));
        }

        @Override
        public void onBlackListUpdate(BIMUserFullInfo userFullInfo) {
            adapter.insertOrUpdateData(VEContactBlackListData.create(userFullInfo));
        }

        @Override
        public void onUserProfileUpdate(BIMUserFullInfo userFullInfo) {

        }
    };
}
