import { EmojiInfo } from './viewModel/EmojiHelper'
import { EmojiWrapper, VEEmojiViewModel } from './viewModel/VEEmojiViewModel'

@Component
export struct VEEmojiPanel {
  @State viewModel: VEEmojiViewModel = new VEEmojiViewModel()
  @State pageIndexList: number[] = []
  emojiListener: OnEmojiClickListener | undefined

  aboutToAppear(): void {
    this.viewModel.loadEmoji((pageList) => {
      this.pageIndexList = pageList
    })
  }

  build() {
    Swiper() {
      ForEach(this.pageIndexList, (pageIndex: number) => {
        Grid() {
          ForEach(this.viewModel.pageMap.get(pageIndex), (wrapper: EmojiWrapper) => {
            GridItem() {
              Image(wrapper.resId)
                .width(36)
                .height(36)
                .objectFit(ImageFit.Contain)
            }.onClick(() => {
              this.onEmojiClick(wrapper)
            })
          })
        }
        .layoutDirection(GridDirection.Row)
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr')
        .width('100%')
        .height(140)
      })
    }.indicator(false)
    .loop(false)
    .width('100%')
  }

  private onEmojiClick(wrapper: EmojiWrapper) {
    if (wrapper.type == EmojiWrapper.TYPE_NORMAL) {
      let emojiInfo = wrapper.emojiInfo;
      if (emojiInfo) {
        this.emojiListener?.onEmojiClick(emojiInfo)
      }
    } else if (wrapper.type == EmojiWrapper.TYPE_DELETE) {
      this.emojiListener?.onEmojiDeleteClick()
    }
  }
}


export interface OnEmojiClickListener {
  onEmojiClick: (info: EmojiInfo) => void
  onEmojiDeleteClick: () => void
}