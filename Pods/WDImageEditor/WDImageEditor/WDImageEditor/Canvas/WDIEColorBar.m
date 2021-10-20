//
//  WDIEColorBar.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEColorBar.h"
#import "WDIEUtils.h"

@interface WDIEColorBar ()

@property (nonatomic, copy) NSArray<UIButton *> *buttons;

// 记录当前被选择的按钮
@property (nonatomic, weak) UIButton *selectedButton;

// 记录标准的按钮宽度
@property (nonatomic, assign) CGFloat buttonWidth;

@end

@implementation WDIEColorBar

- (instancetype)init {
	NSArray *colors = @[
						[WDIEUtils wdie_colorFromRGB:0xFFFFFF],
						[WDIEUtils wdie_colorFromRGB:0x2B2B2B],
						[WDIEUtils wdie_colorFromRGB:0xFF1D12],
						[WDIEUtils wdie_colorFromRGB:0xFBF606],
						[WDIEUtils wdie_colorFromRGB:0x14E213],
						[WDIEUtils wdie_colorFromRGB:0x199BFF],
						[WDIEUtils wdie_colorFromRGB:0x8C06FF],
						[WDIEUtils wdie_colorFromRGB:0xF902FF]
						];
	return [self initWithColors:colors];
}

- (instancetype)initWithColors:(NSArray<UIColor *> *)colors {
	
	if (self = [super initWithFrame:CGRectZero]) {
		self.colors = colors;
		self.borderColor = UIColor.whiteColor;
		self.selectedIndex = 0;
	}
	
	return self;
}

#pragma mark - Getter & Setter

- (void)setColors:(NSArray<UIColor *> *)colors {
	[_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj removeFromSuperview];
	}];
	
	_colors = colors;
	_buttons = [self genButtons:colors];
	[self layoutIfNeeded];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	if (selectedIndex < _buttons.count) {
		UIButton *button = _buttons[selectedIndex];
		[self tappedOnButton:button];
	}
}

- (NSUInteger)selectedIndex {
	for (int i = 0; i < _buttons.count; i++) {
		if(_selectedButton == _buttons[i]) {
			return i;
		}
	}
	
	return 0;
}

- (void)setBorderColor:(UIColor *)borderColor {
	_borderColor = borderColor;
	for (UIButton *button in self.buttons) {
		button.layer.borderColor = [UIColor colorWithCGColor:borderColor.CGColor].CGColor;
	}
}

- (UIColor *)selectedColor {
	if(!self.colors) {
		return nil;
	}
	
	return [UIColor colorWithCGColor:self.colors[self.selectedIndex].CGColor];
}

#pragma mark - Layout

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// 按钮间的间距和按钮宽度相同
	CGFloat buttonWidth = self.bounds.size.width / (self.buttons.count * 2 - 1);
	if(buttonWidth > 24) {
		buttonWidth = 24;
	}
	self.buttonWidth = buttonWidth;
	CGPoint buttonCenter = CGPointMake(buttonWidth * 0.5, self.bounds.size.height * 0.5);
	for(UIButton *button in self.buttons) {
		
		if (button == self.selectedButton) {
			//如果是被选择的按钮 放大1.3倍
			button.frame = CGRectMake(0, 0, buttonWidth * 1.3, buttonWidth * 1.3);
		} else {
			button.frame = CGRectMake(0, 0, buttonWidth, buttonWidth);
		}
		
		button.center = buttonCenter;
		button.layer.cornerRadius = button.frame.size.width * 0.5;
		button.layer.borderWidth = button.frame.size.width  * 0.1;
		buttonCenter.x += buttonWidth * 2;
	}

}

#pragma mark - Private Helper

- (NSArray *)genButtons:(NSArray *)colors {
	
	NSMutableArray *arr = [NSMutableArray array];
	
	for(int i = 0; i < colors.count; i++) {
		UIColor *color = colors[i];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = i;
		[button setBackgroundColor:color];
		button.layer.masksToBounds = YES;
		button.layer.borderColor = self.borderColor.CGColor;
		[button addTarget:self action:@selector(tappedOnButton:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		[arr addObject:button];
	}
	
	return arr;
}

#pragma mark - User Interaction

- (void)tappedOnButton:(UIButton *)button {
	if (self.selectedButton == button) {
		return;
	}
	
	self.selectedButton = button;
	[self setNeedsLayout];
	
	if (_selectedColorBlock) {
		UIColor *color = [UIColor colorWithCGColor:button.backgroundColor.CGColor];
		_selectedColorBlock(color, button.tag);
	}
}

@end
