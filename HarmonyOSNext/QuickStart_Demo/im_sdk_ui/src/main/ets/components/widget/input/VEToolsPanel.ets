import { VEBaseTool, VEToolsViewModel } from './viewModel/VEToolsViewModel'

@Component
export struct VEToolsPanel {
  viewModel: VEToolsViewModel = new VEToolsViewModel()
  @Consume tools: VEBaseTool[]

  aboutToAppear(): void {
    this.viewModel.initData(this.tools)
  }

  build() {
    Swiper() {
      ForEach(this.viewModel.pageIndexList, (pageIndex: number) => {
        Grid() {
          ForEach(this.viewModel.pageMap.get(pageIndex), (tool: VEBaseTool) => {
            GridItem() {
              Column() {
                Image(tool.resId)
                  .width(64)
                  .height(64)
                  .padding(17)
                  .border({
                    width: 1,
                    radius: 4,
                    color: '#e8e8e8',
                    style: BorderStyle.Solid
                  })
                  .objectFit(ImageFit.Contain)
                Text(tool.title).fontSize(12)
                  .margin({ top: 8 })
                  .fontColor('#555555')
              }.alignItems(HorizontalAlign.Center)
            }.onClick(() => {
              tool.onClick()
            })
          })
        }
        .layoutDirection(GridDirection.Row)
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .width('100%')
        .height(200)
      })
    }.indicator(false)
    .loop(false)
    .width('100%')
  }
}