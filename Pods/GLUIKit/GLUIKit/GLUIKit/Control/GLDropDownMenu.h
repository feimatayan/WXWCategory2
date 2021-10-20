//
//  GLDropDownMenu.h
//  GLUIKit
//
//  Created by Kevin on 15/10/19.
//  Copyright (c) 2015年 koudai. All rights reserved.
//


#import "GLView.h"


@class GLDropDownMenu;

@protocol GLDropDownMenuDelegate <NSObject>

-(void)glDropDownMenu:(GLDropDownMenu *)menu didSelectItemIndex:(NSInteger)index;

@end


typedef NS_ENUM(NSUInteger, GLDropDownMenuType) {
    
    GLDropDownMenuTypeValue1 = 0,   // item只有文字
    GLDropDownMenuTypeValue2,       // item = 图标 + 文字
};


/*********************************
 *
 * 下拉菜单
 *
 ********************************/
@interface GLDropDownMenu : GLView

/// 用于存放临时变量。目前用来存放全屏的遮盖。
@property (nonatomic, strong) id userData;

/// delegate
@property (nonatomic, weak) id<GLDropDownMenuDelegate> delegate;

/// 类型
@property (nonatomic) GLDropDownMenuType type;

/// 背景图片
@property (nonatomic, strong) UIImage *backgroundImage;

/// 上边的内部留白
@property (nonatomic) CGFloat paddingTop;

/// item高
@property (nonatomic) CGFloat itemHeight;

/// 左侧留白
@property (nonatomic) CGFloat marginLeft;

/// 右侧留白
@property (nonatomic) CGFloat paddingRight;

/**
 *
 * titleItems结构
 * 第一种,@[@[imageName,title],@[@[imageName,title]]];
 * 第二种,@[@[title],@[@[title]]]
 *
 * @param titleItems 条目数据
 * @param type 类型
 *
 **/
- (instancetype)initWithTitleItems:(NSArray *)titleItems type:(GLDropDownMenuType)type;


@end
