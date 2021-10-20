//
//  VDUploadStreamReader.h
//  VDUploador
//
//  Created by 杨鑫 on 2021/5/21.
//  Copyright © 2021 yangxin02. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WDNErrorDO;

@interface VDUploadStreamReader : NSObject

/// 读取成功后，这两个值才会加
@property (nonatomic, assign, readonly) NSUInteger partIndex;
@property (nonatomic, assign, readonly) unsigned long long offset;

@property (nonatomic, assign, readonly) NSUInteger partCount;
@property (nonatomic, assign, readonly) NSUInteger partSize;

@property (nonatomic, assign, readonly) unsigned long long fileSize;

- (instancetype)initWithPath:(NSString *)path partSize:(NSUInteger)partSize;

- (WDNErrorDO *)updateFileSize;

/// 循环读取的时候，最好套上@autoreleasepool
/// 内部已经套上了@autoreleasepool
/// 按照分片大小，计算平均分片的大小
- (NSData *)readNextIfEnd:(BOOL *)isEnd error:(WDNErrorDO **)error;

- (WDNErrorDO *)closeFile;

- (WDNErrorDO *)reSeek;

@end
