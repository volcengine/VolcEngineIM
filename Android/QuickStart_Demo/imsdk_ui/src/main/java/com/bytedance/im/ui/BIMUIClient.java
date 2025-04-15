package com.bytedance.im.ui;

import android.app.Application;


import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.enums.BIMConnectStatus;
import com.bytedance.im.core.api.enums.BIMEnv;
import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.enums.BIMMemberRole;
import com.bytedance.im.core.api.enums.BIMMessageType;
import com.bytedance.im.core.api.interfaces.BIMConnectListener;
import com.bytedance.im.core.api.interfaces.BIMConversationListListener;
import com.bytedance.im.core.api.interfaces.BIMMessageListener;
import com.bytedance.im.core.api.interfaces.BIMP2PMessageListener;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.interfaces.BIMSendCallback;
import com.bytedance.im.core.api.interfaces.BIMSimpleCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.core.api.model.BIMGroupInfo;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.core.api.model.BIMMessage;
import com.bytedance.im.core.api.model.BIMSDKConfig;
import com.bytedance.im.core.api.model.BIMUnReadInfo;
import com.bytedance.im.imcloud.internal.utils.IMLog;
import com.bytedance.im.ui.api.interfaces.BIMMessageOperation;
import com.bytedance.im.ui.api.interfaces.BIMUserExistChecker;
import com.bytedance.im.ui.member.BIMGroupMemberProvider;
import com.bytedance.im.ui.message.BIMMessageListFragment;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyMessageUI;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMP2PTypingElement;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareElement;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMShareCustomMessageUI;
import com.bytedance.im.ui.message.adapter.ui.custom.BIMGroupNotifyElement;
import com.bytedance.im.ui.message.adapter.ui.widget.input.tools.BaseToolBtn;
import com.bytedance.im.ui.message.adapter.ui.widget.pop.BIMMessageOptionPopupWindow;
import com.bytedance.im.core.model.inner.msg.BaseCustomElement;
import com.bytedance.im.ui.message.convert.base.ui.BaseCustomElementUI;
import com.bytedance.im.core.service.manager.BIMMessageManager;
import com.bytedance.im.ui.message.convert.manager.BIMMessageUIManager;
import com.bytedance.im.ui.starter.ModuleStarter;
import com.bytedance.im.ui.user.BIMUserProvider;
import com.bytedance.im.ui.user.DefaultProvider;
import com.bytedance.im.ui.utils.FileUtils;
import com.bytedance.im.ui.utils.BIMUIUtils;
import com.bytedance.im.ui.utils.media.AudioHelper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @type api
 * @brief BIMUI 对外接口类, 通过此类提供所有 UI 能力接口。
 */
public class BIMUIClient {
    private static final String TAG = "BIMUIClient";
    private ModuleStarter moduleStarter;
    private BIMUserExistChecker userExistChecker;

    private BIMGroupMemberProvider bimGroupMemberProvider = new BIMGroupMemberProvider();

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
        moduleStarter = new ModuleStarter();
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
     * @param application 应用 Application 实例。
     * @param appId       从[控制台](https://console.volcengine.com/rtc/im/appManage)获取的应用 ID。
     *                    不同应用 ID 无法进行互通。
     * @param config      配置信息，参看 BIMSDKConfig{@link #BIMSDKConfig}。
     * @type api
     * @brief 初始化 SDK。
     */
    public void init(Application application, int appId, BIMSDKConfig config) {
        init(application, appId, BIMEnv.DEFAULT_ZH.getEnv(), "", config);
    }

    /**
     * @hidden
     */
    public void init(Application application, int appId, int env, BIMSDKConfig config) {
        init(application, appId, env, "", config);
    }

    /**
     * @hidden
     */
    public void init(Application application, int appId, int env, String swimLean, BIMSDKConfig config) {
        BIMClient.getInstance().initSDK(application, appId, config, env, swimLean);
        if (BIMUIUtils.isMainProcess(application) && BIMUIUtils.isMainThread()) {
            FileUtils.initDir(application);
            AudioHelper.getInstance().initAudio(application);
            BIMMessageUIManager.getInstance().init();
            registerMessageUI(new BIMShareCustomMessageUI());
            registerMessageUI(new BIMGroupNotifyMessageUI());
            registerMessageElement("1", BIMShareElement.class);
            registerMessageElement("2", BIMGroupNotifyElement.class);
            registerMessageElement("1000", BIMP2PTypingElement.class);
            getUserProvider().init(application);
            getBimGroupMemberProvider().init();
        }
        IMLog.i(TAG, "initUISDK end initVersion: " + getVersion() + " imSDK initVersion: " + BIMClient.getInstance().getVersion());
    }

    /**
     * @hidden
     */
    public <T extends BaseCustomElementUI> void registerMessageUI(T abstractMessageUI) {
        BIMMessageUIManager.getInstance().registerMessageUI(abstractMessageUI);
    }

    /**
     * @hidden
     */
    public void registerMessageElement(String type, Class<? extends BaseCustomElement> cls) {
        BIMClient.getInstance().registerMessageElement(type, cls);
    }

    /**
     * @hidden
     */
    public void registerMessageOperation(BIMMessageOperation operation) {
        BIMMessageOptionPopupWindow.registerOperation(operation);
    }

    /**
     * @hidden
     */
    public void registerToolBtn(BaseToolBtn toolBtn) {
        BIMMessageListFragment.registerCustomToolBtn(toolBtn);
    }

    /**
     * @hidden
     */
    private BIMUserProvider provider;

    /**
     * @param BIMUserProvider 用户信息 provider,参看 UserProvider{@link #UserProvider}。
     * @type api
     * @brief 设置用户信息 provider。
     */
    public void setUserProvider(BIMUserProvider provider) {
        this.provider = provider;
    }

    /**
     * @hidden
     */
    public BIMUserProvider getUserProvider() {
        if (provider == null) {
            provider = new DefaultProvider();
        }
        return provider;
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
    public void login(String uidStr, String token, BIMSimpleCallback callback) {
        BIMClient.getInstance().loginWithUIDString(uidStr, token, callback);
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
    public void addMessageListener(BIMMessageListener listener) {
        BIMClient.getInstance().addMessageListener(listener);
    }

    /**
     * @hidden
     */
    public void removeMessageListener(BIMMessageListener listener) {
        BIMClient.getInstance().removeMessageListener(listener);
    }

    /**
     * @hidden
     */
    public BIMMessage createTextMessage(String text) {
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
        String data = BIMMessageManager.getInstance().encode(content);
        content.setData(data);
        return createCustomMessage(data);
    }

    /**
     * @hidden
     */
    public BIMMessage createP2PMessage(BaseCustomElement content) {
        String data = BIMMessageManager.getInstance().encode(content);
        content.setData(data);
        return createP2PMessage(data);
    }

    /**
     * @hidden
     */
    public BIMMessage createP2PMessage(String content) {
        return BIMClient.getInstance().createP2PMessage(content);
    }

    /**
     * @hidden
     */
    public void sendP2PMessage(final BIMMessage message, String conversationId, BIMSimpleCallback callback) {
        BIMClient.getInstance().sendP2PMessage(message, conversationId, callback);
    }


    /**
     * @hidden
     */
    public void sendP2PMessage(final BIMMessage message, String conversationId, List<Long> userIdList, BIMSimpleCallback callback) {
        BIMClient.getInstance().sendP2PMessage(message, conversationId, userIdList, callback);
    }


    /**
     * @hidden
     */
    public void addP2PMessageListener(BIMP2PMessageListener listener) {
        BIMClient.getInstance().addP2PMessageListener(listener);
    }


    /**
     * @hidden
     */
    public void removeP2PMessageListener(BIMP2PMessageListener listener) {
        BIMClient.getInstance().removeP2PMessageListener(listener);
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
    public void getConversationByShortID(long conversationShortId, boolean isServer, BIMResultCallback<BIMConversation> callback) {
        BIMClient.getInstance().getConversationByShortID(conversationShortId, isServer, callback);
    }

    /**
     * @hidden
     */
    public void getConversationByShortIDList(List<Long> conversationShortIdList, boolean isServer, BIMResultCallback<List<BIMConversation>> callback) {
        BIMClient.getInstance().getConversationByShortIDList(conversationShortIdList, isServer, callback);
    }

    /**
     * @hidden
     */
    public void getConversationMemberList(String conversationId, BIMResultCallback<List<BIMMember>> callback) {
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
        return BuildConfig.VERSION_NAME;
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


    /**
     * @hidden
     */
    public void getMessage(String uuid, BIMResultCallback<BIMMessage> callback) {
        BIMClient.getInstance().getMessage(uuid, callback);
    }

    /**
     * @hidden
     */
    public void getMessageByServerID(long msgId, long conversationShortId, boolean isServer, BIMResultCallback<BIMMessage> callback) {
        BIMClient.getInstance().getMessageByServerID(msgId, conversationShortId, isServer, callback);
    }

    /**
     * @param message  待更新的消息
     * @param callback 结果回调, 参看 BIMResultCallback{@link #BIMResultCallback},BIMMessage{@link #BIMMessage}
     * @type api
     * @brief 修改消息内容和ext。
     */
    public void modifyMessage(BIMMessage message, BIMResultCallback<BIMMessage> callback) {
        if (message.getMsgType() == BIMMessageType.BIM_MESSAGE_TYPE_CUSTOM) {
            BaseCustomElement customElement = (BaseCustomElement) message.getElement();
            customElement.setData(BIMMessageManager.getInstance().encode(customElement));//更新element
            BIMClient.getInstance().modifyMessage(message, callback);
        } else {
            if (callback != null) {
                callback.onFailed(BIMErrorCode.BIM_PARAMETER_ERROR);
            }
        }
    }

    public ModuleStarter getModuleStarter() {
        return moduleStarter;
    }

    public BIMUserExistChecker getUserExistChecker() {
//        if (userExistChecker == null) {
            return new BIMUserExistChecker() {
                @Override
                public void check(List<Long> uidList, BIMResultCallback<Map<Long, Boolean>> callback) {
                    Map<Long, Boolean> map = new HashMap<>();
                    if (uidList != null && !uidList.isEmpty()) {
                        for (Long uid : uidList) {
                            map.put(uid, true); //默认全部认为账号存在
                        }
                    }
                    callback.onSuccess(map);
                }
            };
//        }
//        return userExistChecker;
    }

    public void setUserExistChecker(BIMUserExistChecker userExistChecker) {
        this.userExistChecker = userExistChecker;
    }

    public BIMGroupMemberProvider getBimGroupMemberProvider() {
        return bimGroupMemberProvider;
    }
}

