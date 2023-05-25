package com.bytedance.im.ui.emoji;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class EmojiUtils {
    private static String RES_PREFIX = "imsdk_emoji_";
    private static final int DEFAULT_EMOJI_SIZE = 23; //单位dp
    private static final int DEFAULT_TEXT_SIZE = 16; //单位sp

    public static float getEmojiDrawableHeight(Context context, float fontSizeInPx, boolean adjustFontSize) {
        if (adjustFontSize) {
            return getDefaultEmojiHeight(context) + (fontSizeInPx - getDefaultTextSize(context));
        } else {
            return fontSizeInPx;
        }
    }

    public static float getEmojiDrawableWidth(Drawable drawable, float height) {
        //drawable的宽高比
        float widthHeightRatio = drawable.getIntrinsicWidth() / (drawable.getIntrinsicHeight() + 0f);
        return widthHeightRatio * height;
    }

    static List<EmojiInfo> parseToList(JSONArray array) {
        if (array == null) {
            return null;
        }
        int length = array.length();
        List<EmojiInfo> emojiInfos = new ArrayList<>();
        for (int i = 0; i < length; i++) {
            EmojiInfo emojiInfo = parse(array.optJSONObject(i));
            if (emojiInfo != null) {
                emojiInfos.add(emojiInfo);
            }
        }
        return emojiInfos;
    }

    static EmojiInfo parse(JSONObject object) {
        if (object == null) {
            return null;
        }
        EmojiInfo emojiInfo = new EmojiInfo();
        emojiInfo.code = object.optInt("code");
        emojiInfo.text = object.optString("value");
        return emojiInfo;
    }

    public static int getEmojiResId(Context context, int code) {
        if (context == null) {
            return 0;
        }
        String resName = RES_PREFIX + code;
        try {
            return context.getResources().getIdentifier(resName, "drawable", context.getPackageName());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static float sp2px(Context context, float sp) {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_SP, sp, context.getResources().getDisplayMetrics());
    }

    public static float dip2Px(Context context, float dipValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return dipValue * scale + 0.5f;
    }

    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    public static float getDefaultTextSize(Context context) {
        return dip2Px(context, DEFAULT_TEXT_SIZE);
    }

    public static float getDefaultEmojiHeight(Context context) {
        return dip2Px(context, DEFAULT_EMOJI_SIZE);
    }

    static String getStringFromAssets(Context context, String fileName) {
        if (context == null) {
            return "";
        }

        InputStream inputStream = null;
        BufferedReader reader = null;
        try {
            inputStream = context.getAssets().open(fileName);
            reader = new BufferedReader(new InputStreamReader(inputStream));

            StringBuilder builder = new StringBuilder();

            String line;

            while ((line = reader.readLine()) != null) {
                builder.append(line);
            }
            return builder.toString();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return "";
    }
}
