export interface IMWSConnectListener {
  onConnectChange: (status: number, log: string) => void
}