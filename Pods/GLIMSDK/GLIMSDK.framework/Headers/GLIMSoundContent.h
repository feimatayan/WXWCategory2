//
//  GLIMSoundContent.h
//  GLIMSDK
//
//  Created by ZephyrHan on 17/2/13.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMMessageContent.h"

@interface GLIMSoundContent : GLIMMessageContent

/**
 文件URL，如果文件在本地，则使用本地文件scheme
 */
@property (nonatomic, strong) NSURL* fileURL;

/**
 音频时长
 */
@property (nonatomic) NSUInteger duration;

/**
 是否播放过 0 未读 1正在读 2 已读 
 */
@property (nonatomic) NSInteger readStatus;

@end
