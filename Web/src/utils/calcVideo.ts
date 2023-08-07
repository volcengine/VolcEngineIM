export const maxSize = 300 * 2 ** 20; // 300M
export const videoMaxDuration = 5 * 60 * 1000;

class CalcVideo {
  video: HTMLVideoElement;
  constructor() {
    this.video = document.createElement('video');
    this.video.preload = 'metadata';
  }

  loadMetaData(file: File, fileNum: number): any {
    return new Promise((resolve, reject) => {
      let fileSize = this.fileSizeFormat(file.size, fileNum);
      let type = this.getFileType(file.name);

      // 媒体数据加载完成，如 时长、尺寸（仅视频）以及文本轨道
      this.video.onloadedmetadata = () => {
        window.URL.revokeObjectURL(this.video.src);
        const { duration } = this.video;

        resolve({
          fileSize,
          duration,
          type,
          height: this.video.videoHeight,
          width: this.video.videoWidth,
        });
      };
      this.video.onerror = reject;
      this.video.src = URL.createObjectURL(file);
    });
  }

  loadVideo(
    file: File,
    fileNum: number
  ): Promise<{
      coverURL?: string;
      fileSize?: string;
      video?: HTMLVideoElement;
      duration?: number;
      type?: string;
      width?: number;
      height?: number;
    }> {
    return new Promise((resolve, reject) => {
      let fileSize = this.fileSizeFormat(file.size, fileNum);
      let type = this.getFileType(file.name);
      // 当前帧加载完成
      this.video.onloadeddata = () => {
        window.URL.revokeObjectURL(this.video.src);
        const { duration } = this.video;
        const width = this.video.videoWidth;
        const height = this.video.videoHeight;

        resolve({
          coverURL: getVideoPoster(this.video, { width, height }),
          fileSize,
          video: this.video,
          duration,
          type,
          width,
          height,
        });
      };

      this.video.onerror = reject;

      /** 涉及其他可能会导致截图黑屏 */
      this.video.preload = 'auto';
      this.video.src = URL.createObjectURL(file);
    });
  }

  /**
   * fileSizeFormat 格式化文件大小
   * @param  {[int]} total [文件大小] Byte
   * @param  {[int]} n {1: "KB", 2: "MB", 3: "GB", 4: "TB"}
   * @return {[string]}  [带单位的文件大小的字符串]
   */
  fileSizeFormat(total: number, n: number) {
    let format: string;
    let len = total / 1024;

    if (len > 1000) {
      return this.fileSizeFormat(len, ++n);
    } else {
      format = len.toFixed(2);

      return Number(format);
    }
  }

  getFileType(filename: string) {
    let exts = filename.split('.');

    if (Array.isArray(exts) && exts.length) {
      const ext = exts[exts.length - 1];
      return ext.toLowerCase();
    }

    return '';
  }
}

export function getVideoPoster(video: HTMLVideoElement, options: { width: number; height: number }) {
  if (!video) {
    return '';
  }

  const { width, height } = options;
  const canvas = document.createElement('canvas');
  const context2d = canvas.getContext('2d');
  canvas.width = width;
  canvas.height = height;
  context2d.drawImage(video, 0, 0, width, height);

  // 默认是png 格式
  let url = canvas.toDataURL();

  return url;
}

export default CalcVideo;
