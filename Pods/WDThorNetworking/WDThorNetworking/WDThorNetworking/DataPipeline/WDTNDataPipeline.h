//
//  WDTNDataPipeline.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WDTNDataProcessProtocol;

@interface WDTNDataPipeline : NSObject

- (void)appendItem:(id<WDTNDataProcessProtocol>)item;

/**
 调用管道的方法，将最终的处理结果返回。

 @param data 输入数据

 @return 输出数据
 */
- (id)processData:(id)data error:(NSError **)error;

/**
 清空管道的队列
 */
- (void)removeAllItems;

@end
