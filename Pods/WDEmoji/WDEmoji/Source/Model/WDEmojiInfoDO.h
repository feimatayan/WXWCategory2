//
//  WDEmojiInfoDO.h
//  WDEmoji
//
//  Created by 陈岳燊 on 2020/11/3.
//

#import <Foundation/Foundation.h>


@class WDEmojiItemDO;
@class WDEmojiThemeDO;


@interface WDEmojiInfoDO : NSObject

@property (nonatomic, strong) NSArray<WDEmojiThemeDO *> *emoji;

- (instancetype)initWithEmoji:(NSArray<WDEmojiThemeDO *> *)emoji;

+ (instancetype)aDoWithEmoji:(NSArray<WDEmojiThemeDO *> *)emoji;

@end


@interface _WDEmojiInnerInfoDO : NSObject

@property (nonatomic, strong) NSString *md5;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSArray<WDEmojiThemeDO *> *emoji;

@end


@interface WDEmojiThemeDO : NSObject

@property (nonatomic, strong) NSArray<WDEmojiItemDO *> *emojiList;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *emojiTheme;

@end


@interface WDEmojiItemDO : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *fileName;

@end
