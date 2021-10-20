//
//  WDTNAFResponseSerialization.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/10/11.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 空实现，AFNetworking调用该协议实现json 解析，但是我们的数据需要先解密，所以跳过改步骤。
 AFURLSessionManagerTaskDelegate 中使用并发执行 json 解析。
 使用时，请使用 id<AFURLResponseSerialization> 强制类型转换。
 */
@interface WDTNAFResponseSerialization : NSObject

@end
