//
//  WDEmojiInfoDO.m
//  WDEmoji
//
//  Created by 陈岳燊 on 2020/11/3.
//

#import <Foundation/Foundation.h>
#import "WDEmojiInfoDO.h"
#import "NSObject+YYModel.h"

@implementation WDEmojiInfoDO

- (instancetype)initWithEmoji:(NSArray<WDEmojiThemeDO *> *)emoji {
    self = [super init];
    if (self) {
        _emoji = emoji;
    }

    return self;
}

+ (instancetype)aDoWithEmoji:(NSArray<WDEmojiThemeDO *> *)emoji {
    return [[self alloc] initWithEmoji:emoji];
}

@end

@implementation _WDEmojiInnerInfoDO

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
            @"emoji": WDEmojiThemeDO.class,
    };
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    return YES;
}

@end

@implementation WDEmojiThemeDO

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{
            @"emojiList": WDEmojiItemDO.class,
    };
}

@end

@implementation WDEmojiItemDO

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if (self.value.length > 2) {
        self.value = [NSString stringWithFormat:@"[\u2006%@\u2006]", [self.value substringWithRange:NSMakeRange(1, self.value.length - 2)]];
    }
    return YES;
}

@end
