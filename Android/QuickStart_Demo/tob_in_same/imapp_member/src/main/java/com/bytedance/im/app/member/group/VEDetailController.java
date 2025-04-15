package com.bytedance.im.app.member.group;

import android.app.Activity;
import android.text.TextUtils;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.DialogUtil;

public class VEDetailController {
    /**
     * 处理置顶
     *
     * @param topSwitch
     * @param conversation
     * @param activity
     */
    public static void initStickSwitch(Switch topSwitch, BIMConversation conversation, Activity activity) {
        topSwitch.setChecked(conversation.isStickTop());
        topSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!buttonView.isPressed()) {
                    return;
                }
                BIMUIClient.getInstance().stickTopConversation(conversation.getConversationID(), isChecked, new BIMSimpleCallback() {
                    @Override
                    public void onSuccess() {
                        Toast.makeText(activity, "操作成功", Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        topSwitch.setChecked(!isChecked);
                        Toast.makeText(activity, "操作失败", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }

    public static void initMarkNewChat(View markNewChatView, BIMConversation conversation, Activity activity) {
        markNewChatView.setVisibility(View.GONE);
        markNewChatView.setOnClickListener(v -> {
            DialogUtil.showMarkNewChatDialog(activity, new BIMResultCallback<Boolean>() {
                @Override
                public void onSuccess(Boolean aBoolean) {
                    BIMGroupNotifyElement content = new BIMGroupNotifyElement();
                    String text = " 已清除上下文 ";
                    content.setText(text);

                    BIMMessage markNewChatMessage = BIMUIClient.getInstance().createCustomMessage(content);
                    BIMClient.getInstance().sendMessage(markNewChatMessage, conversation.getConversationID(), new BIMSendCallback() {
                        @Override
                        public void onSuccess(BIMMessage bimMessage) {
                            BIMClient.getInstance().markNewChat(conversation.getConversationID(), true, new BIMSimpleCallback() {
                                @Override
                                public void onSuccess() {
                                    Toast.makeText(activity, "操作成功", Toast.LENGTH_SHORT).show();
                                }

                                @Override
                                public void onFailed(BIMErrorCode code) {
                                    Toast.makeText(activity, "操作失败", Toast.LENGTH_SHORT).show();
                                }
                            });
                        }

                        @Override
                        public void onError(BIMMessage bimMessage, BIMErrorCode code) {

                        }
                    });
                }

                @Override
                public void onFailed(BIMErrorCode code) {

                }
            });
        });
        if (conversation.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
            BIMUIClient.getInstance().getUserProvider().getUserInfoAsync(conversation.getOppositeUserID(), new BIMResultCallback<BIMUIUser>() {
                @Override
                public void onSuccess(BIMUIUser bimuiUser) {
                    if (bimuiUser.getIsRobot()) {
                        markNewChatView.setVisibility(View.VISIBLE);
                    }
                }

                @Override
                public void onFailed(BIMErrorCode code) {
                    markNewChatView.setVisibility(View.GONE);
                }
            });
        }
    }

    public static void initMuteSwitch(Switch muteSwitch, BIMConversation conversation, Activity activity) {
        muteSwitch.setChecked(conversation.isMute());
        muteSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (!buttonView.isPressed()) {
                    return;
                }
                BIMUIClient.getInstance().muteConversation(conversation.getConversationID(), isChecked, new BIMSimpleCallback() {
                    @Override
                    public void onSuccess() {
                        Toast.makeText(activity, "操作成功", Toast.LENGTH_SHORT).show();
                    }

                    @Override
                    public void onFailed(BIMErrorCode code) {
                        muteSwitch.setChecked(!isChecked);
                        Toast.makeText(activity, "操作失败", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }

    public static String getGroupName(BIMConversation conversation) {
        String name = conversation.getName();
        if (TextUtils.isEmpty(name)) {
            name = "未命名群聊";
        }
        return name;
    }

    public static String getNotice(BIMConversation conversation) {
        String notice = conversation.getNotice();
        if (TextUtils.isEmpty(notice)) {
            notice = "未设定";
        }
        return notice;
    }

    public static String getDescription(BIMConversation conversation) {
        String description = conversation.getDescription();
        if (TextUtils.isEmpty(description)) {
            description = "未设定";
        }
        return description;
    }
}
