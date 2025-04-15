package com.bytedance.im.app.conversation;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
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
import android.widget.Toast;

import androidx.annotation.Nullable;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.api.interfaces.BIMSupportUnread;
import com.bytedance.im.ui.api.interfaces.BIMUnreadListener;
import com.bytedance.im.ui.conversation.BIMConversationListFragment;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.DialogUtil;
import com.bytedance.im.ui.starter.ModuleStarter;
import com.bytedance.im.ui.user.OnUserInfoUpdateListener;
import com.bytedance.im.ui.utils.BIMUINameUtils;
import com.bytedance.im.user.BIMContactExpandService;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class VEConversationListFragment extends Fragment implements BIMSupportUnread {
    private static final String TAG = "VEConvFragment";
    private ImageView createIv;
    private FrameLayout convListContainer;
    private TextView allConvBtn, friendConvBtn;
    private View searchBtn;
    private Fragment allConvListFragment, friendConvListFragment;
    private int REQUEST_CODE_CRETE_UID_LIST = 1000;
    private int REQUEST_CODE_CRETE_UID = 1001;
    private int REQUEST_CODE_CLEAR_UNREAD = 1002;
    private int REQUEST_CODE_CRETE_ROBOT_UID = 1003;

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
        searchBtn = rootView.findViewById(R.id.global_search);
        allConvBtn.setOnClickListener(this::toggleList);
        friendConvBtn.setOnClickListener(this::toggleList);
        searchBtn.setOnClickListener(this::goToSearchActivity);
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
        BIMUIClient.getInstance().getUserProvider().addUserUpdateListener(new OnUserInfoUpdateListener() {
            @Override
            public void onUpdate(long uid, BIMUIUser user) {

            }
        });
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
        LinearLayout clearUnread = contentView.findViewById(R.id.ll_clear_all_unread);
        LinearLayout createRobotChat = contentView.findViewById(R.id.ll_create_robot_single_chat);
        PopupWindow popupWindow = new PopupWindow(contentView, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setOutsideTouchable(true);
        popupWindow.showAsDropDown(createBtn, 0, 10);
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int id = v.getId();
                if (id == R.id.ll_create_single) {
                    BIMUIClient.getInstance().getModuleStarter().startMemberSelectSingle(VEConversationListFragment.this, "发起单聊", REQUEST_CODE_CRETE_UID);
                } else if (id == R.id.ll_create_group) {
                    BIMUIClient.getInstance().getModuleStarter().startMemberModuleAddForResult(VEConversationListFragment.this, "发起群聊", REQUEST_CODE_CRETE_UID_LIST);
                } else if (id == R.id.ll_create_robot_single_chat) {
                    BIMUIClient.getInstance().getModuleStarter().startRobotSelectSingle(VEConversationListFragment.this, "发起机器人单聊", REQUEST_CODE_CRETE_ROBOT_UID);
                } else if (id == R.id.ll_clear_all_unread) {
                    DialogUtil.showBottomConfirmDialog(v.getContext(), "确定要清除所有未读提醒？", "确定",
                            view -> BIMClient.getInstance().markAllConversationsRead(null));
                }
                popupWindow.dismiss();
            }
        };
        createSingle.setOnClickListener(listener);
        createGroup.setOnClickListener(listener);
        clearUnread.setOnClickListener(listener);
        createRobotChat.setOnClickListener(listener);
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
            v.setBackgroundResource(R.drawable.ve_im_selected_conv_list_item_bg);
            switchConvList(ConvPage.CONV_LIST);
        } else if (v.getId() == R.id.btn_friend_conv) {
            v.setBackgroundResource(R.drawable.ve_im_selected_conv_list_item_bg);
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
            if (unreadListener != null) {
                unreadListener.onUnreadChanged(totalUnreadCount);
            }
        }

        @Override
        public void onConversationRead(String conversationId, long fromUid) {

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

        @Override
        public void onConversationRead(String conversationId, long fromUid) {

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

    private BIMUnreadListener unreadListener;

    @Override
    public void setUnReadListener(BIMUnreadListener listener) {
        this.unreadListener = listener;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == REQUEST_CODE_CRETE_UID_LIST) {
                ArrayList<Long> uidList = (ArrayList<Long>) data.getSerializableExtra(ModuleStarter.MODULE_KEY_UID_LIST);
                if (uidList != null && !uidList.isEmpty()) {
                    createGroupConversationAndStart(uidList);
                }
            } else if (requestCode == REQUEST_CODE_CRETE_UID || requestCode == REQUEST_CODE_CRETE_ROBOT_UID) {
                Long uid = data.getLongExtra(ModuleStarter.MODULE_KEY_UID, 0);
                if (uid != null && uid > 0) {
                    createSingleConversationAndStart(uid, requestCode == REQUEST_CODE_CRETE_ROBOT_UID);
                }
            }
        }
    }

    private void createGroupConversationAndStart(List<Long> uidList) {
        BIMGroupInfo groupInfo = new BIMGroupInfo.BIMGroupInfoBuilder().name("未命名群聊").build();
        BIMUIClient.getInstance().createGroupConversation(groupInfo, uidList, new BIMResultCallback<BIMConversation>() {

            @Override
            public void onSuccess(BIMConversation bimConversation) {
                Log.i(TAG, "createGroupConversationAndStart() onSuccess()");
                sendAddMemberMessage(bimConversation, uidList);
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "createGroupConversationAndStart() onFailed() code: " + code);
                if (code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_CONVERSATION_MORE_THAN_LIMIT) {
                    Toast.makeText(getActivity(), "加群个数超过上限", Toast.LENGTH_SHORT).show();
                } else if (code == BIMErrorCode.BIM_SERVER_ERROR_CREATE_CONVERSATION_MEMBER_TOUCH_LIMIT) {
                    Toast.makeText(getActivity(), "群成员已达上限", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(getActivity(), "创建群聊失败 code: " + code, Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void sendAddMemberMessage(BIMConversation conversation, List<Long> uidList) {
        if (uidList == null || uidList.isEmpty()) {
            return;
        }
        uidList.add(BIMClient.getInstance().getCurrentUserID());//自己追到最后
        BIMUIClient.getInstance().getUserProvider().getUserInfoListAsync(uidList, new BIMResultCallback<List<BIMUIUser>>() {
            @Override
            public void onSuccess(List<BIMUIUser> bimuiUsers) {
                Iterator<BIMUIUser> iterator = bimuiUsers.iterator();
                BIMUIUser selfInfo = null;
                while (iterator.hasNext()) {
                    BIMUIUser user = iterator.next();
                    if (user.getUid() == BIMClient.getInstance().getCurrentUserID()) {
                        selfInfo = user;
                        iterator.remove();
                        break;
                    }
                }
                String text = BIMUINameUtils.getShowNickName(selfInfo)
                        + " 邀请 "
                        + BIMUINameUtils.buildNickNameList(bimuiUsers) + " 加入群聊";
                BIMGroupNotifyElement content = new BIMGroupNotifyElement();
                content.setText(text);
                BIMMessage createAddMemberMessage = BIMUIClient.getInstance().createCustomMessage(content);
                BIMUIClient.getInstance().sendMessage(createAddMemberMessage, conversation.getConversationID(), new BIMSendCallback() {

                    @Override
                    public void onProgress(BIMMessage message, int progress) {

                    }

                    @Override
                    public void onSaved(BIMMessage bimMessage) {

                    }

                    @Override
                    public void onSuccess(BIMMessage bimMessage) {
                        BIMUIClient.getInstance().getModuleStarter().startMessageModule(getActivity(), conversation.getConversationID());
                    }

                    @Override
                    public void onError(BIMMessage bimMessage, BIMErrorCode code) {
                    }
                });
            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Log.i(TAG, "getUserFullInfoList() BIMErrorCode() code: " + code);
            }
        });
    }

    private void createSingleConversationAndStart(Long uid, boolean isRobot) {
        BIMUIClient.getInstance().createSingleConversation(uid, new BIMResultCallback<BIMConversation>() {
            @Override
            public void onSuccess(BIMConversation bimConversation) {
                if (isRobot) {
                    BIMClient.getInstance().markNewChat(bimConversation.getConversationID(), true, null);
                }
                BIMUIClient.getInstance().getModuleStarter().startMessageModule(getActivity(), bimConversation.getConversationID());

            }

            @Override
            public void onFailed(BIMErrorCode code) {
                Toast.makeText(getActivity(), "创建单聊失败 code: " + code, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void goToSearchActivity(View v) {
        BIMUIClient.getInstance().getModuleStarter().startGlobalSearchModule(getActivity());
    }
}

enum ConvPage {
    CONV_LIST,
    FRIEND_CONV_LIST
}