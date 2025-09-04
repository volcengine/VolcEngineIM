import { IMPage, IMRouter } from '@imcloud/imapp_router';

//视频播放页面，先放置在这里
@Component
struct INPreviewVideoPlayPage {
  data: Map<String, string> = new Map()
  url: string | undefined = ""

  aboutToAppear(): void {
    this.url = this.data.get("url")
  }

  build() {
    NavDestination() {
      Column() {
        Video({ src: this.url })
          .width('100%')
          .height('100%')
          .autoPlay(true)
          .loop(true)

      }.width('100%')
      .height('100%')
    }.hideTitleBar(true)
  }
}


@Builder
function videoPlayPageBuilder(value: object) {
  INPreviewVideoPlayPage({ data: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_PREVIEW_VIDEO_PAGE, wrapBuilder(videoPlayPageBuilder))


