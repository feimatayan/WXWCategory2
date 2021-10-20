//
//  WDIEDrawLineView.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDIEDrawLineView;

@protocol WDIEDrawLineViewDelegate <NSObject>

@optional

- (void)darwLineViewTouchMoved:(WDIEDrawLineView *)drawLineView;

- (void)darwLineViewTouchEnded:(WDIEDrawLineView *)drawLineView;

- (void)drawLineView:(WDIEDrawLineView *)drawLineView lineCountChanged:(NSUInteger)lineCount;

@end


@interface WDIEDrawLineView : UIView

@property (nonatomic, weak) id<WDIEDrawLineViewDelegate> delegate;

//从外部传递的 笔刷长度和宽度，在包含画板的VC中 要是颜色、粗细有所改变 都应该将对应的值传进来
@property (nonatomic, strong) UIColor *currentPaintBrushColor;

@property (nonatomic, assign) CGFloat currentPaintBrushWidth;

@property (nonatomic, assign) BOOL enableDraw;

/**
 外部调用的清空画板和撤销上一步
 */
- (void)cleanAllDrawBySelf;//清空画板

/**
 撤销上一条线条
 */
- (void)cleanFinallyDraw;

@end
