export interface BIMLoginListener {
  onProtoAgree: () => void
  doLogin: (uid: string, token: string) => void
  onDebugClick: () => void
}