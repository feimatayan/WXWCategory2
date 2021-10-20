//
//  GLIMBigEmojiContent.h
//  GLIMSDK
//
//  Created by huangbiao on 2017/3/14.
//  Copyright © 2017年 Koudai. All rights reserved.
//

#import "GLIMMessageContent.h"

@interface GLIMBigEmojiContent : GLIMMessageContent

/**
 表情包名
 */
@property (nonatomic, strong) NSString *packageName;

/**
 表情名
 */
@property (nonatomic, strong) NSString *emojiName;

/**
 表情对应的服务器链接
 */
@property (nonatomic, strong) NSURL *emojiUrl;


/**
 动态表情对应的服务器链接
 */
@property (nonatomic, strong) NSURL *emojiGifUrl;


//是否是 gif
@property (nonatomic, assign, readonly) BOOL isGif;


@property (nonatomic, strong) NSString *faceId;

@property (nonatomic, strong) NSString *face_custom_url;


- (NSDictionary *)ce_dictionary;

@end
