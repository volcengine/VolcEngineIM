package com.bytedance.im.app.main;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.bytedance.im.app.R;
import com.bytedance.im.app.create.VECreateGroupActivity;
import com.bytedance.im.app.create.VECreateSingleActivity;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.conversation.BIMConversationListFragment;
import com.bytedance.im.user.BIMContactExpandService;

import java.util.List;

public class VEConvFragment extends Fragment {
    private static final String TAG = "VEConvFragment";
    private ImageView createIv;
    private FrameLayout convListContainer;
    private TextView allConvBtn, friendConvBtn;
    private Fragment allConvListFragment, friendConvListFragment;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.ve_im_fragment_conve, container, false);
        createIv = rootView.findViewById(R.id.iv_create);
        allConvBtn = rootView.findViewById(R.id.btn_all_conv);
        friendConvBtn = rootView.findViewById(R.id.btn_friend_conv);
        convListContainer = rootView.findViewById(R.id.conversation_list_container);

        allConvBtn.setOnClickListener(this::toggleList);
        friendConvBtn.setOnClickListener(this::toggleList);

        createIv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.i(TAG, "more onClick()");
                showPopUpWindow(v);
            }
        });

        BIMClient.getInstance().addConversationListener(convListener);
        if (BIMClient.getInstance().getService(BIMContactExpandService.class) != null) {
            BIMClient.getInstance().getService(BIMContactExpandService.class).addFriendConversationListener(friendConvListener);
        }
        toggleList(allConvBtn);
        return rootView;
    }

    private void checkIfNeedInit(FragmentTransaction ft) {
        if (allConvListFragment == null) {
            allConvListFragment = new BIMConversationListFragment();
            ft.add(R.id.conversation_list_container, allConvListFragment, "all_conv_list");
        }
        if (friendConvListFragment == null) {
            friendConvListFragment = new VEFriendConversationFragment();
            ft.add(R.id.conversation_list_container, friendConvListFragment, "friend_conv_list");
        }
    }

    private void switchConvList(ConvPage convPage) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();

        checkIfNeedInit(ft);

        ft.hide(allConvListFragment);
        ft.hide(friendConvListFragment);
        if (convPage == ConvPage.CONV_LIST) {
            ft.show(allConvListFragment);
        } else if (convPage == ConvPage.FRIEND_CONV_LIST) {
            ft.show(friendConvListFragment);
        }
        ft.commit();
    }

    private void showPopUpWindow(View createBtn) {
        View contentView = LayoutInflater.from(getActivity()).inflate(R.layout.ve_im_popup_window_create_chat, null);
        LinearLayout createSingle = contentView.findViewById(R.id.ll_create_single);
        LinearLayout createGroup = contentView.findViewById(R.id.ll_create_group);
        PopupWindow popupWindow = new PopupWindow(contentView, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setOutsideTouchable(true);
        popupWindow.showAsDropDown(createBtn, 0, 10);
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int id = v.getId();
                if (id == R.id.ll_create_single) {
                    VECreateSingleActivity.start(getActivity());
                } else if (id == R.id.ll_create_group) {
                    VECreateGroupActivity.start(getActivity());
                }
                popupWindow.dismiss();
            }
        };
        createSingle.setOnClickListener(listener);
        createGroup.setOnClickListener(listener);
        //弹窗显示时添加全局阴影
        WindowManager.LayoutParams lp = getActivity().getWindow().getAttributes();
        lp.alpha = 0.7f;
        getActivity().getWindow().setAttributes(lp);

        //弹窗消失时移出全局阴影
        popupWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                WindowManager.LayoutParams lp = getActivity().getWindow().getAttributes();
                lp.alpha = 1f;
                getActivity().getWindow().setAttributes(lp);
            }
        });
    }

    private void toggleList(View v) {
        allConvBtn.setBackground(null);
        friendConvBtn.setBackground(null);
        if (v.getId() == R.id.btn_all_conv) {
            v.setBackgroundResource(R.drawable.selected_conv_list_item_bg);
            switchConvList(ConvPage.CONV_LIST);
        } else if (v.getId() == R.id.btn_friend_conv) {
            v.setBackgroundResource(R.drawable.selected_conv_list_item_bg);
            switchConvList(ConvPage.FRIEND_CONV_LIST);
        }
    }

    BIMConversationListListener convListener = new BIMConversationListListener() {
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
            allConvBtn.setText("全部" + getUnreadText(totalUnreadCount));
        }
    };

    BIMConversationListListener friendConvListener = new BIMConversationListListener() {
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
            friendConvBtn.setText("好友" + getUnreadText(totalUnreadCount));
        }
    };

    private String getUnreadText(int totalUnreadCount) {
        if (totalUnreadCount <= 0) {
            return "";
        } else if (totalUnreadCount > 99) {
            return " 99+";
        } else {
            return " " + totalUnreadCount;
        }
    }
}

enum ConvPage {
    CONV_LIST,
    FRIEND_CONV_LIST
}