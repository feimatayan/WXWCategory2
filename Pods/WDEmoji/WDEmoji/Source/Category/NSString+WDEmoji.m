//
//  NSString+EMJ.m
//  WDBCommon
//
//  Created by yangxin02 on 2020/11/10.
//

#import "NSString+WDEmoji.h"
#import "NSAttributedString+WDEmoji.h"


@implementation NSString (WDEmoji)

+ (NSAttributedString *)vd_emjString:(NSString *)aString
                                font:(UIFont *)font
                              offset:(UIOffset)offset {
    return [NSAttributedString vd_emjString:aString font:font offset:offset];
}

- (NSAttributedString *)vd_emjStringWith:(UIFont *)font offset:(UIOffset)offset {
    return [NSAttributedString vd_emjString:self font:font offset:offset];
}

@end
