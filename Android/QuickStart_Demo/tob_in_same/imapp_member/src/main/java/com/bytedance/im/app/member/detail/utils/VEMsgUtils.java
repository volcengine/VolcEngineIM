package com.bytedance.im.app.member.detail.utils;

import android.text.TextUtils;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class VEMsgUtils {

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
