import axios from 'axios';

const request = axios.create({
  headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  },
  timeout: 30000,
  withCredentials: false,
});

request.interceptors.response.use(
  response => {
    const res = response.data;
    // 当 code 不为 0 时，统一弹出错误提示框，并抛出错误
    if (res.code) {
      // Toast.warn(res.status_msg);
      throw new Error(res.status_msg);
    }

    return res;
  },
  error => {
    if (error.response?.code) {
      return Promise.reject(error.response);
    }
  }
);

export default request;
