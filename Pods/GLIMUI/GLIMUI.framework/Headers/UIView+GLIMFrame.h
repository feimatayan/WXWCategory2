//
//  UIView+GLIMFrame.h
//  GLIMSDK
//
//  Created by huangbiao on 15/10/29.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GLIMFrame)

#pragma mark - x coordinate
@property (nonatomic, assign) CGFloat im_x;
@property (nonatomic, assign) CGFloat im_centerX;
@property (nonatomic, assign) CGFloat im_tail;


#pragma mark - y coordinate
@property (nonatomic, assign) CGFloat im_y;
@property (nonatomic, assign) CGFloat im_centerY;
@property (nonatomic, assign) CGFloat im_bottom;


#pragma mark - other
@property (nonatomic, assign) CGFloat im_width;
@property (nonatomic, assign) CGFloat im_height;
@property (nonatomic, assign) CGPoint im_origin;
@property (nonatomic, assign) CGSize im_size;

@end
