import { IMAccessor, IMEnvService, IMLogService, IMWSConnectListener, IMWSMsgInfo, IMWSService, WSParameter } from '@imcloud/imsdk_common';
import { ChannelInfo, ConnectionState, IWsChannelMsg, WsChannel, WsChannelMsg, WsChannelSdk, WsEventListener } from '@bytedance/wschannel';

export class BIMWSService implements IMWSService, WsEventListener {
  onAppForegroundChang(isForeground: boolean): void {
  }
  private tag = "INBIMWSService"
  private _imAccessor: IMAccessor | undefined;
  private logger: IMLogService|undefined;
  private _hasInit = false;
  private _wsChannel: WsChannel | undefined;
  private _env: IMEnvService|undefined;
  private _wsParameter: WSParameter | undefined
  private _curState: ConnectionState = ConnectionState.CONNECTION_UNKNOWN
  private _stateListener: IMWSConnectListener | undefined
  private _receiverListener: (data: IMWSMsgInfo) => void = () => {
  }

  initWs(env: IMEnvService, logger: IMLogService): void {
    this._env = env;
    this.logger = logger;
  }

  setOnReceiveListener(listener: (data: IMWSMsgInfo) => void): void {
    this.logger?.log(IMLogService.level_info, this.tag, `setOnReceiveListener()`)
    this._receiverListener = listener;
  }

  async disConnect(): Promise<boolean> {
    let r = await this._wsChannel?.stopConnection() ?? false
    this.logger?.log(IMLogService.level_info, this.tag, `disConnect() isSuccess:${r}`)
    this._wsChannel = undefined;
    return true
  }

  onConnectStateChange(state: ConnectionState, connectLog: string): void {
    this.logger?.log(IMLogService.level_info, this.tag, `onConnectStateChange state:${state} connectLog:${connectLog}`)
    this._curState = state
    this._stateListener?.onConnectChange(state, connectLog)
  }

  onMsgReceive(msg: IWsChannelMsg): void {
    this.logger?.log(IMLogService.level_info, this.tag, `onMsgReceive seqId:${msg.seqId} logId:${msg.logId}`)
    let data = new IMWSMsgInfo()
    data.seqId = msg.seqId
    data.logId = msg.logId
    data.payloadEncoding = msg.payloadEncoding
    data.payloadType = msg.payloadType
    data.service = msg.service
    data.method = msg.method
    data.payload = msg.payload
    data.headers = msg.headers
    this._receiverListener(data)
  }

  async connect(wsParameter: WSParameter): Promise<boolean> {
    this._wsParameter = wsParameter
    this.logger?.log(IMLogService.level_info, this.tag, `connect() wsParameter: ${wsParameter}}`)
    if (this._hasInit) {
      return false;
    }

    let extraMap = new Map<string, string>()
    if (wsParameter.token) {
      extraMap.set("token", wsParameter.token)
    }

    let ex = wsParameter.extra
    ex.set("device_platform", "Harmony")
    ex.set("ne", "1")
    if (ex) {
      ex.forEach((value, key) => {
        extraMap.set(key, value)
      })
    }

    let headerMap = new Map<string, string>()
    let xttToken = wsParameter.xttToken;
    if (xttToken) {
      xttToken.forEach((value, key) => {
        headerMap.set(key, value)
      })
    }
    let envHeaderMap = this._env?.getHeaderMap()
    if (envHeaderMap) {
      envHeaderMap.forEach((value, key) => {
        headerMap.set(key, value)
      })
    }


    let isConnectSuccess = false
    try {
      let channelInfo = new ChannelInfo(
        wsParameter.deviceId ?? '',
        wsParameter.iid,
        wsParameter.fpid,
        wsParameter.appid,
        wsParameter.appKey,
        this._imAccessor?.versionCode ?? 0,
        this._imAccessor?.versionCode ?? 0,
        wsParameter.urls,
        extraMap,
        headerMap)
      this.logger?.log(IMLogService.level_info, this.tag, `registerChannel start`)
      this._wsChannel = WsChannelSdk.registerChannel(channelInfo, this);
      isConnectSuccess = await this._wsChannel.startConnection()
      this._hasInit = true;
      this.logger?.log(IMLogService.level_info, this.tag, `registerChannel end isConnectSuccess:${isConnectSuccess}`)
    } catch (e) {
      this.logger?.log(IMLogService.level_info, this.tag, `registerChannel exception :${e}`)
    }
    return isConnectSuccess;
  }

  setConnectChangedListener(statusListener: IMWSConnectListener): void {
    this.logger?.log(IMLogService.level_info, this.tag, `setConnectChangedListener()`)
    this._stateListener = statusListener
  }

  isConnect(): boolean {
    let isConnect = this._wsChannel?.isConnected() ?? false
    this.logger?.log(IMLogService.level_info, this.tag, `isConnect :${isConnect}`)
    return isConnect
  }

  geConnectStatus(): number {
    this.logger?.log(IMLogService.level_info, this.tag, `geConnectStatus() status:${this._curState}`)
    return this._curState
  }

  async sendMsg(data: IMWSMsgInfo): Promise<boolean> {
    let allHeaderList = this._env?.getHeaderMap()
    if (data) {
      data.headers?.forEach((value, key) => {
        allHeaderList?.set(key, value)
      })
    }

    let msg = WsChannelMsg.builder()
      .seqId(data.seqId)
      .logId(0n)
      .service(this._wsParameter?.serviceId ?? 2)
      .method(this._wsParameter?.method ?? 1)
      .headers(allHeaderList)
      .payloadEncoding("pb")
      .payloadType("pb")
      .payload(data.payload)
      .build()
    let isSuccess = await this._wsChannel?.sendMsg(msg) ?? false
    this.logger?.log(IMLogService.level_info, this.tag, `sendMsg isSuccess:${isSuccess} seqId:${data.seqId}`)
    return isSuccess
  }

  onConfigReady(json: string): void {
  }

  init(context: Context, imAccessor: IMAccessor): void {
    this._imAccessor = imAccessor
    this.logger?.log(IMLogService.level_info, this.tag, `init() success`)
  }

  unInit(context: Context): void {
  }

  onLogin(context: Context, uid: bigint): void {
  }

  onLogout(): void {
    this.logger?.log(IMLogService.level_info, this.tag, `onLogout()`)
    this.disConnect()
    this._hasInit = false;
    this._wsChannel = undefined;
    this._wsParameter = undefined
    this._curState = ConnectionState.CONNECTION_UNKNOWN
    this._stateListener = undefined
  }
}