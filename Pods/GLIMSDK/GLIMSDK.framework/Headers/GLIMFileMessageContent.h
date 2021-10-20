//
//  GLIMFileMessageContent.h
//  GLIMSDK
//
//  Created by huangbiao on 2021/6/23.
//  Copyright © 2021 Koudai. All rights reserved.
//

#import "GLIMMessageContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLIMFileMessageContent : GLIMMessageContent

/// 文件类型，如.doc
@property (nonatomic, copy) NSString *fileType;
/// 文件名称
@property (nonatomic, copy) NSString *fileName;
/// 文件大小
@property (nonatomic, copy) NSString *fileSize;
/// 文件id
@property (nonatomic, copy) NSString *fileId;

#pragma mark - 对外字段

@property (nonatomic, copy, readonly) NSString *fileSizeString;

/// 对外预览字段
- (NSDictionary *)filePreviewInfos;

/// 立即下载
- (BOOL)downloadImmediately;

#pragma mark - Test
+ (instancetype)mockData;

@end

NS_ASSUME_NONNULL_END
