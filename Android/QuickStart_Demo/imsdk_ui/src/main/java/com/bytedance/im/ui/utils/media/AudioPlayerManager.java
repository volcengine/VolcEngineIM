package com.bytedance.im.ui.utils.media;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.text.TextUtils;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class AudioPlayerManager implements MediaPlayer.OnCompletionListener, MediaPlayer.OnErrorListener {

    private Context mContext;
    private MediaPlayer mPlayer;
    private ExecutorService mExecutor;
    private String mMedia;

    public AudioPlayerManager(Context context) {
        mContext = context;
        mExecutor = Executors.newSingleThreadExecutor();
    }

    public void start(String path) {
        start(path, false);
    }

    private void start(final String path, boolean force) {
        if (isPlaying() && !force) {
            return;
        }
        if (TextUtils.isEmpty(path)) {
            return;
        }
        mMedia = path;
        if (mExecutor == null || mExecutor.isShutdown()
                || mExecutor.isTerminated()) {
            mExecutor = Executors.newSingleThreadExecutor();
        }
        mExecutor.submit(new Runnable() {
            @Override
            public void run() {
                try {
                    if (mPlayer != null) {
                        mPlayer.reset();
                    }
                    mPlayer = new MediaPlayer();
                    prepare();
                    mPlayer.start();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void stop() {
        if (!isPlaying()) {
            return;
        }
        if (mExecutor == null || mExecutor.isShutdown()
                || mExecutor.isTerminated()) {
            mExecutor = Executors.newSingleThreadExecutor();
        }
        mExecutor.submit(new Runnable() {
            @Override
            public void run() {
                try {
                    mPlayer.stop();
                    mPlayer.reset();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    private void prepare() {
        try {

            mPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mPlayer.setDataSource(mMedia);
            mPlayer.setVolume(1, 1);
            mPlayer.setLooping(false);
            mPlayer.setOnCompletionListener(this);
            mPlayer.setOnErrorListener(this);
            mPlayer.prepare();
        } catch (Exception e) {
            e.printStackTrace();
            release(false);
        }
    }

    public void release() {
        release(true);
    }

    private void release(final boolean shutdown) {
        mExecutor.submit(new Runnable() {

            @Override
            public void run() {
                try {
                    if (mPlayer != null) {
                        mPlayer.reset();
                        mPlayer.release();
                        mPlayer = null;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (shutdown) {
                    if (mExecutor != null) {
                        mExecutor.shutdown();
                        mExecutor = null;
                    }
                }
            }
        });
    }

    private boolean isPlaying() {
        return mPlayer != null && mPlayer.isPlaying();
    }

    @Override public void onCompletion(MediaPlayer mp) {

    }

    @Override public boolean onError(MediaPlayer mp, int what, int extra) {
        return false;
    }
}
