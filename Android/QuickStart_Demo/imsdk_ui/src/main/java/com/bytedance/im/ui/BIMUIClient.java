package com.bytedance.im.ui;

import android.app.Application;

import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConnectStatus;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.interfaces.BIMConnectListener;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.core.api.model.BIMUnReadInfo;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyMessageUI;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareCustomMessageUI;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.message.convert.base.model.BaseCustomElement;
import com.bytedance.im.ui.message.convert.manager.BIMMessageManager;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.ui.utils.FileUtils;
import com.bytedance.im.ui.utils.BIMUIUtils;
import com.bytedance.im.ui.utils.media.AudioHelper;

import java.util.List;
/**
 * @type api
 * @brief BIMUI 对外接口类, 通过此类提供所有 UI 能力接口。
 */
public class BIMUIClient {
    /**
     * @hidden
     */
    private static final class InstanceHolder {
        private static final BIMUIClient instance = new BIMUIClient();
    }
    /**
     * @hidden
     */
    private BIMUIClient() {
    }

    /**
     * @return BIMClient 单例
     * @type api
     * @brief 获取 BIMClient 单例
     */
    public static BIMUIClient getInstance() {
        return InstanceHolder.instance;
    }

    /**
     * @param app    应用 Application 实例。
     * @param appId  从[控制台](https://console.volcengine.com/rtc/im/appManage)获取的应用 ID。
     *               不同应用 ID 无法进行互通。
     * @param config 配置信息，参看 BIMSDKConfig{@link #BIMSDKConfig}。
     * @type api
     * @brief 初始化 SDK。
     */
    public void init(Application application, int appId, BIMSDKConfig config) {
        init(application, appId, 0, "", config);
    }

    /**
     * @hidden
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
    /**
     * @param BIMUserProvider 用户信息 provider,参看 UserProvider{@link #UserProvider}。
     * @type api
     * @brief 设置用户信息 provider。
     */
    public void setUserProvider(BIMUserProvider BIMUserProvider) {
        UserManager.geInstance().setUserProvider(BIMUserProvider);
    }

    public BIMUserProvider getUserProvider() {
        return UserManager.geInstance().getUserProvider();
    }

    /**
     * @hidden
     */
    public void login(long uid, String token, BIMSimpleCallback callback) {
        BIMClient.getInstance().login(uid, token, callback);
    }

    /**
     * @hidden
     */
    public void addConnectListenerListener(final BIMConnectListener listener) {
        BIMClient.getInstance().addConnectListener(listener);
    }

    /**
     * @hidden
     */
    public void removeConnectListener(final BIMConnectListener listener) {
        BIMClient.getInstance().removeConnectListener(listener);
    }
    /**
     * @hidden
     */
    public void setGroupMemberRole(String conversationId, List<Long> uidList, BIMMemberRole role, BIMSimpleCallback callback) {
        BIMClient.getInstance().setGroupMemberRole(conversationId, uidList, role, callback);
    }
    /**
     * @hidden
     */
    public void addConversationListener(BIMConversationListListener listener) {
        BIMClient.getInstance().addConversationListener(listener);
    }

    /**
     * @hidden
     */
    public void removeConversationListener(BIMConversationListListener listener) {
        BIMClient.getInstance().removeConversationListener(listener);
    }

    /**
     * @hidden
     */
    public BIMMessage createTextMessage(String text){
        return BIMClient.getInstance().createTextMessage(text);
    }

    /**
     * @hidden
     */
    public BIMMessage createCustomMessage(String json) {
        return BIMClient.getInstance().createCustomMessage(json);
    }

    /**
     * @hidden
     */
    public BIMMessage createCustomMessage(BaseCustomElement content) {
        return createCustomMessage(BIMMessageManager.getInstance().encode(content));
    }

    /**
     * @hidden
     */
    public void sendMessage(final BIMMessage message, String conversationId, BIMSendCallback callback) {
        BIMClient.getInstance().sendMessage(message, conversationId, callback);
    }

    /**
     * @hidden
     */
    public void getConversation(String conversationId, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().getConversation(conversationId, callback);
    }

    /**
     * @hidden
     */
    public void getGroupMemberList(String conversationId, BIMResultCallback<List<BIMMember>> callback) {
        BIMClient.getInstance().getConversationMemberList(conversationId, callback);
    }

    /**
     * @hidden
     */
    public void leaveGroup(String conversationId, boolean isDeleteServer, BIMSimpleCallback callback) {
        BIMClient.getInstance().leaveGroup(conversationId, isDeleteServer, callback);
    }

    /**
     * @hidden
     */
    public void dissolveGroup(String conversationId, boolean isDeleteLocal, BIMSimpleCallback callback) {
        BIMClient.getInstance().dissolveGroup(conversationId, isDeleteLocal, callback);
    }

    /**
     * @hidden
     */
    public void createGroupConversation(BIMGroupInfo groupInfo, List<Long> uidList, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().createGroupConversation(groupInfo, uidList, callback);
    }

    /**
     * @hidden
     */
    public void createSingleConversation(long toUid, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().createSingleConversation(toUid, callback);
    }

    /**
     * @hidden
     */
    public void removeGroupMemberList(String conversationId, List<Long> ids, BIMSimpleCallback callback) {
        BIMClient.getInstance().removeGroupMemberList(conversationId, ids, callback);
    }

    /**
     * @hidden
     */
    public void addGroupMemberList(String conversationId, List<Long> ids, BIMSimpleCallback callback) {
        BIMClient.getInstance().addGroupMemberList(conversationId, ids, callback);
    }

    /**
     * @hidden
     */
    public void setGroupNotice(String conversationId, String notice, BIMSimpleCallback callback) {
        BIMClient.getInstance().setGroupNotice(conversationId, notice, callback);
    }


    /**
     * @hidden
     */
    public void setGroupName(String conversationId, String name, BIMSimpleCallback callback) {
        BIMClient.getInstance().setGroupName(conversationId, name, callback);
    }

    /**
     * @hidden
     */
    public void stickTopConversation(String conversationId, boolean isPined, BIMSimpleCallback callback) {
        BIMClient.getInstance().stickTopConversation(conversationId, isPined, callback);
    }


    /**
     * @hidden
     */
    public void muteConversation(String conversationId, boolean isMute, BIMSimpleCallback callback) {
        BIMClient.getInstance().muteConversation(conversationId, isMute, callback);
    }

    /**
     * @hidden
     */
    public BIMConnectStatus getConnectStatus() {
        return BIMClient.getInstance().getConnectStatus();
    }

    /**
     * @hidden
     */
    public int getAppId() {
        return BIMClient.getInstance().getAppID();
    }

    /**
     * @hidden
     */
    public long getCurUserId() {
        return BIMClient.getInstance().getCurrentUserID();
    }

    /**
     * @hidden
     */
    public String getVersion() {
        return BIMClient.getInstance().getVersion();
    }

    /**
     * @hidden
     */
    public void logout() {
        BIMClient.getInstance().logout();
    }
    /**
     * @hidden
     */
    public void getTotalUnreadMessageCount(BIMResultCallback<BIMUnReadInfo> callback) {
        BIMClient.getInstance().getTotalUnreadMessageCount(callback);
    }

    /**
     * @hidden
     */
    public void refreshMediaMessage(BIMMessage bimMessage, BIMResultCallback<BIMMessage> callback) {
        BIMClient.getInstance().refreshMediaMessage(bimMessage, callback);
    }
}

