//
//  GLFormCell.h
//  GLUIKit
//
//  Created by Kevin on 15/10/10.
//  Copyright (c) 2015年 koudai. All rights reserved.
//




#import "GLView.h"




/// defaul Height
const static CGFloat kGLFormCellHeight = 50.0f;


typedef NS_ENUM(NSUInteger, GLFormCellType) {
    
    GLFormCellTypeDefault = 0,    // 左对其label
    GLFormCellTypeValue1  = 1,    // 左对齐label，右侧带有"箭头"图标
    GLFormCellTypeValue2  = 2,    // 左对齐label，右侧带有switch滑块
    GLFormCellTypeValue3  = 3,    // 左对齐label，中间desc label，右侧"箭头"图标
};


@class GLLabel;
@class GLSwitch;
@class GLControl;
@protocol GLFormCellDelegate;


@interface GLFormCell : GLView

/// delegate, switch or click event
@property (nonatomic, assign) id<GLFormCellDelegate> delegate;

/// cell type
@property (nonatomic, assign) GLFormCellType cellType;

/// 标题 左对齐label
@property (nonatomic, strong) GLLabel *titleLabel;

/// desc 中间的label
@property (nonatomic, strong) GLLabel *middleDescLabel;

/// show bottomLine flag default NO
@property (nonatomic, assign) BOOL isShowBottomLine;

/// right switch
@property (nonatomic, readonly) GLSwitch *rightSwitch;




/**
 *  @brief 初始化实例
 *
 *  @param frame FomeCell Frame
 *  @param type  FomeCell Type
 *
 *  @return GLFormCell 实例
 */
- (instancetype)initWithFrame:(CGRect)frame cellType:(GLFormCellType)type;


/**
 *  @brief 设置文字内容
 *
 *  @param title content string
 *
 *  @return label的x值
 */
- (CGFloat)setTitle:(NSString *)title;


/**
 *  @brief 设置文字内容
 *
 *  @param title   content string
 *  @param descStr 中间的描述字符串
 */
- (void)setTitle:(NSString *)title middleDesc:(NSString *)descStr;


/**
 *  @brief 设置中部字符串的颜色
 *
 *  @param color color 文字颜色
 */
- (void)setMiddleDescStrTextColor:(UIColor *)color;


/**
 *  @brief 设置BottomLine Frame
 *
 *  @param frame 要设置的Frame
 */
- (void)setBottomLineFrame:(CGRect)frame;




@end









@protocol GLFormCellDelegate <NSObject>

@optional

/**
 *  @brief click action
 *
 *  @param cell    被点击的GLFomeCell 实例
 *  @param control 响应action的UIControl 实例
 */
- (void)glFormCell:(GLFormCell *)cell didClick:(GLControl *)control;
/**
 *  @brief switch ValueChanged
 *
 *  @param cell          swithch 实例
 *  @param changedSwitch 响应action的UIControl 实例
 */
- (void)glFormCell:(GLFormCell *)cell didSwitchValueChange:(GLSwitch *)changedSwitch;

@end

