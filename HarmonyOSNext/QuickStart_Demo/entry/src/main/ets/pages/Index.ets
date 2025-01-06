import { IMPage, IMRouter, RouterNameConstants } from '@imcloud/imapp_router';
import { BIMUIClient } from '@imcloud/im_sdk_ui';

@Entry
@Component
struct Index {
  @State entryHapRouter: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.entryHapRouter) {
      RelativeContainer() {
        Text("IMCloud").alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          right: { anchor: "__container__", align: HorizontalAlign.End },
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom }
        }).fontSize(35)
          .textAlign(TextAlign.Center).onClick(() => {
        })
      }.width('100%')
      .height('100%')
    }.navDestination(this.routerMap);
  }

  aboutToAppear(): void {
    if (!this.entryHapRouter) {
      this.entryHapRouter = new NavPathStack();
    }
    IMRouter.createRouter(this.entryHapRouter);
    if (BIMUIClient.isTob()) {
      console.debug("entry","启动tob版本")
      IMRouter.push(IMPage.TOB_LOGIN) //tob版本
    } else {
      console.debug("entry","启动内部版本")
      IMRouter.push(IMPage.IN_LOGIN) //内部版本
    }
  }

  @Builder
  routerMap(builderName: string, param: object) {
    IMRouter.getBuilder(builderName).builder(param);
  };
}