package com.bytedance.im.ui.utils.audio;

import android.media.MediaRecorder;
import android.util.Log;

import com.bytedance.im.ui.log.BIMLog;

import java.io.File;
import java.io.IOException;


public class VoiceRecordManager {
    private final String TAG = "VoiceRecordManager ";
    private MediaRecorder mMediaRecorder;

    //录音状态
    private int mCurrentRecordState = RecordState.IDLE;
    private String path;
    public interface RecordState {
        int IDLE = 0;
        int PREPARED = 1;
        int START = 2;
        int STOP = 3;
        int RELEASE = 4;
    }

    public VoiceRecordManager() {
        //防止手机录音器不能用导致crash的情况
        try {
            mMediaRecorder = new MediaRecorder();
        } catch (Exception e) {
            BIMLog.e(TAG, "VoiceRecordManager() e:"+ Log.getStackTraceString(e));
        }
    }

    public boolean reset(String path) {
        BIMLog.i(TAG, "reset() path:" + path);
        File temp = new File(path);
        if (!temp.exists()) {
            try {
                temp.createNewFile();
            } catch (IOException e) {
                BIMLog.i(TAG, "reset() e.getMessage(): " + e.getMessage() + " e.getCause():" + e.getCause());
                e.printStackTrace();
            }
        }
        this.path = path;
        if (mMediaRecorder != null) {
            try {
                if (mMediaRecorder == null) {
                    mMediaRecorder = new MediaRecorder();
                }
                mMediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);//设置录音来源
                mMediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.AAC_ADTS);//设置输出格式
                mMediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);//设置编码格式
                mMediaRecorder.setOutputFile(path);//设置输出路径
                mMediaRecorder.prepare();//准备
                mCurrentRecordState = RecordState.PREPARED;
                return true;
            } catch (Exception e) {
                BIMLog.i(TAG, "reset() e: "+e);
            }
        } else {
            BIMLog.i(TAG , "reset:mMediaRecorder = null");
        }
        mCurrentRecordState = RecordState.IDLE;
        return false;
    }

    public boolean start() {
        if (mMediaRecorder != null) {
            try {
                mMediaRecorder.start();
                mCurrentRecordState = RecordState.START;
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                BIMLog.e(TAG, "start() e message:"+ e.getMessage());
                BIMLog.e(TAG, "start() e cause:"+ e.getCause());
                BIMLog.e(TAG, "start() e:"+ Log.getStackTraceString(e));
            }
        } else {
            BIMLog.w(TAG , "start:mMediaRecorder = null");
        }
        mCurrentRecordState = RecordState.IDLE;
        return false;
    }

    public boolean stop() {
        if (mMediaRecorder != null) {
            try {
                mMediaRecorder.stop();
                mCurrentRecordState = RecordState.STOP;
                return true;
            } catch (Exception e) {
                BIMLog.e(TAG, "stop() e:"+e);
            }
        } else {
            BIMLog.i(TAG , "stop:mMediaRecorder = null");
        }
        mCurrentRecordState = RecordState.IDLE;
        return false;
    }

    public boolean release() {
        if (mMediaRecorder != null) {
            try {
                mMediaRecorder.reset();
                mCurrentRecordState = RecordState.IDLE;
                return true;
            } catch (Exception e) {
                BIMLog.e(TAG, "e:"+e);
            }
        } else {
            BIMLog.i(TAG , "release:mMediaRecorder = null");
        }
        mCurrentRecordState = RecordState.IDLE;
        return false;
    }

    public MediaRecorder getMediaRecoder() {
        return mMediaRecorder;
    }

    public int getCurrentState() {
        return mCurrentRecordState;
    }

    public String getPath() {
        return path;
    }
}
