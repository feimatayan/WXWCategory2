//
//  GLLineLabel.h
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//


#import "GLLabel.h"


/**
 *  划线的label，暂支持中划线，下划线
 */
@interface GLLineLabel : GLLabel
{
    UIColor *_lineColor;
}

/**
 *  线颜色，默认self.textColor
 */
@property (strong,getter=lineColor) UIColor *lineColor;

/**
 *  线高度，默认0.5
 */
@property (assign) CGFloat lineHeight;

/**
 *  文字size，需要适时调整labelframe！！！
 */
@property (nonatomic, assign) CGSize optimumSize;

@end


/////////////////////////////////////////////////////////////////


/**
 *  中划线
 */
@interface GLMiddleLineLabel : GLLineLabel

@end


/////////////////////////////////////////////////////////////////


/**
 *  下划线
 */
@interface GLBottomLineLabel : GLLineLabel


@end
