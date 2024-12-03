package com.bytedance.im.ui.starter;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import com.bytedance.im.core.api.enums.BIMErrorCode;
import com.bytedance.im.core.api.interfaces.BIMResultCallback;
import com.bytedance.im.core.api.model.BIMConversation;
import com.bytedance.im.ui.BIMUIClient;
import com.bytedance.im.ui.message.BIMMessageListFragment;

import java.util.ArrayList;

public class ModuleStarter {
    public static final String MODULE_KEY_UID = "uid";
    public static final String MODULE_KEY_CID = "cid";
    public static final String MODULE_KEY_UID_LIST_INVALID = "uid_list_invalid";
    public static final String MODULE_KEY_UID_LIST_REMOVED = "uid_list_removed";
    public static final String MODULE_KEY_UID_LIST_CHECKED = "uid_list_checked";
    public static final String MODULE_KEY_SHOW_OWNER = "uid_list_is_show_owner";
    public static final String MODULE_KEY_OWNER_SELECTABLE = "uid_list_is_owner_selectable";
    public static final String MODULE_KEY_SHOW_TAG = "uid_list_is_show_tag";
    public static final String MODULE_KEY_UID_LIST = "uid_list";
    public static final String MODULE_KEY_TITLE = "title";
    public static final String MODULE_IS_DELETE_LOCAL = "is_delete_local";
    public static final String MODULE_MSG_UUID = "uuid";

    //启动个人页
    public boolean startProfileModule(Context context, long uid) {
        return startProfileModule(context, uid, null);
    }

    //启动个人页
    public boolean startProfileModule(Context context, long uid, String cid) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_UID, uid);
        if (!TextUtils.isEmpty(cid)) {
            intent.putExtra(MODULE_KEY_CID, cid);
        }
        intent.setAction("com.bytedance.im.app.profile.VEUserProfileEditActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        return checkAndStart(context, intent);
    }

    //启动搜索页
    public boolean startSearchModule(Context context, String cid) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_CID, cid);
        intent.setAction("com.bytedance.im.app.search.VESearchResultActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        return checkAndStart(context, intent);
    }

    public boolean startGlobalSearchModule(Context context){
        Intent intent = new Intent();
        intent.setAction("com.bytedance.im.app.search.global.VEGlobalSearchResultActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        return checkAndStart(context, intent);
    }

    //启动聊天页
    public boolean startMessageModule(Context context, String cid) {
        return startMessageModule(context, null, cid);
    }

    //启动聊天页
    public boolean startMessageModule(Context context, String uuid, String cid) {
        Intent intent = new Intent();
        intent.putExtra(BIMMessageListFragment.TARGET_CID, cid);
        if (!TextUtils.isEmpty(uuid)) {
            intent.putExtra(BIMMessageListFragment.TARGET_MSG_ID, uuid);
        }
        intent.setAction(BIMMessageListFragment.ACTION);
        intent.addCategory("android.intent.category.DEFAULT");
        return checkAndStart(context, intent);
    }

    //启动选人
    public boolean startMemberModuleAddForResult(Fragment fragment, String title, int requestCode) {
        return startMemberModuleAddForResult(fragment, title, new ArrayList<>(), requestCode);
    }
    //启动选人
    public boolean startMemberModuleAddForResult(Activity activity, String title, ArrayList<Long> invalidList, int requestCode) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_TITLE, title);
        intent.putExtra(MODULE_KEY_UID_LIST_INVALID, invalidList);
        intent.setAction("com.bytedance.im.app.member.user.VEUserAddActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        if (intent.resolveActivity(activity.getPackageManager()) != null) {
            activity.startActivityForResult(intent, requestCode);
            return true;
        }
        return false;
    }

    //启动选人
    public boolean startMemberModuleAddForResult(Fragment fragment, String title, ArrayList<Long> invalidList, int requestCode) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_TITLE, title);
        intent.putExtra(MODULE_KEY_UID_LIST_INVALID, invalidList);
        intent.setAction("com.bytedance.im.app.member.user.VEUserAddActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        if (intent.resolveActivity(fragment.getActivity().getPackageManager()) != null) {
            fragment.startActivityForResult(intent, requestCode);
            return true;
        }
        return false;
    }
    //启动查看列表

    public boolean startMemberModuleList(Activity activity, String title, String conversationId) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_TITLE, title);
        intent.putExtra(MODULE_KEY_CID, conversationId);
        intent.setAction("com.bytedance.im.app.member.group.VEMemberListActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        return checkAndStart(activity, intent);
    }
    //启动选人
    public boolean startMemberModuleSelect(Activity activity,
                                           String title,
                                           String conversationId,
                                           ArrayList<Long> removedList,
                                           ArrayList<Long> checkedList,
                                           boolean isShowOwner,
                                           boolean isOwnerSelectable,
                                           boolean isShowTag,
                                           int requestCode) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_TITLE, title);
        intent.putExtra(MODULE_KEY_CID, conversationId);
        intent.putExtra(MODULE_KEY_UID_LIST_REMOVED, removedList);
        intent.putExtra(MODULE_KEY_UID_LIST_CHECKED, checkedList);
        intent.putExtra(MODULE_KEY_SHOW_OWNER, isShowOwner);
        intent.putExtra(MODULE_KEY_SHOW_TAG, isShowTag);
        intent.putExtra(MODULE_KEY_OWNER_SELECTABLE,isOwnerSelectable);
        intent.setAction("com.bytedance.im.app.member.group.VEMemberSelectListActivity");
        intent.addCategory("android.intent.category.DEFAULT");
        if (intent.resolveActivity(activity.getPackageManager()) != null) {
            activity.startActivityForResult(intent, requestCode);
            return true;
        }
        return false;
    }
    //启动单选
    public boolean startMemberSelectSingle(Fragment fragment, String title, int requestCode) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_TITLE, title);
        intent.setAction("com.bytedance.im.app.member.user.VECreateSingleActivity");
        if (intent.resolveActivity(fragment.getActivity().getPackageManager()) != null) {
            fragment.startActivityForResult(intent, requestCode);
            return true;
        }
        return false;
    }
    //单聊详情
    public boolean startDetailSingleActivity(Activity activity, String conversationId) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_CID, conversationId);
        intent.setAction("com.bytedance.im.app.member.detail.VEDetailSingleConversationActivity");
        return checkAndStart(activity, intent);
    }
    //群聊详情
    public boolean startDetailGroupActivity(Activity activity,String conversationId){
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_CID, conversationId);
        intent.setAction("com.bytedance.im.app.member.detail.VEDetailGroupConversationActivity");
        return checkAndStart(activity, intent);
    }

    //检查是否存在内部会话管理
    public boolean checkExistInDetailGroupActivity(Context context){
        Intent intent = new Intent();
        intent.setAction("com.bytedance.im.app.conversationin.activity.INConversationDetailActivity");
        return  intent.resolveActivity(context.getPackageManager()) != null;
    }

    //群聊详情
    public boolean startInDetailGroupActivity(Activity activity,String conversationId){
        Intent intent = new Intent();
        intent.putExtra(MODULE_KEY_CID, conversationId);
        intent.setAction("com.bytedance.im.app.conversationin.activity.INConversationDetailActivity");
        return checkAndStart(activity, intent);
    }

    //已读回执列表
    public boolean startReadReceiptListActivity(Activity activity, String msgUUID) {
        Intent intent = new Intent();
        intent.putExtra(MODULE_MSG_UUID, msgUUID);
        intent.setAction("com.bytedance.im.app.member.receipt.VEReadReceiptListActivity");
        return checkAndStart(activity, intent);
    }
    //启动陌生人会话
    public boolean startStrangeConvListActivity(Activity activity) {
        Intent intent = new Intent();
        intent.setAction("com.bytedance.im.app.conversationin.strange.INStrangeConvListActivity");
        return checkAndStart(activity,intent);
    }

    public boolean startConvMemberSearch(Activity activity,String conversationId){
        Intent intent = new Intent();
        intent.putExtra(ModuleStarter.MODULE_KEY_CID,conversationId);
        intent.setAction("com.bytedance.im.app.search.global.member.VEConvMemberSearchActivity");
        return checkAndStart(activity,intent);
    }

    private boolean checkAndStart(Context context, Intent intent) {
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(intent);
            return true;
        }
        return false;
    }
}
