package com.bytedance.im.app.main;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bytedance.im.app.BuildConfig;
import com.bytedance.im.app.R;
import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.app.contact.mainList.VEContactListFragment;
import com.bytedance.im.app.user.VEDefaultAccountProvider;
import com.bytedance.im.app.utils.VEUtils;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;

import java.util.List;

public class VEIMMainActivity extends Activity implements View.OnClickListener {
    private static int SELECTED_COLOR = 0xFF9770FF;
    private static int UNSELECTED_COLOR = Color.BLACK;

    private static final String TAG = "VEIMMainActivity";
    private Fragment conversationListFragment;
    private Fragment veMineFragment;
    private Fragment liveGroupFragment;
    private Fragment contactFragment;
    private View convTab;
    private View mineTab;
    private View liveGroupTab;
    private TextView totalUnread;
    private static final String TAG_CONVERSATION = "tag_conversation";
    private static final String TAG_MINE = "tag_mine";
    private static final String TAG_LIVE_GROUP = "tag_live_group";
    private static final String TAG_CONTACT = "tag_contact";
    private int currentTab = -1;
    private TextView convTabTv;
    private TextView mineTabTv;
    private TextView liveGroupTabTv;
    private ImageView liveGroupTabIv;
    private TextView contactTabTv;
    private View contactTab;
    private TextView contactTvUnread;

    public static void start(Context context) {
        Intent intent = new Intent(context, VEIMMainActivity.class);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i(TAG, "onCreate()");
        setContentView(R.layout.ve_im_activity_main_list);
        convTab = findViewById(R.id.rl_conversation);
        convTabTv = findViewById(R.id.tv_conversation);
        mineTab = findViewById(R.id.rl_mine);
        mineTabTv = findViewById(R.id.tv_mine);
        liveGroupTab = findViewById(R.id.rl_live_group);
        liveGroupTabTv = findViewById(R.id.tv_live_group);
        liveGroupTabIv = findViewById(R.id.iv_live_group);
        contactTab = findViewById(R.id.rl_contact);
        contactTabTv = findViewById(R.id.tv_contact);
        contactTvUnread = findViewById(R.id.tv_contact_unread);
        totalUnread = findViewById(R.id.tv_conversation_unread_num);
        convTab.setOnClickListener(this);
        mineTab.setOnClickListener(this);
        liveGroupTab.setOnClickListener(this);
        contactTab.setOnClickListener(this);
        BIMUIClient.getInstance().addConversationListener(new BIMConversationListListener() {
            @Override
            public void onNewConversation(List<BIMConversation> conversationList) {

            }

            @Override
            public void onConversationChanged(List<BIMConversation> conversationList) {

            }

            @Override
            public void onConversationDelete(List<BIMConversation> conversationList) {

            }

            @Override
            public void onTotalUnreadMessageCountChanged(int totalUnreadCount) {
                if (totalUnreadCount > 99) {
                    totalUnread.setText("99+");
                } else {
                    totalUnread.setText(String.valueOf(totalUnreadCount));
                }
                if (totalUnreadCount > 0) {
                    totalUnread.setVisibility(View.VISIBLE);
                } else {
                    totalUnread.setVisibility(View.GONE);
                }
            }

            @Override
            public void onConversationRead(String conversationId, long fromUid) {

            }
        });
        if (VEUtils.isShield()) { //隐藏了直播群，删掉 if 可体验
            View liveTab = findViewById(R.id.rl_live_group);
            LinearLayout tabLayout = findViewById(R.id.cl_menu);
            liveTab.setVisibility(View.GONE);
            tabLayout.setWeightSum(3);
        }
    }

    @Override
    protected void onResume() {
        Log.i(TAG, "onResume()");
        super.onResume();
        conversationListFragment = getFragmentManager().findFragmentByTag(TAG_CONVERSATION);
        veMineFragment = getFragmentManager().findFragmentByTag(TAG_MINE);
        liveGroupFragment = getFragmentManager().findFragmentByTag(TAG_LIVE_GROUP);
        contactFragment = getFragmentManager().findFragmentByTag(TAG_CONTACT);

        FragmentTransaction transaction = getFragmentManager().beginTransaction();
        if (conversationListFragment == null) {
            conversationListFragment = new VEConvFragment();
            transaction.add(R.id.page_container, conversationListFragment, TAG_CONVERSATION);
        }
        if (veMineFragment == null) {
            veMineFragment = new VEMineFragment();
            transaction.add(R.id.page_container, veMineFragment, TAG_MINE);
        }
        if (liveGroupFragment == null) {
            liveGroupFragment = new VELiveGroupFragment();
            transaction.add(R.id.page_container, liveGroupFragment, TAG_LIVE_GROUP);
        }
        if (contactFragment == null) {
            VEContactListFragment contactListFragment = new VEContactListFragment();
            contactListFragment.setUnreadCountListener(num -> {
                contactTvUnread.setVisibility(num > 0 ? View.VISIBLE : View.GONE);
                contactTvUnread.setText(num > 99 ? "99+" : ("" + num));
            });
            contactFragment = contactListFragment;
            transaction.add(R.id.page_container, contactFragment, TAG_CONTACT);
        }
        transaction.commit();

        if (currentTab == -1) {
            switchTab(convTab.getId());
        } else {
            switchTab(currentTab);
        }
    }

    public void switchTab(int id) {
        currentTab = id;
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        ft.hide(veMineFragment).hide(liveGroupFragment).hide(conversationListFragment).hide(contactFragment);

        switch (id) {
            case R.id.rl_conversation:
                ft.show(conversationListFragment);
                break;
            case R.id.rl_mine:
                ft.show(veMineFragment);
                break;
            case R.id.rl_live_group:
                ft.show(liveGroupFragment);
                break;
            case R.id.rl_contact:
                ft.show(contactFragment);
                break;
            default:
                break;
        }
        ft.commit();
        setTagColor();
    }

    private void setTagColor() {
        if (convTabTv != null) {
            convTabTv.setTextColor(currentTab == R.id.rl_conversation ? SELECTED_COLOR : UNSELECTED_COLOR);
        }
        if (mineTabTv != null) {
            mineTabTv.setTextColor(currentTab == R.id.rl_mine ? SELECTED_COLOR : UNSELECTED_COLOR);
        }
        if (liveGroupTabTv != null) {
            liveGroupTabTv.setTextColor(currentTab == R.id.rl_live_group ? SELECTED_COLOR : UNSELECTED_COLOR);
        }
        if (contactTabTv != null) {
            contactTabTv.setTextColor(currentTab == R.id.rl_contact ? SELECTED_COLOR : UNSELECTED_COLOR);
        }
    }

    @Override
    public void onClick(View v) {
        switchTab(v.getId());
    }

    @Override
    public void onBackPressed() {
        return;
    }
}
