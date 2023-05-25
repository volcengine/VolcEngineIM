package com.bytedance.im.app.login.net;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

public interface LoginService {
    //get请求
    /**
     * 此段逻辑应该是 appServer 去 IMCloud 获取，不应该在客户端直接到 IMCloud 获取，此处 mock。
     */
    @GET("get_token")
    Call<ResponseBody> getToken(@Query("userID") long userId, @Query("appID") long appId);
}
