//
//  WDJSBridgeAssembler.m
//  WDJSBridge
//
//  Created by WangYiqiao on 2018/3/12.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDJSBridgeAssembler.h"
#import "WDJSBridgeInterface.h"
#import "WDJSBridgeConfig.h"
#import "WDJSBridgeMacros.h"

@implementation WDJSBridgeAssembler

#pragma mark - component info

/**
 *    返回组件名称, 不实现此函数，默认使用实现该协议的类的类名作为名称
 *
 *    @return 组件名称
 */
- (nullable NSString*)name {
	return @"WDJSBridge";
}

/**
 *    返回组件描述
 *
 *    @return 组件描述
 */
- (nullable NSString*)desc {
	return [NSString stringWithFormat:@"WDJSBridge: %@, Protocol_Version: %@, ProtocolJSObject: %@", [WDJSBridgeInterface sdkVersion], [WDJSBridgeInterface protocolVersion], kWDBridgeProtocolJSObject];
}

/**
 *    返回组件启动顺序，组件启动顺序从0开始，依次后推。
 *    启动序号可以有重复，同样序号的组件，启动顺序按名称排序。
 *    如果不实现此函数，默认启动次序为100，
 *    建议不需要优先启动的组件，尽量不要同个修改此数值。
 *
 *    @return 是否成功启动
 */
- (NSUInteger)launchingIndex {
	return 100;
	
}

/**
 *    返回组件版本号
 *
 *    @return 版本号
 */
- (nullable NSString*)version {
	return [WDJSBridgeInterface sdkVersion];
}



#pragma mark - interface required methods

/**
 *    启动组件
 *
 *    @return 是否成功启动
 */
- (BOOL)comeonStartup {
	
	
	return YES;
}

/**
 *    对组件进行参数更新
 *
 *    @param params 参数
 */
- (void)comeonParameters:(nullable NSDictionary*)params {

}

/**
 *    开关组件Log功能
 *
 *    @param useLog 是否开启log
 */
- (void)useLog:(BOOL)useLog {
	[WDJSBridgeInterface enableLog:useLog];
}

/**
 *    获取组件Log状态
 *
 *    @return 是否开启log
 */
- (BOOL)getUseLog {
	return [WDJSBridgeConfig sharedConfig].showLog;
}

/**
 *    返回当前运行状态, 宿主可以选择在需要的时候查看组件运行状态，获取组件详细信息
 *
 *    @return 当前运行状态的详细描述内容
 */
- (nullable NSString*)reportCurrentStatus {
	return @"started";
}


@end
