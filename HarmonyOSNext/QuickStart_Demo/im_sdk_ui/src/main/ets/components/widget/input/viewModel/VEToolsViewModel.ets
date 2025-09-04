import { HashMap } from '@kit.ArkTS'

export class VEToolsViewModel {
  private static PAGE_SIZE = 8
  data: VEBaseTool[] = []
  pageMap: HashMap<number, VEBaseTool[]> = new HashMap()
  pageIndexList: number[] = []

  constructor() {
  }

  initData(tools: VEBaseTool[]) {
    let pageCount: number = 0;
    let list: VEBaseTool[] = tools
    for (let i = 0; i < this.data.length; i++) {
      if (i % VEToolsViewModel.PAGE_SIZE == 0 && i != 0) {
        this.pageIndexList.push(pageCount)
        this.pageMap.set(pageCount++, list)
        list = []
      }
      list.push(this.data[i])
    }
    if (list.length != 0) {
      this.pageIndexList.push(pageCount)
      this.pageMap.set(pageCount++, list)
    }
  }
}

export interface VEBaseTool {
  resId: ResourceStr
  title: string
  onClick(): void
}
