import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import BIMUILog from '../../../../log/BIMUILog';
import { fileIo } from '@kit.CoreFileKit';
export class AudioRecorder {
  private _tag = "AudioRecorder"
  private avRecorder: media.AVRecorder | undefined = undefined;
  private _file: fileIo.File | undefined
  private _path:string = ""
  private avProfile: media.AVRecorderProfile = {
    audioBitrate: 100000, // 音频比特率
    audioChannels: 2, // 音频声道数
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前只支持aac
    audioSampleRate: 48000, // 音频采样率
    fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前只支持m4a
  };

  // 注册audioRecorder回调函数
  setAudioRecorderCallback() {
    if (this.avRecorder != undefined) {
      // 状态机变化回调函数
      this.avRecorder.on('stateChange', (state: media.AVRecorderState, reason: media.StateChangeReason) => {
        BIMUILog.debug(this._tag,`AudioRecorder current state is ${state}`);
      })
      // 错误上报回调函数
      this.avRecorder.on('error', (err: BusinessError) => {
        BIMUILog.debug(this._tag,`AudioRecorder failed, code is ${err.code}, message is ${err.message}`);
      })
    }
  }

  // 开始录制对应的流程
  async startRecordingProcess(path: string) {
    BIMUILog.debug(this._tag, `startRecordingProcess path: ${path} `)
    this._path = path
    this._file = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
    if (this.avRecorder != undefined) {
      await this.avRecorder.release();
      this.avRecorder = undefined;
    }
    // 1.创建录制实例
    try {
      let fd = this._file?.fd
      if(!fd){
        return
      }
      this.avRecorder = await media.createAVRecorder();
      this.setAudioRecorderCallback();
      // 2.获取录制文件fd赋予avConfig里的url；参考FilePicker文档
      let avConfig: media.AVRecorderConfig = {
        audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC, // 音频输入源，这里设置为麦克风
        profile: this.avProfile,
        url: `fd://${fd}`, // 参考应用文件访问与管理开发示例新建并读写一个文件
      };
      // 3.配置录制参数完成准备工作
      await this.avRecorder.prepare(avConfig);
      // 4.开始录制
      await this.avRecorder.start();
    } catch (e) {
      BIMUILog.debug(this._tag, `e error: ${e} `)
    }
  }

  // 暂停录制对应的流程
  async pauseRecordingProcess() {
    if (this.avRecorder != undefined && this.avRecorder.state === 'started') { // 仅在started状态下调用pause为合理状态切换
      await this.avRecorder.pause();
    }
  }

  // 恢复录制对应的流程
  async resumeRecordingProcess() {
    if (this.avRecorder != undefined && this.avRecorder.state === 'paused') { // 仅在paused状态下调用resume为合理状态切换
      await this.avRecorder.resume();
    }
  }

  // 停止录制对应的流程
  async stopRecordingProcess() {
    if (this.avRecorder != undefined) {
      // 1. 停止录制
      if (this.avRecorder.state === 'started'
        || this.avRecorder.state === 'paused') { // 仅在started或者paused状态下调用stop为合理状态切换
        await this.avRecorder.stop();
      }
      // 2.重置
      await this.avRecorder.reset();
      // 3.释放录制实例
      await this.avRecorder.release();
      this.avRecorder = undefined;
      // 4.关闭录制文件fd
      let fd = this._file?.fd
      fileIo.closeSync(fd)
    }
  }
}