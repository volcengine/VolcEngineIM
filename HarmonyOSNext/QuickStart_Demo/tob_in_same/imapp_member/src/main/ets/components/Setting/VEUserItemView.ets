import { BIMMember, BIMMemberRole } from '@imcloud/imsdk'
import { VEUserWrapper } from '../../pages/create/VEUserWrapper'

@Component
export struct VEUserItemView {
  @ObjectLink wrapper: VEUserWrapper
  roleName: string | undefined
  showRoleName: boolean = true

  aboutToAppear(): void {
    if (this.wrapper.member?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
      this.roleName = '群主'
    } else if (this.wrapper.member?.getRole() == BIMMemberRole.BIM_MEMBER_ROLE_ADMIN) {
      this.roleName = '管理员'
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        Image(this.wrapper.user.portraitUrl)
          .objectFit(ImageFit.ScaleDown)
          .width(36)
          .height(36)

        Text(this.wrapper.user.nickName)
          .fontSize(20)
          .fontColor("#222222")
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
          .margin({ left: 8 })

        Text(this.roleName)
          .fontSize(8)
          .border({ width: 1 })
          .borderRadius(4)
          .fontColor(Color.Gray)
          .borderColor(Color.Gray)
          .padding(2)
          .margin({left: 8})
          .visibility(this.roleName ? Visibility.Visible : Visibility.Hidden)
      }

      if (this.wrapper.isEdit) {
        Image(this.wrapper.isSelect ? $r('app.media.icon_im_radio_checked') : $r('app.media.icon_im_radio_unchecked'))
          .width(18)
          .height(18)
          .objectFit(ImageFit.Contain)
      }

    }.padding({
      left: 16, right: 16
    })
    .height(60)
    .onClick(() => {
      if (this.wrapper.isEdit && this.wrapper.member?.getRole() != BIMMemberRole.BIM_MEMBER_ROLE_OWNER) {
        this.wrapper.isSelect = !this.wrapper.isSelect
      }
    })
  }
}