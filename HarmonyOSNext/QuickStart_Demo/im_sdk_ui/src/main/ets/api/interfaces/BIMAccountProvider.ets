import { BIMLoginListener } from './BIMLoginListener'

export interface BIMAccountProvider {
  init(context: Context, appId: number, env: number): void

  createLoginFragment(): WrappedBuilder<[BIMLoginListener]>
}