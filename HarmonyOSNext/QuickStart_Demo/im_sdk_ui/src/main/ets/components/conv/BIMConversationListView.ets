import { BIMConversation } from '@imcloud/imsdk';
import { BIMConvListViewModel } from './data/BIMConvListViewModel';
import { BIMConvWrapper } from './data/model/BIMConvWrapper';
import { UnReadDot } from '../../components/widget/UnReadDot';
import { BIMUIClient } from '../../api/BIMUIClient';

@Component
export struct BIMConversationListView {
  private tag = "BIMConversationListView"
  @State viewModel: BIMConvListViewModel = new BIMConvListViewModel();
  itemClickListener: (conv: BIMConversation) => void = () => {
  }
  itemLongClickListener: (conv: BIMConversation) => void = () => {
  }

  aboutToAppear(): void {
    this.viewModel.loadMore()
    BIMUIClient.getInstance().addConversationListener(this.viewModel.conversationListListener)
  }
  aboutToDisappear(): void {
    BIMUIClient.getInstance().removeConversationListener(this.viewModel.conversationListListener)
  }

  build() {
    List() {
      LazyForEach(this.viewModel.data, (item: BIMConvWrapper, index: number) => {
        ListItem() {
          if (item.type == BIMConvWrapper.TYPE_CONV) {
            BIMConvItemView({ wrapper: item })
              .onClick(() => {
                this.itemClickListener(item.conv)
              })
              .gesture(LongPressGesture().onAction(() => {
                this.itemLongClickListener(item.conv)
              }))
          }
        }
      },(item: BIMConvWrapper, index: number)=>{
          return index + '__' + item.conv?.getConversationId()

      })
    }
    .onScrollIndex((start, end, center) => {
      let size = this.viewModel.data.totalCount()
      if (end == size - 1) {
        this.viewModel.loadMore()
      }
    })
    .scrollBar(BarState.Off)
  }
}

//item
@Component
export struct BIMConvItemView {
  @ObjectLink wrapper: BIMConvWrapper

  build() {
    Stack({alignContent: Alignment.TopStart}) {
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
            UnReadDot({ unReadStr: this.wrapper.unReadStr, color: this.wrapper.conv.isMute() ? '#bbbbbb' : Color.Red })
              .visibility(this.wrapper.isShowUnread ? Visibility.Visible : Visibility.Hidden)
              .offset({
                left: 18,
                top: -18
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
              Text(this.wrapper.time)
                .fontColor('#4c222222')
                .fontSize(12)
                .margin({ right: 16 })
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }

            Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Text(this.wrapper.lastMsgHint)
                .fontSize(14)
                .fontColor('#999999')
                .id("last_msg")
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .visibility(this.wrapper.lastMsgHint!="" ? Visibility.Visible : Visibility.None)

              Image($r('app.media.icon_mute'))
                .width(14)
                .height(14)
                .objectFit(ImageFit.Contain)
                .margin({ right: 16 })
                .visibility(this.wrapper.conv.isMute() ? Visibility.Visible : Visibility.None)
            }.margin({top: 8})
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