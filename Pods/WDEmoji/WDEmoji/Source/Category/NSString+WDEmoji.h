//
//  NSString+EMJ.h
//  WDBCommon
//
//  Created by yangxin02 on 2020/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (WDEmoji)


/// 填充表情包，表情使用font.lineHeight，在垂直方向偏移font.descender，在水平方向偏移-1
/// @param aString 文本
/// @param font 字体大小，优先使用Attribute中的字体，用于表情包的size
/// @param offset 表情偏移，水平方向正是往右，垂直方向正是往上
+ (NSAttributedString *)vd_emjString:(NSString *)aString
                                font:(UIFont *)font
                              offset:(UIOffset)offset;


/// 填充表情包，表情使用font.lineHeight，在垂直方向偏移font.descender，在水平方向偏移-1
/// @param font 字体大小，优先使用Attribute中的字体，用于表情包的size
/// @param offset 表情偏移，水平方向正是往右，垂直方向正是往上
- (NSAttributedString *)vd_emjStringWith:(UIFont *)font offset:(UIOffset)offset;

@end
