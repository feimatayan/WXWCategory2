//
//  WDNJSBridge.h
//  WDNJSBridge
//
//  Created by WangYiqiao on 2017/12/22.
//  Copyright © 2017年 WangYiqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WDWebView/WDWebViewPluginProtocol.h>

#define kWDJSBridgeErrMsgKey  @"_errMsg"
#define kWDJSBridgeErrCodeKey @"code"


@class WDJSBridgeItem;

typedef NS_ENUM(NSInteger, WDJSBridgeHandlerResponseCode) {
    WDJSBridgeHandlerResponseCodeSuccess = 0,		//成功
    WDJSBridgeHandlerResponseCodeFailure = 1,		//失败
    WDJSBridgeHandlerResponseCodeCancel  = 2,		//取消
};

typedef NS_ENUM(NSUInteger, WDJSBridgeErrorType) {
    WDJSBridgeErrorNotYetRealized = 10001, //暂未实现
    WDJSBridgeErrorNilCUID = 10002,
    WDJSBridgeErrorInvalidateData = 10003
};

/**
 API处理后的回调
 
 @param responseCode 处理结果码
 @param result 处理结果数据
 */
typedef void (^WDJSBridgeHandlerCallback)(WDJSBridgeHandlerResponseCode responseCode, NSDictionary *result);

/**
 API处理
 
 @param item 协议解析后的数据
 @param callback 扩展API处理完毕的回调
 */
typedef void (^WDJSBridgeHandler)(WDJSBridgeItem *item, WDJSBridgeHandlerCallback callback);

/**
 native主动调用h5的结果回调
 
 @param result json解析后的结果
 @param error 错误（有错误不处理结果）
 */
typedef void (^WDJSBridgeCallCompletion)(NSDictionary *result, NSError *error);


@protocol WDWebViewProtocol;
@protocol WDJSBridgeProtocol;
@class WDBridgeProtocolConfig;

@interface WDNJSBridge : NSObject<WDWebViewPluginProtocol>
/**
 询问业务方是否允许JSBridge加载该次请求的代理
 如果为nil 则默认为支持
 */
@property (nonatomic, weak) id<WDJSBridgeProtocol> delegate;

/**
 是否自动管理JSBridge的UserAgent字段 形如:KDJSBridge2/1.0.0
 当JSBridge 注册\注销 为WDWebView的插件时会自动 添加\删除
 JSBridge的UserAgent字段
 默认为是
 */
@property(nonatomic, assign) BOOL isAutoManageUserAgent;

/**用于控制是否开启调用源的校验，默认为开启，YES为开启，NO为关闭
 * 开启后会用"urlWhiteListPattern"参数所指定的正则表达式进行校验，若校验通过则可进入JSBridge解析调用流程，若不通过直接返回错误
 * 关闭后不会进行校验，直接进入JSBridge解析调用流程
 * */
@property(nonatomic, assign) BOOL webviewUrlWhiteListControl;

/**白名单的正则表达式，当外部需要对默认的正则表达式替换时，可以向该值复制
 * 默认: ^(http|https)://([^/\?#]+\.)*((vdian|weidian|koudai|youshop|geilicdn|qq|ruyu)\.com)([\?|#|/|:].*)?$
 * */
@property(nonatomic, copy) NSString *urlWhiteListPattern;

/**用于控制是否使用预置Api,默认为YES。
 * */
@property(nonatomic, assign) BOOL enablePresetApi;

@property(nonatomic, strong, readonly) NSDictionary *handlersCopy;
/**
  注册业务实现方法

 @param module 协议module字段
 @param identifier 协议identifier字段
 @param handler 执行函数块
 */
- (void)registerHandlerWithModule:(NSString *)module identifier:(NSString *)identifier handler:(WDJSBridgeHandler)handler;

/**
 同时注册多个方法对应一个实现
 
 @param module 协议module字段
 @param identifiers 协议identifier字段数组
 @param handler 执行函数块
 */
- (void)registerHandlerWithModule:(NSString *)module identifiers:(NSArray<NSString *> *)identifiers handler:(WDJSBridgeHandler)handler;

/**
 注销业务实现
 
 @param module 协议module字段
 @param identifier 协议identifier字段
 */
- (void)unregisterHandlerWithModule:(NSString *)module identifier:(NSString *)identifier;

/**
 注销多个业务实现
 
 @param module 协议module字段
 @param identifiers 协议identifier字段数组
 */
- (void)unregisterHandlerWithModule:(NSString *)module identifiers:(NSArray<NSString *> *)identifiers;

/**
 注销所有业务插件
 */
- (void)unregisterAllHandlers;

/**
 客户端调用jsbridge插件

 @param module 协议module字段
 @param identifier 协议identifier字段
 @param completion 回执
 */
- (void)callJSBridgeWithModule:(NSString *)module identifier:(NSString *)identifier param:(NSDictionary *)param completion:(WDJSBridgeCallCompletion)completion;

/**
 是否存在指定的Handler
 
 @param module 协议module字段
 @param identifier 协议identifier字段
 @return BOOL YES:存在 NO:不存在
 */
- (BOOL)handlerExistsWithModule:(NSString *)module identifier:(NSString *)identifier;

/**
 解析协议URL
 @param config 协议配置 如果为nil则为默认配置
 */
- (void)parseBridgeURL:(NSURL *)url config:(WDBridgeProtocolConfig *)config;

/**
 解析协议URL

 @param url 协议URL
 @param config 协议配置 如果为nil则为默认配置
 @param completion 解析完成的回执
 */
- (void)parseBridgeURL:(NSURL *)url config:(WDBridgeProtocolConfig *)config completeBlock:(WDJSBridgeCallCompletion)completion;

@end

@interface WDNJSBridge(CallH5)

/**
 客户端主动发起jsbridge请求

 @param module 协议module字段
 @param identifier 协议identifier字段
 @param completion 回执
 */
- (void)callToH5WithModule:(NSString *)module identifier:(NSString *)identifier param:(NSDictionary *)param completion:(WDJSBridgeCallCompletion)completion;

@end


@interface WDNJSBridge(Deprecated)
/**
 注册Module对应的模糊匹配
 优先调用module_identifier精确匹配的，最后调用模糊匹配的
 谨慎使用！使用不当可能会造成功能调用错误!
 */
- (void)registerHandlerWithModule:(NSString *)module handler:(WDJSBridgeHandler)handler;

/**
 注销Module对应的模糊匹配
 */
- (void)unregisterHandlerWithModule:(NSString *)module;

@end


