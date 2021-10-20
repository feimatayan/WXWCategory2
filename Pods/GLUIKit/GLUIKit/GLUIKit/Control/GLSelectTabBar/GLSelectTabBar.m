//
//  GLSelectTabBar.m
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 30/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#import "GLUIKitUtils.h"
#import "GLSelectTabBar.h"
#import "GLScrollView.h"
#import "NSString+GLString.h"
#import "GLColorConstants.h"
#import "GLFontConstants.h"
#import "GLButton.h"
#import "GLLabel.h"

/**
 导航类型

 - GLSelectTabBarStyleNormal: 普通
 - GLSelectTabBarStyleScroll: 滚动
 */
typedef NS_ENUM (NSInteger, GLSelectTabBarStyle) {
    GLSelectTabBarStyleNormal = 0,
    GLSelectTabBarStyleScroll = 1
};

@interface GLSelectTabBar ()

@property (nonatomic, assign) NSUInteger rowCount;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *datas;

/**
 当前二级tab类型
 */
@property (nonatomic, assign) GLSelectTabBarStyle selectTabBarStyle;

/**
 按钮组
 */
@property (nonatomic, strong) NSMutableArray *btns;

/**
 滚动view
 */
@property (nonatomic, strong) GLScrollView *svContainer;

/**
 当前选中index
 */
@property (nonatomic, assign) NSUInteger currentIndex;

/**
 指示器
 */
@property (nonatomic, strong) GLView *vIndicator;

@property (nonatomic, strong) GLView *vLine;
@end

@implementation GLSelectTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.svContainer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setShowBottomSeparator:(BOOL)showBottomSeparator {
    if (showBottomSeparator == NO) {
        self.vLine.hidden = YES;
    } else {
        self.vLine.hidden = NO;
    }
}

- (instancetype)init {
    if (self = [super init]) {
//        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
        [self configBaseView];
    }

    return self;
}

/**
 构建基本view
 */
- (void)configBaseView {
    self.btns = [[NSMutableArray alloc] init];

    // 滚动背景
    GLScrollView *svContainer = [[GLScrollView alloc] init];
    svContainer.frame = self.svContainer.bounds;
    svContainer.alwaysBounceHorizontal = YES;
    svContainer.alwaysBounceVertical = NO;
    svContainer.showsHorizontalScrollIndicator = FALSE;
    [self addSubview:svContainer];
    self.svContainer = svContainer;

    if (@available(iOS 11.0, *)) {
        svContainer.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
//        svContainer.automaticallyAdjustsScrollIndicatorInsets = NO;
    }

    GLView *vLine = [[GLView alloc] init];
    vLine.frame = CGRectMake(0, 0, 0, 0.5);
    vLine.backgroundColor = GLVC_Gray_EEEEEE;
    [self.svContainer addSubview:vLine];
    self.vLine = vLine;

    GLView *vIndicator = [[GLView alloc] init];
    vIndicator.frame = CGRectMake(0, 41.5, 28, 2.5);
    vIndicator.backgroundColor = UIColorFromRGB(0xD91B1B);
    vIndicator.layer.cornerRadius = 1;
    vIndicator.clipsToBounds = YES;
    self.vIndicator = vIndicator;
    [svContainer addSubview:self.vIndicator];
}

// 外部frame 修改
- (void)layoutSubviews {
    [super layoutSubviews];
    self.svContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    CGSize size = self.svContainer.contentSize;
    self.svContainer.contentSize = CGSizeMake(size.width, self.svContainer.height);

    CGRect rect = self.vIndicator.frame;
    rect.origin.y = self.frame.size.height - 2.5;
    self.vIndicator.frame = rect;

    rect = self.vLine.frame;
    rect.origin.y = self.frame.size.height - 0.5;
    rect.size.width = self.frame.size.width;
    self.vLine.frame = rect;

    [self reloadData];
}

// 重新布局
- (void)reloadData {
    // 清空当前数据源
    for (UIView *view in self.svContainer.subviews) {
        if (view == self.vIndicator || view == self.vLine) {
            continue;
        } else {
            [view removeFromSuperview];
        }
    }

    [self dealSubViews];
}

- (void)dealSubViews {
    // 指示器

    if ([self.dataSource respondsToSelector:@selector(numberOfSelectTabBar:)]) {
        self.rowCount = [self.dataSource numberOfSelectTabBar:self];
        if (self.rowCount == 0) {
            return;
        }
    } else {
        self.rowCount = 0;
        return;
    }

    self.datas = [[NSMutableArray alloc] init];
    // 获取数据源
    if ([self.dataSource respondsToSelector:@selector(selectTabBar:dataSourceForIndex:)]) {
        for (int i = 0; i < self.rowCount; i++) {
            GLSelectTabBarData *tbData = [self.dataSource selectTabBar:self dataSourceForIndex:i];
            tbData.tbIndex = i;
            [self.datas addObject:tbData];
        }
    }

    self.btns = [[NSMutableArray alloc] init];

    // 对数据源进行处理，解析采用哪种结构
    self.selectTabBarStyle = [self dealSelectTabBarStyle];

    // 普通模式
    if (self.selectTabBarStyle == GLSelectTabBarStyleNormal) {
        [self dealSubviewsByNormal];
    }
    // 滚动模式
    else if (self.selectTabBarStyle == GLSelectTabBarStyleScroll) {
        [self dealSubviewsByScroll];
    }

    [self moveIndicatorFrame:self.currentIndex];
}

- (void)dealSubviewsByNormal {
    float margin = 0.0;
    if (self.datas.count < 4) {
        margin = 16;
    }
    float space = 0.0;
    self.svContainer.scrollEnabled = NO;
    float totalTextWidth = 0.0;
    // 创建按钮
    for (GLSelectTabBarData *data in self.datas) {
        GLButton *btn = [self createTabBarButton:data];

        totalTextWidth = totalTextWidth + btn.width;

        [self.btns addObject:btn];
        [self.svContainer addSubview:btn];
    }
    space = (self.width - margin * 2 - totalTextWidth) / (self.datas.count * 2);

    GLButton *btnPre = nil;
    // 布局
    for (int index = 0; index < self.btns.count; index++) {
        GLButton *btn = [self.btns objectAtIndex:index];
        CGRect rect = btn.frame;
        if (btnPre == nil) {
            rect.origin.x = margin + space;
        } else {
            rect.origin.x = space * 2 + CGRectGetMaxX(btnPre.frame);
        }
        btn.frame = rect;

        btnPre = btn;
    }
    self.svContainer.contentSize = CGSizeMake(self.width, self.frame.size.height);
}

- (void)dealSubviewsByScroll {
    self.svContainer.scrollEnabled = YES;
    // 创建按钮
    for (GLSelectTabBarData *data in self.datas) {
        GLButton *btn = [self createTabBarButton:data];
        [self.btns addObject:btn];
        [self.svContainer addSubview:btn];
    }
    float space = 20;
    float margin = 16;
    GLButton *btnPre = nil;
    float maxWidth = 0.0;
    // 布局
    for (int index = 0; index < self.btns.count; index++) {
        GLButton *btn = [self.btns objectAtIndex:index];
        CGRect rect = btn.frame;
        if (btnPre == nil) {
            rect.origin.x = margin;
        } else {
            rect.origin.x = space + CGRectGetMaxX(btnPre.frame);
        }
        btn.frame = rect;
        btnPre = btn;
        maxWidth = CGRectGetMaxX(btn.frame);
    }
    // 滚动区域大小
    self.svContainer.contentSize = CGSizeMake(maxWidth + margin, 44);
}

- (void)setTheme:(GLSelectTabBarBtnTheme)theme {
    CGRect rect = self.vIndicator.frame;
    rect.origin.y = self.frame.size.height - 2.5;
    self.vIndicator.frame = rect;

    _theme = theme;
}

/**
 给按钮加上角标

 @param btn 按钮
 @param index index
 */
- (void)dealUnreadStatusForBtn:(GLButton *)btn forIndex:(NSUInteger)index {
    // 红点
    GLView *vPoint = [[GLView alloc] init];
    vPoint.frame = CGRectMake(btn.width - 8, 6, 8, 8);
    vPoint.backgroundColor = GLVC_Red_E9071F;
    vPoint.layer.cornerRadius = 4;

    vPoint.clipsToBounds = YES;
    vPoint.tag = 100001;
    [btn addSubview:vPoint];

    // 未读数
    GLLabel *lbUnread = [[GLLabel alloc] init];
    lbUnread.frame = CGRectMake(btn.width - 10, -1, 18, 18);
    lbUnread.font = GLFS_Px_24;
    lbUnread.layer.cornerRadius = 9;
    lbUnread.clipsToBounds = YES;
    lbUnread.backgroundColor = GLVC_Red_E9071F;
    lbUnread.textColor = GLTC_White_FFFFFF;
    lbUnread.textAlignment = NSTextAlignmentCenter;
    lbUnread.tag = 100002;
    [btn addSubview:lbUnread];

    GLSelectTabBarUnReadNumStyle unStyle = GLSelectTabBarUnReadNumStylePoint;
    if ([self.dataSource respondsToSelector:@selector(selectTabBar:unReadNunTypeForIndex:)]) {
        unStyle = [self.dataSource selectTabBar:self unReadNunTypeForIndex:index];
    }

    if (unStyle == GLSelectTabBarUnReadNumStylePoint) {
        lbUnread.hidden = YES;
        vPoint.hidden = YES;

        if ([self.dataSource respondsToSelector:@selector(selectTabBar:unReadNumForIndex:)]) {
            NSUInteger unreadNum = [self.dataSource selectTabBar:self unReadNumForIndex:index];
            if (unreadNum > 0) {
                vPoint.hidden = NO;
            }
        }
    } else if (unStyle == GLSelectTabBarUnReadNumStyleNum) {
        lbUnread.hidden = YES;
        vPoint.hidden = YES;
        if ([self.dataSource respondsToSelector:@selector(selectTabBar:unReadNumForIndex:)]) {
            NSUInteger unreadNum = [self.dataSource selectTabBar:self unReadNumForIndex:index];
            if (unreadNum > 0) {
                lbUnread.hidden = NO;
                NSUInteger limitMax = 99;
                if ([self.dataSource respondsToSelector:@selector(selectTabBar:limitUnReadNumForIndex:)]) {
                    limitMax = [self.dataSource selectTabBar:self limitUnReadNumForIndex:index];
                }

                if (unreadNum > limitMax) {
                    lbUnread.text = [NSString stringWithFormat:@"%zd+", limitMax];
                } else {
                    lbUnread.text = [NSString stringWithFormat:@"%zd", unreadNum];
                }
                // 位移 未读数的大小。

                CGSize textSize;
                if ([lbUnread.text respondsToSelector:@selector(sizeWithAttributes:)]) {
                    textSize = [lbUnread.text sizeWithAttributes:@{ NSFontAttributeName: GLFS_Px_24 }];
                } else {
                    textSize = [lbUnread.text glSizeWithFont:GLFS_Px_24];
                }

                if (textSize.width + 8 < 18) {
                    textSize.width = 10;
                }

                CGRect rect = lbUnread.frame;
                rect.origin.x = btn.width - textSize.width / 2 - 2;
                rect.size.width = textSize.width + 8;
                lbUnread.frame = rect;
            }
        }
    }
}

/**
 创建TabBarButton 的按钮

 @param data data
 @return btn
 */
- (GLButton *)createTabBarButton:(GLSelectTabBarData *)data {
    GLButton *btn = [GLButton buttonWithType:UIButtonTypeCustom];

    float btnWidth = [data.tbTitle glSizeWithFont:GLFS_Px_28].width + 16;

    if (self.theme == GLSelectTabBarBtnThemeNormal) {
        [btn setTitleColor:GLTC_Black_404040 forState:UIControlStateNormal];
        btn.titleLabel.font = GLFS_Px_28;
        [btn setTitle:data.tbTitle forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 3, btnWidth, self.frame.size.height - 6);
    } else {
    }

    btn.tag = 1;
    [btn addTarget:self action:@selector(clickTabBarBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self dealUnreadStatusForBtn:btn forIndex:data.tbIndex];

    return btn;
}

/**
 点击按钮事件

 @param sender btn
 */
- (IBAction)clickTabBarBtn:(id)sender {
    NSUInteger index = [self.btns indexOfObject:sender];
    if (self.currentIndex == index) {
        return;
    } else {
        for (GLButton *btn in self.btns) {
            [btn setTitleColor:GLTC_Black_404040 forState:UIControlStateNormal];
        }
        self.currentIndex = index;
        [self switchTabBarAtIndex:index];
    }
}

/**
 切换至某个index

 @param index index
 */
- (void)switchTabBarAtIndex:(NSUInteger)index {
    if (index >= self.btns.count) {
        return;
    }
    for (GLButton *btn in self.btns) {
        [btn setTitleColor:GLTC_Black_404040 forState:UIControlStateNormal];
    }
    self.currentIndex = index;
    // 移动 vIndicator
    [self moveIndicatorFrame:index];

    if ([self.delegate respondsToSelector:@selector(selectTabBar:didClickSelectTabBar:)]) {
        [self.delegate selectTabBar:self didClickSelectTabBar:index];
    }
}

- (void)moveIndicatorFrame:(NSUInteger)index {
    GLButton *selectBtn = [self.btns objectAtIndex:index];
    [selectBtn setTitleColor:UIColorFromRGB(0xD91B1B) forState:UIControlStateNormal];

    CGRect originIndicatorFrame = self.vIndicator.frame;

    [self.svContainer scrollRectToVisible:selectBtn.frame animated:YES];

    self.vIndicator.frame = originIndicatorFrame;
    GL_WEAK(self)

    if (GL_SYSTEM_IOS6) {
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect rect = weak_self.vIndicator.frame;

            rect.origin.x = selectBtn.frame.origin.x + (selectBtn.size.width - 28) / 2;

            weak_self.vIndicator.frame = rect;
        } completion:nil];
    } else {
        CGRect rect = self.vIndicator.frame;

        rect.origin.x = selectBtn.frame.origin.x + (selectBtn.size.width - 28) / 2;
        self.vIndicator.frame = rect;
    }
}

/**
 处理数据，计算采用哪种类型tabbar

 @return 类型
 */
- (GLSelectTabBarStyle)dealSelectTabBarStyle {
    if (self.datas.count > 4) {
        // 如果所有文字组成的按钮加上默认空白超过最大宽度，采用scroll模式
        float maxWidth = 0.0;
        maxWidth = maxWidth + 32;
        for (GLSelectTabBarData *data in self.datas) {
            float btnWidth = [data.tbTitle glSizeWithFont:GLFS_Px_28].width + 16;
            maxWidth = maxWidth + btnWidth;
        }
        if (self.datas.count > 0) {
            maxWidth = maxWidth + (self.datas.count * 20);
        }
        if (maxWidth > self.frame.size.width) {
            return GLSelectTabBarStyleScroll;
        } else {
            return GLSelectTabBarStyleNormal;
        }
    } else {
        return GLSelectTabBarStyleNormal;
    }
}

- (void)showUnReadStatusAtIndex:(NSInteger)index forNum:(NSUInteger)num {
    GLButton *btn = [self.btns objectAtIndex:index];
    GLView *vPoint = [btn viewWithTag:100001];
    GLLabel *lbUnread = [btn viewWithTag:100002];

    vPoint.hidden = YES;
    lbUnread.hidden = YES;

    lbUnread.hidden = YES;
    vPoint.hidden = YES;
    GLSelectTabBarUnReadNumStyle unStyle = GLSelectTabBarUnReadNumStylePoint;
    if ([self.dataSource respondsToSelector:@selector(selectTabBar:unReadNunTypeForIndex:)]) {
        unStyle = [self.dataSource selectTabBar:self unReadNunTypeForIndex:index];
    }

    if (unStyle == GLSelectTabBarUnReadNumStylePoint) {
        if (num > 0) {
            vPoint.hidden = NO;
        }
    } else if (unStyle == GLSelectTabBarUnReadNumStyleNum) {
        if (num > 0) {
            lbUnread.hidden = NO;
            NSUInteger limitMax = 99;
            if ([self.dataSource respondsToSelector:@selector(selectTabBar:limitUnReadNumForIndex:)]) {
                limitMax = [self.dataSource selectTabBar:self limitUnReadNumForIndex:index];
            }

            if (num > limitMax) {
                lbUnread.text = [NSString stringWithFormat:@"%zd+", limitMax];
            } else {
                lbUnread.text = [NSString stringWithFormat:@"%zd", num];
            }
            // 位移 未读数的大小。

            CGSize textSize;
            if ([lbUnread.text respondsToSelector:@selector(sizeWithAttributes:)]) {
                textSize = [lbUnread.text sizeWithAttributes:@{ NSFontAttributeName: GLFS_Px_24 }];
            } else {
                textSize = [lbUnread.text glSizeWithFont:GLFS_Px_24];
            }

            if (textSize.width + 8 < 18) {
                textSize.width = 10;
            }

            CGRect rect = lbUnread.frame;
            rect.origin.x = btn.width - textSize.width / 2 - 2;
            rect.size.width = textSize.width + 8;
            lbUnread.frame = rect;
        }
    }
}

@end
