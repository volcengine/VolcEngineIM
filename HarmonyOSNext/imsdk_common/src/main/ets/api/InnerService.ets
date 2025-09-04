import { Context } from '@ohos.arkui.UIContext'
import { IMAccessor } from './IMAccessor'

export interface InnerService {
  init(context: Context, imAccessor: IMAccessor): void

  unInit(context: Context): void

  onLogin(context: Context, uid: bigint): void

  onLogout(): void
}