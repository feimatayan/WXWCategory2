//
//  GLGzipProvider.h
//  GLAES_GzipProvider
//
//  Created by 赵 一山 on 14/12/29.
//  Copyright (c) 2014年 赵 一山. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLGzipProvider : NSObject

+ (NSData *)unzip:(NSData*)srcData;
+ (NSData *)zip:(NSData*)srcData;

@end
