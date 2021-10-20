//
//  WDTNDataProcessProtocol.h
//  WDTNNetworkExtensionProject
//
//  Created by wangcheng on 2016/9/29.
//  Copyright © 2016年 weidian. All rights reserved.
//

@protocol WDTNDataProcessProtocol <NSObject>

/**
 管道每个环节的数据加工。
 实现类需要明确定义输入输出数据的类型，并做类型判断。

 @param data 输入数据，实现类需要明确定义数据类型

 @return 输出数据，实现类需要明确定义数据类型
 */
- (id)processData:(id)data error:(NSError **)error;

@end
