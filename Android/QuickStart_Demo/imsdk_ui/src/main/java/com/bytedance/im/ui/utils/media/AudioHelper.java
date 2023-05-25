package com.bytedance.im.ui.utils.media;

import android.content.Context;

public class AudioHelper {

    private AudioPlayerManager mPlayerManager;
    private String path = "";

    private static class SingleHolder {
        private static final AudioHelper instance = new AudioHelper();
    }

    private AudioHelper() {
    }

    public static AudioHelper getInstance() {
        return SingleHolder.instance;
    }

    public String getPath(){
        return path;
    }

    public void initAudio(Context context) {
        mPlayerManager = new AudioPlayerManager(context);
    }
    public void play(String path) {
        this.path = path;
        if (mPlayerManager != null) {
            mPlayerManager.start(path);
        }
    }

    public void onStop() {
        if (mPlayerManager != null) {
            mPlayerManager.stop();
        }
    }

    public void onDestroy() {
        if (mPlayerManager != null) {
            mPlayerManager.release();
        }
    }
}
