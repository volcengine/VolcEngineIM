export interface BIMLoginListener {
  onProtoAgree: (isCheck: boolean) => void
  doLogin: (uid: string, token: string) => Promise<boolean>
  onDebugClick: () => void
}