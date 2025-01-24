package com.bytedance.im.ui.utils;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.bytedance.im.core.api.enums.BIMConversationType;
import com.bytedance.im.core.api.model.BIMMember;
import com.bytedance.im.ui.api.BIMUIUser;
import com.bytedance.im.core.api.BIMClient;
import com.bytedance.im.core.api.model.BIMMessage;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

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

    public static String toJson(Object o) {
        return gson.toJson(o);
    }


    /**
     * web 使用飞书富文本，临时兼容
     */
    public static String fixWebContent(String contentStr) {
        try {
            JSONObject o = new JSONObject(contentStr);
            JSONObject textO = new JSONObject(o.getString("text"));
            String innerText = textO.getString("innerText");
            Log.i("fixWebContent", "fixed Web");
            return innerText;
        } catch (JSONException e) {
            Log.i("fixWebContent", "fixed Web no need");
        }
        return "";
    }

    public static String fixWebHint(String hint) {
        try {
            JSONObject o = new JSONObject(hint);
            String innerText = o.getString("innerText");
            Log.i("fixWebContent", "fixed WebHint ");
            return innerText;
        } catch (JSONException e) {
            Log.i("fixWebContent", "fixed WebHint no need");
        }
        return "";
    }

    public static String generateRecallHint(BIMMessage bimMessage, BIMUIUser user) {
        return generateRecallHint(bimMessage, user, null);
    }

    public static String generateRecallHint(BIMMessage bimMessage, BIMUIUser user, BIMMember member) {
        String r = "";
        if (BIMClient.getInstance().getCurrentUserID() == bimMessage.getSenderUID()) {
            r = "你 撤回了一条消息";
        } else if (bimMessage.getConversationType() == BIMConversationType.BIM_CONVERSATION_TYPE_ONE_CHAT) {
            r = "对方 撤回了一条消息";
        } else {
            if (user != null) {
                String name = BIMUINameUtils.getShowNameInGroup(member, user);
                r = name + " 撤回了一条消息";
            }
        }
        return r;
    }

    public static String mapToString(Map<String, String> map) {
        if (map == null) {
            return null;
        }
        try {
            JSONObject json = new JSONObject();
            for (String key : map.keySet()) {
                String value = map.get(key);
                if (TextUtils.isEmpty(key) || TextUtils.isEmpty(value)) {
                    continue;
                }
                json.put(key, value);
            }
            return json.toString();
        } catch (Exception e) {
            // ignore
        }
        return null;
    }

    public static Map<String, String> stringToMap(String input) {
        return stringToMap(input, new HashMap<String, String>());
    }

    public static Map<String, String> stringToMap(String input, Map<String, String> oldMap) {
        if (TextUtils.isEmpty(input) || oldMap == null) {
            return null;
        }
        try {
            JSONObject json = new JSONObject(input);
            Iterator<?> it = json.keys();
            while (it.hasNext()) {
                String key = (String) it.next();
                if (TextUtils.isEmpty(key)) {
                    continue;
                }
                String value = json.getString(key);
                if (TextUtils.isEmpty(value)) {
                    continue;
                }
                oldMap.put(key, value);
            }
        } catch (Exception e) {
            // ignore
        }
        return oldMap;
    }
}
