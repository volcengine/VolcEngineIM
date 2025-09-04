## 1.0.0

## 2.0.0

- 提供HTTP网络请求基础能力

## 2.0.1

- POST请求兼容用户传入body为空的场景，构造"body=null"字符串避免出现401参数非法的错误
- Index.ets export BDTuring以及SecurityCallback相关接口

## 2.0.2

- 修复计算post请求body md5时触发的bug：篡改了原始body内容

## 2.0.3

- 增加了请求日志监控回调接口
- 代码format优化

## 2.0.4

- 请求stream接口增加header回调
