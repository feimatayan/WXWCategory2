//
//  WDBridgeProtocolParser.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/4.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDBridgeProtocolParser.h"
#import "NSURL+WDJSBridge.h"
#import "NSString+WDJSBridge.h"
#import "WDJSBridgeItem.h"
#import "NSDictionary+WDJSBridge.h"
#import "WDJSBridgeLogger.h"
#import "WDJSBridgeMacros.h"
#import "WDJSBridgeItem.h"
#import "WDJSBridgeLogger.h"
#import "WDJSBridgeStatisticsManager.h"

/// 保存的会话队列的字典
/*
 {
 bridgeParam =     {
 action = invoke;
 callbackID = 1463570643121;
 status =     {
 "status_code" = 0;
 "status_reason" = "";
 };
 };
 }
 */
static NSMutableDictionary *sessionInfos_ = nil;

/**
 * {
 callBackBlock:{block}
 * }
 *
 */
static NSMutableDictionary *callInfos_ = nil;

@interface WDBridgeProtocolParser ()

@end


@implementation WDBridgeProtocolParser

- (instancetype)init
{
	if (self = [super init]) {
		if (!sessionInfos_) {
			sessionInfos_ = [NSMutableDictionary dictionary];
		}
		
		if (!callInfos_) {
			callInfos_ = [NSMutableDictionary dictionary];
		}
	}
	
	return self;
}

#pragma mark - Public
- (WDBridgeProtocolParseStatus)parseProtocolURL:(NSURL *)URL contextInfo:(NSDictionary *)contextInfo completion:(dispatch_block_t)completion
{
	WDJSBridgeLog(@"JSBridgeCore——>parseProtocolURL: %@", URL);
	
	__block NSInteger statusCode = 0;
	__block NSString *statusReason = @"";
	[self validateProtocolURL:URL completion:^(NSInteger code, NSString *reason) {
		statusCode = code;
		statusReason = reason;
	}];
	
	//url param pairs
	NSMutableDictionary *paramPairs = [[URL jsbridge_queryPairs] mutableCopy];
	
	WDJSBridgeLog(@"JSBridgeCore——>parseProtocolURL paramPairs: %@", paramPairs);
	
	//param存放业务参数，形如："{\"name\":\"123\"}";
	NSString *paramString = paramPairs[@"param"];
	
	//兼容param为空的情况
	if(!paramString || paramString.length <= 0) {
		paramString = @"{}";
	}
	
	WDJSBridgeLog(@"JSBridgeCore——>parseProtocolURL paramPairs: %@", paramPairs);
	
	//moudle
	NSString *module = paramPairs[@"module"];
	
	//identifier
	NSString *identifier = paramPairs[@"identifier"];
	
	//是否需要解析bridgeParam
	BOOL needProtocolBridgeParam = YES;
	if (self.protocolConfig) {
		needProtocolBridgeParam = self.protocolConfig.needProtocolBridgeParam;
	}
	
	//本次解析内容是否是h5给native上次请求的回执
	//pushData字段改为了__pushData__ 两种情况暂时都做兼容
	BOOL isH5CallBack = [identifier isEqualToString:kWDBridgeProtocolCallBackIdentifier2] || [identifier isEqualToString:kWDBridgeProtocolCallBackIdentifier];
	
	//返回协议解析结果
	WDBridgeProtocolParseStatus parseStatus;
	if (statusCode == WDBridgeErrorCodeOK) {
		parseStatus = WDBridgeProtocolParseStatusValid;
		
		//如果不是h5的的回执，需要询问业务方是否支持
		if (!isH5CallBack) {
			//询问业务层是否支持该业务类型
			BOOL supported = [self checkIsSuppportedForModule:module identifier:identifier url:URL];
			if (!supported) {
				statusCode = WDBridgeErrorCodeUnSupportedRequest;
				statusReason = kWDBridgeErrorDescriptionUnSupportedRequest;
				
				//通知协议错误接收者
				[[NSNotificationCenter defaultCenter] postNotificationName:@"SBridgeCore_Protocol_Error" object:@{@"status_code":@(statusCode),@"status_reason":statusReason}];
			}
		}
		
	}else {
		if (statusCode == WDBridgeErrorCodeSchemeInvalid) {
			parseStatus = WDBridgeProtocolParseStatusInvaild;
		}else {
			parseStatus = WDBridgeProtocolParseStatusValidButProtocolError;
		}
		
		[[WDJSBridgeStatisticsManager sharedManager] logWithEvent: WDJSBridgeStatistics_jsbridge_h5_native_illegal param:@{@"url": URL.absoluteString ?: @""}];
		
		//通知协议错误接收者
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SBridgeCore_Protocol_Error" object:@{@"status_code":@(statusCode),@"status_reason":statusReason}];
	}
	
	//bridgeParam
	NSString *bridgeParamString = paramPairs[@"bridgeParam"];
	
	//params bridgeParam object
	NSDictionary *bridgeParam = [bridgeParamString jsbridge_jsonObjectParse];
	
	WDJSBridgeLog(@"JSBridgeCore——>parseProtocolURL bridgeParam: %@", bridgeParam);
	
	//isH5CallBack和bridgeParamString相关
	if (needProtocolBridgeParam) {
		
		//区分是call的callback，还是H5的request
		if (isH5CallBack) {
			WDJSBridgeLog(@"JSBridgeCore——>h5回调native。。。");
			//格式如下：
			/*
			 bridgeParam:{
			 "status": {
			 "status_code": 0,
			 "status_reason": ""
			 },
			 "callbackID": "xxx",
			 "action": "call"
			 }
			 */
			
			//如果是h5的callback result流程，则检查callid是否合法
			
			//如果callbackID是通过native主动call的流程生成的，则需要通知业务方
			NSString *callbackID = [bridgeParam[@"callbackID"] description];
			NSDictionary *callInfo = callInfos_[callbackID];
			if (callInfo) {
				void (^callBackBlock)(NSString *result,NSError *error) = callInfo[@"callBackBlock"];
				if (callBackBlock) {
					
					NSError *error = nil;
					
					//回调格式都错了，还说个啥！
					if (statusCode != 0) {
						error = [NSError errorWithDomain:kWDBridgeErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:statusReason}];
						callBackBlock(nil,error);
						[callInfos_ removeObjectForKey:callbackID];
						
						//通知上层解析完成
						if (completion) {
							completion();
						}
						return parseStatus;
					}
					
					//读h5的callback的status
					NSDictionary *status = bridgeParam[@"status"];
					if (status) {
						statusCode = [status[@"status_code"] integerValue];
						
						if (status[@"status_reason"]) {
							statusReason = status[@"status_reason"];
						}
						
						if (statusCode != 0) {
							paramString = nil;
							error = [NSError errorWithDomain:kWDBridgeErrorDomain code:statusCode userInfo:@{NSLocalizedDescriptionKey:statusReason}];
						}
					}
					
					callBackBlock(paramString,error);
				}else {
					WDJSBridgeLog(@"JSBridgeCore——>h5回调的block找不到");
				}
				
				[callInfos_ removeObjectForKey:callbackID];
			}
			
			//通知上层解析完成
			if (completion) {
				completion();
			}
			return parseStatus;
		}
	}
	
	
	//session id
	NSString *innerSessionID = [self newSessionID];
	NSMutableDictionary *sessionItem = [NSMutableDictionary new];
	
	//session信息中保存的bridgeParam
	if (needProtocolBridgeParam) {
		NSDictionary *status = @{@"status_code":@(statusCode),@"status_reason":statusReason};
		
		//组装返回的bridgeParam结构
		NSMutableDictionary *tempBridgeParam = [NSMutableDictionary dictionaryWithDictionary:bridgeParam];
		tempBridgeParam[@"status"] = status;
		sessionItem[@"bridgeParam"] = tempBridgeParam;
	}
	
	
	if (self.protocolConfig.useCustomCallbackMethod) {
		if (paramPairs[@"callback"]) {
			sessionItem[@"callback"] = paramPairs[@"callback"];
		}
	}
	
	if (statusCode != 0) {
		sessionInfos_[innerSessionID] = sessionItem;
		
		// 直接回调协议错误
		[self jsbridgeCallbackWithContextID:innerSessionID result:nil];
		
		//通知上层解析完成
		if (completion) {
			completion();
		}
		return parseStatus;
	}
	
	sessionInfos_[innerSessionID] = sessionItem;
	
	//build result
//	WDJSBridgeItem *item = [WDJSBridgeItem itemWithURL:URL];
	WDJSBridgeItem *item = [WDJSBridgeItem item];
	[item setValue:URL forKey:@"url"];
	[item setValue:module forKey:@"module"];
	[item setValue:identifier forKey:@"identifier"];
	[item setValue:innerSessionID forKey:@"contextID"];
    [item setValue:contextInfo forKey:@"contextInfo"];
    
	if (needProtocolBridgeParam) {
		[item setValue:bridgeParam forKey:@"bridgeParam"];
	}
	
	
	if (needProtocolBridgeParam)
	{
		//action
		NSString *action = bridgeParam[@"action"];
		WDJSBridgeLog(@"JSBridgeCore——>确定调用方式:%@",action);
		
		//同步调用，直接返回数据
		if ([action isEqualToString:@"call"]) {
			[item setValue:paramString forKey:@"param"];
			[self notifyParseFinish:item complete:self.complete];
			
			//通知上层解析完成
			if (completion) {
				completion();
			}
			return parseStatus;
		}
		
		//异步调用
		//fetchMethod & sessionID
		NSString *sessionID = bridgeParam[@"sessionID"];
		NSString *fetchMethod = bridgeParam[@"fetchMethod"];
		
		//call h5
		WDJSBridgeLog(@"JSBridgeCore——>invoke调用h5方法");
		
		[self requestWithMethod:fetchMethod param:sessionID completion:^(NSString *invokeResult) {
			
			if (invokeResult) {
				[item setValue:invokeResult forKey:@"param"];
			}
			
			[self notifyParseFinish:item];
		}];
		
		//通知上层解析完成
		if (completion) {
			completion();
		}
		
	}else {
		if (paramString) {
			[item setValue:paramString forKey:@"param"];
		}
		
		[self notifyParseFinish:item];
		
		//通知上层解析完成
		if (completion) {
			completion();
		}
		return parseStatus;
	}
	
	return parseStatus;
}

- (void)validateProtocolURL:(NSURL *)url completion:(void(^)(NSInteger statusCode,NSString *statusReason))completion
{
	// 添加类型判断
	if(!url || ![url isKindOfClass:NSURL.class]) {
		if (completion) {
			completion(WDBridgeErrorCodeInvalidURL,kWDBridgeErrorDescriptionInvalidURL);
		}
		return;
	}
	
	//scheme不合法
	NSString *scheme = [self bridgeScheme];
	if (![scheme isEqualToString:url.scheme]) {
		if (completion) {
			completion(WDBridgeErrorCodeSchemeInvalid,kWDBridgeErrorDescriptionSchemeInvalid);
		}
		return;
	}
	
	NSMutableDictionary *paramPairs = [[url jsbridge_queryPairs] mutableCopy];
	
	//check moudle
	NSString *module = paramPairs[@"module"];
	if (![self checkIfStringIsValid:module]) {
		if (completion) {
			completion(WDBridgeErrorCodeParamMissing,kWDBridgeErrorDescriptionParamMissing);
		}
		return;
	}
	
	//check identifier
	NSString *identifier = paramPairs[@"identifier"];
	if (![self checkIfStringIsValid:identifier]) {
		if (completion) {
			completion(WDBridgeErrorCodeParamMissing,kWDBridgeErrorDescriptionParamMissing);
		}
		return;
	}
	
	//是否需要解析bridgeParam
	BOOL needProtocolBridgeParam = YES;
	if (self.protocolConfig) {
		needProtocolBridgeParam = self.protocolConfig.needProtocolBridgeParam;
	}
	
	//解析bridgeParams
	if (needProtocolBridgeParam) {
		
		//url param pairs
//		NSString *paramString = paramPairs[@"param"];
//		if (!paramString) {
//			if (completion) {
//				completion(WDBridgeErrorCodeParamMissing,kWDBridgeErrorDescriptionParamMissing);
//			}
//			return;
//		}
		
		//check bridgeParam
		NSString *bridgeParamString = paramPairs[@"bridgeParam"];
		NSDictionary *bridgeParam = [bridgeParamString jsbridge_jsonObjectParse];
		if (![bridgeParam isKindOfClass:[NSDictionary class]]) {
			if (completion) {
				completion(WDBridgeErrorCodeParamMissing,kWDBridgeErrorDescriptionParamMissing);
			}
			return;
		}
		
		//check callback id
		NSString *callBackID = bridgeParam[@"callbackID"];
		
		//本次解析内容是否是h5给native上次请求的回执
		//pushData字段改为了__pushData__ 两种情况暂时都做兼容
		BOOL isH5CallBack = [identifier isEqualToString:kWDBridgeProtocolCallBackIdentifier2] || [identifier isEqualToString:kWDBridgeProtocolCallBackIdentifier];
		
		if (isH5CallBack) {
			if (![self checkIfStringIsValid:[callBackID description]]) {
				if (completion) {
					completion(WDBridgeErrorCodeOther,@"");
				}
				return;
			}
		}
		
		//如果是h5的回调，下面不用检查
		if (isH5CallBack) {
			if (completion) {
				completion(WDBridgeErrorCodeOK,@"");
			}
			return;
		}
		
		//check action
		NSString *action = bridgeParam[@"action"];
		if (![action isEqualToString:@"invoke"] && ![action isEqualToString:@"call"]) {
			if (completion) {
				completion(WDBridgeErrorCodeActionUnknown,kWDBridgeErrorDescriptionActionUnknown);
			}
			return;
		}
		
		//同步调用，直接返回数据
		if ([action isEqualToString:@"call"]) {
			if (completion) {
				completion(WDBridgeErrorCodeOK,@"");
			}
			return;
		}
		
		//异步调用
		
		//check fetchMethod & sessionID
		NSString *sessionID = bridgeParam[@"sessionID"];
		if (![self checkIfStringIsValid:sessionID]) {
			if (completion) {
				completion(WDBridgeErrorCodeInvokeError,kWDBridgeErrorDescriptionInvokeError);
			}
			return;
		}
		
		NSString *fetchMethod = bridgeParam[@"fetchMethod"];
		if (![self checkIfStringIsValid:fetchMethod]) {
			if (completion) {
				completion(WDBridgeErrorCodeInvokeError,kWDBridgeErrorDescriptionInvokeError);
			}
			return;
		}
		
	}else {
		//nothing to do
	}
	
	if (completion) {
		completion(WDBridgeErrorCodeOK,@"");
	}
	return;
}

/*
 结构如下：
 kdbridge://iOS/?module=xxx&identifier=xxx&param=\"i am param string\"&bridgeParam=\"{callbackID:00000,action:call}\"&callback=0;
 */
- (void)jsbridgeCallWithParams:(WDJSBridgeItem *)requestData completion:(void(^)(NSString *result,NSError *error))completion;
{
	NSString *module = requestData.module;
	NSString *param = requestData.param;
	NSString *identifier = requestData.identifier;
	
	WDJSBridgeLog(@"JSBridgeCore——>native 主动 call h5...");
	
	if (![self checkIfStringIsValid:module]) {
		if (completion) {
			NSError *error = [NSError errorWithDomain:kWDBridgeErrorDomain code:WDBridgeErrorCodeParamMissing userInfo:@{NSLocalizedDescriptionKey:kWDBridgeErrorDescriptionParamMissing}];
			completion(nil,error);
		}
		WDJSBridgeLog(@"JSBridgeCore——>module参数缺失");
		return;
	}
	
	//check identifier
	if (![self checkIfStringIsValid:identifier]) {
		if (completion) {
			NSError *error = [NSError errorWithDomain:kWDBridgeErrorDomain code:WDBridgeErrorCodeParamMissing userInfo:@{NSLocalizedDescriptionKey:kWDBridgeErrorDescriptionParamMissing}];
			completion(nil,error);
		}
		WDJSBridgeLog(@"JSBridgeCore——>identifier参数缺失");
		return;
	}
	
	NSMutableString *requestString = [NSMutableString new];
	
	//add scheme
	NSString *scheme = [self bridgeScheme];
	
	[requestString appendFormat:@"%@://iOS/?",scheme];
	
	//moudle,identifier
	[requestString appendFormat:@"module=%@&identifier=%@",[module jsbridge_urlEncode],[identifier jsbridge_urlEncode]];
	
	//params
	[requestString appendFormat:@"&param=%@",[param jsbridge_urlEncode]];
	
	//是否需要组装bridgeParam
	BOOL needProtocolBridgeParam = YES;
	if (self.protocolConfig) {
		needProtocolBridgeParam = self.protocolConfig.needProtocolBridgeParam;
	}
	
	NSString *callBackID = [self newSessionID];
	if (needProtocolBridgeParam) {
		//bridgeParam
		NSMutableDictionary *bridgeParam = [@{@"action":@"call",@"callbackID":callBackID} mutableCopy];
		[requestString appendFormat:@"&bridgeParam=%@",[[bridgeParam jsbridge_jsonString] jsbridge_urlEncode]];
		
		//callback
		[requestString appendFormat:@"&callback=0"];
	}
	
	//post
	WDJSBridgeLog(@"JSBridgeCore——>native 主动call");
    
    NSString *jsString = [NSString stringWithFormat:@"%@('%@')", kWDBridgeProtocolMethodCall, requestString];
    if(_delegate && [_delegate respondsToSelector:@selector(evaluateJsString:completion:)]) {
        [_delegate evaluateJsString:jsString completion:^(id result, NSError *error) {
            if(completion) {
                completion(result, error);
            }
        }];
    } else {
        if(completion) {
            NSError *error = [NSError errorWithDomain:@"WDJSBridgeError" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"evaluate js delegate is nil"}];
            completion(nil, error);
        }
    }
	
	//save session
	callInfos_[callBackID] = @{@"callBackBlock":completion};
}


/*
 {
 bridgeParam =     {
 action = invoke;
 callbackID = 1463570643121;
 status =     {
 "status_code" = 0;
 "status_reason" = "";
 };
 };
 
 param = \"i am a json string"\;
 }
 */
- (BOOL)jsbridgeCallbackWithContextID:(id)contextID result:(NSDictionary *)result
{
	//目前只处理字符串
	if (![contextID isKindOfClass:[NSString class]]) {
		WDJSBridgeLog(@"JSBridgeCore——>contextID不合法");
		return NO;
	}
	
	WDJSBridgeLog(@"JSBridgeCore——>native callback h5...");
	//fetch cached session infos
	NSDictionary *sessionInfo = sessionInfos_[contextID];
	if (!sessionInfo) {
		WDJSBridgeLog(@"JSBridgeCore——>找不到对应的callbackID");
		return NO;
	}
	
	if (!sessionInfo[@"bridgeParam"]) {
		WDJSBridgeLog(@"JSBridgeCore——>callback参数错误");
		//remove cached session infos
		[sessionInfos_ removeObjectForKey:contextID];
		return NO;
	}
	
	NSMutableDictionary *resultInfo = [NSMutableDictionary dictionaryWithDictionary:sessionInfo];
	if (result) {
		resultInfo[@"param"] = result;
	}
	
	//json result
	NSString *resultJson = [resultInfo jsbridge_jsonString];
	
	NSString *callback = sessionInfo[@"callback"];
	if (!callback) {
		callback = kWDBridgeProtocolMethodCallBack;
	}
	
	[self requestWithMethod:callback param:resultJson completion:NULL];
	
	WDJSBridgeLog(@"JSBridgeCore——>注入callback");
	
	//remove cached session infos
	[sessionInfos_ removeObjectForKey:contextID];
	
	return YES;
}

#pragma mark - Private Helper

- (NSString *)jsStringWithMethod:(NSString *)method param:(NSString *)param {
	
	if (!method || ![method isKindOfClass:NSString.class]) {
		return nil;
	}
	
	if (!param || ![param isKindOfClass:NSString.class]) {
		return nil;
	}
	
	return [NSString stringWithFormat:@"%@(%@)", method, param];
}

- (void)requestWithMethod:(NSString *)method param:(NSString *)param completion:(WDBridgeProtocolRequestCompletion)completion {
	NSString *jsString = [NSString stringWithFormat:@"%@(%@)", method, param];
	if(_delegate && [_delegate respondsToSelector:@selector(evaluateJsString:completion:)]) {
		[_delegate evaluateJsString:jsString completion:^(id result, NSError *error) {
			if(completion) {
				completion(result);
			}
		}];
	} else {
		if(completion) {
			completion(nil);
		}
	}
}

- (void)notifyParseFinish:(WDJSBridgeItem *)data {
	if (_delegate && [_delegate respondsToSelector:@selector(protocol_didFinishParse:)]) {
		[_delegate protocol_didFinishParse:data];
	}
}

- (void)notifyParseFinish:(WDJSBridgeItem *)data complete:(WDJSBridgeCallCompletion)completion{
    if (_delegate && [_delegate respondsToSelector:@selector(protocol_didFinishParse:complete:)]) {
        [_delegate protocol_didFinishParse:data complete:completion];
    }
}

- (NSString *)newSessionID {
	unsigned long long timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
	return [NSString stringWithFormat:@"%llu",timeInterval];
}

- (NSString *)bridgeScheme {
	NSString *scheme = [self.protocolConfig scheme];
	if (!scheme) {
		scheme = @"kdbridge";
	}
	
	return scheme;
}


- (BOOL)checkIfStringIsValid:(NSString *)obj {
	//有容乃大！！！
	if ([obj isKindOfClass:[NSNumber class]]) {
		obj = obj.description;
	}
	
	if ([obj isKindOfClass:[NSString class]] && obj.length > 0) {
		return YES;
	}
	
	return NO;
}

- (BOOL)checkIsSuppportedForModule:(NSString *)module identifier:(NSString *)identifier url:(NSURL *)url {
	BOOL supported = NO;
	if (_delegate && [_delegate respondsToSelector:@selector(protocol_judgeIsSupported:)])
	{
		WDJSBridgeItem *item = [[WDJSBridgeItem alloc] init];
		item.module = module;
		item.identifier = identifier;
		[item setValue:url forKey:@"url"];
		supported = [_delegate protocol_judgeIsSupported:item];
	}
	
	return supported;
}


@end
