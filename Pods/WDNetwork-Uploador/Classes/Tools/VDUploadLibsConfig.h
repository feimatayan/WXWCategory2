//
//  VDUploadLibsConfig.h
//  VDUploador
//
//  Created by weidian2015090112 on 2018/11/15.
//  Copyright © 2018年 yangxin02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDUploadAccountDO.h"
#import "VDUploadAccountDelegate.h"


@interface VDUploadLibsConfig : NSObject

+ (instancetype)sharedInstance;

// 登录，刷新token，登出，都要更新
// 最新版的登录SDK内部做了
@property (nonatomic, strong) VDUploadAccountDO *account;

// 登录的代理
@property (nonatomic, weak) id<VDUploadAccountDelegate> accountDelegate;

@end
