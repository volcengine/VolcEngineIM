package com.bytedance.im.app.utils;

import android.icu.text.Collator;
import android.os.Build;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;

public class SimplePinyinHelper {
    private static String TAG = "SimplePinyinHelper";

    //use gb2312
    private static Range range[] = new Range[] {
            new Range('A', '阿'),
            new Range('B', '丷'),
            new Range('C', '擦'),
            new Range('D', '咑'),
            new Range('E', '妸'),
            new Range('F', '发'),
            new Range('G', '旮'),
            new Range('H', '哈'),
            new Range('J', '讥'),
            new Range('K', '咖'),
            new Range('L', '拉'),
            new Range('M', '妈'),
            new Range('N', '拿'),
            new Range('O', '哦'),
            new Range('P', '妑'),
            new Range('Q', '七'),
            new Range('R', '呥'),
            new Range('S', '仨'),
            new Range('T', '它'),
            new Range('W', '洼'),
            new Range('X', '夕'),
            new Range('Y', '丫'),
            new Range('Z', '匝'),
    };

    private static final List<String> chineseTags = new ArrayList<>();
    private static final boolean highVersion = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N;
    static {
        for (Range r : range) {
            chineseTags.add("" + r.chineseChar);
        }
    }

    public static boolean ifValid(String s) {
        if (s.isEmpty()) {
            return false;
        } else {
            char c = s.toCharArray()[0];
            return (c >= 0x4E00 && c <= 0x9FA5) || (c >= 0x2E80 && c <= 0x2EF3);
        }
    }

    public static Character getCharBySort(String t) {
        try {
            if (highVersion) {
                Collator c = Collator.getInstance(Locale.CHINESE);
                int n = Collections.binarySearch(chineseTags, t, c::compare);
                if (n < 0) n = (-n) - 1 - 1; // locate there and use pre range char
                if (n <= 0) n = 0;
                return range[n].c;
            } else {
                java.text.Collator c = java.text.Collator.getInstance(Locale.CHINESE);
                int n = Collections.binarySearch(chineseTags, t, c::compare);
                if (n < 0) n = (-n) - 1 - 1;
                if (n <= 0) n = 0;
                return range[n].c;
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
        }
        return null;
    }

    public static String getFirstPinyinChar(String chinese) {
        StringBuilder sb = new StringBuilder();
        String[] split = chinese.split("");
        for (String s: split) {
            if (s.isEmpty()) {
                continue;
            }

            Character c = null;
            if (ifValid(s)) {
                c = getCharBySort(s);
            } else {
                sb.append(s);
                continue;
            }

            if (c == null) {
                break;
            } else {
                sb.append(c);
            }
        }

        Log.d(TAG, sb.toString());
        if (sb.length() <= 0) {
            return "#";
        } else {
            return sb.toString();
        }
    }
}

class Range {
    public char c, chineseChar;

    public Range(char c, char c1) {
        this.c = c;
        this.chineseChar = c1;
    }
}
