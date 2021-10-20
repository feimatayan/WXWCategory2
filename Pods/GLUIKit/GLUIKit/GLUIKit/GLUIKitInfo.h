//
//  GLUIKitInfo.h
//  GLUIKit
//
//  Created by xiaofengzheng on 1/13/16.
//  Copyright © 2016 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLUIKitInfo : NSObject



/*! @brief 获取 当前GLUIKit.framework的版本号
 *
 * @return 返回 当前版本号
 */
+ (NSString *)getVersion;




/**
 *  @brief  获取 当前GLUIKit.framework支持的iOS版本号
 *
 *  @return 返回 支持的iOS版本号
 */
+ (NSString *)getSupportIOS;






@end
