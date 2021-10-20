//
//  GLFormCell.m
//  GLUIKit
//
//  Created by Kevin on 15/10/10.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLFormCell.h"
#import "GLUIKitUtils.h"
#import "GLImageView.h"
#import "GLLabel.h"
#import "GLControl.h"
#import "GLSwitch.h"


@interface GLFormCell()

/// 右侧箭头ImageView
@property (nonatomic, strong) GLImageView *rightArrowIV;

/// 右侧滑块
@property (nonatomic, strong) GLSwitch *rightSwitch;

/// bottom line
@property (nonatomic, strong) GLView *bottomLine;

/// 覆盖在view上的点击层
@property (nonatomic, strong) GLControl *coverControl;

@end

/// 左侧留白
static const CGFloat kMarginLeft = 20;

/// 间隔
static const CGFloat kSpace = 10;


@implementation GLFormCell

- (instancetype)initWithFrame:(CGRect)frame cellType:(GLFormCellType)type
{
    _cellType = type;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // init title label
        _titleLabel                 = [[GLLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font            = [GLUIKitUtils transferToiOSFontSize:26];
        _titleLabel.textColor       = UIColorFromRGB(0x222222);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        
        CGFloat originX = GLUIKIT_SCREEN_WIDTH - kMarginLeft;
        
        if (GLFormCellTypeValue1 == _cellType) {  // 右侧箭头
            // GLUIKit_icon_right_arrow
            UIImage *arrowImage = [UIImage imageNamed:@"GLUIKit_icon_right_arrow"];
            //[UIImage imageNamed:@"WDIPh_icon_right_arrow"];
            CGSize arrowsize = CGSizeMake(floorf(arrowImage.size.width),
                                          floorf(arrowImage.size.height));
            originX -= arrowsize.width;
            
            _rightArrowIV = [[GLImageView alloc] initWithImage:arrowImage];
            _rightArrowIV.frame = CGRectMake(originX,
                                             (self.frame.size.height - arrowImage.size.height) / 2,
                                             arrowsize.width,
                                             arrowsize.height);
            [self addSubview:_rightArrowIV];
        }
        else if (GLFormCellTypeValue2 == _cellType) {  // 右侧滑块
            
            _rightSwitch = [[GLSwitch alloc] initWithFrame:CGRectZero];
            originX -= ceil(CGRectGetWidth(_rightSwitch.frame));
            
            _rightSwitch.frame = CGRectMake(originX,
                                            ceilf((self.frame.size.height - CGRectGetHeight(_rightSwitch.frame)) / 2),
                                            ceilf(CGRectGetWidth(_rightSwitch.frame)),
                                            ceilf(CGRectGetHeight(_rightSwitch.frame)));
            [_rightSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:_rightSwitch];
        }
        else if (GLFormCellTypeValue3 == _cellType) {
            
            // right arrow icon
            UIImage *arrowImage = [UIImage imageNamed:@"GLUIKit_icon_right_arrow"];
            // [UIImage imageNamed:@"WDIPh_icon_right_arrow"];
            CGSize arrowsize = CGSizeMake(floorf(arrowImage.size.width),
                                          floorf(arrowImage.size.height));
            originX -= arrowsize.width;
            
            _rightArrowIV = [[GLImageView alloc] initWithImage:arrowImage];
            _rightArrowIV.frame = CGRectMake(originX,
                                             (self.frame.size.height - arrowImage.size.height) / 2,
                                             arrowsize.width,
                                             arrowsize.height);
            [self addSubview:_rightArrowIV];
            
            // middle desc
            _middleDescLabel                 = [[GLLabel alloc] initWithFrame:CGRectZero];
            _middleDescLabel.font            = [GLUIKitUtils transferToiOSFontSize:24.0f];
            _middleDescLabel.textColor       = UIColorFromRGB(0x707070);
            _middleDescLabel.textAlignment   = NSTextAlignmentRight;
            _middleDescLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_middleDescLabel];
        }
        
        // click
        if (GLFormCellTypeValue2 != _cellType) {  // 有滑块的不需要点击
            
            _coverControl = [[GLControl alloc] initWithFrame:CGRectMake(0, 0, GLUIKIT_SCREEN_WIDTH, self.frame.size.height)];
            [_coverControl addTarget:self action:@selector(clickCover:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_coverControl];
        }
        
        // bottom line
        _bottomLine = [[GLView alloc] initWithFrame:CGRectMake(kMarginLeft,
                                                               self.frame.size.height - 0.5,
                                                               GLUIKIT_SCREEN_WIDTH - kMarginLeft * 2,
                                                               0.5)];
        _bottomLine.backgroundColor = GLUIKIT_COLOR_BG_DEFAULT;
        _bottomLine.hidden = YES;
        [self addSubview:_bottomLine];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}



//- (GLView *)toWithDrawCellWithFrame:(CGRect)rect
//{
//    GLView *waitCell                     = [[GLView alloc] initWithFrame:rect];
//    waitCell.tag                         = kGlFormCellTagWaitWithdraw;
//    waitCell.backgroundColor = [UIColor whiteColor];
//    [waitCell WDAddBorderWithStyle:WDBorderStyleTop];
//    [self.view addSubview:waitCell];
//    
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapToWithDrawCell:)];
//    recognizer.delegate = self;
//    [waitCell addGestureRecognizer:recognizer];
//    
//    GLLabel *label1                      = [[GLLabel alloc] initWithFrame:CGRectIntMake(kWDIncomeContentOffsetX, 16, 100, 22)];
//    label1.backgroundColor               = [UIColor clearColor];
//    label1.textColor                     = UIColorFromRGB(0X404040);
//    label1.font                          = [UIFont systemFontOfSize:16];
//    label1.text                          = @"待提现";
//    [waitCell addSubview:label1];
//    
//    GLLabel *label2                      = [[GLLabel alloc] initWithFrame:CGRectIntMake(kWDIncomeContentOffsetX, label1.maxY, 150, 20)];
//    label2.backgroundColor               = [UIColor clearColor];
//    label2.textColor                     = UIColorFromRGB(0X9A9A9A);
//    label2.font                          = [UIFont systemFontOfSize:14];
//    label2.text                          = @"进行中的交易";
//    [waitCell addSubview:label2];
//    
//    UIImage *image                       = GL_IMAGE(@"icon");
//    CGFloat accsoryViewX                 = waitCell.width - image.size.width - 10;
//    CGFloat moneyLabelX                  = MAX(label2.maxX, label1.maxX);
//    CGFloat moneyLabelWidth              = accsoryViewX - moneyLabelX;
//    
//    //待提现金额
//    NSString *toWithDrawMoney = self.listData[@"waiting_withdrawal"];
//#ifdef DEBUG
//    toWithDrawMoney = @"77723333333888.22";
//#endif
//    GLLabel *moneyLabel                  = [[GLLabel alloc] initWithFrame:CGRectIntMake(moneyLabelX, 20, moneyLabelWidth, 28)];
//    moneyLabel.backgroundColor           = [UIColor clearColor];
//    moneyLabel.textColor                 = UIColorFromRGB(0XC60A1E);
//    moneyLabel.font                      = [UIFont systemFontOfSize:20];
//    moneyLabel.adjustsFontSizeToFitWidth = YES;
//    moneyLabel.textAlignment             = NSTextAlignmentRight;
//    moneyLabel.text                      = toWithDrawMoney;
//    [waitCell addSubview:moneyLabel];
//    moneyLabel.center                    = CGPointMake(moneyLabel.center.x, waitCell.height / 2);
//    
//    UIImageView *imageView               = [[UIImageView alloc] initWithImage:image];
//    [waitCell addSubview:imageView];
//    imageView.center                     = CGPointMake(waitCell.width - imageView.width - 10, waitCell.height);
//    return waitCell;
//}
//



- (void)setIsShowBottomLine:(BOOL)isShowBottomLine
{
    self.bottomLine.hidden = !isShowBottomLine;
}


- (void)setBottomLineFrame:(CGRect)frame
{
    self.bottomLine.frame = frame;
}


- (CGFloat)setTitle:(NSString *)title
{
    CGRect tempRect = CGRectZero;
    CGFloat originX = kMarginLeft;
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    tempRect = _titleLabel.frame;
    _titleLabel.frame = CGRectMake(originX, 0, ceilf(tempRect.size.width), self.frame.size.height);
    
    originX += _titleLabel.frame.size.width + kSpace;
    
    return originX ;
}

- (void)setTitle:(NSString *)title middleDesc:(NSString *)descStr
{
    CGFloat originX = [self setTitle:title];
    
    CGFloat bounds = _rightArrowIV.frame.origin.x -kSpace;
    _middleDescLabel.frame = CGRectIntegral(CGRectMake(originX, 0, bounds - originX , kGLFormCellHeight));
    _middleDescLabel.text  = descStr;
}

- (void)setMiddleDescStrTextColor:(UIColor *)color
{
    self.middleDescLabel.textColor = color;
}

#pragma mark - Delegate
#pragma mark - 

- (void)switchChange:(GLSwitch *)changedSwitch
{
    if ([_delegate respondsToSelector:@selector(glFormCell:didSwitchValueChange:)]) {
        [_delegate glFormCell:self didSwitchValueChange:changedSwitch];
    }
}

- (void)clickCover:(GLControl *)control
{
    if ([_delegate respondsToSelector:@selector(glFormCell:didClick:)]) {
        [_delegate glFormCell:self didClick:control];
    }
}

@end
