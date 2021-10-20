//
//  WDEmojiManager.m
//  WDEmoji
//
//  Created by 陈岳燊 on 2020/11/3.
//

#import <YYModel/YYModel.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import "WDEmojiManager.h"
#import "WDEmojiInfoDO.h"

@implementation WDEmojiManager {
    _WDEmojiInnerInfoDO *_emojiInfo;
    NSDictionary *_emojiKeyPathDict;
}


+ (WDEmojiManager *)instance {
    static WDEmojiManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    });

    return _instance;
}

+ (UIImage *)emojiImageWithPath:(NSString *)path bundlePath:(NSString *)bundlePath {
    if (path.length == 0) {
        return nil;
    }

    if (bundlePath.length == 0) {
        bundlePath = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"bundle"];
    }

    NSString *absoluteImagePath = [bundlePath hasSuffix:@"/"] ? bundlePath : [NSString stringWithFormat:@"%@/", bundlePath];

    return [UIImage sd_imageWithData:[[NSData alloc] initWithContentsOfFile:absoluteImagePath]];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _loadLocalEmojiResource];
    }

    return self;
}

- (NSDictionary *)emojiInfoDic {
    return @{
            @"emoji": [_emojiInfo.emoji yy_modelToJSONObject] ?: @[],
    };
}

- (WDEmojiInfoDO *)emojiInfo {
    return [[WDEmojiInfoDO alloc] initWithEmoji:_emojiInfo.emoji];
}

- (NSDictionary *)emojiKeyPathDic {
    return _emojiKeyPathDict;
}

- (void)_loadLocalEmojiResource {
    //只是读一个文件，就不放到异步线程了
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"bundle"];
    NSString *configPath = [[NSBundle bundleWithPath:bundlePath] pathForResource:@"config" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:configPath];

    _emojiInfo = [_WDEmojiInnerInfoDO yy_modelWithJSON:data];
    for (WDEmojiThemeDO *emojiTheme in _emojiInfo.emoji) {
        emojiTheme.path = [bundlePath hasSuffix:@"/"] ? bundlePath : [NSString stringWithFormat:@"%@/", bundlePath];
    }

    _emojiKeyPathDict = [self _p_emjMap];
}

- (NSDictionary *)_p_emjMap {
    NSMutableDictionary *_map = [NSMutableDictionary dictionary];

    // 暂定，不会存在value相同的表情
    for (WDEmojiThemeDO *themeDO in _emojiInfo.emoji) {
        for (WDEmojiItemDO *itemDO in themeDO.emojiList) {
            if (itemDO.value.length > 0 && itemDO.fileName.length > 0) {
                _map[itemDO.value] = [NSString stringWithFormat:@"%@%@", themeDO.path, itemDO.fileName];
            }
        }
    }

    return _map.copy;
}


@end
