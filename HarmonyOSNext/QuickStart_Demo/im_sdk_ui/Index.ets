import { IMPage } from '@imcloud/imapp_router'

export { BIMUIClient } from './src/main/ets/api/BIMUIClient'

export { BIMConversationListView } from './src/main/ets/components/conv/BIMConversationListView'

export { BIMMessageListView } from './src/main/ets/components/msg/BIMMessageListView'

export { BIMUserProvider } from './src/main/ets/api/BIMUserProvider'

export { BIMUIUser } from './src/main/ets/api/BIMUIUser'

export { GroupNotifyElement } from './src/main/ets/components/msg/custom/GroupNotifyElement'

export { BIMAccountProvider } from './src/main/ets/api/interfaces/BIMAccountProvider'

export { BIMLoginListener } from './src/main/ets/api/interfaces/BIMLoginListener'

export function harInit(builderName: string): void {
  // 动态引入要跳转的页面
  switch (builderName) {
    case IMPage.IM_UI_AT_MEMBER:
      import("./src/main/ets/components/member/AtMemberPage");
      break
    case IMPage.IM_UI_MESSAGE_LIST:
      import("./src/main/ets/message/INMessageListPage");
      break
    default:
      break;
  }
}