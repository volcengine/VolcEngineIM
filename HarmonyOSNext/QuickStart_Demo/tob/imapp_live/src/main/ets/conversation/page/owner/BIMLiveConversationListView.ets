import { BIMConversation } from '@imcloud/imsdk';
import { VELiveConvListViewModel } from './viewmodel/VELiveConvListViewModel';
import { VELiveConvWrapper } from './viewmodel/wrap/VELiveConvWrapper';
import BIMUILog from '@imcloud/im_sdk_ui/src/main/ets/log/BIMUILog';


@Component
export struct BIMLiveConversationListView {
  private tag = "BIMConversationListView"
  @Link viewModel: VELiveConvListViewModel;
  @State isRefreshing: boolean = false;
  itemClickListener: (conv: BIMConversation) => void = () => {
  }
  itemLongClickListener: (conv: BIMConversation) => void = () => {
  }

  aboutToAppear(): void {
    this.viewModel.refresh()
  }

  build() {
    Refresh({refreshing:$$this.isRefreshing}){
      List() {
        LazyForEach(this.viewModel.data, (item: VELiveConvWrapper, index: number) => {
          ListItem() {
            BIMConvItemView({ wrapper: item })
              .onClick(() => {
                this.itemClickListener(item.conv)
              })
              .gesture(LongPressGesture().onAction(() => {
                this.itemLongClickListener(item.conv)
              }))
          }
        }, (item: VELiveConvWrapper, index: number) => {
          return index + '__' + item.conv?.getConversationId() + '__' + item.conv.getName() + '__' + item.conv.getPortraitURL() +'__' + item.conv.getCurrentMember()?.getRole()
        })
      }
      .onScrollIndex((start, end, center) => {
        BIMUILog.info(this.tag, `loadMore not hasMore return start ${start} end:${end}`)
        let size = this.viewModel.data.totalCount()
        if (end == size - 1) {
          this.viewModel.loadMore()
        }
      })
      .scrollBar(BarState.Off)
    }.onRefreshing(async () => {
      this.isRefreshing = true
      await this.viewModel.refresh()
      this.isRefreshing = false
    })
  }
}

//item
@Component
export struct BIMConvItemView {
  @ObjectLink wrapper: VELiveConvWrapper

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        Image($r('app.media.icon_stickOnTop'))
          .width(14)
          .height(14)
          .objectFit(ImageFit.Contain)
          .visibility(this.wrapper.conv.isStickTop() ? Visibility.Visible : Visibility.None)
      }
      .height(14)
      .width('100%')
      .justifyContent(FlexAlign.End)


      Column() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          Stack() {
            Image(this.wrapper.portraitUrl)
              .width(44)
              .height(44)
              .objectFit(ImageFit.Contain)
              .alignRules({
                left: { anchor: "__container__", align: HorizontalAlign.Start },
                top: { anchor: "__container__", align: VerticalAlign.Top },
                bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
              })
          }.height('100%')
          .margin({ left: 16 })

          Flex({ justifyContent: FlexAlign.Center, direction: FlexDirection.Column }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Text(this.wrapper.conversationName)
                .fontSize(18)
                .fontColor('#222222')
                .id("title")
                .width(150)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }

            Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Text(this.wrapper.detail)
                .fontSize(14)
                .fontColor('#999999')
                .id("last_msg")
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .visibility(this.wrapper.detail != "" ? Visibility.Visible : Visibility.None)

              Image($r('app.media.icon_mute'))
                .width(14)
                .height(14)
                .objectFit(ImageFit.Contain)
                .margin({ right: 16 })
                .visibility(this.wrapper.conv.isMute() ? Visibility.Visible : Visibility.None)
            }.margin({ top: 8 })
          }
          .margin({ left: 16 })
          .width('100%')
          .clip(true)
        }
        .width('100%')
        .height('100%')

        Divider().width('100%')
      }
      .width('100%')
      .height(75)
    }

  }
}