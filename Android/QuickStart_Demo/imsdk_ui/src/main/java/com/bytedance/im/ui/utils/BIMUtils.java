package com.bytedance.im.ui.utils;

import android.content.Context;
import android.util.Log;

import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.ui.user.UserManager;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.model.BIMMessage;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

public class BIMUtils {
    private static Gson gson = new Gson();
    /**
     * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
     */
    public static int dip2px(Context context, float dpValue) {
        if (context != null) {
            final float scale = context.getResources().getDisplayMetrics().density;
            return (int) (dpValue * scale + 0.5f);
        }
        return 0;
    }

    public static String toJson(Object o){
        return gson.toJson(o);
    }


    /**
     * web 使用飞书富文本，临时兼容
     */
    public static String fixWebContent(String contentStr){
        try {
            JSONObject o = new JSONObject(contentStr);
            JSONObject textO = new JSONObject(o.getString("text"));
            String innerText = textO.getString("innerText");
            Log.i("fixWebContent","fixed Web");
            return innerText;
        } catch (JSONException e) {
            Log.i("fixWebContent","fixed Web no need");
        }
        return "";
    }

    public static String fixWebHint(String hint){
        try {
            JSONObject o = new JSONObject(hint);
            String innerText = o.getString("innerText");
            Log.i("fixWebContent","fixed WebHint ");
            return innerText;
        } catch (JSONException e) {
            Log.i("fixWebContent","fixed WebHint no need");
        }
        return "";
    }

    public static String generateRecallHint(BIMMessage bimMessage){
        String r = "";
        if (BIMClient.getInstance().getCurrentUserID() == bimMessage.getSenderUID()) {
            r = "你 撤回了一条消息";
        } else if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
            r = "对方 撤回了一条消息";
        } else {
            BIMUIUser user = UserManager.geInstance().getUserProvider().getUserInfo(bimMessage.getSenderUID());
            if(user !=null){
                r = user.getNickName() + " 撤回了一条消息";
            }else {
                r = bimMessage.getSenderUID() + " 撤回了一条消息";
            }
        }
        return r;
    }
}
