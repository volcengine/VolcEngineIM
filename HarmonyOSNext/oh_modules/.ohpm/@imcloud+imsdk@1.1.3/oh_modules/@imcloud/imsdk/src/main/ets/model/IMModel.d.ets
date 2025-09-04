/**
 * IM-SDK中Model类的基类接口
 *
 * 一、设计思想
 * 1. 面向接口编程，业务只需要关注接口的声明，无需关注接口的实现
 *
 * 二、接口约定
 * 1. 带返回值的接口、返回类型统一设计为Nullable<T>
 *   （1）undefined代表参数异常或失败、T代表操作完成并拿到结果
 *   （2）比如Nullable<boolean>有三种状态：有操作结果的true或false、以及参数不合法的undefined
 *   （3）部分网络请求接口设计为 IMResult<T>，附带了网络异常状态码或业务配置参数
 *
 * 三、鸿蒙与抖音Android的差异点：
 * 1. 回调通知设计，鸿蒙拆分了消息列表回调和单个消息场景回调，便于消息列表与global全局监听消息observer区分开来
 * 2. 鸿蒙通过ts promise语法解决了Android接口回调地狱问题，同步调用异步逻辑并获得结果，更便于理解
 */
export interface IMModel {
}
