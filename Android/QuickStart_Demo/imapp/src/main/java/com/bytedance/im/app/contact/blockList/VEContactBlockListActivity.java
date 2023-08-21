package com.bytedance.im.app.contact.blockList;

import android.app.Activity;
import android.app.AlertDialog;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bytedance.im.app.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMFriendApplyInfo;

public class VEContactBlockListActivity extends Activity {
    private static int PAGE_SIZE = 20;
    public static String TAG = "VEContactBlockListActivity";

    private ImageView ivBack;
    private boolean mHasMore = true;
    private SwipeRefreshLayout swipe;
    private boolean mIsLoading = false;
    private RecyclerView rvContactList;
    private long mCursor = Long.MAX_VALUE;
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
        rvContactList.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                        >= recyclerView.computeVerticalScrollRange()) {
                    loadData();
                }
            }
        });

        rvContactList.setItemAnimator(null);
        adapter.setListener(new BlockListClickListener() {
            @Override
            public void onClick(BIMFriendApplyInfo dataWrapper) {

            }

            @Override
            public void onLongClick(BIMFriendApplyInfo dataWrapper) {
                showMenu();
            }
        });

        rvContactList.setAdapter(adapter);
        swipe = findViewById(R.id.swipe);
        swipe.setEnabled(false);
        loadData();

        if (null != service) {
//            service.addFriendListener(this.friendListener);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (null != service) {
//            service.removeFriendListener(this.friendListener);
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

    }

    private void showMenu() {
        String[] items = new String[] { "解除拉黑" };
        new AlertDialog.Builder(this).setItems(items, (selectDialog, which) -> {
            if (which == 0) {
                selectDialog.dismiss();
                //TODO remove
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
            TextView tvMain = window.findViewById(R.id.tv_main);
            TextView tvReject = window.findViewById(R.id.tv_reject);
            TextView tvConfirm = window.findViewById(R.id.tv_confirm);

            tvMain.setText("添加黑名单");

            tvConfirm.setOnClickListener(v -> {
                if (null == et.getText() || TextUtils.isEmpty(et.getText().toString())) {
                    Toast.makeText(VEContactBlockListActivity.this, "请输入uid", Toast.LENGTH_SHORT).show();
                } else {
                    if (null != service) {
                        //TODO 需要check


                    }
                }
            });

            tvReject.setOnClickListener(v -> { dialog.dismiss(); });
        }
    }
}
