import Taro from '@tarojs/taro';
import { IMCLOUD_CONFIG  } from '../constants';

export const getToken = (appId, userId, env) => {
  const domain =
     IMCLOUD_CONFIG.tokenDomain;
  const tokenUrl = `${domain}/get_token?appID=${appId}&userID=${userId}`;

  return new Promise<string>((resolve, reject) => {
    Taro.request({
      timeout: 30000,
      url: tokenUrl,
      success: res => {
        resolve(res.data.Token);
      },
      fail: res => {
        reject(res);
      }
    });
  });
};
