package com.bytedance.im.app.member.group;

import android.app.Activity;
import android.text.TextUtils;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.Toast;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.BIMUIClient;

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
