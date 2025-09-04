import { IMPage, IMRouter } from "@imcloud/imapp_router"
import { BIMLiveActionBar } from "../../../widget/BIMLiveActionBar"

@Component
export struct VELiveEditPage {
  static TITLE = "title"
  static DETAIL = "detail"
  arg: Map<string, string> = new Map()
  @State editTextString: String = ""
  title: string = ""
  maxSize: number = 10
  maxLine: number = 1

  aboutToAppear(): void {
    this.title = this.arg.get(VELiveEditPage.TITLE) ?? ""
    this.editTextString = this.arg.get(VELiveEditPage.DETAIL) ?? ""
    if (this.title == "直播群名称"||this.title == "我的群昵称") {
      this.maxSize = 10
      this.maxLine = 1
    } else if (this.title == "直播群描述" || this.title == "直播群公告") {
      this.maxSize = 100
      this.maxLine = 100
    } else if (this.title == "直播群头像" || this.title == "我的群头像") {
      this.maxSize = 1000
      this.maxLine = 1000
    }
  }

  build() {
    NavDestination() {
      Column() {
        BIMLiveActionBar({
          title: this.title, showConfirm: true, confirmLister: () => {
            IMRouter.pop(this.editTextString)
          }
        })
        TextArea({text:$$this.editTextString})
          .fontSize(24)
          .maxLength(this.maxSize)
          .maxLines(this.maxLine)
          .textAlign(TextAlign.Start)
      }
    }.hideTitleBar(true)
  }
}

@Builder
function veLiveEditPageBuilder(arg: object) {
  VELiveEditPage({ arg: arg as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.LIVE_EDIT_TEXT_PAGE, wrapBuilder(veLiveEditPageBuilder))