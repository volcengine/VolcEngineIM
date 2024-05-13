package com.bytedance.im.ui.message.adapter.ui.widget.input.measure;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.PopupWindow;

public class KeyBoardHeightHelper {
    private static final String TAG = "KeyBoardHeightHelper";
    private PopupWindow popwindow;
    private int start;
    private static int keyBoardHeight;

    public void showMeasureWindow(View view, OnMeasureCompleteListener onMeasureCompleteListener) {
        Log.i(TAG, "showMeasureWindow");
        view.post(new Runnable() {
            @Override
            public void run() {
                popwindow = new PopupWindow();
                FrameLayout contentView = new MeasureLayout(view.getContext(), new MeasureLayout.onHeightChangedListener() {
                    @Override
                    public void onHeightChanged(int height) {
                        if (start == 0) {
                            start = height;
                        } else if (height < start) {
                            keyBoardHeight = start - height;
                            if (onMeasureCompleteListener != null) {
                                onMeasureCompleteListener.onKeyBoardShow(keyBoardHeight);
                            }
                        } else {
                            if (onMeasureCompleteListener != null) {
                                onMeasureCompleteListener.onKeyBoardHide();
                            }
                        }
                    }
                });
                popwindow.setContentView(contentView);
                popwindow.setWidth(0);
                popwindow.setHeight(WindowManager.LayoutParams.MATCH_PARENT);
                popwindow.setBackgroundDrawable(new ColorDrawable(Color.RED));
                popwindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
                popwindow.setInputMethodMode(PopupWindow.INPUT_METHOD_NEEDED);
                popwindow.showAtLocation(view.getRootView(), Gravity.NO_GRAVITY, 0, 0);
            }
        });
    }

    public void onDetached() {
        if (popwindow != null) {
            popwindow.dismiss();
        }
    }

    public static int getKeyBoardHeight() {
        return keyBoardHeight;
    }

    public interface OnMeasureCompleteListener {
        void onKeyBoardShow(int keyBoardHeight);

        void onKeyBoardHide();
    }
}
