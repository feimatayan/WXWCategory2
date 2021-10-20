//
//  UILabel+WDAddAttribute.m
//  WDUtility
//
//  Created by yuping on 16/5/12.
//  Copyright © 2016年 yuping. All rights reserved.
//

#import "UILabel+WDAddAttribute.h"
#import "NSString+WDSize.h"

@implementation UILabel (WDAddAttribute)

- (void)wd_addDeleteLine {
    [self wd_addDeleteLineWithColor:self.textColor];
}

- (void)wd_addDeleteLineWithColor:(UIColor *)color {
    if (self.text.length == 0) {
        return ;
    }
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.text.length)];
    [attri addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    [self setAttributedText:attri];
}

- (void)wd_alignTopWithAttributeDic:(NSDictionary *)attributeDic {
    double finalHeight = self.frame.size.height;
    double finalWidth =self.frame.size.width;
    CGSize theStringSize = [self.text wd_boundingRectWithSize:CGSizeMake(finalWidth, finalHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
    int newLinesToPad =(finalHeight - theStringSize.height)/ (((UIFont *)[attributeDic objectForKey:NSFontAttributeName]).pointSize+((NSMutableParagraphStyle *)[attributeDic objectForKey:NSParagraphStyleAttributeName]).lineSpacing);
    for(int i=0; i<newLinesToPad; i++)
    {
        self.text =[self.text stringByAppendingString:@"\n"];
    }
}

@end
