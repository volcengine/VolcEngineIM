import { IMPage } from '@imcloud/imapp_router';

export function harInit(builderName: string): void {
  // 动态引入要跳转的页面
  switch (builderName) {
    case IMPage.IM_MEMBER_CREATE_SINGLE:
      import("./src/main/ets/pages/create/VECreateSinglePage");
      break;
    case IMPage.IM_MEMBER_CREATE_GROUP:
      import("./src/main/ets/pages/create/VECreateGroupPage");
      break
    case IMPage.IM_MEMBER_CREATE_GROUP_REMOVE:
      import("./src/main/ets/pages/create/VECreateGroupRemoveListPage");
      break
    case IMPage.IM_MEMBER_DETAIL_GROUP:
      import("./src/main/ets/pages/detail/VEDetailGroupConversationPage");
      break
    case IMPage.IM_UI_TEXT_INPUT:
      import("./src/main/ets/components/Setting/VETextInputPage");
      break
    case IMPage.IM_UI_MEMBER_LIST:
      import("./src/main/ets/pages/detail/member/VEMemberListPage");
      break
    case IMPage.IM_MEMBER_INTERNAL_DETAIL_CONVERSATION:
      import("./src/main/ets/pages/detail/internal/VEInternalDetailConversationPage");
      break
    case IMPage.IM_MEMBER_MARK_MESSAGE:
      import("./src/main/ets/pages/detail/internal/VEMarkedMessageListPage");
      break
    case IMPage.IM_MEMBER_SEARCH_TEXT:
      import("./src/main/ets/pages/detail/search/VEFTSListPage");
      break
    default:
      break;
  }
}