//
//  VDUploadAccountDelegate.h
//  VDUploador
//
//  Created by weidian2015090112 on 2018/11/15.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol VDUploadAccountDelegate <NSObject>

@optional

- (void)uploadRefreshToken:(void(^)(BOOL success, BOOL needRelogin))callback;

- (void)uploadLogin:(void(^)(BOOL success))callback cancel:(void(^)(void))cancel;

- (void)uploadReLogin:(void(^)(BOOL success))callback cancel:(void(^)(void))cancel;

@end
