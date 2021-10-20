//
//  WDBridgeProtocolParser.h
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/4.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDBridgeProtocolConfig.h"


typedef void (^WDJSBridgeCallCompletion)(NSDictionary *result, NSError *error);

static NSString *const kWDBridgeErrorDomain = @"JSBridgeError";

static NSString *const kWDBridgeProtocolCallBackIdentifier = @"pushData";

static NSString *const kWDBridgeProtocolCallBackIdentifier2 = @"__pushData__";

static NSString *const kWDBridgeErrorDescriptionSchemeInvalid = @"scheme is illegal, must be 'kdbridge'.";
static NSString *const kWDBridgeErrorDescriptionParam1Missing = @"param missing, must contain 'module', 'identifier'.";
static NSString *const kWDBridgeErrorDescriptionParamMissing = @"param missing, must contain 'module', 'identifier', 'param', 'bridgeParam'.";
static NSString *const kWDBridgeErrorDescriptionActionUnknown = @"unknown action, must be 'invoke' or 'call'.";
static NSString *const kWDBridgeErrorDescriptionInvokeError = @"invoke action, 'sessionID' or 'fetchMethod' missing.";
static NSString *const kWDBridgeErrorDescriptionUnSupportedRequest = @"module' or 'identifier' is unsupported.";
static NSString *const kWDBridgeErrorDescriptionNoHandler = @"no handler and api for the request.";

static NSString *const kWDBridgeErrorDescriptionInvalidURL = @"url is nil, or not NSURL class";

typedef NS_ENUM(NSInteger,WDBridgeProtocolParseStatus) {
	/**
	 *  @author Acorld, 16-05-23
	 *
	 *  协议scheme无效，core不会处理
	 */
	WDBridgeProtocolParseStatusInvaild = 0,
	/**
	 *  @author Acorld, 16-05-23
	 *
	 *  协议scheme正确，但是协议结果发生错误，core会处理该请求
	 */
	WDBridgeProtocolParseStatusValidButProtocolError = 1,
	/**
	 *  @author Acorld, 16-05-23
	 *
	 *  协议正确，core会处理该请求
	 */
	WDBridgeProtocolParseStatusValid = 2,
};

/**
 *  @author Acorld, 16-05-17
 *
 *  @brief jsbridge常见协议错误类型
 */
typedef NS_ENUM(NSInteger,WDBridgeErrorCode) {
	/**
	 *  @author Acorld, 16-05-17
	 *
	 *  通道建立成功
	 */
	WDBridgeErrorCodeOK = 0,
	/**
	 *  @author Acorld, 16-05-17
	 *
	 *  scheme无效
	 */
	WDBridgeErrorCodeSchemeInvalid = -1,
	/**
	 *  @author Acorld, 16-05-17
	 *
	 *  param节点下的module/identifier缺失
	 */
	WDBridgeErrorCodeParamMissing = -2,
	/**
	 *  @author Acorld, 16-05-17
	 *
	 *  BridgeParam下的action类型不是invoke/call
	 */
	WDBridgeErrorCodeActionUnknown = -3,
	/**
	 *  @author Acorld, 16-05-17
	 *
	 *  invoke类型的sessionID/fetchMethod缺失
	 */
	WDBridgeErrorCodeInvokeError = -4,
	/**
	 *  @author Acorld, 16-05-27
	 *
	 *  @brief 请求不支持
	 */
	WDBridgeErrorCodeUnSupportedRequest = -5,
	/**
	 *  @author WangYiqiao, 18-03-10
	 *
	 *  @brief URL错误,为nil或者不是NSURL类型
	 */
	WDBridgeErrorCodeInvalidURL		    = -6,
	/**
	 *  @author WangYiqiao, 18-03-30
	 *
	 *  @brief 没有对应的处理
	 */
	WDBridgeErrorCodeNoHandler		    = -7,
	/**
	 *  @author WangYiqiao, 18-04-03
	 *
	 *  @brief 没有对应的处理
	 */
	WDBridgeErrorCodeFounctionError		= -8,
	/**
	 *  @author Acorld, 16-05-17
	 *
	 *  其他不可回调错误，sdk维护
	 */
	WDBridgeErrorCodeOther = -999,
};

/**
 *  @author Acorld, 16-05-19
 *
 *  @brief 执行js方法后得到的回执
 *
 *  @param result 回执json字符串
 */
typedef void(^WDBridgeProtocolRequestCompletion)(NSString *result);

@class WDJSBridgeItem;
@protocol WDBridgeProtocolParserDelegate <NSObject>

- (void)protocol_didFinishParse:(WDJSBridgeItem *)data;

- (void)protocol_didFinishParse:(WDJSBridgeItem *)data complete:(WDJSBridgeCallCompletion)completion;

- (BOOL)protocol_judgeIsSupported:(WDJSBridgeItem *)data;

- (void)evaluateJsString:(NSString *)jsString completion:(void(^)(id, NSError *error))completion;

@end


@interface WDBridgeProtocolParser : NSObject

@property (nonatomic, strong) WDBridgeProtocolConfig *protocolConfig;

@property (nonatomic, weak)id<WDBridgeProtocolParserDelegate> delegate;

@property (nonatomic, copy) WDJSBridgeCallCompletion complete;

- (void)validateProtocolURL:(NSURL *)URL completion:(void(^)(NSInteger statusCode, NSString *statusReason))completion;

- (WDBridgeProtocolParseStatus)parseProtocolURL:(NSURL *)URL contextInfo:(NSDictionary *)contextInfo completion:(dispatch_block_t)completion;

- (BOOL)jsbridgeCallbackWithContextID:(id)contextID result:(NSDictionary *)result;

- (void)jsbridgeCallWithParams:(WDJSBridgeItem *)requestData completion:(void(^)(NSString *result,NSError *error))completion;

@end
