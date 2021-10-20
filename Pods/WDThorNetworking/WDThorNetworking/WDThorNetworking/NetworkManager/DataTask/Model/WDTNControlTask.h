//
//  WDTNControlTask.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WDTNControlTask;

@protocol WDTNControlDelegate <NSObject>

- (void)canelTask:(WDTNControlTask *)controlTask;

@end


@class WDTNNetworkManager;
/**
 业务人员发请求时返回的对象，可以取消请求。
 */
@interface WDTNControlTask : NSObject

/// 请求的url相同时，区分不同的回调函数。
@property (nonatomic, readonly) NSString *controlID;

/// sessionTask的id, manager通过taskIdentifier找到sessionTask进行操作。
@property (nonatomic, readonly) NSString *taskIdentifier;

/**
 taskIdentifier 和 delegate 在初始化时传入，只提供只读权限。
 */
- (instancetype)initWithControlID:(NSString *)controlID taskIdentifier:(NSString *)taskIdentifier delegate:(id<WDTNControlDelegate>)delegate;

/**
 取消task
 */
- (void)cancel;

@end
