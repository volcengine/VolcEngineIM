import { IMPage } from "@imcloud/imapp_router";

export { VELiveGroupFragment } from "./src/main/ets/VELiveGroupFragment"


export function harInit(builderName: string): void {
  // 动态引入要跳转的页面
  switch (builderName) {
    case IMPage.LIVE_ALL_CONV_PAGE:
      import("./src/main/ets/conversation/page/all/VEAllLiveGroupListPage")
      break;
    case IMPage.LIVE_CREATE_CONV_PAGE:
      import("./src/main/ets/conversation/page/create/VELiveCreateGroupPage")
      break;
    case IMPage.LIVE_EDIT_TEXT_PAGE:
      import("./src/main/ets/conversation/page/edit/VELiveEditPage")
      break;
    case IMPage.LIVE_JOIN_CONV_INFO_PAGE:
      import("./src/main/ets/conversation/page/create/VECreateJoinLiveGroupPage")
      break;
    case IMPage.LIVE_CHAT_ROOM_CONV_PAGE:
      import("./src/main/ets/conversation/page/chatroom/VELiveGroupChatRoomPage")
      break;
    case IMPage.LIVE_DETAIL_GROUP_PAGE:
      import("./src/main/ets/conversation/page/detail/VELiveGroupDetailConversationPage")
      break;
    case IMPage.LIVE_TEXT_INPUT:
      import("./src/main/ets/conversation/page/detail/components/VELiveTextInputPage")
      break;
    case IMPage.LIVE_MEMBER_LIST:
      import("./src/main/ets/conversation/page/detail/member/VELiveMemberListPage")
      break;
    case IMPage.LIVE_MEMBER_ONLINE_QUERY:
      import("./src/main/ets/conversation/page/detail/member/online/VELiveOnlineQueryPage")
      break;
    case IMPage.LIVE_MEMBER_ONLINE_QUERY_RESULT:
      import("./src/main/ets/conversation/page/detail/member/online/VELiveOnlineQueryResultPage")
      break;
    case IMPage.LIVE_MEMBER_SILENT_WHITE_LIST:
      import("./src/main/ets/conversation/page/detail/silentWhiteList/VELiveSilentWhitePage")
      break;
    case IMPage.LIVE_MEMBER_SILENT_LIST:
      import("./src/main/ets/conversation/page/detail/silentList/VELiveSilentPage")
      break;
    case IMPage.LIVE_MEMBER_BLOCK_LIST:
      import("./src/main/ets/conversation/page/detail/blockList/VELiveBlockListPage")
      break;
    case IMPage.LIVE_MEMBER_ADMIN_LIST:
      import("./src/main/ets/conversation/page/detail/adminList/VELiveAdminListPage")
      break;
    case IMPage.LIVE_MEMBER_ONLINE_LIST:
      import("./src/main/ets/conversation/page/detail/onlineList/VELiveOnlineListPage")
      break;
    default:
      break;
  }
}