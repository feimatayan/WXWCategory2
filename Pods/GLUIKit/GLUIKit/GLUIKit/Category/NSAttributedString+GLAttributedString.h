//
//  NSAttributedString+GLAttributedString.h
//  GLUIKit
//
//  Created by yanglei on 2017/10/20.
//  Copyright © 2017年 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (GLAttributedString)
/**
 *  计算字体 size AVAILABLE iOS7.0.0 later
 *
 *  @return size
 */
- (CGSize)glSizeWithConstrainedSize:(CGSize)csize;
@end
