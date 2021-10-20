//
//  GLAbilityView.m
//  GLUIKit_Trunk
//
//  Created by xiaofengzheng on 27/03/2017.
//  Copyright © 2017 无线生活（北京）信息技术有限公司. All rights reserved.
//

#define kLeftMargin             20
#define kRightMargin            15
#define kWithRightSwitch        51
#define kHeightRightSwitch      31
#define kSpace                  10
#define kBorderDot              8


#import "GLAbilityView.h"
#import "GLUIKitUtils.h"
#import "GLColorConstants.h"
#import "GLFontConstants.h"

@interface GLAbilityView ()




@end



@implementation GLAbilityView

+ (CGFloat)viewHeight
{
    return 52;
}

- (id)initWithStyle:(GLAbilityViewStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        BOOL actionFlag = YES;
        BOOL arrowFlag = NO;
        switch (style) {
            case GLAbilityViewStyleTitle: {
                
                break;
            }
            case GLAbilityViewStyleTitleArrow: {
                arrowFlag = YES;
                break;
            }
            case GLAbilityViewStyleTitleDescriptionArrow: {
                arrowFlag = YES;
                [self setupDescriptionLabel];
                break;
            }
            case GLAbilityViewStyleTitleSwitch: {
                actionFlag = NO;
                [self setupRightSwitch];
                break;
            }
                
            default:
                break;
        }
        [self setupTitleLabel];
        [self setupBottomLineView];
        if (actionFlag) {
            [self setupActionControl];
        }
        if (arrowFlag) {
            [self setupRightArrowImageView];
        }
        self.backgroundColor = GLUC_White;
    }
    return self;
}

- (void)setupTitleLabel
{
    // init title label
    if (!self.titleLabel) {
        self.titleLabel                 = [[GLLabel alloc] init];
        self.titleLabel.font            = GLFS_Px_32;
        self.titleLabel.textColor       = GLTC_Black_222222;
        self.titleLabel.backgroundColor = GLUC_Clear;
        [self addSubview:self.titleLabel];
    }
}

- (void)setupDescriptionLabel
{
    if (!self.descriptionLabel) {
        self.descriptionLabel                 = [[GLLabel alloc] init];
        self.descriptionLabel.font            = GLFS_Px_28;
        self.descriptionLabel.textColor       = GLTC_Gray_9A9A9A;
        self.descriptionLabel.backgroundColor = GLUC_Clear;
        self.descriptionLabel.textAlignment   = NSTextAlignmentRight;
        [self addSubview:self.descriptionLabel];
    }
}


- (void)setupBottomLineView
{
    if (!self.bottomLineView) {
        self.bottomLineView = [[GLView alloc] init];
        self.bottomLineView.backgroundColor = GLUC_Line;
        [self addSubview:self.bottomLineView];
    }
}


- (void)setupActionControl
{
    if (!self.actionControl) {
        self.actionControl = [[GLControl alloc] init];
        self.actionControl.backgroundColor = GLUC_Clear;
        [self.actionControl addTarget:self action:@selector(actionControlAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.actionControl];
    }
}


- (void)setupRightArrowImageView
{
    if (!self.rightArrowImageView) {
        self.rightArrowImageView = [[GLImageView alloc] init];
        self.rightArrowImageView.image = [UIImage imageNamed:@"GLUIKit_icon_right_arrow"];
        [self addSubview:self.rightArrowImageView];
    }
}

- (void)setupRightSwitch
{
    if (!self.rightSwitch) {
        self.rightSwitch = [[GLSwitch alloc] init];
        [self addSubview:self.rightSwitch];
    }
}

- (void)setupDotLeftView
{
    if (!self.dotLeftView) {
        self.dotLeftView = [[GLView alloc] init];
        self.dotLeftView.backgroundColor = GLUC_Dot;
        [self addSubview:self.dotLeftView];
    }
}

- (void)setupDotRightView
{
    if (!self.dotRightView) {
        self.dotRightView = [[GLView alloc] init];
        self.dotRightView.backgroundColor = GLUC_Dot;
        [self addSubview:self.dotRightView];
    }
}


-(void)actionControlAction:(id)sender
{
    if (self.clickHandlerBlock) {
#ifdef DEBUG
        NSLog(@"%@ click:",self);
#endif
        self.clickHandlerBlock();
    }
}


- (void)setHideLineFlag:(BOOL)hideLineFlag
{
    if (_hideLineFlag != hideLineFlag) {
        _hideLineFlag = hideLineFlag;
    }
    self.bottomLineView.hidden = self.hideLineFlag;
}

- (void)setFullLineFlag:(BOOL)fullLineFlag
{
    if (_fullLineFlag != fullLineFlag) {
        _fullLineFlag = fullLineFlag;
    }
    [self glCustomLayoutFrame:self.frame];
}

- (void)setShowTitleDotLeft:(BOOL)showTitleDotLeft
{
    if (_showTitleDotLeft != showTitleDotLeft) {
        _showTitleDotLeft = showTitleDotLeft;
    }
    [self setupDotLeftView];
    [self glCustomLayoutFrame:self.frame];
}

- (void)setShowTitleDotRight:(BOOL)showTitleDotRight
{
    if (_showTitleDotRight != showTitleDotRight) {
        _showTitleDotRight = showTitleDotRight;
    }
    [self setupDotRightView];
    [self glCustomLayoutFrame:self.frame];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    
    [self glCustomLayoutFrame:self.frame];
}

- (void)setDescription:(NSString *)desStr
{
    if (self.descriptionLabel) {
        self.descriptionLabel.text = desStr;
    }
    [self glCustomLayoutFrame:self.frame];
}

- (void)setTitle:(NSString *)title description:(NSString *)desStr
{
    self.titleLabel.text = title;
    self.descriptionLabel.text = desStr;
    
    [self glCustomLayoutFrame:self.frame];
}

- (void)glCustomLayoutFrame:(CGRect)frame
{
    [super glCustomLayoutFrame:frame];
    [self.titleLabel sizeToFit];
    
    // titleLabel
    self.titleLabel.frame = CGRectMake(kLeftMargin, 0, self.titleLabel.width, self.height);
    
    // dotLeftView
    self.dotLeftView.layer.cornerRadius = kBorderDot/2;
    self.dotLeftView.frame = CGRectMake((kLeftMargin - kBorderDot)/2, (self.height - kBorderDot)/2, kBorderDot, kBorderDot);
    self.dotLeftView.hidden = !self.showTitleDotLeft;
    
    // dotRightView
    self.dotRightView.layer.cornerRadius = kBorderDot/2;
    self.dotRightView.frame = CGRectMake(self.titleLabel.maxX + 6, (self.height - kBorderDot)/2, kBorderDot, kBorderDot);
    self.dotRightView.hidden = !self.showTitleDotRight;
    
    // arrowImageView
    CGFloat w = self.rightArrowImageView.image.size.width;
    CGFloat h = self.rightArrowImageView.image.size.height;
    self.rightArrowImageView.frame = CGRectMake(self.width - kRightMargin - w, (self.height - h)/2, w, h);
    // descriptionLabel
    CGFloat x = self.titleLabel.maxX + kSpace;
    self.descriptionLabel.frame = CGRectMake(x, 0, self.width - x - kSpace - (self.width - self.rightArrowImageView.x), self.height);
    
    if (self.fullLineFlag) {
        self.bottomLineView.frame = CGRectMake(0, self.height - GL_HEIGHT_LINE, self.width, GL_HEIGHT_LINE);
    } else {
        self.bottomLineView.frame = CGRectMake(kLeftMargin, self.height - GL_HEIGHT_LINE, self.width - kLeftMargin, GL_HEIGHT_LINE);
    }
    self.actionControl.frame = CGRectMake(0, 0, self.width, self.height);
    self.rightSwitch.frame = CGRectMake(self.width - kRightMargin - kWithRightSwitch, (self.height - kHeightRightSwitch)/2, kWithRightSwitch, kHeightRightSwitch);
    
    
    
    
}

@end
