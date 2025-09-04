import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { it } from '@ohos/hypium'
import { PullToRefresh } from '@ohos/pulltorefresh'
import { VELiveUserItemView } from '../components/VELiveUserItemView'
import { VELiveMemberDataSource } from '../silentWhiteList/VELiveMemberDataSource'
import { VELiveMemberActionBar } from '../VELiveMemberActionBar'
import { VELiveUserWrapper } from '../VELiveUserWrapper'
import { VELiveBlockListViewModel } from './VELiveBlockListViewModel'

@Component
export struct VELiveBlockListPage {
  arg: Map<string, string> = new Map<string, string>()
  isEdit: boolean = true
  @State viewModel: VELiveBlockListViewModel = new VELiveBlockListViewModel()
  @State refreshing: boolean = false
  @State hasMore: boolean = true
  private scroller: Scroller = new Scroller();
  @State data: VELiveMemberDataSource = this.viewModel.data

  aboutToAppear(): void {
    let cid = this.arg.get('cid')
    if (!cid) {
      return
    }
    this.viewModel.setCid(cid)
    this.viewModel.refresh()
  }

  build() {
    NavDestination() {
      Column() {
        VELiveMemberActionBar({
          title: '进群黑名单', rightTitle: '增加', rightClick: () => {
            this.viewModel.jumpToAddMemberList()
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
            this.viewModel.removeMemberList(item.user.uid)
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
  VELiveBlockListPage({ arg: value as Map<string, string>})
}

IMRouter.registerBuilder(IMPage.LIVE_MEMBER_BLOCK_LIST, wrapBuilder(createMemberListPageBuilder))
