//
//  WDJSBridgeInterface.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/1/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeInterface.h"
#import "WDJSBridgeMacros.h"
#import "WDJSBridgeConfig.h"
#import "NSDictionary+WDJSBridge.h"
#import "NSString+WDJSBridge.h"
#import "WDJSBridgeLogger.h"
#import "WDBridgeProtocolConfig.h"
#import "WDBridgeProtocolParser.h"
#import "WDJSBridgeStatisticsManager.h"

@implementation WDJSBridgeInterface

+ (NSString *)userAgentField {
	return [NSString stringWithFormat:@"%@/%@",kWDBridgeProtocolJSObject,[WDJSBridgeInterface protocolVersion]];
}

+ (NSString *)protocolVersion {
	return WDJSBridge_Protocol_Version;
}

+ (NSString *)sdkVersion {
	return WDJSBridge_SDK_Version;
}

+ (void)enableLog:(BOOL)enable {
	[[WDJSBridgeConfig sharedConfig] setShowLog:enable];
}

+ (BOOL)isValidProtocolURL:(NSURL *)url config:(WDBridgeProtocolConfig *)config {
	
	if (!url || ![url isKindOfClass:NSURL.class]) {
		return NO;
	}
	
	if(!config || ![config isKindOfClass:WDBridgeProtocolConfig.class]) {
		config = [[WDBridgeProtocolConfig alloc] init];
	}
	
	WDBridgeProtocolParser *parser = [[WDBridgeProtocolParser alloc] init];
	parser.protocolConfig = config;
	
	__block NSInteger statusCode = 0;
	[parser validateProtocolURL:url completion:^(NSInteger code, NSString *reason) {
		statusCode = code;
	}];
	
	//返回协议解析结果
	WDBridgeProtocolParseStatus parseStatus;
	if (statusCode == WDBridgeErrorCodeOK) {
		parseStatus = WDBridgeProtocolParseStatusValid;
	}else {
		if (statusCode == WDBridgeErrorCodeSchemeInvalid) {
			parseStatus = WDBridgeProtocolParseStatusInvaild;
		}else {
			parseStatus = WDBridgeProtocolParseStatusValidButProtocolError;
		}
	}
	
	return (parseStatus == WDBridgeProtocolParseStatusValid);
}

+ (NSURL *)generateBridgeURLWithModule:(NSString *)module identifier:(NSString *)identifier params:(NSDictionary *)params config:(WDBridgeProtocolConfig *)config {
	
	if (!module || !identifier) {
		WDJSBridgeLog(@"!module || !identifier");
		return nil;
	}
	
	if(!params || ![params isKindOfClass:NSDictionary.class]) {
		params = [NSDictionary dictionary];
		WDJSBridgeLog(@"params为空或类型不正确，被置空");
	}
	
	WDBridgeProtocolConfig *protocolConfig = config;
	if(!protocolConfig) {
		protocolConfig = [[WDBridgeProtocolConfig alloc] init];
	}
	
	NSString *paramString = [params jsbridge_jsonString];
	
	NSMutableString *requestString = [NSMutableString new];
	
	//add scheme
	NSString *scheme = [protocolConfig scheme];
	if (!scheme) {
		scheme = @"kdbridge";
	}
	
	[requestString appendFormat:@"%@://weidian.com/?",scheme];
	
	//moudle,identifier
	[requestString appendFormat:@"module=%@&identifier=%@",[module jsbridge_urlEncode],[identifier jsbridge_urlEncode]];
	
	//params
	[requestString appendFormat:@"&param=%@",[paramString jsbridge_urlEncode]];
	
	//bridgeParam
	unsigned long long timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
	NSString *callBackID = [NSString stringWithFormat:@"%llu",timeInterval];
	
	NSMutableDictionary *bridgeParam = [@{@"action":@"call",@"callbackID":callBackID} mutableCopy];
	[requestString appendFormat:@"&bridgeParam=%@",[[bridgeParam jsbridge_jsonString] jsbridge_urlEncode]];
	
	//callback
	[requestString appendFormat:@"&callback=0"];
	
	return [NSURL URLWithString:requestString];
}

+ (void)setStatisticsDelegate:(id<WDJSBridgeStatisticsProtocol>)delegate {
	[WDJSBridgeStatisticsManager sharedManager].delegate = delegate;
}

@end
