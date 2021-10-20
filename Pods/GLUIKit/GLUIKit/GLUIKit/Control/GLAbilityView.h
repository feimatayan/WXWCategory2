//
//  GLAbilityView.h
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 27/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLView.h"
#import "GLLabel.h"
#import "GLControl.h"
#import "GLImageView.h"
#import "GLSwitch.h"

typedef void(^ClickHandlerBlock)(void);



typedef NS_ENUM(NSInteger, GLAbilityViewStyle) {
    GLAbilityViewStyleTitle,                    // 文本
    GLAbilityViewStyleTitleArrow,               // 文本 + 箭头
    GLAbilityViewStyleTitleDescriptionArrow,    // 文本 + 描述 + 箭头
    GLAbilityViewStyleTitleSwitch               // 文本 + 开关 (actionControl is nil)
};




@interface GLAbilityView : GLView

// 标题 左对齐label
@property (nonatomic, strong) GLLabel       *titleLabel;

// desc 中间的label
@property (nonatomic, strong) GLLabel       *descriptionLabel;

// bottom line
@property (nonatomic, strong) GLView        *bottomLineView;

// 覆盖在view上的点击层
@property (nonatomic, strong) GLControl     *actionControl;

// 右侧箭头
@property (nonatomic, strong) GLImageView   *rightArrowImageView;

// 左侧红点
@property (nonatomic, strong) GLView        *dotLeftView;

// 右侧红点
@property (nonatomic, strong) GLView        *dotRightView;

// 右侧滑块
@property (nonatomic, strong) GLSwitch  *rightSwitch;

// 隐藏底部分割线 default NO
@property (nonatomic, assign) BOOL      hideLineFlag;

// 整行分割线 default NO
@property (nonatomic, assign) BOOL      fullLineFlag;

// 显示红点在title的左侧
@property (nonatomic, assign) BOOL      showTitleDotLeft;

// 显示红点在title的右侧
@property (nonatomic, assign) BOOL      showTitleDotRight;

// 点击回调
@property (nonatomic, copy)  ClickHandlerBlock clickHandlerBlock;




// 初始化 样式
- (id)initWithStyle:(GLAbilityViewStyle)style;

// 设置 标题
- (void)setTitle:(NSString *)title;

// 设置 标题、描述
- (void)setTitle:(NSString *)title description:(NSString *)desStr;

// 设置 描述
- (void)setDescription:(NSString *)desStr;


@end
