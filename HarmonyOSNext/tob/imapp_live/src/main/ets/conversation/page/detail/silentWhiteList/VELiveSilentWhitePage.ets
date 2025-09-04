import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { it } from '@ohos/hypium'
import { PullToRefresh } from '@ohos/pulltorefresh'
import { VELiveUserItemView } from '../components/VELiveUserItemView'
import { VELiveMemberActionBar } from '../VELiveMemberActionBar'
import { VELiveUserWrapper } from '../VELiveUserWrapper'
import { VELiveMemberDataSource } from './VELiveMemberDataSource'
import { VELiveSilentWhiteViewModel } from './VELiveSilentWhiteViewModel'

@Component
export struct VELiveSilentWhitePage {
  arg: Map<string, string> = new Map<string, string>()
  @State viewModel: VELiveSilentWhiteViewModel = new VELiveSilentWhiteViewModel()
  @State refreshing: boolean = false
  @State hasMore: boolean = true
  private scroller: Scroller = new Scroller();
  @State data: VELiveMemberDataSource = this.viewModel.data

   aboutToAppear():void  {
    let cid = this.arg.get('cid')
    if (!cid) {
      return
    }
    // this.viewModel = new VELiveSilentWhiteViewModel(cid)
    this.viewModel.setCid(cid)
    this.viewModel.refresh()
  }

  build() {
    NavDestination() {
      Column() {
        VELiveMemberActionBar({
          title: '禁言白名单', rightTitle: this.viewModel.isEdit ? '增加' : '', rightClick: () => {
            // let arg = new Map<string, object>()
            // arg.set("selectedList", this.viewModel.getSelectedList())
            // IMRouter.pop( this.viewModel.onConfirmClick() ?? [])
            this.viewModel.jumpToAddSilentWhiteList()
          }
        })

        PullToRefresh({
          data: $data,
          scroller: this.scroller,
          customList: () => this.renderList(),
          onRefresh: () => this.handleRefresh(),
          onLoadMore: () => this.handleLoadMore()
        }).layoutWeight(1)
      }

    }.hideTitleBar(true)
  }


  // 自定义列表渲染
  @Builder
  renderList() {
    List({ space: 3, scroller: this.scroller }) {
      LazyForEach(
        this.viewModel.data,
        (item: VELiveUserWrapper, index: number) => {
        ListItem() {
          VELiveUserItemView({wrapper: item})
        }
        .gesture(LongPressGesture().onAction(() => {
          if (this.viewModel.isEdit) {
            this.viewModel.removeSilentWhiteList(item.user.uid)
          }
        }))
      },
        (item: VELiveUserWrapper) => item.getUniqueID()
      )
    }
    .listDirection(Axis.Vertical)
    // .scrollBar(BarState.Off)
    .width('100%')
    .layoutWeight(1)
    .width('100%')
    .height('100%')
    .edgeEffect(EdgeEffect.None) // 必须禁用默认边缘效果
  }

  async handleRefresh(): Promise<string> {
    await this.viewModel.refresh(); // 等待刷新完成
    this.hasMore = true;
    return '刷新成功'; // 等价于 resolve('刷新成功')
  }

  // 处理上拉加载
  async handleLoadMore(): Promise<string> {
    if (!this.hasMore) {
      return Promise.resolve('');
    }

    await this.viewModel.loadMore()
    this.hasMore =  this.viewModel.hasMore
    return '';
  }

}

@Builder
function createMemberListPageBuilder(value: object) {
  VELiveSilentWhitePage({ arg: value as Map<string, string>})
}

IMRouter.registerBuilder(IMPage.LIVE_MEMBER_SILENT_WHITE_LIST, wrapBuilder(createMemberListPageBuilder))
