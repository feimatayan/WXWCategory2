//
//  GLDropDownMenu.m
//  GLUIKit
//
//  Created by Kevin on 15/10/19.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLDropDownMenu.h"
#import "GLUIKitUtils.h"
#import "NSString+GLString.h"



const CGFloat kStartTag = 100;


@interface GLDropDownMenu()

/// 背景图Image View
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end


@implementation GLDropDownMenu

- (instancetype)initWithTitleItems:(NSArray *)titleItems type:(GLDropDownMenuType)type
{
    _type = type;
    
    _paddingTop   = 5;
    _itemHeight   = 40;
    _marginLeft   = 20;
    _paddingRight = 10;
    
    return [self initWithTitleItems:titleItems];
}

- (instancetype)initWithTitleItems:(NSArray *)titleItems
{
    if (self = [super init]) {
        
        UIFont *defaultFont = [GLUIKitUtils transferToiOSFontSize:28.0f];
        
        NSString *maxString = nil;
        
        for (NSArray *item in titleItems) {
        
            NSString *str = [item lastObject];
            
            if (str.length > maxString.length) {
                maxString = str;
            }
        }
       
        //最长文字长度
        CGSize maxStringSize = [maxString glSizeWithFont:defaultFont];
        
        //行宽度
        CGFloat itemWidth = 0;
      
        //icon宽度
        CGFloat iconWidth = 0;
       
        if (_type == GLDropDownMenuTypeValue2) {
            
            iconWidth = [UIImage imageNamed:[((NSArray *)titleItems[0]) firstObject]].size.width;
            itemWidth = _marginLeft + iconWidth + 10 + maxStringSize.width + _marginLeft;
        }
        else{
            
            itemWidth = _marginLeft + maxStringSize.width + _marginLeft;
        }
        
        CGFloat offsetY = 3 + _paddingTop;
        
        for (int i = 0; i < titleItems.count; i++) {
            
            NSArray *item = titleItems[i];
            
            if (i != 0) {
                
                CGRect rect = CGRectZero;
                
                if (_type == GLDropDownMenuTypeValue2) {
                
                    rect = CGRectMake(_marginLeft + iconWidth + 15,
                                      offsetY,
                                      itemWidth - _marginLeft - iconWidth - 15,
                                      0.5);
                }
                else {
                    rect = CGRectMake(_marginLeft, offsetY, itemWidth - _marginLeft, 0.5);
                }
                
                UIView *line = [[UIView alloc] initWithFrame:rect];
                line.backgroundColor = UIColorFromRGB(0xbcbcbc);
                [self addSubview:line];
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = kStartTag + i;

            if (_type == GLDropDownMenuTypeValue2) {
                
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
                [btn setImage:[UIImage imageNamed:item[0]] forState:UIControlStateNormal];
            }
            
            [btn setTitle:[item lastObject] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
            btn.titleLabel.font = defaultFont;
            [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, offsetY, itemWidth, _itemHeight);
            [self addSubview:btn];
            
            offsetY += _itemHeight;
        }
        
        offsetY += _paddingTop;
        
        // 背景imageview
        UIImage *originalBackImage = [UIImage imageNamed:@"GLUIKit_im_b2b_bgimg"];
        UIImage *expandImage = [originalBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 10, 10, 70)];
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, offsetY)];
        _backgroundImageView.image = expandImage;
        UIView *av = [self viewWithTag:kStartTag];
        [self insertSubview:_backgroundImageView belowSubview:av];
        
        ////////
        self.frame = CGRectMake(0, -offsetY - 40, itemWidth, offsetY);
    }
    
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"Do not call this method directly");
    return nil;
}

#pragma mark - Private
#pragma mark -

- (void)clickItem:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(glDropDownMenu:didSelectItemIndex:)]) {
        [self.delegate glDropDownMenu:self didSelectItemIndex:(sender.tag - kStartTag)];
    }
}

#pragma mark - Public
#pragma mark - 

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImageView.image = backgroundImage;
}


@end
