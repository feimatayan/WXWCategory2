//
//  WDIETextEditView.h
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WDIETextEditView;

@protocol WDIETextEditViewDelegate <NSObject>
@optional

- (void)textEditViewDidCancel:(WDIETextEditView *)textEditView;

- (void)textEditView:(WDIETextEditView *)textEditView didFinishWithText:(NSString *)text andColor:(UIColor *)color;

@end

@interface WDIETextEditView : UIView

@property (nonatomic, copy) NSString *text;

// 文字颜色 默认白色0xFFFFFF
//@property (nonatomic, copy) UIColor *textColor;

// 文字长度限制 默认100
@property (nonatomic, assign) NSUInteger limitLength;

// 默认 白、黑、红、黄、绿、蓝、紫、粉 8种颜色
@property (nonatomic, copy) NSArray<UIColor *> *colors;

// 颜色栏被选中的下标 默认0
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, weak) id<WDIETextEditViewDelegate> delegate;

/**
 展示文字编辑视图
 @param view 父视图
 @param animated 是否添加动画效果 从底部向上滑
 */
- (void)presentFromView:(UIView *)view animated:(BOOL)animated completion:(void(^)(void))completion;

/**
 移除文字编辑视图
 与presentFromView:animated:completion配对使用
 @param animated 是否添加动画效果 从顶部往下滑
 */
- (void)dismissWithAnimated:(BOOL)animated completion:(void(^)(void))completion;

@end
