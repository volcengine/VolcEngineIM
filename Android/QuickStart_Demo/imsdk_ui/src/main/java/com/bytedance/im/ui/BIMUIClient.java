package com.bytedance.im.ui;

import android.app.Application;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConnectStatus;
import com.bytedance.im.core.api.enums.BIMLogLevel;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMConnectListener;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMLogListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.interfaces.BIMSyncServerListener;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.core.api.model.BIMUnReadInfo;
import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyMessageUI;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareCustomMessageUI;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.message.convert.base.model.BaseCustomElement;
import com.bytedance.im.ui.message.convert.manager.BIMMessageManager;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.ui.user.UserProvider;
import com.bytedance.im.ui.utils.FileUtils;
import com.bytedance.im.ui.utils.BIMUIUtils;
import com.bytedance.im.ui.utils.media.AudioHelper;

import java.util.List;

public class BIMUIClient {
    private static final class InstanceHolder {
        private static final BIMUIClient instance = new BIMUIClient();
    }

    private BIMUIClient() {
    }

    public static BIMUIClient getInstance() {
        return InstanceHolder.instance;
    }

    public void init(Application application, int appId, BIMSDKConfig config) {
        init(application, appId, 0, "", config);
    }


        /**
         * 初始化 SDK
         *
         * @param application   application
         * @param appId appId
         */
    public void init(Application application, int appId, int env, String swimLean, BIMSDKConfig config) {
        BIMClient.getInstance().initSDK(application, appId, config,env,swimLean);
        if (BIMUIUtils.isMainProcess(application) && BIMUIUtils.isMainThread()) {
            FileUtils.initDir(application);
            AudioHelper.getInstance().initAudio(application);
            BIMMessageUIManager.getInstance().init();
            BIMMessageUIManager.getInstance().registerMessageUI(new BIMShareCustomMessageUI());
            BIMMessageUIManager.getInstance().registerMessageUI(new BIMGroupNotifyMessageUI());
            BIMMessageManager.getInstance().register("1", BIMShareElement.class);
            BIMMessageManager.getInstance().register("2", BIMGroupNotifyElement.class);
        }
    }

    public void setUserProvider(UserProvider userProvider) {
        UserManager.geInstance().setUserProvider(userProvider);
    }

    public UserProvider getUserProvider() {
        return UserManager.geInstance().getUserProvider();
    }


    /**
     * 设置登录时拉取服务监听
     *
     * @param listener
     */
    public void addSyncServerListener(BIMSyncServerListener listener) {
//        BIMClient.getInstance().addSyncServerListener(listener);
    }

    /**
     * 登录
     *
     * @return
     */
    public void login(long uid, String token, BIMSimpleCallback callback) {
        BIMClient.getInstance().login(uid, token, callback);
    }

    /**
     * 监听连接状态
     *
     * @param listener
     */
    public void addConnectListenerListener(final BIMConnectListener listener) {
        BIMClient.getInstance().addConnectListener(listener);
    }


    public void removeConnectListener(final BIMConnectListener listener) {
        BIMClient.getInstance().removeConnectListener(listener);
    }
    /**
     * 设置群组用户角色
     *
     * @param conversationId
     * @param uidList
     * @param role
     * @param callback
     */
    public void setGroupMemberRole(String conversationId, List<Long> uidList, BIMMemberRole role, BIMSimpleCallback callback) {
        BIMClient.getInstance().setGroupMemberRole(conversationId, uidList, role, callback);
    }

    /**
     * 添加会话监听
     */
    public void addConversationListener(BIMConversationListListener listener) {
        BIMClient.getInstance().addConversationListener(listener);
    }

    /**
     * 移除会话监听
     *
     * @param listener
     */
    public void removeConversationListener(BIMConversationListListener listener) {
        BIMClient.getInstance().removeConversationListener(listener);
    }

    /**
     * 创建自定义消息
     *
     * @param json
     * @return
     */
    public BIMMessage createCustomMessage(String json) {
        return BIMClient.getInstance().createCustomMessage(json);
    }

    /**
     * 创建自定义消息
     *
     * @param content
     * @return
     */
    public BIMMessage createCustomMessage(BaseCustomElement content) {
        return createCustomMessage(BIMMessageManager.getInstance().encode(content));
    }

    /**
     * 发送消息
     *
     * @param message
     * @param conversationId
     * @param callback       回调
     */
    public void sendMessage(final BIMMessage message, String conversationId, BIMSendCallback callback) {
        BIMClient.getInstance().sendMessage(message, conversationId, callback);
    }

    /**
     * 获取会话信息
     *
     * @param conversationId 会话id
     * @param callback       返回监听
     */
    public void getConversation(String conversationId, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().getConversation(conversationId, callback);
    }

    /**
     * 获取群组成员
     *
     * @param conversationId
     * @param callback
     */
    public void getGroupMemberList(String conversationId, BIMResultCallback<List<BIMMember>> callback) {
        BIMClient.getInstance().getConversationMemberList(conversationId, callback);
    }

    /**
     * 离开群组
     *
     * @param conversationId
     * @param callback
     */
    public void leaveGroup(String conversationId, boolean isDeleteServer, BIMSimpleCallback callback) {
        BIMClient.getInstance().leaveGroup(conversationId, isDeleteServer, callback);
    }

    /**
     * 解散群组
     *
     * @param conversationId
     * @param callback
     */
    public void dissolveGroup(String conversationId, boolean isDeleteLocal, BIMSimpleCallback callback) {
        BIMClient.getInstance().dissolveGroup(conversationId, isDeleteLocal, callback);
    }

    /**
     * 创建群组
     *
     * @param groupInfo 群组信息
     * @param uidList   用户列表
     */
    public void createGroupConversation(BIMGroupInfo groupInfo, List<Long> uidList, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().createGroupConversation(groupInfo, uidList, callback);
    }

    /**
     * 创建单聊
     *
     * @param toUid
     * @param callback
     */
    public void createSingleConversation(long toUid, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().createSingleConversation(toUid, callback);
    }

    /**
     * 移出群成员
     *
     * @param conversationId
     * @param ids
     * @param callback
     */
    public void removeGroupMemberList(String conversationId, List<Long> ids, BIMSimpleCallback callback) {
        BIMClient.getInstance().removeGroupMemberList(conversationId, ids, callback);
    }

    /**
     * 添加群成员
     *
     * @param conversationId
     * @param ids
     * @param callback
     */
    public void addGroupMemberList(String conversationId, List<Long> ids, BIMSimpleCallback callback) {
        BIMClient.getInstance().addGroupMemberList(conversationId, ids, callback);
    }

    /**
     * 设置群公告
     *
     * @param conversationId
     * @param notice
     * @param callback
     */
    public void setGroupNotice(String conversationId, String notice, BIMSimpleCallback callback) {
        BIMClient.getInstance().setGroupNotice(conversationId, notice, callback);
    }


    /**
     * 设置群组名称
     *
     * @param conversationId
     * @param name
     * @param callback
     */
    public void setGroupName(String conversationId, String name, BIMSimpleCallback callback) {
        BIMClient.getInstance().setGroupName(conversationId, name, callback);
    }

    /**
     * 置顶会话
     *
     * @param conversationId
     * @param isPined
     * @param callback
     */
    public void stickTopConversation(String conversationId, boolean isPined, BIMSimpleCallback callback) {
        BIMClient.getInstance().stickTopConversation(conversationId, isPined, callback);
    }


    /**
     * 禁言会话
     *
     * @param conversationId
     * @param isMute
     * @param callback
     */
    public void muteConversation(String conversationId, boolean isMute, BIMSimpleCallback callback) {
        BIMClient.getInstance().muteConversation(conversationId, isMute, callback);
    }

    /**
     * 获取连接状态
     *
     * @return
     */
    public BIMConnectStatus getConnectStatus() {
        return BIMClient.getInstance().getConnectStatus();
    }

    /**
     * 返回当前 appid
     *
     * @return
     */
    public int getAppId() {
        return BIMClient.getInstance().getAppID();
    }

    /**
     * 获取当前用户 id
     *
     * @return
     */
    public long getCurUserId() {
        return BIMClient.getInstance().getCurrentUserID();
    }

    /**
     * 获取当前 sdk 名称
     *
     * @return
     */
    public String getVersion() {
        return BIMClient.getInstance().getVersion();
    }

    /**
     * 登出
     *
     * @return
     */
    public void logout() {
        BIMClient.getInstance().logout();
    }

    public void getTotalUnreadMessageCount(BIMResultCallback<BIMUnReadInfo> callback) {
        BIMClient.getInstance().getTotalUnreadMessageCount(callback);
    }

    /**
     * 刷新媒体消息
     *
     * @param bimMessage
     * @param callback
     */
    public void refreshMediaMessage(BIMMessage bimMessage, BIMResultCallback<BIMMessage> callback) {
        BIMClient.getInstance().refreshMediaMessage(bimMessage, callback);
    }
}

