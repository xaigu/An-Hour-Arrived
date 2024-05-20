import { UserSettingClass, AdvertClass } from '@xiaoshida/common'
import { window } from '@kit.ArkUI'

@Entry
@Component
struct Start {
  userSetting: UserSettingClass = new UserSettingClass(getContext(this))
  @State
  adObj: AdvertClass  = {
    showAd: false,
    adTime: 0
  }
  timer: number = -1
  closeWin () {
    window.findWindow("ad_window").destroyWindow()
  }
  async aboutToAppear() {
    this.adObj = await this.userSetting.getUserAd()
    this.timer = setInterval(() => {
      if(this.adObj.adTime === 0) {
        clearInterval(this.timer)
        return
      }
      this.adObj.adTime--
    }, 1000)
  }
  aboutToDisappear(): void {
    clearInterval(this.timer)
  }
  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Image(this.adObj.adImg).objectFit(ImageFit.Cover)
      Text(`${this.adObj.adTime}秒后跳过`)
        .padding({ left: 10, right: 10 })
        .margin({ right: 20, top: 20 })
        .height(30)
        .fontSize(14)
        .borderRadius(15)
        .backgroundColor($r("app.color.background_page"))
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.closeWin()
        })

    }.height('100%').width('100%')
  }
}
