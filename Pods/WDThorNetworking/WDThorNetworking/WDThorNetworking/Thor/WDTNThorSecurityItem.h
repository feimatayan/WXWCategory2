//
//  WDTNThorSecurityItem.h
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/11/8.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * thor加密相关配置, http://wiki.vdian.net/pages/viewpage.action?pageId=5112678
 */
@interface WDTNThorSecurityItem : NSObject

@property (strong, nonatomic) NSString* thorAppKey;

@property (strong, nonatomic) NSString* thorAppSecret;

@property (strong, nonatomic) NSString* thorAesKey;

@end
