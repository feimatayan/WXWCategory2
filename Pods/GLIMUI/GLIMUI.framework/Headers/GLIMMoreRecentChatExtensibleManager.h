//
//  GLIMMoreRecentChatExtensibleManager.h
//  GLIMUI
//
//  Created by jiakun on 2019/3/14.
//  Copyright © 2019年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLIMMoreRecentChatExtensibleManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL isShowLoadMoreChatCell;

@property (nonatomic, assign) BOOL isclickLoadMoreButton;

@property (nonatomic, assign) BOOL isclickLoadMoreExposure;

@property (nonatomic, copy) NSString *currentUID;

@end

NS_ASSUME_NONNULL_END
