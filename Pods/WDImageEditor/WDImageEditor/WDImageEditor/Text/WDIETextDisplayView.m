//
//  WDIETextDisplayView.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/8.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIETextDisplayView.h"
#import "WDIETextOverlayView.h"
#import "WDIEUtils.h"

#define kWDIETextMaxScale    	  5
#define kWDIETextActiveDuration   2

@interface WDIETextDisplayView () {
	CGFloat lastRotation;
	CGFloat previousScale;
	CGFloat beginX;
	CGFloat beginY;
	CGFloat totalScale;
}

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) WDIETextOverlayView *overlayView;

@property (nonatomic, assign) CGSize textSize;

@property (nonatomic, strong) NSTimer *inactiveTimer;

@end

@implementation WDIETextDisplayView

#pragma mark - Getter & Setter

- (NSString *)text {
	return self.label.text;
}

- (void)setText:(NSString *)text {
	self.label.text = text;
	[self updateFrame];
}

- (UIFont *)font {
	return self.label.font;
}

- (void)setFont:(UIFont *)font {
	self.label.font = font;
	[self updateFrame];
}

- (void)setPreferredTextWidth:(CGFloat)preferredTextWidth {
	_preferredTextWidth = preferredTextWidth;
	[self updateFrame];
}

- (void)setAnchor:(CGPoint)anchor {
	_anchor = anchor;
	[self updateFrame];
}

- (UIColor *)textColor {
	return self.label.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
	self.label.textColor = textColor;
}

- (void)setBorderHidden:(BOOL)borderHidden {
	self.overlayView.hidden = borderHidden;
}

- (BOOL)borderHidden {
	return self.overlayView.isHidden;
}

#pragma mark - Init

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		lastRotation = 0;
		previousScale = 1;
		beginX = 0;
		beginY = 0;
		totalScale = 1;
		
		_preferredTextWidth = UIScreen.mainScreen.bounds.size.width;
		
		[self setup];
	}
	
	return self;
}

- (void)setup
{
	self.userInteractionEnabled = YES;
	
	UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAction:)];
	[self addGestureRecognizer:rotationGesture];
	
	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAction:)];
	[self addGestureRecognizer:pinchGesture];
	
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
	panGesture.minimumNumberOfTouches = 1;
	panGesture.maximumNumberOfTouches = 1;
	[self addGestureRecognizer:panGesture];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
	[self addGestureRecognizer:tapGesture];
	
	_label = [[UILabel alloc] init];
	_label.textAlignment = NSTextAlignmentLeft;
	_label.font = [UIFont systemFontOfSize:32];
	_label.adjustsFontSizeToFitWidth = YES;
	_label.numberOfLines = 0;
	[self addSubview:_label];
	
	_overlayView = [[WDIETextOverlayView alloc] init];
	[self addSubview:_overlayView];
	
	[self startInactiveTimer];
}

#pragma mark - Helper

- (void)startInactiveTimer {
	
	[self cancelInactiveTimer];
	
	self.inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:kWDIETextActiveDuration target:self selector:@selector(activeTimerAction) userInfo:nil repeats:NO];
}

- (void)cancelInactiveTimer {
	if(self.inactiveTimer) {
		[self.inactiveTimer invalidate];
		self.inactiveTimer = nil;
	}
}

- (void)activeTimerAction {
	self.borderHidden = YES;
}

- (void)notifyBecomeActive {
	if(_delegate && [_delegate respondsToSelector:@selector(textDisplayViewDidBecomeActive:)]) {
		[_delegate textDisplayViewDidBecomeActive:self];
	}
}

- (void)updateFrame {
	
	self.textSize = [WDIEUtils wdie_sizeWithText:self.text font:self.font constrainedToSize:CGSizeMake(self.preferredTextWidth + 20, 0)];

	self.frame = CGRectMake(self.anchor.x - (self.textSize.width + 88) / 2, self.anchor.y - (self.textSize.height + 44) / 2, self.textSize.width + 88, self.textSize.height + 44);
	
	self.label.frame = CGRectMake((CGRectGetWidth(self.frame) - self.textSize.width) / 2, (CGRectGetHeight(self.frame) - self.textSize.height) / 2, self.textSize.width, self.textSize.height);
	
	self.overlayView.frame = CGRectMake(self.label.frame.origin.x - 8, self.label.frame.origin.y - 4, CGRectGetWidth(self.label.frame) + 16, CGRectGetHeight(self.label.frame) + 8);
	
	[self.superview setNeedsLayout];
}

#pragma mark - Gesture Action

- (void)rotateAction:(UIRotationGestureRecognizer *)gesture
{
	if(gesture.state == UIGestureRecognizerStateEnded) {
		lastRotation = 0;
		self.superview.clipsToBounds = YES;
		[self startInactiveTimer];
		return;
	}
	
	if(gesture.state == UIGestureRecognizerStateBegan) {
		[self cancelInactiveTimer];
		[self notifyBecomeActive];
	}
	
	CGFloat rotation = 0.0 - (lastRotation - gesture.rotation);
	CGAffineTransform currentTransform = self.transform;
	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
	self.transform = newTransform;
	lastRotation = gesture.rotation;
	
	self.superview.clipsToBounds = NO;
	self.borderHidden = NO;
}

- (void)scaleAction:(UIPinchGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateEnded) {
		previousScale = 1.0;
		self.superview.clipsToBounds = YES;
		[self startInactiveTimer];
		return;
	}
	
	if(gesture.state == UIGestureRecognizerStateBegan) {
		[self cancelInactiveTimer];
		[self notifyBecomeActive];
	}
	
	CGFloat newScale = 1.0 - (previousScale - gesture.scale);
	totalScale *= newScale;
	if(totalScale > kWDIETextMaxScale) {
		totalScale = kWDIETextMaxScale;
		return;
	}
	
	CGAffineTransform currentTransform = self.transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
	self.transform = newTransform;
	previousScale = gesture.scale;
	
	self.superview.clipsToBounds = NO;
	self.borderHidden = NO;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
	CGPoint newCenter = [gesture translationInView:self.superview];
	if(gesture.state == UIGestureRecognizerStateBegan) {
		beginX = self.center.x;
		beginY = self.center.y;
		self.borderHidden = NO;
		
		[self cancelInactiveTimer];
		[self notifyBecomeActive];
	}
	
	newCenter = CGPointMake(beginX + newCenter.x, beginY + newCenter.y);
	self.center = newCenter;
	
	self.superview.clipsToBounds = gesture.state == UIGestureRecognizerStateEnded ? YES : NO;
	
	if(gesture.state == UIGestureRecognizerStateEnded) {
		
		[self startInactiveTimer];
		
		if(self.delegate && [self.delegate respondsToSelector:@selector(textDisplayViewDidEndMove:)]) {
			[self.delegate textDisplayViewDidEndMove:self];
		}
	}
	else {
		if(self.delegate && [self.delegate respondsToSelector:@selector(textDisplayViewMoved:)]) {
			[self.delegate textDisplayViewMoved:self];
		}
	}
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
	if(_delegate && [_delegate respondsToSelector:@selector(textDisplayViewTaped:)]) {
		[_delegate textDisplayViewTaped:self];
	}
	
	[self startInactiveTimer];
	
	[self notifyBecomeActive];
}

@end
