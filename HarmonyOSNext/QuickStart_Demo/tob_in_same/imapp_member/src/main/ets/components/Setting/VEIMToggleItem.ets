import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
export struct ToggleItem {
  title: string = '';
  @Prop isSwitchOn: boolean = false;
  onChange: (value: boolean) => void = (value: boolean) => {
  }
  switchOnClick: () => void = () => {
  }
  build() {
    Column() {
      Row() {
        Text(this.title).fontSize(17)
        Blank()
        Toggle({type:ToggleType.Switch, isOn: this.isSwitchOn})
          .onChange((isOn: boolean) => {
            this.onChange(isOn)
            console.log('zj--onChange')
          })
          .onClick(()=> {
            this.switchOnClick();
          })
      }
      .width('100%')
      .padding(10)
    }
  }
}