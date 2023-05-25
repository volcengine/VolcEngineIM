package com.bytedance.im.app.login.net;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.bytedance.im.app.constants.Constants;
import com.bytedance.im.app.constants.SpUtils;
import com.bytedance.im.app.login.net.interceptor.EnvInterceptor;

import java.util.HashMap;

import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class HttpClient {
    private static final String TAG = "HttpClient";
    public static final String TOKEN_API = "";
    public static final String TOKEN_API_BOE = "";
    public static final String TOKEN_API_I18N = "";

    private Retrofit retrofit;
    private Context mContext;

    private static final class InstanceHolder {
        private static final HttpClient instance = new HttpClient();
    }

    public int env = Constants.ENV_RELEASE;
    private String swimLean;

    public void init(Context context) {
        mContext = context;
        env = SpUtils.getInstance().getEnv();
        Log.i(TAG, "init env:" + env);
        String baseUrl;
        HashMap<String, String> header = new HashMap<String, String>();
        if (env == Constants.ENV_BOE) {
            baseUrl = TOKEN_API_BOE;
        } else if (env == Constants.ENV_BOEi18n) {
            baseUrl = TOKEN_API_I18N;
        } else if (env == Constants.ENV_PPE) {
            baseUrl = TOKEN_API;
        } else {
            baseUrl = TOKEN_API;
        }
        if (TextUtils.isEmpty(baseUrl)) {
            return;
        }
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .addInterceptor(new EnvInterceptor(header))
                .build();
        retrofit = new Retrofit.Builder()
                .baseUrl(baseUrl)
                .client(okHttpClient)
                .addConverterFactory(GsonConverterFactory.create())
                .build();
    }

    private HttpClient() {

    }

    public static HttpClient getInstance() {
        return InstanceHolder.instance;
    }

    public Retrofit getRetrofit() {
        return retrofit;
    }

    public int getEnv() {
        return env;
    }

    public String getSwimLean() {
        return swimLean;
    }
}
