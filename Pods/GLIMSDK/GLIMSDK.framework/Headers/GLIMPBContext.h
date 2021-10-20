//
//  GLIMPBContext.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/2/15.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLIMPBContext : NSObject

+ (instancetype)sharedContext;

@property (nonatomic, assign) UInt64 userID;        // 用户ID
@property (nonatomic, assign) SInt32 sourceType;    // App类型
@property (nonatomic, strong) NSString *clientID;   // 设备ID

- (void)resetContext;
- (BOOL)isValidUserID;

@end
