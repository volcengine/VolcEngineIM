import { IMPage } from '@imcloud/imapp_router';

export function harInit(builderName: string): void {
  // 动态引入要跳转的页面
  switch (builderName) {
    case IMPage.TOB_LOGIN:
      import("./src/main/ets/pages/login/VELoginPage")
      break;
    case IMPage.TOB_DEBUG:
      import("./src/main/ets/pages/debug/VEDebugPage")
      break
    case IMPage.TOB_MAIN:
      import("./src/main/ets/pages/VEMainPage")
      break
    default:
      break;
  }
}