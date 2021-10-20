//
//  WDIETextLabel.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/10.
//  Copyright © 2018年 weidian. All rights reserved.
//

#define kResizeThumbSize 45.0f

#import "WDIETextLabel.h"

@interface WDIETextLabel () {
	BOOL isResizingLR;
	BOOL isResizingUL;
	BOOL isResizingUR;
	BOOL isResizingLL;
	CGPoint touchStart;
	CGFloat lastRotation;
	CGPoint lastOrigin;
}

@property (nonatomic, assign, readonly) CGFloat radius;

@end

@implementation WDIETextLabel

#pragma mark - Getter & Setter

- (CGFloat)radius {
	return sqrtf(powf(self.bounds.size.width, 2) + powf(self.bounds.size.height, 2));
}

#pragma mark - Init

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.layer.borderWidth = 2.0;
		self.layer.borderColor = UIColor.whiteColor.CGColor;
		self.numberOfLines = 0;
		self.font = [UIFont systemFontOfSize:200];
		self.textAlignment = NSTextAlignmentLeft;
		self.adjustsFontSizeToFitWidth = YES;
		
		UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAction:)];
		[self addGestureRecognizer:rotateGesture];
	}
	
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	touchStart = [[touches anyObject] locationInView:self];
	isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
	isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
	isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
	isResizingLL = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touchPoint = [[touches anyObject] locationInView:self];
	CGPoint previous = [[touches anyObject] previousLocationInView:self];
	
	CGFloat deltaWidth = touchPoint.x - previous.x;
	CGFloat deltaHeight = touchPoint.y - previous.y;
	
	// get the frame values so we can calculate changes below
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y;
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
	
	if (isResizingLR) {
		self.frame = CGRectMake(x, y, touchPoint.x+deltaWidth, touchPoint.y+deltaWidth);
	} else if (isResizingUL) {
		self.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width-deltaWidth, height-deltaHeight);
	} else if (isResizingUR) {
		self.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
	} else if (isResizingLL) {
		self.frame = CGRectMake(x+deltaWidth, y, width-deltaWidth, height+deltaHeight);
	} else {
		// not dragging from a corner -- move the view
		self.center = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
								  self.center.y + touchPoint.y - touchStart.y);
	}
	
}

#pragma mark - UIRotationGesture Action

- (void)rotateAction:(UIRotationGestureRecognizer *)gesture {
	
	if (gesture.state == UIGestureRecognizerStateEnded){
		lastRotation = 0.0;
		return;
	}
	
	if (gesture.state == UIGestureRecognizerStateBegan) {
		lastOrigin = self.frame.origin;
	}
	
	CGFloat rotation = 0.0 - (lastRotation - gesture.rotation);
	CGFloat deltaX = self.radius * (1 - cosf(rotation));
	CGFloat deltaY = self.radius * sinf(rotation);
	CGRect rect = self.frame;
	rect.origin.x = lastOrigin.x + deltaX;
	rect.origin.y = lastOrigin.y + deltaY;
	self.frame = rect;
	NSLog(@"deltaX: %.2f, deltaY: %.2f", deltaX, deltaY);

//	CGFloat r = (self.bounds.size.width * self.bounds.size)
//	CGAffineTransform currentTransform = self.transform;
//	CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
//	self.transform = newTransform;
//	lastRotation = gesture.rotation;
}


@end
