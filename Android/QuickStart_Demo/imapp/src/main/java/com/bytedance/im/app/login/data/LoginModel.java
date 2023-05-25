package com.bytedance.im.app.login.data;

import android.text.TextUtils;
import android.util.Log;

import com.bytedance.im.app.VEIMApplication;
import com.bytedance.im.ui.user.BIMUser;
import com.bytedance.im.app.login.net.HttpClient;
import com.bytedance.im.app.login.net.LoginService;


import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;


public class LoginModel {
    private static final String TAG = "LoginModel";

    public static void getToken(long uid, OnGetTokenListener listener) {
        HttpClient.getInstance()
                .getRetrofit()
                .create(LoginService.class)
                .getToken(uid, VEIMApplication.APP_ID)
                .enqueue(new Callback<ResponseBody>() {
                    @Override
                    public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                        try {
                            Log.i(TAG, "get token response: " + response.body()+" code: " + response.code());
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

    public interface OnGetTokenListener {
        void onGetToken(String token);

        void onFailed(Throwable t);
    }
}
