@Component
export struct UnReadDot {
  unReadStr: string =""
  color: ResourceColor = Color.Red

  build() {
    Stack() {
      Shape() {
        Circle().width(20).height(20).fill(this.color)
      }

      Text(this.unReadStr).fontSize(10).fontColor(Color.White)
    }
  }
}