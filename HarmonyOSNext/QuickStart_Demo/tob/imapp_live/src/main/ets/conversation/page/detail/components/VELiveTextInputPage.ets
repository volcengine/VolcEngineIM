import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VELiveMemberActionBar } from '../VELiveMemberActionBar'

@Component
export struct VELiveTextInputPage {
  arg: Map<string, string | boolean | number> = new Map<string, string | boolean>()
  @State title: string = '';
  @State editable: boolean = true;
  @State content: string = ''
  @State limit: number = 10

  aboutToAppear(): void {
    this.title = this.arg.get('title') as string
    this.editable = this.arg.get('editable') as boolean ?? false
    this.content = this.arg.get('content') as string
    this.limit = this.arg.get('limit') as number
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          VELiveMemberActionBar({
            title: this.title,
            rightTitle: this.editable ? "完成" : undefined,
            rightClick: () => {
              let arg = new Map<string, string>()
              arg.set('content', this.content)
              IMRouter.pop(arg)
            }
          })
          TextArea({ text: $$this.content, placeholder: '请输入' })
            .margin(10)
            .enabled(this.editable)
            .defaultFocus(true)
            .maxLength(this.limit)
        }
      }

    }.hideTitleBar(true)

  }
}

@Builder
function textInputPageBuilder(value: object) {
  VELiveTextInputPage({ arg: value as Map<string, string | boolean> })
}

IMRouter.registerBuilder(IMPage.LIVE_TEXT_INPUT, wrapBuilder(textInputPageBuilder))