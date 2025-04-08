package com.bytedance.im.app.uidstr.token;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;


import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;


public class TokenHelper {
    private static final String TAG = "HttpClient";
    public static final String TOKEN_API = "https://imapi.volcvideo.com/imcloud/";
    public static final String TOKEN_API_BOE = "https://imapi-boe.sinf.net/imcloud/";
    public static final String TOKEN_API_I18N = "https://imapi.bytepluses.com/imcloud/";

    /**
     * 线上环境
     */
    public static final int ENV_RELEASE = 0;
    /**
     * ppe环境
     */
    public static final int ENV_PPE = 2;
    /**
     * boe环境
     */
    public static final int ENV_BOE = 3;
    /**
     * boe环境，不带泳道，跟 boe 的域名不同
     */
    public static final int ENV_BOEi18n = 4;
    /**
     * 海外环境
     */
    public static final int ENV_i18n = 5;
    /**
     * 海外环境 ppe
     */
    public static final int ENV_PPEi18n = 6;
    private Context mContext;

    private TokenService tokenService;


    public TokenHelper(Context context, int env, String swimLean) {
        mContext = context;
        Log.i(TAG, "init env:" + env + " swimLean:" + swimLean);
        String baseUrl;
        Map<String, String> heads = new HashMap<>();
        if (env == ENV_BOE) {
            baseUrl = TOKEN_API_BOE;
        } else if (env == ENV_i18n || env == ENV_PPEi18n) {
            baseUrl = TOKEN_API_I18N;
        } else if (env == ENV_PPE) {
            baseUrl = TOKEN_API;
            heads.put("x-use-ppe", "1");
            if (!TextUtils.isEmpty(swimLean)) {
                heads.put("x-tt-env", swimLean);
            }
        } else {
            baseUrl = TOKEN_API;
        }
        if (TextUtils.isEmpty(baseUrl)) {
            return;
        }

        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .addInterceptor(new Interceptor() {
                    @Override
                    public Response intercept(Chain chain) throws IOException {
                        Request.Builder builder = chain.request().newBuilder();
                        for (Map.Entry<String, String> head : heads.entrySet()) {
                            builder.addHeader(head.getKey(), head.getValue());
                            Log.i(TAG, "intercept add head  key:" + head.getKey() + " value:" + head.getValue());
                        }
                        return chain.proceed(builder.build());
                    }
                })
                .build();
        Retrofit retrofit = new Retrofit
                .Builder()
                .baseUrl(baseUrl)
                .client(okHttpClient)
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        tokenService = retrofit.create(TokenService.class);
    }

    public void getToken(long uid, int appId, GetTokenListener listener) {
        tokenService.getToken(uid, appId)
                .enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        try {
                            Log.i(TAG, "get token request uid: " + uid + " appId: " + appId + " url: " + call.request().url());
                            Log.i(TAG, "get token response: " + response.body() + " code: " + response.code());
                            JSONObject jsonObject = new JSONObject(response.body().string());
                            String token = jsonObject.optString("Token");
                            Log.i(TAG, "get token success:" + token);
                            listener.onGetToken(token);
                            if (TextUtils.isEmpty(token)) {
                                listener.onFailed(new Throwable(response.body().toString()));
                            }
                        } catch (IOException | JSONException e) {
                            e.printStackTrace();
                            listener.onFailed(e);
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        Log.i(TAG, "onFailure:" + t.getStackTrace());
                        listener.onFailed(t);
                    }
                });
    }

    public void getTokenWithStrUid(String uidStr, int appId, GetTokenListener listener) {
        tokenService.getTokenWithStrUid(uidStr, appId)
                .enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, retrofit2.Response<ResponseBody> response) {
                        try {
                            Log.i(TAG, "get token request uidStr: " + uidStr + " appId: " + appId + " url: " + call.request().url());
                            Log.i(TAG, "get token response: " + response.body() + " code: " + response.code());
                            JSONObject jsonObject = new JSONObject(response.body().string());
                            String token = jsonObject.optString("Token");
                            Log.i(TAG, "get token success:" + token);
                            listener.onGetToken(token);
                            if (TextUtils.isEmpty(token)) {
                                listener.onFailed(new Throwable(response.body().toString()));
                            }
                        } catch (IOException | JSONException e) {
                            e.printStackTrace();
                            listener.onFailed(e);
                        }
                    }

                    @Override
                    public void onFailure(Call<ResponseBody> call, Throwable t) {
                        Log.i(TAG, "onFailure:" + t.getStackTrace());
                        listener.onFailed(t);
                    }
                });
    }

    public interface GetTokenListener {
        void onGetToken(String token);

        void onFailed(Throwable e);
    }
}
