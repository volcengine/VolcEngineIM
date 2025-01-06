
import { IMPage, IMRouter } from '@imcloud/imapp_router'
import { VEMemberActionBar } from '../VEMemberActionBar'

@Component
export struct VETextInputPage {
  arg: Map<string, string|boolean> = new Map<string, string|boolean>()
  @State title: string = '';
  @State editable: boolean = true;
  @State content: string = ''

  aboutToAppear(): void {
    this.title = this.arg.get('title') as string
    this.editable = this.arg.get('editable') as boolean ?? false
    this.content = this.arg.get('content') as string
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          VEMemberActionBar({
            title: this.title,
            rightTitle: this.editable ? "完成" : undefined,
            rightClick: () => {
              let arg = new Map<string, string>()
              arg.set('content', this.content)
              IMRouter.pop(arg)
            }
          })
          TextArea({text: $$this.content, placeholder: '请输入'})
            .margin(10)
            .enabled(this.editable)
            .defaultFocus(true)
        }
      }

    }.hideTitleBar(true)

  }
}

@Builder
function textInputPageBuilder(value: object) {
  VETextInputPage({ arg: value as Map<string, string|boolean> })
}

IMRouter.registerBuilder(IMPage.IM_UI_TEXT_INPUT, wrapBuilder(textInputPageBuilder))