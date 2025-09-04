import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { it } from '@ohos/hypium'
import { PullToRefresh } from '@ohos/pulltorefresh'
import { VELiveUserItemView } from '../components/VELiveUserItemView'
import { VELiveMemberDataSource } from '../silentWhiteList/VELiveMemberDataSource'
import { VELiveMemberActionBar } from '../VELiveMemberActionBar'
import { VELiveUserWrapper } from '../VELiveUserWrapper'
import { VELiveOnlineListViewModel } from './VELiveOnlineListViewModel'

@Component
export struct VELiveOnlineListPage {
  arg: Map<string, string | boolean> = new Map<string, string | boolean>()
  @State viewModel: VELiveOnlineListViewModel = new VELiveOnlineListViewModel()
  @State refreshing: boolean = false
  @State hasMore: boolean = true
  private scroller: Scroller = new Scroller();
  @State data: VELiveMemberDataSource = this.viewModel.data


  aboutToAppear(): void {
    let cid = this.arg.get('cid') as string
    if (!cid) {
      return
    }
    let isEdit = this.arg.get('isEdit') as boolean ?? false
    this.viewModel.setCid(cid, isEdit)
    this.viewModel.refresh()
  }

  build() {
    NavDestination() {
      Column() {
        VELiveMemberActionBar({
          title: this.viewModel.isEdit ? '移出群成员' :'群成员列表', rightTitle: this.viewModel.isEdit ? '完成' : '', rightClick: () => {
            this.viewModel.onConfirmClick()
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
        },
        (item: VELiveUserWrapper) => item.getUniqueID()
      )
    }
    .listDirection(Axis.Vertical)
    // .scrollBar(BarState.Off)
    .layoutWeight(1)
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
  VELiveOnlineListPage({ arg: value as Map<string, string | boolean>})
}

IMRouter.registerBuilder(IMPage.LIVE_MEMBER_ONLINE_LIST, wrapBuilder(createMemberListPageBuilder))
