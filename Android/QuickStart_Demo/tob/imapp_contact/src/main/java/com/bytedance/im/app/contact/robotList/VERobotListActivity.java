package com.bytedance.im.app.contact.robotList;

import static com.bytedance.im.ui.starter.ModuleStarter.MODULE_KEY_TITLE;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.bytedance.im.app.contact.R;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.user.BIMContactExpandService;
import com.bytedance.im.user.api.model.BIMUserFullInfo;
import com.bytedance.im.user.api.model.BIMUserProfile;

import java.util.ArrayList;
import java.util.List;

public class VERobotListActivity extends Activity {
    public static String TAG = "VERobotListActivity";
    public static String SELECT_TAG = "UID";

    public static int MODE_SELECT_SINGLE = 1;
    public static int MODE_VIEW = 2;

    private ImageView ivBack;
    private int mode = MODE_VIEW;
    private SwipeRefreshLayout swipe;
    private RecyclerView rvContactList;
    private static UserChecker userChecker = null;
    private RobotListAdapter adapter = new RobotListAdapter();

    public static void start(Context context) {
        context.startActivity(new Intent(context, VERobotListActivity.class));
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.ve_im_fragment_contact_invite_list);

        ivBack = findViewById(R.id.iv_back);
        ivBack.setOnClickListener(v -> finish());
        rvContactList = findViewById(R.id.rv_contact_list);
        rvContactList.setLayoutManager(new LinearLayoutManager(this));

        Intent intent = getIntent();
        String configTitle = intent.getStringExtra(MODULE_KEY_TITLE);
        if (configTitle == null) {
            ((TextView)findViewById(R.id.tv_contact_list_title)).setText("机器人列表");
        } else {
            ((TextView)findViewById(R.id.tv_contact_list_title)).setText(configTitle);
        }

        rvContactList.setItemAnimator(null);
        rvContactList.setAdapter(adapter);
        adapter.setOnclickListener(new RobotListAdapter.OnClickListener() {
            @Override
            public void onClick(BIMUserFullInfo profile) {
                BIMClient.getInstance().createSingleConversation(profile.getUid(), new BIMResultCallback<BIMConversation>() {
                    @Override
                    public void onSuccess(BIMConversation conversation) {
                        if (conversation.getLastMessage() == null) {
                            BIMClient.getInstance().markNewChat(conversation.getConversationID(), true, null);
                        }
                        BIMUIClient.getInstance().getModuleStarter().startMessageModule(VERobotListActivity.this, conversation.getConversationID());
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        Log.e(TAG, "create conversation failed: " + profile.getUid());
                    }
                });
            }
        });
        swipe = findViewById(R.id.swipe);
        swipe.setEnabled(false);
        loadData();
    }

    private void loadData() {
        BIMClient.getInstance().getService(BIMContactExpandService.class).getAllRobotFullInfo(true, new BIMResultCallback<List<BIMUserFullInfo>>() {

            @Override
            public void onSuccess(List<BIMUserFullInfo> profiles) {
                if (userChecker != null && profiles != null) {
                    List<BIMUserFullInfo> newProfiles = new ArrayList<>();

                    for (BIMUserFullInfo profile: profiles) {
                        if (userChecker.isValid(profile)) {
                            newProfiles.add(profile);
                        }
                    }
                    profiles = newProfiles;
                }

                adapter.addData(profiles);
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(VERobotListActivity.this, "操作失败", Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        RobotDataWrapper selectData = adapter.getSelectedData();
        if (selectData != null && selectData.getIsSelected()) {
            Intent intent = new Intent();
            intent.putExtra(SELECT_TAG, selectData.getRawData().getUid());
            setResult(RESULT_OK, intent);
        }
    }

    public static void injectUserChecker(UserChecker injectChecker) {
        userChecker = injectChecker;
    }

    public interface UserChecker {
        boolean isValid(BIMUserFullInfo fullInfo);
    }
}