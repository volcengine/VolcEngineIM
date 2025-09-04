import { hilog } from '@kit.PerformanceAnalysisKit';

@Component
export struct VELiveIMToggleItem {
  title: string = '';
  @Prop isSwitchOn: boolean = false;
  @Prop isEnabled: boolean = true
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
          .enabled(this.isEnabled)
          .onChange((isOn: boolean) => {
            this.onChange(isOn)
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