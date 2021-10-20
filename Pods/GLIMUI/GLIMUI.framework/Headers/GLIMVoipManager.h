//
//  WDIMVoipManager.h
//  WDIMExtension
//
//  Created by 六度 on 2017/6/5.
//  Copyright © 2017年 com.weidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLIMSDK/GLIMSDK.h>
#import <PushKit/PushKit.h>
#define  GLIM_RECEIVE_VOIPPUSH_AND_LOGIN_SUCESSFULLY    @"GLIM_RECEIVE_VOIPPUSH_AND_LOGIN_SUCESSFULLY"

#define  GLIMNOTIFICATION_RECEIVE_VOIPPUSH_AND_LOGIN_SUCESSFULLY    @"GLIMNOTIFICATION_RECEIVE_VOIPPUSH_AND_LOGIN_SUCESSFULLY"
#define  GLIM_APP_HAS_BEN_KILLED    @"GLIM_APP_HAS_BEN_KILLED"


@interface GLIMVoipManager : NSObject
+ (instancetype)shareManager;


- (void)handleVoipPush:(NSDictionary *)userInfo;

@end
