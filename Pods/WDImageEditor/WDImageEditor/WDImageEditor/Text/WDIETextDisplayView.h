//
//  WDIETextDisplayView.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDIETextDisplayView;

@protocol WDIETextDisplayViewDelegate <NSObject>
@optional

- (void)textDisplayViewTaped:(WDIETextDisplayView *)textDisplayView;

- (void)textDisplayViewMoved:(WDIETextDisplayView *)textDisplayView;

- (void)textDisplayViewDidEndMove:(WDIETextDisplayView *)textDisplayView;

- (void)textDisplayViewDidBecomeActive:(WDIETextDisplayView *)textDisplayView;

@end


@interface WDIETextDisplayView : UIView

@property (nonatomic, weak) id<WDIETextDisplayViewDelegate> delegate;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) CGFloat preferredTextWidth;

@property (nonatomic, assign) CGPoint anchor;

@property (nonatomic, assign) BOOL borderHidden;

// 记录颜色下标
@property (nonatomic, assign) NSUInteger index;

@end
