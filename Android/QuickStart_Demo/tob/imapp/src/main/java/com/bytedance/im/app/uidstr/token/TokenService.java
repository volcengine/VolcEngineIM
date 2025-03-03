package com.bytedance.im.app.uidstr.token;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

public interface TokenService {
    /**
     * 此段逻辑应该是 appServer 去 IMCloud 获取，不应该在客户端直接到 IMCloud 获取，此处 mock。
     */
    @GET("get_token")
    Call<ResponseBody> getTokenWithStrUid(@Query("userIDString") String userId, @Query("appID") long appId);

    /**
     * 此段逻辑应该是 appServer 去 IMCloud 获取，不应该在客户端直接到 IMCloud 获取，此处 mock。
     */
    @GET("get_token")
    Call<ResponseBody> getToken(@Query("userID") long userId, @Query("appID") long appId);
}
