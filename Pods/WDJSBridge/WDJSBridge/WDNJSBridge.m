//
//  WDNJSBridge.m
//  WDNJSBridge
//
//  Created by WangYiqiao on 2017/12/22.
//  Copyright © 2017年 WangYiqiao. All rights reserved.
//

#import "WDNJSBridge.h"
#import "WDJSBridgeBaseApi.h"
#import "WDJSBridgeApiFactory.h"
#import "WDBridgeProtocolParser.h"
#import "WDJSBridgeItem.h"
#import "WDJSBridgeInterface.h"
#import "WDJSBridgeProtocol.h"
#import "WDJSBridgeDefine.h"
#import "WDJSBridgeStatisticsManager.h"
#import "WDJSBridgeURLWhiteListEngine.h"
#import "WDJSBridgeMacros.h"

#import <WDWebView/WDWebViewConfigureProtocol.h>

static NSInteger const kErrMsgCodeFail            = -1;
static NSInteger const kErrMsgCodeCancel          = -2;
static NSInteger const kErrMsgCodeSuccess         = 0;
static NSString * const kErrMsgMessageSuccess     = @"ok";
static NSString * const kErrMsgMessageFail        = @"fail";
static NSString * const kErrMsgMessageCancel      = @"cancel";
static NSString * const kErrMsgCodeKey            = @"code";
static NSString * const kErrMsgMessageKey         = @"message";

@interface WDNJSBridge () <WDBridgeProtocolParserDelegate>

@property(nonatomic, strong) NSMutableDictionary *handlers;

@property(nonatomic, weak) UIView <WDWebViewProtocol> *webView;

@property(nonatomic, strong) WDBridgeProtocolParser *protocolParser;

@end

@implementation WDNJSBridge

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        _protocolParser = [[WDBridgeProtocolParser alloc] init];
        _protocolParser.delegate = self;
        _handlers = [NSMutableDictionary dictionary];
		_isAutoManageUserAgent = YES;
		_webviewUrlWhiteListControl = YES;
        _enablePresetApi = YES;
    }

    return self;
}

#pragma mark - Public

- (void)callJSBridgeWithModule:(NSString *)module identifier:(NSString *)identifier param:(NSDictionary *)param completion:(WDJSBridgeCallCompletion)completion {
	
	if(!module || module.length <= 0) {
		if(completion) {
			NSError *error = [NSError errorWithDomain:kWDBridgeErrorDomain code:WDBridgeErrorCodeParamMissing userInfo:@{NSLocalizedDescriptionKey:kWDBridgeErrorDescriptionParam1Missing}];
			completion(nil,error);
		}
		return;
	}
	
	if(!identifier || identifier.length <= 0) {
		if(completion) {
			NSError *error = [NSError errorWithDomain:kWDBridgeErrorDomain code:WDBridgeErrorCodeParamMissing userInfo:@{NSLocalizedDescriptionKey:kWDBridgeErrorDescriptionParam1Missing}];
			completion(nil,error);
		}
		return;
	}
	
    WDJSBridgeItem *requestData = [[WDJSBridgeItem alloc] init];
    requestData.module = module;
    requestData.identifier = identifier;
    requestData.param = [self dictionaryToJsonString:param];
    [self dispatchBridgeData:requestData completeBlock:completion];
	
	[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_call_plugin item:requestData];
}

#pragma mark - Register

- (void)registerHandlerWithModule:(NSString *)module identifiers:(NSArray<NSString *> *)identifiers handler:(WDJSBridgeHandler)handler {
    for (NSString *identifier in identifiers) {
        [self registerHandlerWithModule:module identifier:identifier handler:handler];
    }
}

- (void)registerHandlerWithModule:(NSString *)module identifier:(NSString *)identifier handler:(WDJSBridgeHandler)handler {
    NSString *handlerName = [NSString stringWithFormat:@"%@_%@", module, identifier];
    WDJSBridgeHandler blockHandler = [handler copy];
    self.handlers[handlerName] = blockHandler;
}

#pragma mark - Unregister

- (void)unregisterHandlerWithModule:(NSString *)module identifier:(NSString *)identifier {
    NSString *handlerName = [NSString stringWithFormat:@"%@_%@", module, identifier];
    [self.handlers removeObjectForKey:handlerName];
}

- (void)unregisterHandlerWithModule:(NSString *)module identifiers:(NSArray<NSString *> *)identifiers {
    for (NSString *identifier in identifiers) {
        [self unregisterHandlerWithModule:module identifier:identifier];
    }
}

- (void)unregisterAllHandlers {
	[self.handlers removeAllObjects];
}

#pragma mark - Public Helper

- (BOOL)handlerExistsWithModule:(NSString *)module identifier:(NSString *)identifier {

    if (!module || module.length <= 0) {
        return NO;
    }

    if (!identifier || identifier.length <= 0) {
        return NO;
    }

    NSString *handlerName = [NSString stringWithFormat:@"%@_%@", module, identifier];
    WDJSBridgeHandler handler = self.handlers[handlerName];

    return handler != nil;
}


- (void)parseBridgeURL:(NSURL *)url config:(WDBridgeProtocolConfig *)config {

    if (!config || ![config isKindOfClass:WDBridgeProtocolConfig.class]) {
        config = [[WDBridgeProtocolConfig alloc] init];
    }

    WDBridgeProtocolParser *parser = [[WDBridgeProtocolParser alloc] init];
    parser.protocolConfig = config;
    parser.delegate = self;
    [parser parseProtocolURL:url contextInfo:nil completion:nil];
}

- (void)parseBridgeURL:(NSURL *)url config:(WDBridgeProtocolConfig *)config completeBlock:(WDJSBridgeCallCompletion)completion {
    
    if (!config || ![config isKindOfClass:WDBridgeProtocolConfig.class]) {
        config = [[WDBridgeProtocolConfig alloc] init];
    }
    
    WDBridgeProtocolParser *parser = [[WDBridgeProtocolParser alloc] init];
    parser.protocolConfig = config;
    parser.delegate = self;
    parser.complete = completion;
    [parser parseProtocolURL:url contextInfo:nil completion:nil];
}

#pragma mark - Private Helper

- (void)dispatchBridgeData:(WDJSBridgeItem *)data completeBlock:(WDJSBridgeCallCompletion)completeBlock {

    NSString *module = data.module;
    NSString *identifier = data.identifier;
    NSString *paramJson = data.param;
    NSDictionary *param = nil;
    if (paramJson) {
        param = [NSJSONSerialization JSONObjectWithData:[paramJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    }

    data.parsedParam = [NSDictionary dictionaryWithDictionary:param];

    __weak typeof(self) weak_self = self;
    WDJSBridgeHandlerCallback callback = ^void(WDJSBridgeHandlerResponseCode responseCode, NSDictionary *result) {
        NSMutableDictionary *dic;
        if (!result || ![result isKindOfClass:NSDictionary.class]) {
            dic = [NSMutableDictionary dictionary];
        } else {
            dic = [[NSMutableDictionary alloc] initWithDictionary:result];
        }
        // 构造_errMsg "_errMsg":{"code":xxx, "message":xxx}
        NSString *message;
        NSInteger code;
        switch (responseCode) {
            case WDJSBridgeHandlerResponseCodeSuccess: message = kErrMsgMessageSuccess;
                code = kErrMsgCodeSuccess;
                break;
            case WDJSBridgeHandlerResponseCodeFailure: message = kErrMsgMessageFail;
                code = kErrMsgCodeFail;
                break;
            case WDJSBridgeHandlerResponseCodeCancel: message = kErrMsgMessageCancel;
                code = kErrMsgCodeCancel;
                break;
            default: message = kErrMsgMessageSuccess;
                code = kErrMsgCodeSuccess;
                break;
        }

        if (dic[kWDJSBridgeErrMsgKey] && [dic[kWDJSBridgeErrMsgKey] isKindOfClass:NSString.class]) {
            message = dic[kWDJSBridgeErrMsgKey];
        }
        dic[kWDJSBridgeErrMsgKey] = @{kErrMsgCodeKey: @(code), kErrMsgMessageKey: message};

		[weak_self.protocolParser jsbridgeCallbackWithContextID:data.contextID result:dic];
		
        if (completeBlock) {
			
			NSError *error = nil;
			if(responseCode != WDJSBridgeHandlerResponseCodeSuccess) {
				error = [NSError errorWithDomain:kWDBridgeErrorDomain code:WDBridgeErrorCodeFounctionError userInfo:@{NSLocalizedDescriptionKey:message}];
			}
			
            completeBlock(dic, error);
        }

		
		[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_callback param:@{@"result": dic} item:data];
    };

    // 优先调用业务方注册的 -> 再调用内置API的 -> 最后调用模糊匹配的 Module_*
    if ([self handlerExistsWithModule:module identifier:identifier]) {
        NSString *handlerName = [NSString stringWithFormat:@"%@_%@", module, identifier];
        WDJSBridgeHandler handler = self.handlers[handlerName];
        handler(data, callback);
		
		[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_invoke_business_plugin item:data];
		
        return;
    }

    if ([WDJSBridgeApiFactory apiExistsInModule:module identifier:identifier] && _enablePresetApi) {
        WDJSBridgeBaseApi *api = [WDJSBridgeApiFactory apiWithModule:module identifier:identifier params:param];
        api.jsbridge = self;
        NSDictionary *info = [self genApiContextInfoWithModule:module identifier:identifier];
        [api callApiWithContextInfo:info callback:callback];
		
		[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_invoke_inner_plugin item:data];
		
        return;
    }

    if ([self handlerExistsWithModule:module identifier:@"*"] && _enablePresetApi) {
        NSString *handlerName = [NSString stringWithFormat:@"%@_*", module];
        WDJSBridgeHandler handler = self.handlers[handlerName];
        handler(data, callback);
		
		[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_invoke_fuzzy_plugin item:data];
		
		return;
	}
	
	if(completeBlock) {
		NSError *error = [NSError errorWithDomain:kWDBridgeErrorDomain code:WDBridgeErrorCodeNoHandler userInfo:@{NSLocalizedDescriptionKey:kWDBridgeErrorDescriptionNoHandler}];
		completeBlock(nil,error);
	}
	
	[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_invoke_fail item:data];
}

- (NSDictionary *)genApiContextInfoWithModule:(NSString *)module identifier:(NSString *)identifier {

    NSDictionary *dic = nil;

    if ([module isEqualToString:WDJSBridgePlugin_DefaultModule] && [identifier isEqualToString:WDJSBridgePlugin_GoBack]) {
        if (self.webView) {
            dic = @{@"webView": _webView};
        }
    } else if ([module isEqualToString:WDJSBridgePlugin_DefaultModule] && [identifier isEqualToString:WDJSBridgePlugin_IsMethodExist]) {
        dic = @{@"jsbridge": self};
    }

    return dic;
}

- (BOOL)url:(NSURL *)url isValidForParser:(WDBridgeProtocolParser *)parser {

    if (!url || ![url isKindOfClass:NSURL.class]) {
        return NO;
    }

    __block NSInteger statusCode = 0;
    __block NSString *statusReason = @"";
    [parser validateProtocolURL:url completion:^(NSInteger code, NSString *reason) {
        statusCode = code;
        statusReason = reason;
    }];

    //返回协议解析结果
    WDBridgeProtocolParseStatus parseStatus;
    if (statusCode == WDBridgeErrorCodeOK) {
        parseStatus = WDBridgeProtocolParseStatusValid;
    } else {
        if (statusCode == WDBridgeErrorCodeSchemeInvalid) {
            parseStatus = WDBridgeProtocolParseStatusInvaild;
        } else {
            parseStatus = WDBridgeProtocolParseStatusValidButProtocolError;
        }
    }

    return (parseStatus == WDBridgeProtocolParseStatusValid);
}

- (NSString *)dictionaryToJsonString:(NSDictionary *)object {
	
	if(!object || ![object isKindOfClass:NSDictionary.class]) {
		return nil;
	}
	
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    return jsonString;
}

#pragma mark - WDWebViewPluginProtocol

- (void)registerPlugin:(id<WDWebViewPluginProtocol>)plugin toWebView:(UIView<WDWebViewProtocol> *)webView withConfigure:(id<WDWebViewConfigureProtocol>)configuration {
	_webView = webView;
	if(self.isAutoManageUserAgent) {
		[(id<WDWebViewConfigureProtocol>)[configuration class] appendUserAgent:[WDJSBridgeInterface userAgentField]];
	}
}

- (void)unregisterPlugin:(id<WDWebViewPluginProtocol>)plugin toWebView:(UIView<WDWebViewProtocol> *)webView withConfigure:(id<WDWebViewConfigureProtocol>)configuration {
	_webView = nil;
//	if(self.isAutoManageUserAgent) {
//		[(id<WDWebViewConfigureProtocol>)[configuration class] removeUserAgent:[WDJSBridgeInterface userAgentField]];
//	}
}

- (BOOL)wdpWebView:(UIView <WDWebViewProtocol> *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WDNWebViewNavigationType)navigationType {
    if(![request.URL.absoluteString length]){
        return YES;
    }
    if(_webviewUrlWhiteListControl){
        if(![WDJSBridgeURLWhiteListEngine isURLTrusted:webView.URL//后续应该使用 webView.loadingURL
                                        withURLPattern:_urlWhiteListPattern]){
            [[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_webview_url_illegal
                                                                param:@{
                                                                        @"url": request.URL.absoluteString,
                                                                        @"webviewUrl": [webView.URL.absoluteString length] ? webView.URL.absoluteString : @""}];
            return YES;
        }
    }
    
    if ([self url:request.URL isValidForParser:self.protocolParser]) {
        NSString *webViewUrlString = webView.URL.absoluteString;
        [self.protocolParser parseProtocolURL:request.URL
                                  contextInfo:@{
                                                @"webViewUrl":webViewUrlString ? : @""
                                                }
                                   completion:nil];
        
        [[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_call
                                                            param:@{
                                                                    @"url": request.URL.absoluteString,
                                                                    @"webviewUrl": [webView.URL.absoluteString length] ? webView.URL.absoluteString : @""}];
        
        return NO;
    }
    
    return YES;
}

#pragma mark - WDBridgeProtocolParser

- (void)protocol_didFinishParse:(WDJSBridgeItem *)data {
    [self dispatchBridgeData:data completeBlock:nil];
}

- (void)protocol_didFinishParse:(WDJSBridgeItem *)data complete:(WDJSBridgeCallCompletion)completion{
    [self dispatchBridgeData:data completeBlock:completion];
}

- (BOOL)protocol_judgeIsSupported:(WDJSBridgeItem *)data {
    NSString *module = data.module;
    NSString *identifier = data.identifier;
    BOOL isApiExists = [WDJSBridgeApiFactory apiExistsInModule:module identifier:identifier];
    BOOL isHandlerExists = [self handlerExistsWithModule:module identifier:identifier];

    // 增加模糊匹配
    isHandlerExists = isHandlerExists || [self handlerExistsWithModule:module identifier:@"*"];
	
	// 是存在方法处理该事件
	BOOL isMethodExists = isApiExists || isHandlerExists;
	
	[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_jsbridge_support param:@{@"jsbridgeSupport": isMethodExists ? @"YES": @"NO"} item:data];
	
	// 询问业务方是否允许处理本次JSBridge事件
	if(isMethodExists) {
		BOOL isBridgeShouldLoad = YES;
		if (_delegate && [_delegate respondsToSelector:@selector(jsbridge:shouldSupportForItem:)]) {
			isBridgeShouldLoad = [_delegate jsbridge:self shouldSupportForItem:data];
			
			[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_business_support param:@{@"businessSupport": isBridgeShouldLoad ? @"YES": @"NO"} item:data];
		}
		
		[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_both_support param:@{@"bothSupport": isBridgeShouldLoad ? @"YES": @"NO"} item:data];
		
		return isBridgeShouldLoad;
	}
	
    return isMethodExists;
}

- (void)evaluateJsString:(NSString *)jsString completion:(void (^)(id, NSError *))completion {
    if (_webView && [_webView respondsToSelector:@selector(evaluateJavaScript:completionHandler:)]) {
        dispatch_main_async_safe(^{
            [self.webView evaluateJavaScript:jsString completionHandler:completion];
        });
    }
}

#pragma mark -- Getter

- (NSDictionary *)handlersCopy {
    return _handlers.copy;
}

@end

@implementation WDNJSBridge(CallH5)

- (void)callToH5WithModule:(NSString *)module identifier:(NSString *)identifier param:(NSDictionary *)param completion:(WDJSBridgeCallCompletion)completion{
	
	[[WDJSBridgeStatisticsManager sharedManager] logWithEvent:WDJSBridgeStatistics_jsbridge_call_h5 param:@{@"module":module ?: @"", @"identifier": identifier ?: @""}];
	
    WDJSBridgeItem *requestData = [[WDJSBridgeItem alloc] init];
    requestData.module = module;
    requestData.identifier = identifier;

    NSError *error;
    if ([NSJSONSerialization isValidJSONObject:param]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:&error];
        if (!error && data != nil) {
            requestData.param = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }

    [self.protocolParser jsbridgeCallWithParams:requestData completion:^(NSString *result, NSError *error) {
        if (result && [result isKindOfClass:NSString.class] && [result length]) {
            NSError *jsonError;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonError];
            if (completion) {
                completion(dic, jsonError);
            }
        } else {
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

@end

@implementation WDNJSBridge (Deprecated)

- (void)registerHandlerWithModule:(NSString *)module handler:(WDJSBridgeHandler)handler {
    NSString *handlerName = [NSString stringWithFormat:@"%@_*", module];
    self.handlers[handlerName] = handler;
}

- (void)unregisterHandlerWithModule:(NSString *)module {
    NSString *handlerName = [NSString stringWithFormat:@"%@_*", module];
    [self.handlers removeObjectForKey:handlerName];
}

@end

