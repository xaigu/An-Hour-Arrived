import { AdvertClass } from '../models'
import { Context } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'
import { USER_SETTING, USER_SETTING_AD } from '../constants/setting'

// 默认广告选项
export  const defaultAd:AdvertClass={
  showAd:true,
  adTime:5,
  adImg:$r('app.media.start')
}
//
export class  UserSettingClass{
  context:Context

  constructor(context: Context) {
    this.context = context
  }
  //获取存储用户信息的首选项仓库
  getstore(){
    return preferences.getPreferences(this.context,USER_SETTING)
  }
  //设置用户广告设置
 async  setUserAd(ad:AdvertClass){
    const adStore=await this.getstore()
   await adStore.put(USER_SETTING_AD,JSON.stringify(ad))
   await adStore.flush()
  }
  //获取广告配置
  async  getUserAd(): Promise<AdvertClass>{
    const adStore=await this.getstore()
    return  JSON.parse(await adStore.get(USER_SETTING_AD, JSON.stringify(defaultAd)) as string) as AdvertClass
  }
}
