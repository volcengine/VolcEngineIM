package com.bytedance.im.app.login.net.interceptor;


import android.util.Log;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/**
 * 环境拦截器
 */
public class EnvInterceptor implements Interceptor {
    private static final String TAG = "EnvInterceptor";
    private Map<String, String> heads = new HashMap<>();

    public EnvInterceptor(Map<String, String> heads) {
        this.heads = heads;
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request.Builder builder = chain.request().newBuilder();
        for (Map.Entry<String, String> head : heads.entrySet()) {
            builder.addHeader(head.getKey(), head.getValue());
            Log.i(TAG, "intercept add head  key:" + head.getKey() + " value:" + head.getValue());
        }
        return chain.proceed(builder.build());
    }
}
