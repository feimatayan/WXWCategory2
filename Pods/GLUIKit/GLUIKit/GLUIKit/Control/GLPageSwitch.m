//
//  GLPageSwitch.m
//  WDCommlib
//
//  Created by smallsao on 15/12/17.
//  Copyright © 2015年 赵 一山. All rights reserved.
//

#import "GLSCrollView.h"
#import "GLPageSwitch.h"
#import "GLUIKitUtils.h"
#import "GLLabel.h"


@interface GLPageSwitchScrollView : GLScrollView

@end

@implementation GLPageSwitchScrollView

- (BOOL)touchesShouldCancelInContentView:(GLView *)view {
    return YES;
}

@end


@interface GLPageSwitch ()
/// 滚动区域
@property (nonatomic, strong) GLScrollView *scrollView;
/// 所包含的button 组
@property (nonatomic, strong) NSMutableArray *buttons;
/// 主题view
@property (nonatomic, strong) GLView *contentView;
/// 选中指示器
@property (nonatomic, strong) GLView *selectionIndicatorBar;
/// 底部指示
@property (nonatomic, strong) GLView *bottomTrim;
/// 按钮状态组
@property (nonatomic, strong) NSMutableDictionary *buttonColorsByState;

@property (nonatomic, assign) GLPageSwitchSpaceStyle spaceStyle;

@property (nonatomic, strong) NSLayoutConstraint *leftSelectionIndicatorConstraint, *rightSelectionIndicatorConstraint;

/// 红点
@property (nonatomic, strong) NSMutableArray *ivRedPoints;

/// 未读数
@property (nonatomic, strong) NSMutableArray *lbUnreadNums;

@end

/// 指示器选中 显示高度
#define kGLPageSwitchSelectionIndicatorHeight 2
@implementation GLPageSwitch


- (void)drawBaseView {
    self.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[GLPageSwitchScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_scrollView];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    _contentView = [[GLView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_contentView)]];
    
    if (self.spaceStyle == GLPageSwitchSpaceStyleAutoWidthNoScroll || self.spaceStyle == GLPageSwitchSpaceStyleFixedWidth) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0]];
    }
    
    _bottomTrim = [[GLView alloc] init];
    _bottomTrim.backgroundColor = [UIColor blackColor];
    _bottomTrim.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_bottomTrim];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomTrim]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_bottomTrim)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomTrim(height)]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"height" : @(GL_HEIGHT_LINE)} views:NSDictionaryOfVariableBindings(_bottomTrim)]];
    
    self.buttonInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    self.displayStyle = GLPageSwitchDisplayStyleBottomBar;
    
    _buttons = [NSMutableArray array];
    _lbUnreadNums = [NSMutableArray array];
    _ivRedPoints = [NSMutableArray array];
    
    _selectionIndicatorBar = [[GLView alloc] init];
    _selectionIndicatorBar.translatesAutoresizingMaskIntoConstraints = NO;
    _selectionIndicatorBar.backgroundColor = [UIColor blackColor];
    
    _buttonColorsByState = [NSMutableDictionary dictionary];
    _buttonColorsByState[@(UIControlStateNormal)] = UIColorFromRGB(0x404040);
}

/**
 *  @author smallsao, 15-12-17 15:12:34
 *
 *  use frame
 *
 *  @param frame      frame
 *  @param spaceStyle 控件展示类型
 *
 *  @return id
 */
- (id)initByFrame:(CGRect)frame withSpaceStyle:(GLPageSwitchSpaceStyle)spaceStyle {
    self.unreadNumBGColor = [UIColor redColor];
    self.unreadNumTitleColor = [UIColor whiteColor];
    self.redPointImage = [UIImage imageNamed:@"GLUIKit_icon_red_dot"];
    self.spaceStyle = spaceStyle;
    self = [super initWithFrame:frame];
    if (self) {
        [self drawBaseView];
    }
    return self;
}

/**
 *  @author smallsao, 15-12-17 15:12:41
 *
 *  use autolayout
 *
 *  @param spaceStyle 控件展示类型
 *
 *  @return id
 */
- (id)initByAutolayoutWithSpaceStyle:(GLPageSwitchSpaceStyle)spaceStyle {
    self.unreadNumBGColor = [UIColor redColor];
    self.unreadNumTitleColor = [UIColor whiteColor];
    self.redPointImage = [UIImage imageNamed:@"GLUIKit_icon_red_dot"];
    self.spaceStyle = spaceStyle;
    self = [super init];
    if (self) {
        [self drawBaseView];
    }
    return self;
}


#pragma mark - Custom Getters and Setters

- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    self.selectionIndicatorBar.backgroundColor = selectionIndicatorColor;
    
    if (!self.buttonColorsByState[@(UIControlStateSelected)]) {
        self.buttonColorsByState[@(UIControlStateSelected)] = selectionIndicatorColor;
    }
}

- (UIColor *)selectionIndicatorColor {
    return self.selectionIndicatorBar.backgroundColor;
}

- (void)setBottomTrimColor:(UIColor *)bottomTrimColor {
    self.bottomTrim.backgroundColor = bottomTrimColor;
}

- (UIColor *)bottomTrimColor {
    return self.bottomTrim.backgroundColor;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.buttonColorsByState[@(state)] = color;
}

#pragma mark - Public Methods

- (void)reloadData {
    
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    for (UILabel *lb in self.lbUnreadNums) {
        [lb removeFromSuperview];
    }
    for (UIImageView *iv in self.ivRedPoints) {
        [iv removeFromSuperview];
    }
    
    [self.selectionIndicatorBar removeFromSuperview];
    [self.buttons removeAllObjects];
    [self.lbUnreadNums removeAllObjects];
    [self.ivRedPoints removeAllObjects];
    
    NSInteger totalButtons = self.items.count;
    if (totalButtons < 1) {
        return;
    }
    
    if (self.spaceStyle == GLPageSwitchSpaceStyleAutoWidthNoScroll) {
        [self reloadDataByAutoWidthNoScroll];
    }
    else if (self.spaceStyle == GLPageSwitchSpaceStyleFixedWidth) {
        [self reloadDataByFixedWidth];
    }
    else if (self.spaceStyle == GLPageSwitchSpaceStyleAutoWidthWithScroll) {
        [self reloadDataByAutoWidthWithScroll];
    }
    
    if (totalButtons > 0) {
        UIButton *selectedButton = self.buttons[self.selectedButtonIndex];
        selectedButton.selected = YES;
        
        switch (self.displayStyle) {
            case GLPageSwitchDisplayStyleBottomBar: {
                [self.contentView addSubview:self.selectionIndicatorBar];
                
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectionIndicatorBar(height)]|"
                                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                         metrics:@{@"height" : @(kGLPageSwitchSelectionIndicatorHeight)}
                                                                                           views:NSDictionaryOfVariableBindings(_selectionIndicatorBar)]];
                
                [self alignSelectionIndicatorWithButton:selectedButton];
                break;
            }
                
            case GLPageSwitchDisplayStyleButtonBorder: {
                selectedButton.layer.borderColor = self.selectionIndicatorColor.CGColor;
                break;
            }
        }
    }
    
    [self sendSubviewToBack:self.bottomTrim];
    
    [self updateConstraintsIfNeeded];
}
- (void)reloadDataByAutoWidthNoScroll {
    UIButton *previousButton;
    NSInteger totalButtons = self.items.count;
    GLView *tempView;
    NSDictionary *metrics = @{@"mr":@(20),@"mt":@(20),@"mtl":@(10),@"mtll":@(-7),@"height":@(20),@"btnMargin":@(self.btnMargin)};

    tempView = [[GLView alloc] init];
    [self.contentView addSubview:tempView];
    tempView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tempView]-0-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(tempView)]];
    
    for (NSInteger index = 0; index < totalButtons; index++) {
        NSString *buttonTitle = _items[index];
        UIButton *button = [self selectionListButtonWithTitle:buttonTitle];
        [tempView addSubview:button];
        [self.buttons addObject:button];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        GLView *bgUnreadNum = [[GLView alloc] init];
        bgUnreadNum.layer.cornerRadius = 8;
        bgUnreadNum.clipsToBounds = YES;
        bgUnreadNum.backgroundColor = UIColorFromRGB(0xC60A1E);
        bgUnreadNum.translatesAutoresizingMaskIntoConstraints = NO;
        [tempView addSubview:bgUnreadNum];
        [self.lbUnreadNums addObject:bgUnreadNum];

        GLLabel *unreadNum = [[GLLabel alloc] init];
        [bgUnreadNum addSubview:unreadNum];
        unreadNum.translatesAutoresizingMaskIntoConstraints = NO;
        unreadNum.font = FONTSYS(10);
        unreadNum.textAlignment = NSTextAlignmentLeft;
        unreadNum.textColor = self.unreadNumTitleColor;
        unreadNum.tag = 1000000;

        UIImageView *redPoint = [[UIImageView alloc] init];
        [tempView addSubview:redPoint];
        redPoint.image = self.redPointImage;
        redPoint.translatesAutoresizingMaskIntoConstraints = NO;
        [self.ivRedPoints addObject:redPoint];
        
        redPoint.hidden = YES;
        bgUnreadNum.hidden = YES;
        
        [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-(-5)-[redPoint(==7)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button,redPoint)]];
        [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[redPoint(==7)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button,redPoint)]];
        [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-mtll-[bgUnreadNum(>=16)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bgUnreadNum,button)]];
        [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[bgUnreadNum(==16)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bgUnreadNum,button)]];

        
        [bgUnreadNum addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[unreadNum(>=0)]-5-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(unreadNum)]];
        [bgUnreadNum addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[unreadNum(==16)]-0-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(unreadNum)]];
        
        if (totalButtons == 1) {
            // 只有一个按钮
            [tempView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            
            [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button(>=0)]|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button)]];
        }
        else {
            // 多个button
            if (index == 0) {
                // 第一个按钮
                [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-mr-[button(>=20@666)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button)]];
                
                previousButton = button;
            }
            else if (totalButtons == index + 1){
                // 最后一个
                [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-btnMargin-[button(>=20@666)]-mr-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button,previousButton)]];
            }
            else {
                // 中间的button
                [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-btnMargin-[button(>=20@666)]" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button,previousButton)]];
                
                previousButton = button;

            }
            [tempView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button(>=0)]|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(button,previousButton)]];
            
            

        }
        
        
        
    }
    
}

- (void)reloadDataByFixedWidth {
    NSInteger totalButtons = self.items.count;
    UIButton *previousButton;

    for (NSInteger index = 0; index < totalButtons; index++) {
        NSString *buttonTitle = _items[index];
        
        UIButton *button = [self selectionListButtonWithTitle:buttonTitle];
        [self.contentView addSubview:button];
        
        GLView *bgUnreadNum = [[GLView alloc] init];
        bgUnreadNum.layer.cornerRadius = 8;
        bgUnreadNum.clipsToBounds = YES;
        bgUnreadNum.backgroundColor = UIColorFromRGB(0xC60A1E);
        bgUnreadNum.translatesAutoresizingMaskIntoConstraints = NO;
        [button addSubview:bgUnreadNum];
        [self.lbUnreadNums addObject:bgUnreadNum];
        
        GLLabel *unreadNum = [[GLLabel alloc] init];
        [bgUnreadNum addSubview:unreadNum];
        unreadNum.translatesAutoresizingMaskIntoConstraints = NO;
        unreadNum.font = FONTSYS(10);
        unreadNum.textAlignment = NSTextAlignmentLeft;
        unreadNum.textColor = self.unreadNumTitleColor;
        unreadNum.tag = 1000000;
        
        UIImageView *redPoint = [[UIImageView alloc] init];
        [button addSubview:redPoint];
        redPoint.image = self.redPointImage;
        redPoint.translatesAutoresizingMaskIntoConstraints = NO;
        [self.ivRedPoints addObject:redPoint];
        
        redPoint.hidden = YES;
        bgUnreadNum.hidden = YES;
        
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[redPoint(==7)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[redPoint(==7)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bgUnreadNum(>=16)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[bgUnreadNum(==16)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        
        
        [bgUnreadNum addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[unreadNum(>=0)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unreadNum)]];
        [bgUnreadNum addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[unreadNum(==16)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unreadNum)]];
        
        
        
        if (previousButton) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-btnMargin-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"btnMargin":@(self.btnMargin)}
                                                                                       views:NSDictionaryOfVariableBindings(previousButton, button)]];
            
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            
        } else {
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[button]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"btnMargin":@(self.btnMargin)} views:NSDictionaryOfVariableBindings(button)]];
            
        }
        
        previousButton = button;
        
        [self.buttons addObject:button];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button,previousButton)]];
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-20-|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(previousButton)]];
    
    
    
}



- (void)reloadDataByAutoWidthWithScroll {
    NSInteger totalButtons = self.items.count;
    UIButton *previousButton;

    for (NSInteger index = 0; index < totalButtons; index++) {
        NSString *buttonTitle = _items[index];
        
        UIButton *button = [self selectionListButtonWithTitle:buttonTitle];
        [self.contentView addSubview:button];
        
        GLView *bgUnreadNum = [[GLView alloc] init];
        bgUnreadNum.layer.cornerRadius = 8;
        bgUnreadNum.clipsToBounds = YES;
        bgUnreadNum.backgroundColor = UIColorFromRGB(0xC60A1E);
        bgUnreadNum.translatesAutoresizingMaskIntoConstraints = NO;
        [button addSubview:bgUnreadNum];
        [self.lbUnreadNums addObject:bgUnreadNum];
        
        GLLabel *unreadNum = [[GLLabel alloc] init];
        [bgUnreadNum addSubview:unreadNum];
        unreadNum.translatesAutoresizingMaskIntoConstraints = NO;
        unreadNum.font = FONTSYS(10);
        unreadNum.textAlignment = NSTextAlignmentLeft;
        unreadNum.textColor = self.unreadNumTitleColor;
        unreadNum.tag = 1000000;
        
        UIImageView *redPoint = [[UIImageView alloc] init];
        [button addSubview:redPoint];
        redPoint.image = self.redPointImage;
        redPoint.translatesAutoresizingMaskIntoConstraints = NO;
        [self.ivRedPoints addObject:redPoint];
        
        redPoint.hidden = YES;
        bgUnreadNum.hidden = YES;
        
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[redPoint(==7)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[redPoint(==7)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[bgUnreadNum(>=16)]-(-15)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        [button addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[bgUnreadNum(==16)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bgUnreadNum,redPoint)]];
        
        
        [bgUnreadNum addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[unreadNum(>=0)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unreadNum)]];
        [bgUnreadNum addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[unreadNum(==16)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(unreadNum)]];
        
        
        
        if (previousButton) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-mr-[button(>=10)]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"mr":@(10)}
                                                                                       views:NSDictionaryOfVariableBindings(previousButton, button)]];
        } else {
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[button(>=10)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(button)]];
            
            
        }
        
        previousButton = button;
        
        [self.buttons addObject:button];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button,previousButton)]];
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-20-|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(previousButton)]];
}

- (void)display {
    if (!self.buttons.count) {
        [self reloadData];
    }
}

- (void)layoutSubviews {
    [self display];
    [super layoutSubviews];
}

#pragma mark - Private Methods

- (UIButton *)selectionListButtonWithTitle:(NSString *)buttonTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = self.buttonInsets;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    
    for (NSNumber *controlState in [self.buttonColorsByState allKeys]) {
        [button setTitleColor:self.buttonColorsByState[controlState] forState:controlState.integerValue];
    }
    
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button sizeToFit];
    
    if (self.displayStyle == GLPageSwitchDisplayStyleButtonBorder) {
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 3.0;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.masksToBounds = YES;
    }
    
    [button addTarget:self
               action:@selector(buttonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, GLUIKIT_SCREEN_WIDTH/2, button.frame.size.height);
    return button;
}

- (void)setupSelectedButton:(UIButton *)selectedButton oldSelectedButton:(UIButton *)oldSelectedButton {
    switch (self.displayStyle) {
        case GLPageSwitchDisplayStyleBottomBar: {
            [self.contentView removeConstraint:self.leftSelectionIndicatorConstraint];
            [self.contentView removeConstraint:self.rightSelectionIndicatorConstraint];
            
            [self alignSelectionIndicatorWithButton:selectedButton];
            [self layoutIfNeeded];
            break;
        }
            
        case GLPageSwitchDisplayStyleButtonBorder: {
            selectedButton.layer.borderColor = self.selectionIndicatorColor.CGColor;
            oldSelectedButton.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        }
    }
}

- (void)alignSelectionIndicatorWithButton:(UIButton *)button {
    self.leftSelectionIndicatorConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicatorBar
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:0.0];
    [self.contentView addConstraint:self.leftSelectionIndicatorConstraint];
    
    self.rightSelectionIndicatorConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicatorBar
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:button
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:0.0];
    [self.contentView addConstraint:self.rightSelectionIndicatorConstraint];
}


/**
 *  @author smallsao, 16-01-12 12:01:32
 *
 *  @brief 切换至某个页面
 *
 *  @param page page
 */
- (void)switchToPage:(NSInteger)page {
    id sender = [self.buttons objectAtIndex:page];
    [self buttonWasTapped:sender];
}
#pragma mark - Action Handlers

- (void)buttonWasTapped:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    if (index != NSNotFound) {
        if (index == self.selectedButtonIndex) {
            return;
        }
        
        UIButton *oldSelectedButton = self.buttons[self.selectedButtonIndex];
        oldSelectedButton.selected = NO;
        self.selectedButtonIndex = index;
        
        UIButton *tappedButton = (UIButton *)sender;
        tappedButton.selected = YES;
        
        [self layoutIfNeeded];
        if (GL_SYSTEM_IOS6) {
            [UIView animateWithDuration:0.4
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 [self setupSelectedButton:tappedButton oldSelectedButton:oldSelectedButton];
                             }
                             completion:nil];
            
        }
        else{
            [self setupSelectedButton:tappedButton oldSelectedButton:oldSelectedButton];
        }
        
        [self.scrollView scrollRectToVisible:CGRectInset(tappedButton.frame, 0, 0)
                                    animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
            [self.delegate selectionList:self didSelectButtonWithIndex:index];
        }
    }
}


/**
 *  @author smallsao, 16-01-13 11:01:44
 *
 *  @brief 显示未读数
 *
 *  @param num  未读数
 *  @param page 页码
 */
- (void)showUnreadStatusWithNum:(NSInteger)num forPageIndex:(NSInteger)page {
    if (page < self.lbUnreadNums.count) {
        GLView *v = [self.lbUnreadNums objectAtIndex:page];
        GLLabel *lb = [v viewWithTag:1000000];
        UIImageView *iv = [self.ivRedPoints objectAtIndex:page];
        
        iv.hidden = YES;
        if (num > 99) {
            lb.text = [NSString stringWithFormat:@"99+"];
        }
        else {
            lb.text = [NSString stringWithFormat:@"%zd",num];
        }
        
        v.hidden = NO;
    }
}

/**
 *  @author smallsao, 16-01-13 11:01:11
 *
 *  @brief 显示红点
 *
 *  @param page 页码
 */
- (void)showUnreadStatusWithRedPointForPage:(NSInteger)page {
    if (page < self.lbUnreadNums.count) {
        GLView *v = [self.lbUnreadNums objectAtIndex:page];
        UIImageView *iv = [self.ivRedPoints objectAtIndex:page];
        iv.hidden = NO;
        v.hidden = YES;
    }
}

/**
 *  @author smallsao, 16-01-13 11:01:34
 *
 *  @brief 隐藏未读状态显示
 *
 *  @param page 页码
 */
- (void)hideUnreadStatusForPage:(NSInteger)page {
    if (page < self.lbUnreadNums.count) {
        GLView *v = [self.lbUnreadNums objectAtIndex:page];
        UIImageView *iv = [self.ivRedPoints objectAtIndex:page];
        iv.hidden = YES;
        v.hidden = YES;
    }
}
@end
