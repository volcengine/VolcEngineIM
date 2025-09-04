import { IMPage, IMRouter } from '@imcloud/imapp_router';

//视频播放页面，先放置在这里
@Component
struct INPreviewImagePage {
  data: Map<String, string> = new Map()
  url: string | undefined = ""

  aboutToAppear(): void {
    this.url = this.data.get("url")
  }

  build() {
    NavDestination() {
      Column() {
        Image(this.url)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.ScaleDown)
      }.width('100%')
      .height('100%')
    }.hideTitleBar(true)
  }
}


@Builder
function previewImagePageBuilder(value: object) {
  INPreviewImagePage({ data: value as Map<string, string> })
}

IMRouter.registerBuilder(IMPage.IM_PREVIEW_IMAGE_PAGE, wrapBuilder(previewImagePageBuilder))