# 火山引擎即时通讯 小程序 Demo 项目

详细说明请参见 https://www.volcengine.com/docs/6348/1124746 (Web 版)

## 依赖安装
- `npm install`

## 前置配置
- 编辑 `src/constants.ts`，修改 `APP_ID` 为自己应用的值
- 编辑 `src/utils/api.ts`，接入自己的业务后端获取 token 回调（可能需要修改 `src/constants.ts` 中的 `IMCLOUD_CONFIG.tokenDomain`）；或通过控制台生成临时的 token 并返回

## 运行项目
- `npm run dev:weapp`
