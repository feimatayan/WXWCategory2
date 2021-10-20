//
//  GLIMImageContent.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMMessageContent.h"
#import <CoreGraphics/CoreGraphics.h>


@interface GLIMImageContent : GLIMMessageContent

/**
 文件URL，如果文件在本地，则使用本地文件scheme
 */
@property (nonatomic, strong) NSURL* fileURL;

/**
 图片大小
 */
@property (nonatomic) CGSize size;

/**
 缩略图大小
 */
@property (nonatomic) CGSize thumbnailSize;

/// 获取待上传的图片数据
- (id)getUploadImage:(NSString *)chatID;

@end
