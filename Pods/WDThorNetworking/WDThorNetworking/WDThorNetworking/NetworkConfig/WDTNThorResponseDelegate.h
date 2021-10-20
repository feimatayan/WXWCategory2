//
//  WDTNThorResponseDelegate.h
//  WDThorNetworking
//
//  Created by weidian2015090112 on 2019/8/20.
//  Copyright © 2019 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WDTNThorResponseDelegate <NSObject>

@optional

/**
 是否正在进行实名认证
 */
- (BOOL)thorAppInAuthentication;



/**
 实名认证
 
 @param urlString 认证url
 @param result  {
 "authPageUrl": "",
 "message": ""
 }
 */
- (void)thorAuthenticationWithURL:(NSString *)urlString result:(NSDictionary *)result;

@end
