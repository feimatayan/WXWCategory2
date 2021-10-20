//
//  GLGzipProvider.m
//  GLAES_GzipProvider
//
//  Created by 赵 一山 on 14/12/29.
//  Copyright (c) 2014年 赵 一山. All rights reserved.
//

#import "GLGzipProvider.h"
#import "CryptUtil.h"
#import "NSData-AES.h"

@implementation GLGzipProvider

+ (NSData *)unzip:(NSData*)srcData {
    return [CryptUtil gzipExtract:srcData];
}

+ (NSData *)zip:(NSData*)srcData {
   return [CryptUtil gzipCompress:srcData];
}

@end
