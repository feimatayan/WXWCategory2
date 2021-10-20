//
//  WDTNThorGZip.h
//  WDThorNetworking
//
//  Created by ZephyrHan on 2017/11/16.
//  Copyright © 2017年 Weidian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WDTNThorGZip : NSObject

+ (NSData *)gzipCompress:(NSData *)inputData;

+ (NSData*)gzipUncompress:(NSData*)compressedData;

@end
