export interface IMUploadListener<T> {
  onStart: () => void
  onFailed: (code: number, msg: string) => void
  onProgress: (progress: number) => void
  onSuccess: (result: T) => void
}