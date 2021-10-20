//
//  WDIETranslucentView.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/3/6.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIETranslucentView.h"

@interface WDIETranslucentView ()

@property (nonatomic, strong) CAGradientLayer *gradLayer;

@end

@implementation WDIETranslucentView

- (instancetype)initWithStartPoint:(CGPoint)startPoint andEndPoint:(CGPoint)endPoint {
	
	if (self = [super initWithFrame:CGRectZero]) {
		_gradLayer = [CAGradientLayer layer];
		NSArray *colors = [NSArray arrayWithObjects:
						   (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
						   (id)[[UIColor colorWithWhite:0 alpha:0.3] CGColor],
						   (id)[[UIColor colorWithWhite:0 alpha:0.5] CGColor],
						   (id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor],
						   (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
						   nil];
		[_gradLayer setColors:colors];
		[_gradLayer setStartPoint:startPoint];
		[_gradLayer setEndPoint:endPoint];
		
		[self.layer setMask:_gradLayer];
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[_gradLayer setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
}

@end
