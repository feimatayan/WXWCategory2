//
//  GLIMVideoContent.h
//  GLIMSDK
//
//  Created by TempHB on 2019/7/24.
//  Copyright © 2019 Koudai. All rights reserved.
//

#import "GLIMMessageContent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 视频消息
 */
@interface GLIMVideoContent : GLIMMessageContent

/// 视频ID
@property (nonatomic, copy) NSString *videoID;
/// 视频封面
@property (nonatomic, copy) NSString *videoCover;
/// 视频时长
@property (nonatomic, copy) NSString *videoDuration;
/// 视频链接
@property (nonatomic, copy) NSString *playUrl;

/// 视频封面本地地址
@property (nonatomic, copy) NSString *videoLocalCover;
/// 视频本地缓存地址（相对路径）
@property (nonatomic, copy) NSString *videoLocalUrl;
/// 视频本地缓存目录类型
@property (nonatomic, assign) NSUInteger pathDirectory;

//此条消息是风控
@property (nonatomic, assign, readonly) BOOL videoForbidden;

- (NSString *)detailInfo;

/**
 对外提供的视频播放字段

 @return 字段字典
 */
- (NSDictionary *)videoPlayInfos;

/**
 时长显示

 @return 时长显示
 */
- (NSString *)durationString;

/// 返回本地播放URL
- (NSURL *)localPlayUrl;

@end

NS_ASSUME_NONNULL_END
