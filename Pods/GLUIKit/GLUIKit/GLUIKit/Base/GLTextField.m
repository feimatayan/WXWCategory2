//
//  GLTextField.m
//  GLUIKit
//
//  Created by xiaofengzheng on 15-9-28.
//  Copyright (c) 2015年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLTextField.h"
#import "GLUIKitUtils.h"

@implementation GLTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder) {
        NSDictionary *dic = @{NSForegroundColorAttributeName:UIColorFromRGB(0xd6d6d6)};
        NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder
                                                                                                  attributes:dic];
        self.attributedPlaceholder = attributedPlaceholder;
       
    }
}



@end
