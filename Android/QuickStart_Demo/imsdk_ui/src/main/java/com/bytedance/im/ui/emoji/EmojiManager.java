package com.bytedance.im.ui.emoji;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.TextUtils;

import org.json.JSONArray;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by weizhenguo on 2019-10-14.
 */
public class EmojiManager {

    private static String ASSETS_FILE_NAME = "emoji/emoji.txt";
    private static final int MARGIN = 2;
    private Pattern mPattern = Pattern.compile("\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]");

    private List<EmojiInfo> mEmojiArray;
    private Map<String, EmojiInfo> mEmojiMap;

    private volatile static EmojiManager sInstance;

    private EmojiManager() {

    }

    public static EmojiManager getInstance() {
        if (sInstance == null) {
            synchronized (EmojiManager.class) {
                if (sInstance == null) {
                    sInstance = new EmojiManager();
                }
            }
        }
        return sInstance;
    }

    public SpannableString parseEmoJi(Context context, CharSequence content, float fontSizeInPx, boolean adjustFontSize) {
        float height = EmojiUtils.getEmojiDrawableHeight(context, fontSizeInPx, adjustFontSize) + 0.5f;
        return parseEmoJi(context, content, height);
    }

    public SpannableString parseEmoJi(Context context, CharSequence content) {
        float height = EmojiUtils.getDefaultEmojiHeight(context);
        return parseEmoJi(context, content, height);
    }

    public SpannableString parseEmoJi(Context context, CharSequence content, float height) {
        if (content == null || context == null) {
            return null;
        }
        //先移除已经添加加入的span
        if (content instanceof Spannable) {
            Spannable spanContent = (Spannable) content;
            EmojiCenterImageSpan[] spans = spanContent.getSpans(0, content.length(), EmojiCenterImageSpan.class);
            if (spans != null && spans.length > 0) {
                for (EmojiCenterImageSpan span : spans) {
                    spanContent.removeSpan(span);
                }
            }
        }

        SpannableString spannable = SpannableString.valueOf(content);
        Matcher matcher = mPattern.matcher(content);
        while (matcher.find()) {
            String regEmoJi = matcher.group();//获取匹配到的emoji字符串
            int start = matcher.start();//匹配到字符串的开始位置
            int end = matcher.end();//匹配到字符串的结束位置
            int resId = getEmojiResId(context, regEmoJi);//通过emoji名获取对应的表情id
            Drawable drawable;
            if (resId > 0) {
                drawable = context.getResources().getDrawable(resId);
            } else {
                continue;
            }
            if (drawable != null) {
                int width = (int) (EmojiUtils.getEmojiDrawableWidth(drawable, height) + 0.5f);
                drawable.setBounds(0, 0, width, (int) height);

                EmojiCenterImageSpan imageSpan = new EmojiCenterImageSpan(drawable);
                imageSpan.mMarginLeft = MARGIN;
                imageSpan.mMarginRight = MARGIN;
                spannable.setSpan(imageSpan, start, end, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
            }
        }
        return spannable;
    }

    public int getEmojiResId(Context context, String text) {
        if (TextUtils.isEmpty(text)) {
            return 0;
        }
        if (mEmojiMap == null) {
            loadEmojiConfig(context);
        }
        if (mEmojiMap == null) {
            return 0;
        }
        EmojiInfo emojiInfo = mEmojiMap.get(text);
        return emojiInfo == null ? 0 : emojiInfo.resId;
    }

    public List<EmojiInfo> getEmojis(Context context) {
        if (mEmojiArray == null) {
            loadEmojiConfig(context);
        }
        return mEmojiArray;
    }

    private void loadEmojiConfig(Context context) {
        String configStr = EmojiUtils.getStringFromAssets(context, ASSETS_FILE_NAME);
        if (TextUtils.isEmpty(configStr)) {
            return;
        }
        try {
            mEmojiArray = EmojiUtils.parseToList(new JSONArray(configStr));
            int length = mEmojiArray.size();
            mEmojiMap = new HashMap<>();
            for (int i = 0; i < length; i++) {
                EmojiInfo emojiInfo = mEmojiArray.get(i);
                if (emojiInfo == null) {
                    continue;
                }
                emojiInfo.resId = EmojiUtils.getEmojiResId(context, emojiInfo.code);
                mEmojiMap.put(emojiInfo.text, emojiInfo);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
