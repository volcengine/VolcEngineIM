package com.bytedance.im.app.contact.mainList;

import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_ADD_SELF_FRIEND_NOT_ALLOW;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_ALIAS_ILLEGAL;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_ALIAS_TOO_LONG;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_DUPLICATE_APPLY;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_IS_FRIEND;
import static com.bytedance.im.core.api.enums.BIMErrorCode.BIM_SERVER_FRIEND_MORE_THAN_LIMIT;

import android.app.AlertDialog;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;


import com.bytedance.im.app.contact.R;
import com.bytedance.im.app.contact.blockList.VEContactBlockListActivity;
import com.bytedance.im.app.contact.inviteList.VEContactInviteActivity;
import com.bytedance.im.app.contact.mainList.item.ContactListActionItem;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.interfaces.BIMAccountProvider;
import com.bytedance.im.ui.api.interfaces.BIMSupportUnread;
import com.bytedance.im.ui.api.interfaces.BIMUnreadListener;
import com.bytedance.im.imsdk.contact.user.BIMContactExpandService;
import com.bytedance.im.imsdk.contact.user.api.BIMFriendListener;
import com.bytedance.im.imsdk.contact.user.api.model.BIMApplyInfo;
import com.bytedance.im.imsdk.contact.user.api.model.BIMFriendApplyInfo;
import com.bytedance.im.imsdk.contact.user.api.model.BIMUserFullInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class VEContactListFragment extends Fragment implements BIMSupportUnread {
    public static String TAG = "VEContactListFragment";
    private static final int PAGE_SIZE = 20;
    private static final int MAX_NICKNAME_BYTE_SIZE = 96;

    private long mCursor = 0;
    private TextView addContact;
    private boolean mHasMore = true;
    private boolean mIsLoading = false;
    private RecyclerView rvContactList;
    private SwipeRefreshLayout swipeRefreshLayout;
    private BIMUnreadListener unreadListener;
    private final VEContactListAdapter adapter = new VEContactListAdapter();
    private BIMContactExpandService service;

    private final OnClickListener contactClickListener = new OnClickListener() {
        @Override
        public void onClick(View v, ContactListDataInfo<?> data) {
            if (ContactListItemType.TYPE_INVITE_LIST == data.getType()) {
                if (null != getActivity()) {
                    Intent intent = new Intent(getActivity(), VEContactInviteActivity.class);
                    getActivity().startActivity(intent);
                }
            } else if (ContactListItemType.TYPE_BLACK_LIST == data.getType()) {
                if (null != getActivity()) {
                    Intent intent = new Intent(getActivity(), VEContactBlockListActivity.class);
                    getActivity().startActivity(intent);
                }
            } else if (ContactListItemType.TYPE_CONTACT == data.getType()) {
                if (null != getActivity()) {
                    BIMUserFullInfo friendInfo = (BIMUserFullInfo)data.getData();
                    BIMClient.getInstance().createSingleConversation(friendInfo.getUid(), new BIMResultCallback<BIMConversation>() {
                        @Override
                        public void onSuccess(BIMConversation conversation) {
                            BIMUIClient.getInstance().getModuleStarter().startMessageModule(getActivity(), conversation.getConversationID());
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Log.e(TAG, "create conversation failed: " + friendInfo.getUid());
                        }
                    });
                }
            }
        }

        @Override
        public void onLongClick(View v, ContactListDataInfo<?> data) {
            showItemOptionMenu(data);
        }

        @Override
        public void onPortraitClick(View v, ContactListDataInfo<?> data) {
            BIMUserFullInfo userFullInfo = (BIMUserFullInfo) data.getData();
            BIMUIClient.getInstance().getModuleStarter().startProfileModule(getActivity(),userFullInfo.getUid());
        }
    };

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.ve_im_fragment_contact_list, container, false);

        swipeRefreshLayout = view.findViewById(R.id.swipe);
        addContact = view.findViewById(R.id.tv_add_contact);
        rvContactList = view.findViewById(R.id.rv_contact_list);
        addContact.setOnClickListener(v -> showAddContactDialog());
        rvContactList.setLayoutManager(new LinearLayoutManager(getActivity()));
        adapter.setListener(this.contactClickListener);
        swipeRefreshLayout.setEnabled(false);
        rvContactList.setItemAnimator(null);
        rvContactList.setAdapter(adapter);
        service = BIMClient.getInstance().getService(BIMContactExpandService.class);
        rvContactList.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(@NonNull RecyclerView recyclerView, int newState) {
                if (recyclerView.computeVerticalScrollExtent() + recyclerView.computeVerticalScrollOffset()
                        >= recyclerView.computeVerticalScrollRange()) {
                    loadData();
                }
            }
        });
        service.addFriendListener(friendListener);
        initStickTopItem();
        loadData();
        return view;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        service.removeFriendListener(friendListener);
    }

    private void loadData() {
        Log.d(TAG, "loadData, cursor " + mCursor + ", hasMore " + mHasMore + ", isLoading " + mIsLoading);
        if (service != null && mHasMore && !mIsLoading) {
            mIsLoading = true;
            service.getFriendList( new BIMResultCallback<List<BIMUserFullInfo>>() {

                @Override
                public void onSuccess(List<BIMUserFullInfo> bimFriendInfos) {
                    mIsLoading = false;
                    boolean isFirstPage = mCursor == 0;
                    mHasMore = false;
                    mCursor = 0;
                    List<ContactListDataInfo<?>> temp = new ArrayList<>();
                    if (bimFriendInfos != null) {
                        for (BIMUserFullInfo fullInfo : bimFriendInfos) {
                            temp.add(ContactListDataInfo.create(fullInfo));
                        }
                    }
                    Collections.sort(temp, ContactListDataInfo::compare);
                    adapter.appendData(temp, isFirstPage);
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    mIsLoading = false;
                    mHasMore = false;
                    Log.e(TAG, " loadData, error " + code);
                }
            });
        }
    }

    private void initStickTopItem() {
        List<ContactListDataInfo<?>> stickTopData = new ArrayList<>();
        stickTopData.add(ContactListDataInfo.create(ContactListItemType.TYPE_INVITE_LIST));
        stickTopData.add(ContactListDataInfo.create(ContactListItemType.TYPE_BLACK_LIST));
        adapter.setStickUpItem(stickTopData);
    }

    private void showAddContactDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        AlertDialog dialog = builder.setCancelable(false).show();

        if (dialog.getWindow() != null) {
            Window window = dialog.getWindow();
            window.setContentView(R.layout.ve_item_dialog_add_contact);
            window.clearFlags(WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM);

            EditText et = window.findViewById(R.id.et_uid);
            et.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});

            TextView tvReject = window.findViewById(R.id.tv_reject);
            TextView tvConfirm = window.findViewById(R.id.tv_confirm);

            tvConfirm.setOnClickListener(v -> {
                if (null == et.getText() || TextUtils.isEmpty(et.getText().toString())) {
                    Toast.makeText(getActivity(), "请输入uid", Toast.LENGTH_SHORT).show();
                } else {
                    if (null != service) {
                        BIMApplyInfo apply = new BIMApplyInfo();
                        apply.setUid(Long.parseLong(et.getText().toString()));
                        BIMUIClient.getInstance().getUserExistChecker().check(Collections.singletonList(apply.getUid()), new BIMResultCallback<Map<Long, Boolean>>() {
                            @Override
                            public void onSuccess(Map<Long, Boolean> longBooleanMap) {
                                if (!longBooleanMap.containsKey(apply.getUid()) || !longBooleanMap.get(apply.getUid())) {
                                    Toast.makeText(getActivity(), "uid不存在，请重新输入", Toast.LENGTH_SHORT).show();
                                    return;
                                }

                                service.applyFriend(apply, new BIMResultCallback<BIMFriendApplyInfo>() {
                                    @Override
                                    public void onSuccess(BIMFriendApplyInfo friendApplyInfo) {
                                        dialog.dismiss();
                                        Toast.makeText(getActivity(), "操作成功", Toast.LENGTH_SHORT).show();
                                    }

                                    @Override
                                    public void onFailed(BIMErrorCode code) {
                                        if (code == BIM_SERVER_IS_FRIEND) {
                                            Toast.makeText(getActivity(), "TA已经是你的好友，请重新输入", Toast.LENGTH_SHORT).show();
                                        } else if (code == BIM_SERVER_FRIEND_MORE_THAN_LIMIT) {
                                            Toast.makeText(getActivity(), "已超出好友数量上限", Toast.LENGTH_SHORT).show();
                                        }  else if (code == BIM_SERVER_ADD_SELF_FRIEND_NOT_ALLOW) {
                                            Toast.makeText(getActivity(), "自己不能添加自己为好友", Toast.LENGTH_SHORT).show();
                                        } else if (code == BIM_SERVER_DUPLICATE_APPLY) {
                                            Toast.makeText(getActivity(), "已发送过好友申请，请等待对方处理", Toast.LENGTH_SHORT).show();
                                        } else {
                                            Toast.makeText(getActivity(), "操作失败：" + code, Toast.LENGTH_SHORT).show();
                                        }
                                    }
                                });
                            }

                            @Override
                            public void onFailed(BIMErrorCode code) {
                                Toast.makeText(getActivity(), "uid不存在，请重新输入", Toast.LENGTH_SHORT).show();
                            }
                        });
                    }
                }
            });

            tvReject.setOnClickListener(v -> { dialog.dismiss(); });
        }
    }

    private void showItemOptionMenu(ContactListDataInfo<?> data) {
        if (data.getType() == ContactListItemType.TYPE_CONTACT) {
            String[] items = new String[] { "删除好友", "修改好友备注" };
            long uid = ((BIMUserFullInfo) data.getData()).getUid();
            new AlertDialog.Builder(getActivity()).setItems(items, (selectDialog, which) -> {
                if (which == 0) {
                    selectDialog.dismiss();
                    showDeleteFriendDialog(uid);
                } else if (which == 1) {
                    showChangeContactNickNameDialog(data);
                }
            }).show();
        }
    }

    private void showDeleteFriendDialog(long uid) {
        new AlertDialog.Builder(getActivity()).setMessage("删除好友意味着你与对方解除好友关系")
            .setNegativeButton("取消", (dialog, which1) -> dialog.dismiss())
            .setPositiveButton("确认", (dialog, which) -> {
                if (service != null) {
                    service.deleteFriend(uid, new BIMSimpleCallback() {
                        @Override
                        public void onSuccess() {
                            Toast.makeText(getActivity(), "操作成功", Toast.LENGTH_SHORT).show();
                            BIMClient.getInstance().deleteConversation(uid, null);
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            Toast.makeText(getActivity(), "操作失败: " + code, Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }).show();
    }

    private void showChangeContactNickNameDialog(ContactListDataInfo<?> data) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setCancelable(true);

        AlertDialog dialog = builder.show();
        if (dialog.getWindow() != null) {
            Window window = dialog.getWindow();
            window.setContentView(R.layout.ve_item_dialog_add_contact);
            window.clearFlags(WindowManager.LayoutParams.FLAG_ALT_FOCUSABLE_IM);

            EditText et = window.findViewById(R.id.et_uid);
            TextView tvMain = window.findViewById(R.id.tv_main);
            TextView tvReject = window.findViewById(R.id.tv_reject);
            TextView tvConfirm = window.findViewById(R.id.tv_confirm);

            tvMain.setText("修改好友备注");
            et.setInputType(EditorInfo.TYPE_CLASS_TEXT);

            BIMUserFullInfo info = (BIMUserFullInfo) data.getData();
            et.setHint("输入备注");
            String preAlias = info.getAlias();
            et.setText(preAlias == null ? "" : preAlias);

            tvReject.setOnClickListener(v -> {
                dialog.dismiss();
            });

            et.setFilters(new InputFilter[] { new InputFilter() {
                @Override
                public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
                    String s1 = source.toString() + dest.toString();
                    if (s1.getBytes().length > MAX_NICKNAME_BYTE_SIZE) {
                        Toast.makeText(getActivity(), "不能超过96字节", Toast.LENGTH_SHORT).show();
                        return "";
                    } else {
                        return source;
                    }
                }
            }});

            tvConfirm.setOnClickListener(v -> {
                if (null != service) {
                    service.updateFriendAlias(info.getUid(), et.getText().toString().trim(), new BIMSimpleCallback() {
                        @Override
                        public void onSuccess() {
                            dialog.dismiss();
                            Toast.makeText(getActivity(), "操作成功", Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onFailed(BIMErrorCode code) {
                            if (code == BIM_SERVER_ALIAS_TOO_LONG) {
                                Toast.makeText(getActivity(), "不能超过96字节", Toast.LENGTH_SHORT).show();
                            } else if (code == BIM_SERVER_ALIAS_ILLEGAL) {
                                Toast.makeText(getActivity(), "文本中可能包含敏感词，请修改后重试", Toast.LENGTH_SHORT).show();
                                dialog.dismiss();
                            } else {
                                Toast.makeText(getActivity(), "操作失败：" + code, Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                }
            });
        }
    }

    private BIMFriendListener friendListener = new BIMFriendListener() {
        @Override
        public void onFriendApply(BIMFriendApplyInfo applyInfo) {}


        @Override
        public void onFriendDelete(BIMUserFullInfo userFullInfo) {
            adapter.removeData(ContactListDataInfo.create(userFullInfo));
        }

        @Override
        public void onFriendUpdate(BIMUserFullInfo userFullInfo) {
            adapter.insertOrUpdate(ContactListDataInfo.create(userFullInfo), !mHasMore);
        }

        @Override
        public void onFriendAdd(BIMUserFullInfo userFullInfo) {
            adapter.insertOrUpdate(ContactListDataInfo.create(userFullInfo), !mHasMore);
        }

        @Override
        public void onFriendAgree(BIMFriendApplyInfo applyInfo) {}

        @Override
        public void onFriendRefuse(BIMFriendApplyInfo applyInfo) {

        }

        @Override
        public void onFriendApplyUnreadCountChanged(int count) {
            ContactListDataInfo<ContactListActionItem> item = ContactListDataInfo.create(ContactListItemType.TYPE_INVITE_LIST);
            item.getData().setUnreadCount(count);
            adapter.updateStickTopData(item);
            if (unreadListener != null) {
                unreadListener.onUnreadChanged(count);
            }
        }

        @Override
        public void onBlackListAdd(BIMUserFullInfo userFullInfo) {

        }

        @Override
        public void onBlackListDelete(BIMUserFullInfo userFullInfo) {

        }

        @Override
        public void onBlackListUpdate(BIMUserFullInfo userFullInfo) {

        }

        @Override
        public void onUserProfileUpdate(BIMUserFullInfo userFullInfo) {
        }
    };

    @Override
    public void setUnReadListener(BIMUnreadListener listener) {
        this.unreadListener = listener;
    }
}
