import { OptionInfo } from './opt/model/OptionInfo'
import { EmojiInfo } from '../viewModel/EmojiHelper'
import { MsgEmojiWrap } from './emoji/MsgEmojiWrap'
import { VEEmojiPanel } from '../VEEmojiPanel'
import { OptionViewModel } from './opt/OptionViewModel'
import { BIMMessage } from '@imcloud/imsdk'

@CustomDialog
export struct BIMMessageOptionPopupWindow {
  controller: CustomDialogController
  likeClickListener: (msg: BIMMessage, emoji: EmojiInfo) => void = () => {
  }
  @State viewModel: OptionViewModel = new OptionViewModel(this.getUIContext())

  build() {
    Stack() {
      Column() {
        WaterFlow() {
          LazyForEach(this.viewModel.optionDataSource, (item: OptionInfo, index: number) => {
            FlowItem() {
              Column() {
                Image(item.icon).width(20).height(20).objectFit(ImageFit.Contain)
                Text(item.title).fontColor(Color.Black).fontSize(12).margin({ top: 7 })
              }.width(40)
              .height(50)
              .onClick(() => {
                this.viewModel.optionController?.close()
                if (this.viewModel.msg) {
                  item.onClick(this.viewModel.msg)
                }
              })
            }
          })
        }.layoutDirection(FlexDirection.Row)
        .height(50)
        .margin({ left: 8, right: 8, top: 8 })
        .visibility(this.viewModel.isEnableOption ? Visibility.Visible : Visibility.Hidden)

        Divider().backgroundColor('#e8e8e8').height(1).visibility(this.viewModel.isEnableEmoji ? Visibility.Visible : Visibility.None)
        WaterFlow() {
          LazyForEach(this.viewModel.emojiDataSource, (item: MsgEmojiWrap, index: number) => {
            FlowItem() {
              Column() {
                Image(item.info?.res).width(36).height(36).objectFit(ImageFit.Contain)
              }.width(40)
              .height(40)
            }.onClick(() => {
              if (item.type == MsgEmojiWrap.TYPE_MORE) {
                this.viewModel.isExpandEmoji = true
              } else if (item.type == MsgEmojiWrap.TYPE_NORMAL) {
                if (item.info && this.viewModel.msg) {
                  this.likeClickListener(this.viewModel.msg, item.info)
                  this.viewModel.optionController?.close()
                }
              }
            })
          })
        }.layoutDirection(FlexDirection.Row)
        .height(this.viewModel.isEnableEmoji ? 40 : 0)
        .margin({
          left: 8,
          right: 8,
          bottom: 8,
          top: 8
        })
      }.visibility(this.viewModel.isExpandEmoji && this.viewModel.isEnableEmoji ? Visibility.None : Visibility.Visible)

      VEEmojiPanel({
        emojiListener: {
          onEmojiClick: (info: EmojiInfo) => {
            if (this.viewModel.msg) {
              this.likeClickListener(this.viewModel.msg, info)
              this.viewModel.optionController?.close()
            }
          }, onEmojiDeleteClick: () => {
            this.viewModel.isExpandEmoji = false
          }
        }
      }).visibility(this.viewModel.isExpandEmoji && this.viewModel.isEnableEmoji ? Visibility.Visible : Visibility.None)
    }.backgroundColor(Color.White).borderRadius(6)
  }
}