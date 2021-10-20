//
//  NSAttributedString+EMJ.m
//  WDBCommon
//
//  Created by yangxin02 on 2020/11/10.
//

#import "NSAttributedString+WDEmoji.h"

#import "WDEmojiManager.h"


#define kEMJRegexSTRING001 @"(\\[)[\\w|\\s|\\d]{3,10}(\\])"


@implementation NSAttributedString (WDEmoji)

+ (NSAttributedString *)vd_emjString:(NSString *)aString
                                font:(UIFont *)font
                              offset:(UIOffset)offset {
    if ([aString isKindOfClass:NSMutableString.class]) {
        aString = aString.copy;
    }

    return [self vd_emjString:aString
             attributedString:nil
                         font:font
                       offset:offset];
}

+ (NSAttributedString *)vd_emjAttributedString:(NSAttributedString *)aString
                                          font:(UIFont *)font
                                        offset:(UIOffset)offset {
    if ([aString isKindOfClass:NSMutableAttributedString.class]) {
        aString = aString.copy;
    }

    return [self vd_emjString:aString.string
             attributedString:aString
                         font:font
                       offset:offset];
}

+ (NSAttributedString *)vd_emjString:(NSString *)aString
                    attributedString:(NSAttributedString *)attributedString
                                font:(UIFont *)font
                              offset:(UIOffset)offset {
    if (aString.length == 0) {
        return [NSAttributedString new];
    }

    NSUInteger length = aString.length;
    NSRange range = NSMakeRange(0, length);

    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kEMJRegexSTRING001
                                                                           options:0
                                                                             error:&error];
    if (regex == nil || error) {
        return attributedString ?: [[NSAttributedString alloc] initWithString:aString];
    }

    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:aString
                                                              options:0
                                                                range:range];
    if (matches.count == 0) {
        return attributedString ?: [[NSAttributedString alloc] initWithString:aString];
    }

    NSDictionary *emjMap = [WDEmojiManager instance].emojiKeyPathDic;

    // https://blog.csdn.net/lwb102063/article/details/77992060
    // https://www.jianshu.com/p/3da70c418fe7
    /*
     * lineHeight是行高, 当你要计算这些字所占用的高度的时候，要用这个属性
     * baseLine, 指的就是紧贴着这些字符的那条线
     * ascender, baseLine的上部分
     * descender, baseLine的下部分
     * capHeight, 表示最高的字符的高度
     * xHeight, 表示最低的字符的高度
     * leading, 指的是如果有多行的话，两个baseline之间的距离，如果只有一行，那么这个值就是0
     
     font.pointSize     17
     font.lineHeight    20.287109375
     font.ascender      16.1865234375
     font.descender     -4.1005859375
     font.capHeight     11.97802734375
     font.xHeight       8.9482421875
     */
    font = font ?: [UIFont systemFontOfSize:[UIFont labelFontSize]];

    NSUInteger index = 0;
    NSRange lastMatchRange;

    NSMutableAttributedString *result = [NSMutableAttributedString new];
    for (NSTextCheckingResult *match in matches) {
        // 匹配前面有字符
        if (match.range.location - index > 0) {
            NSRange leftRange = NSMakeRange(index, match.range.location - index);
            NSAttributedString *leftString;
            if (attributedString) {
                leftString = [attributedString attributedSubstringFromRange:leftRange];
            } else {
                NSString *tmpString = [aString substringWithRange:leftRange];
                leftString = [[NSAttributedString alloc] initWithString:tmpString];
            }
            [result appendAttributedString:leftString];

            index = match.range.location;
        }

        // 匹配的部分
        index += match.range.length;
        lastMatchRange = match.range;
        
        NSString *matchString = [aString substringWithRange:match.range];
        NSString *emjPath = emjMap[matchString];
        
        // 保留未替换成功的文本属性
        NSAttributedString *matchAttrString = [[NSAttributedString alloc] initWithString:matchString];
        if (attributedString) {
            matchAttrString = [attributedString attributedSubstringFromRange:match.range];
        }
        
        if (emjPath.length == 0) {
            [result appendAttributedString:matchAttrString];
            continue;
        }

        UIImage *image = [[UIImage alloc] initWithContentsOfFile:emjPath];
        if (!image || image.size.width == 0 || image.size.height == 0) {
            [result appendAttributedString:matchAttrString];
            continue;
        }
        
        __block NSDictionary *matchAttrs = @{};
        if (attributedString) {
            NSRange matchAttrRange = NSMakeRange(0, matchAttrString.length);
            // 表情的文本一般不会有分开Attributes的情况，所以枚举的时候做一下判断
            [matchAttrString enumerateAttributesInRange:matchAttrRange
                                                options:NSAttributedStringEnumerationReverse
                                             usingBlock:^(NSDictionary<NSAttributedStringKey,id> * attrs, NSRange range, BOOL *stop) {
                if (NSEqualRanges(matchAttrRange, range)) {
                    matchAttrs = attrs;
                    *stop = YES;
                }
            }];
        }
        
        CGFloat emjPaddingLeft = -1 + offset.horizontal;            // 正是往右
        CGFloat emjPaddingTop = font.descender + offset.vertical;   // 正是往上
        CGFloat emjHeight = font.lineHeight;
        
        // 如果有字体，优先使用matchAttr中的字体
        UIFont *attrFont = matchAttrs[NSFontAttributeName];
        if (attrFont) {
            emjPaddingLeft = -1 + offset.horizontal;            // 正是往右
            emjPaddingTop = attrFont.descender + offset.vertical;   // 正是往上
            emjHeight = attrFont.lineHeight;
        }

        CGFloat imageWidth = image.size.width * emjHeight / image.size.height;
        CGFloat imageHeight = emjHeight;
        
        // 文字中加图片
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = image;
        attachment.bounds = CGRectMake(emjPaddingLeft, emjPaddingTop, imageWidth, imageHeight);
        
        // 遍历表情需要的属性，
        // 段落需要，不然UILabel排版会有问题，高度异常
        // 字符间距(间距是在右边的)，表情是不支持字符间距的，加个空格
        __block bool needKern = NO;
        if (matchAttrs.count > 0) {
            NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
            [matchAttrs enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (key == NSParagraphStyleAttributeName) {
                    tmp[NSParagraphStyleAttributeName] = obj;
                } else if (key == NSKernAttributeName) {
                    // 设置字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
                    int originKernValue = [obj intValue];
                    if (originKernValue >= 3 && length - index) {
                        // 排除最后的表情包，不加间距
                        needKern = YES;
                        
                        tmp[NSKernAttributeName] = @(originKernValue - 3);
                    }
                } else if (key == NSBaselineOffsetAttributeName) {
                    // 设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
                    tmp[NSBaselineOffsetAttributeName] = obj;
                }
            }];
            matchAttrs = tmp.copy;
        }

        // 原本文本中的属性
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        if (matchAttrs.count > 0) {
            NSMutableAttributedString *tmp = [attachmentString mutableCopy];
            if (needKern) {
                [tmp appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }
            NSRange attachmentRange = NSMakeRange(0, tmp.length);
            [tmp addAttributes:matchAttrs range:attachmentRange];
            
            attachmentString = tmp.copy;
        }
        [result appendAttributedString:attachmentString];
    }

    if (length - index > 0) {
        NSRange lastRange = NSMakeRange(index, length - index);
        NSAttributedString *lastString;
        if (attributedString) {
            lastString = [attributedString attributedSubstringFromRange:lastRange];
        } else {
            NSString *tmpString = [aString substringWithRange:lastRange];
            lastString = [[NSAttributedString alloc] initWithString:tmpString];
        }
        [result appendAttributedString:lastString];
    }

    return result.copy;
}

- (NSAttributedString *)vd_emjAttributedStringWith:(UIFont *)font
                                            offset:(UIOffset)offset {
    return [NSAttributedString vd_emjAttributedString:self
                                                 font:font
                                               offset:offset];
}

@end
