import { BIMMessageWrapper } from '../data/model/BIMMessageWrapper'

@Builder
export function buildCustomDefaultUI(wrapper: BIMMessageWrapper) {
  CustomDefaultMessageUI({ msgWrapper: wrapper })
}

@Component
export struct CustomDefaultMessageUI {
  msgWrapper: BIMMessageWrapper | undefined

  build() {
    Text("不支持类型")
      .fontSize('13')
      .fontColor(this.msgWrapper?.isSelf ? '#ffffff' : '#222222')
      .backgroundColor(Color.Gray)
  }
}