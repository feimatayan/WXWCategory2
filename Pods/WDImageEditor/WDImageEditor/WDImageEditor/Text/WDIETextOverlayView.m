//
//  WDIETextOverlayView.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIETextOverlayView.h"
#import <Masonry/Masonry.h>

#define kWDIETextBorderWidth 1
#define kWDIETextCornerWidth 5

@interface WDIETextOverlayView ()

@property (nonatomic, strong, readwrite) UIView *leftTopView;

@property (nonatomic, strong, readwrite) UIView *leftBottomView;

@property (nonatomic, strong, readwrite) UIView *rightTopView;

@property (nonatomic, strong, readwrite) UIView *rightBottomView;

@end

@implementation WDIETextOverlayView

#pragma mark - Getter

- (UIView *)leftTopView {
	if (!_leftTopView) {
		_leftTopView = [[UIView alloc] init];
		_leftTopView.backgroundColor = UIColor.whiteColor;
	}
	
	return _leftTopView;
}

- (UIView *)leftBottomView {
	if (!_leftBottomView) {
		_leftBottomView = [[UIView alloc] init];
		_leftBottomView.backgroundColor = UIColor.whiteColor;
	}
	
	return _leftBottomView;
}

- (UIView *)rightTopView {
	if (!_rightTopView) {
		_rightTopView = [[UIView alloc] init];
		_rightTopView.backgroundColor = UIColor.whiteColor;
	}
	
	return _rightTopView;
}

- (UIView *)rightBottomView {
	if (!_rightBottomView) {
		_rightBottomView = [[UIView alloc] init];
		_rightBottomView.backgroundColor = UIColor.whiteColor;
	}
	
	return _rightBottomView;
}

#pragma mark - Init

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		self.layer.borderWidth = kWDIETextBorderWidth;
		self.layer.borderColor = UIColor.whiteColor.CGColor;
		self.layer.shadowOpacity = 0.8;
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeZero;
		
		[self addSubview:self.leftTopView];
		[self addSubview:self.rightTopView];
		[self addSubview:self.leftBottomView];
		[self addSubview:self.rightBottomView];
		
		[self makeConstraints];
	}
	
	return self;
}

- (void)makeConstraints {
	
	CGFloat padding = kWDIETextBorderWidth;
	
	[self.leftTopView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.mas_left).offset(padding);
		make.centerY.equalTo(self.mas_top).offset(padding);
		make.width.height.equalTo(@kWDIETextCornerWidth);
	}];
	
	[self.leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.mas_left).offset(padding);
		make.centerY.equalTo(self.mas_bottom).offset(-padding);
		make.width.height.equalTo(@kWDIETextCornerWidth);
	}];
	
	[self.rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.mas_right).offset(-padding);
		make.centerY.equalTo(self.mas_bottom).offset(-padding);
		make.width.height.equalTo(@kWDIETextCornerWidth);
	}];
	
	[self.rightTopView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.mas_right).offset(-padding);
		make.centerY.equalTo(self.mas_top).offset(padding);
		make.width.height.equalTo(@kWDIETextCornerWidth);
	}];
}

@end
