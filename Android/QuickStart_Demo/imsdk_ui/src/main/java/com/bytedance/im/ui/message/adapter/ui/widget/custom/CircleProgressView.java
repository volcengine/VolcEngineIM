package com.bytedance.im.ui.message.adapter.ui.widget.custom;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.View;

public class CircleProgressView extends View {

    private Paint paint;
    private RectF rectF;
    private Rect rect;
    public CircleProgressView(Context context) {
        this(context,null);
    }

    public CircleProgressView(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs,0);
    }

    public CircleProgressView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        paint = new Paint();
        paint.setAntiAlias(true);
        rectF = new RectF();
        rect = new Rect();
    }

    private int current = 1, max = 100;
    private float arcWidth = 10;
    private float width;

    public void setProgress(int current) {
        this.current = current;
        invalidate();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        width = getMeasuredWidth();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(arcWidth);
        paint.setColor(Color.GRAY);
        float bigCircleRadius = width / 2;
        float smallCircleRadius = bigCircleRadius - arcWidth;
        canvas.drawCircle(bigCircleRadius, bigCircleRadius, smallCircleRadius, paint);
        paint.setColor(Color.GREEN);
        rectF.set(arcWidth, arcWidth, width - arcWidth, width - arcWidth);
        canvas.drawArc(rectF, 90, current * 360 / max, false, paint);
        String txt = current * 100 / max + "%";
        paint.setStrokeWidth(0);
        paint.setTextSize(40);
        paint.getTextBounds(txt, 0, txt.length(), rect);
        paint.setColor(Color.GREEN);
        canvas.drawText(txt, bigCircleRadius - rect.width() / 2, bigCircleRadius + rect.height() / 2, paint);
    }
}
