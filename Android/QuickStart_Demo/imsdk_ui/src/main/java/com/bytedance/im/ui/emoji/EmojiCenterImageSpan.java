package com.bytedance.im.ui.emoji;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.text.TextUtils;
import android.text.style.ImageSpan;

/**
 * prevent a leak: android.text.TextLine#sCached, android.text.SpanSet#recycle
 * see : https://android-review.googlesource.com/#/c/145621/
 */
public class EmojiCenterImageSpan extends ImageSpan {

    public int mMarginLeft;
    public int mMarginRight;
    private Drawable drawable;
    private Rect rect;

    public EmojiCenterImageSpan(Bitmap b) {
        super(b);
    }

    public EmojiCenterImageSpan(Bitmap b, int verticalAlignment) {
        super(b, verticalAlignment);
    }

    public EmojiCenterImageSpan(Context context, Bitmap b) {
        super(context.getApplicationContext(), b);
    }

    public EmojiCenterImageSpan(Context context, Bitmap b, int verticalAlignment) {
        super(context.getApplicationContext(), b, verticalAlignment);
    }

    public EmojiCenterImageSpan(Drawable d) {
        super(d);
    }

    public EmojiCenterImageSpan(Drawable d, int verticalAlignment) {
        super(d, verticalAlignment);
    }

    public EmojiCenterImageSpan(Drawable d, String source) {
        super(d, source);
    }

    public EmojiCenterImageSpan(Drawable d, String source, int verticalAlignment) {
        super(d, source, verticalAlignment);
    }

    public EmojiCenterImageSpan(Context context, Uri uri) {
        super(context.getApplicationContext(), uri);
    }

    public EmojiCenterImageSpan(Context context, Uri uri, int verticalAlignment) {
        super(context.getApplicationContext(), uri, verticalAlignment);
    }

    public EmojiCenterImageSpan(Context context, int resourceId) {
        super(context.getApplicationContext(), resourceId);
    }

    public EmojiCenterImageSpan(Context context, int resourceId, int verticalAlignment) {
        super(context.getApplicationContext(), resourceId, verticalAlignment);
    }

    @Override
    public int getSize(Paint paint, CharSequence text, int start, int end,
                       Paint.FontMetricsInt fontMetricsInt) {
        if (!emojiIsValid(text, start, end)) {
            return 0;
        }
        drawable = getDrawable();
        rect = drawable.getBounds();
        if (fontMetricsInt != null) {
            Paint.FontMetricsInt fmPaint = paint.getFontMetricsInt();
            int fontHeight = fmPaint.bottom - fmPaint.top;
            int drHeight = rect.bottom - rect.top;

            int top = drHeight / 2 - fontHeight / 4;
            int bottom = drHeight / 2 + fontHeight / 4;

            fontMetricsInt.ascent = -bottom;
            fontMetricsInt.top = -bottom;
            fontMetricsInt.bottom = top;
            fontMetricsInt.descent = top;
        }
        return rect.right + mMarginLeft + mMarginRight;
    }

    @Override
    public void draw(Canvas canvas, CharSequence text, int start, int end,
                     float x, int top, int y, int bottom, Paint paint) {
        if (!emojiIsValid(text, start, end)) {
            return;
        }
        if (canvas == null || rect == null) {
            return;
        }
        if (x + mMarginLeft + (rect.right - rect.left) + mMarginRight > canvas.getWidth()) {
            return;
        }
        x += mMarginLeft;
        Drawable drawable = getDrawable();
        canvas.save();
//        int transY = ((bottom - top) - drawable.getBounds().bottom) / 2 + top;
        Paint.FontMetricsInt fm = paint.getFontMetricsInt();
        int transY = (int) (((y + fm.descent) + (y + fm.ascent)) / 2 - drawable.getBounds().bottom / 2 + 0.5f);
        canvas.translate(x, transY);
        drawable.draw(canvas);
        canvas.restore();
    }

    //解决部分机型（pixel 3 android9.0、huwei nova3i android9.0等机型）在表情和/处在换行处引发的表情重复绘制导致富文本绘制超出屏幕
    private boolean emojiIsValid(CharSequence text, int start, int end) {
        //使用setting控制是否走判断逻辑
//        if (!EmojiSettingsManager.INSTANCE.shouldUseEmojiVerify()) {
//            return true;
//        }
        if (TextUtils.isEmpty(text)) {
            return false;
        }
        return text.subSequence(start, end).toString().startsWith("[");
    }
}