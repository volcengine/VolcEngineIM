import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';

//https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/using-BIMAudioPlayer-for-playback-V5
export class BIMAudioPlayer {
  private count: number = 0;
  private isSeek: boolean = true; // 用于区分模式是否支持seek操作
  private fileSize: number = -1;
  private fd: number = 0;
  private avPlayer: media.AVPlayer | undefined
  private static instance = new BIMAudioPlayer()

  public static getInstance() {
    return BIMAudioPlayer.instance
  }

  // 注册BIMAudioPlayer回调函数
  setBIMAudioPlayerCallback(avPlayer: media.AVPlayer) {
    // seek操作结果回调函数
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      console.info(`BIMAudioPlayer seek succeeded, seek time is ${seekDoneTime}`);
    })
    // error回调监听函数,当BIMAudioPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    avPlayer.on('error', (err: BusinessError) => {
      console.error(`Invoke BIMAudioPlayer failed, code is ${err.code}, message is ${err.message}`);
      avPlayer.reset(); // 调用reset重置资源，触发idle状态
    })
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('BIMAudioPlayer state idle called.');
          avPlayer.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // BIMAudioPlayer 设置播放源后触发该状态上报
          console.info('BIMAudioPlayer state initialized called.');
          avPlayer.prepare();
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('BIMAudioPlayer state prepared called.');
          avPlayer.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('BIMAudioPlayer state playing called.');
          if (this.count !== 0) {
            if (this.isSeek) {
              console.info('BIMAudioPlayer start to seek.');
              avPlayer.seek(avPlayer.duration); //seek到音频末尾
            } else {
              // 当播放模式不支持seek操作时继续播放到结尾
              console.info('BIMAudioPlayer wait to play end.');
            }
          } else {
            avPlayer.pause(); // 调用暂停接口暂停播放
          }
          this.count++;
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('BIMAudioPlayer state paused called.');
          avPlayer.play(); // 再次播放接口开始播放
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('BIMAudioPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('BIMAudioPlayer state stopped called.');
          avPlayer.reset(); // 调用reset接口初始化BIMAudioPlayer状态
          break;
        case 'released':
          console.info('BIMAudioPlayer state released called.');
          break;
        default:
          console.info('BIMAudioPlayer state unknown called.');
          break;
      }
    })
  }


  // 以下demo为通过url设置网络地址来实现播放直播码流的demo
  async play(url: string) {
    // 创建BIMAudioPlayer实例对象
    if (this.avPlayer) {
      this.avPlayer.stop()
    }
    this.avPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数
    this.setBIMAudioPlayerCallback(this.avPlayer);
    this.isSeek = false; // 不支持seek操作
    this.avPlayer.url = url;
  }

  async stop() {
    if (this.avPlayer) {
      this.avPlayer.stop()
    }
  }
}