class SingletonData {
  // 静态属性，用于存储单例实例
  private static instance: SingletonData;

  // 私有构造函数，防止外部通过 new 关键字创建实例
  private constructor() {}

  private _data = {
    // 有默认值的属性
    isFistLoad: true,
    isDeleteSpecialBotConv: false,
  };

  // 静态方法，用于获取单例实例
  public static getInstance(): SingletonData {
    if (!SingletonData.instance) {
      SingletonData.instance = new SingletonData();
    }
    return SingletonData.instance;
  }

  public getData(key: string): any {
    return this._data[key];
  }

  public setData(key: string, value: any): void {
    this._data[key] = value;
  }

  public resetAllData(): void {
    this._data = { isFistLoad: true, isDeleteSpecialBotConv: false };
  }
}

export default SingletonData;
