import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import  {AdvertClass, TOKEN_KEY,UserSettingClass} from  '@xiaoshida/common'

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async  onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    // 这里要尝试去读一下运营的配置-我们现在还没有实现接口，直接模拟一下
    const userSetting=new UserSettingClass(this.context)
    const result=await new Promise<AdvertClass>((resolve,reject)=>{
      try {
        setTimeout(() => {
          resolve({
            showAd: true,
            adTime: 5,
            adImg: $r('app.media.start')
          } as AdvertClass)
        }, 500)
      } catch (e) {
        AlertDialog.show({message:JSON.stringify(reject)})
      }
    })
    await userSetting.setUserAd(result)//写入首选项
    if (result.showAd){
      const win =await windowStage.createSubWindow("ad_window")
      await win.showWindow()
      win.setUIContent("/pages/Start/Start".slice(1))
    }
    const token = await userSetting.getUserToken()
    if(token) {
      AppStorage.setOrCreate(TOKEN_KEY, token)
      windowStage.loadContent('pages/Index');
    }else {
      windowStage.loadContent("pages/Login/Login")
    }


    windowStage.loadContent('/pages/Index'.slice(1), (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
