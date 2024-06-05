package com.bytedance.im.ui.message.adapter.ui.widget.input.audio;

import android.Manifest;
import android.app.Fragment;
import android.content.Context;
import androidx.annotation.Nullable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.TextView;

import com.bytedance.im.ui.log.BIMLog;
import com.bytedance.im.ui.utils.BIMPermissionController;
import com.bytedance.im.ui.utils.FileUtils;
import com.bytedance.im.ui.utils.audio.VoiceRecordManager;

import java.io.File;

public class VoiceInputButton extends TextView {
    private static final String TAG = "VoiceInputButton";
    private boolean callEnd = false;
    private boolean callCancel = false;
    private Fragment fragment;
    private VoiceRecordManager voiceRecordManager;
    private OnAudioRecordListener listener;

    public VoiceInputButton(Context context) {
        this(context, null);
    }

    public VoiceInputButton(Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public VoiceInputButton(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public void init(Fragment fragment, OnAudioRecordListener listener) {
        this.fragment = fragment;
        this.listener = listener;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            setText("正在录音,手指上滑取消");
            onAudioStart();
            callEnd = false;
            callCancel = false;
        } else if (event.getAction() == MotionEvent.ACTION_UP) {
            setText("点击录音");
            if (!callEnd && !callCancel) {
                onAudioEnd();
            }
            callEnd = true;
        } else if (event.getAction() == MotionEvent.ACTION_MOVE) {
            if (event.getY() < 0 && !callCancel) {
                setText("点击录音");
                onAudioCancel();
                callCancel = true;
            }
        }
        return true;
    }

    public void onAudioStart() {
        BIMLog.i(TAG, "onAudioStart()");
        BIMPermissionController.checkPermission(fragment.getActivity(), new String[]{Manifest.permission.RECORD_AUDIO,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.WRITE_EXTERNAL_STORAGE}, (isAllGranted, permissions, grantResults) -> {
            if (isAllGranted) {
                if (voiceRecordManager == null) {
                    voiceRecordManager = new VoiceRecordManager();
                }
                voiceRecordManager.reset(getContext().getFilesDir()+ File.separator + System.currentTimeMillis() + ".aac");
                voiceRecordManager.start();
                if (listener != null) {
                    listener.onStart();
                }
            }
        });
    }

    public void onAudioEnd() {
        BIMLog.i(TAG, "onAudioEnd()");
        if (voiceRecordManager != null) {
            voiceRecordManager.stop();
            voiceRecordManager.release();
            if (listener != null) {
                listener.onSuccess(voiceRecordManager.getPath());
            }
        }
    }

    public void onAudioCancel() {
        BIMLog.i(TAG, "onAudioCancel()");
        if (voiceRecordManager != null) {
            voiceRecordManager.stop();
            voiceRecordManager.release();
        }
        if (listener != null) {
            listener.onCancel();
        }
    }

    public interface OnAudioRecordListener {
        void onStart();
        void onCancel();
        void onSuccess(String path);
    }
}
