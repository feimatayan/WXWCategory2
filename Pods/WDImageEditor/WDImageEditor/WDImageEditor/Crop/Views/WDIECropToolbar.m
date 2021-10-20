//
//  WDIECropToolbar.h
//
//  Copyright 2015-2018 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "WDIECropToolbar.h"

#define WDIECROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT     0   // convenience debug toggle

@interface WDIECropToolbar()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong, readwrite) UIButton *doneIconButton;
@property (nonatomic, strong, readwrite) UIButton *cancelIconButton;

@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *clampButton;

@property (nonatomic, strong) UIButton *rotateButton; // defaults to counterclockwise button for legacy compatibility

@property (nonatomic, assign) BOOL reverseContentLayout; // For languages like Arabic where they natively present content flipped from English

@end

@implementation WDIECropToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setup];
	}
	
	return self;
}

- (void)setup {
	self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
	self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.12f alpha:1.0f];
	[self addSubview:self.backgroundView];
	
	// On iOS 9, we can use the new layout features to determine whether we're in an 'Arabic' style language mode
	if (@available(iOS 9.0, *)) {
		self.reverseContentLayout = ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft);
	}
	else {
		self.reverseContentLayout = [[[NSLocale preferredLanguages] objectAtIndex:0] hasPrefix:@"ar"];
	}
	
	_doneIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_doneIconButton setImage:[WDIECropToolbar doneImage] forState:UIControlStateNormal];
	[_doneIconButton setImage:[UIImage imageNamed:@"WDIE_Rotate_Finish"] forState:UIControlStateNormal];
	[_doneIconButton setImage:[UIImage imageNamed:@"WDIE_Rotate_Finish_Highlighted"] forState:UIControlStateHighlighted];
	[_doneIconButton setImage:[UIImage imageNamed:@"WDIE_Rotate_Finish_Highlighted"] forState:UIControlStateSelected];
	[_doneIconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_doneIconButton];
	
	_cancelIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cancelIconButton setImage:[UIImage imageNamed:@"WDIE_Crop_Close"] forState:UIControlStateNormal];
	[_cancelIconButton setImage:[UIImage imageNamed:@"WDIE_Crop_Close_Highlighed"] forState:UIControlStateHighlighted];
	[_cancelIconButton setImage:[UIImage imageNamed:@"WDIE_Crop_Close_Highlighed"] forState:UIControlStateSelected];
	[_cancelIconButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_cancelIconButton];
	
	_clampButton = [UIButton buttonWithType:UIButtonTypeSystem];
	_clampButton.contentMode = UIViewContentModeCenter;
	_clampButton.tintColor = [UIColor whiteColor];
	[_clampButton setImage:[WDIECropToolbar clampImage] forState:UIControlStateNormal];
	[_clampButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_clampButton];
	
	_rotateCounterclockwiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_rotateCounterclockwiseButton setImage:[UIImage imageNamed:@"WDIE_Crop_Rotate"] forState:UIControlStateNormal];
	[_rotateCounterclockwiseButton setImage:[UIImage imageNamed:@"WDIE_Crop_Rotate_Highlighted"] forState:UIControlStateHighlighted];
	[_rotateCounterclockwiseButton setImage:[UIImage imageNamed:@"WDIE_Crop_Rotate_Highlighted"] forState:UIControlStateSelected];
	[_rotateCounterclockwiseButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_rotateCounterclockwiseButton];
	
	_rotateClockwiseButton = [UIButton buttonWithType:UIButtonTypeSystem];
	_rotateClockwiseButton.contentMode = UIViewContentModeCenter;
	_rotateClockwiseButton.tintColor = [UIColor whiteColor];
	[_rotateClockwiseButton setImage:[WDIECropToolbar rotateCWImage] forState:UIControlStateNormal];
	[_rotateClockwiseButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_rotateClockwiseButton];
	
	_resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
	_resetButton.contentMode = UIViewContentModeCenter;
	_resetButton.tintColor = [UIColor whiteColor];
	_resetButton.enabled = NO;
	[_resetButton setImage:[WDIECropToolbar resetImage] forState:UIControlStateNormal];
	[_resetButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_resetButton];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGSize boundsSize = self.bounds.size;
	
	CGRect backgroundViewFrame = self.bounds;
	backgroundViewFrame.origin.x -= self.backgroundViewOutsets.left;
	backgroundViewFrame.size.width += self.backgroundViewOutsets.left;
	backgroundViewFrame.size.width += self.backgroundViewOutsets.right;
	backgroundViewFrame.origin.y -= self.backgroundViewOutsets.top;
	backgroundViewFrame.size.height += self.backgroundViewOutsets.top;
	backgroundViewFrame.size.height += self.backgroundViewOutsets.bottom;
	self.backgroundView.frame = backgroundViewFrame;
	
#if TOCROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT
	static UIView *containerView = nil;
	if (!containerView) {
		containerView = [[UIView alloc] initWithFrame:CGRectZero];
		containerView.backgroundColor = [UIColor redColor];
		containerView.alpha = 0.1;
		[self addSubview:containerView];
	}
#endif
	
	CGFloat insetPadding = 10.0f;
	
	// Work out the cancel button frame
	CGRect frame = CGRectZero;
	frame.size.height = 44.0f;
	frame.size.width = 44.0f;
	
	//If normal layout, place on the left side, else place on the right
	if (self.reverseContentLayout == NO) {
		frame.origin.x = insetPadding;
	}
	else {
		frame.origin.x = boundsSize.width - (frame.size.width + insetPadding);
	}
	self.cancelIconButton.frame = frame;
	
	// Work out the Done button frame
	frame.size.width = 44.0f;
	
	if (self.reverseContentLayout == NO) {
		frame.origin.x = boundsSize.width - (frame.size.width + insetPadding);
	}
	else {
		frame.origin.x = insetPadding;
	}
	self.doneIconButton.frame = frame;
	
	// Work out the frame between the two buttons where we can layout our action buttons
	CGFloat x = self.reverseContentLayout ? CGRectGetMaxX(self.doneIconButton.frame) : CGRectGetMaxX(self.cancelIconButton.frame);
	CGFloat width = 0.0f;
	
	if (self.reverseContentLayout == NO) {
		width = CGRectGetMinX(self.doneIconButton.frame) - CGRectGetMaxX(self.cancelIconButton.frame);
	}
	else {
		width = CGRectGetMinX(self.cancelIconButton.frame) - CGRectGetMaxX(self.doneIconButton.frame);
	}
	
	CGRect containerRect = CGRectIntegral((CGRect){x,frame.origin.y,width,44.0f});
	
#if TOCROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT
	containerView.frame = containerRect;
#endif
	
	CGSize buttonSize = (CGSize){44.0f,44.0f};
	
	NSMutableArray *buttonsInOrderHorizontally = [NSMutableArray new];
	
	if (!self.rotateCounterclockwiseButtonHidden) {
		[buttonsInOrderHorizontally addObject:self.rotateCounterclockwiseButton];
	}
	
	if(!self.resetButtonHidden) {
		[buttonsInOrderHorizontally addObject:self.resetButton];
	}
	
	if (!self.clampButtonHidden) {
		[buttonsInOrderHorizontally addObject:self.clampButton];
	}
	
	if (!self.rotateClockwiseButtonHidden) {
		[buttonsInOrderHorizontally addObject:self.rotateClockwiseButton];
	}

	[self layoutToolbarButtons:buttonsInOrderHorizontally withSameButtonSize:buttonSize inContainerRect:containerRect horizontally:YES];
}

// The convenience method for calculating button's frame inside of the container rect
- (void)layoutToolbarButtons:(NSArray *)buttons withSameButtonSize:(CGSize)size inContainerRect:(CGRect)containerRect horizontally:(BOOL)horizontally
{
	NSInteger count = buttons.count;
	CGFloat fixedSize = horizontally ? size.width : size.height;
	CGFloat maxLength = horizontally ? CGRectGetWidth(containerRect) : CGRectGetHeight(containerRect);
	CGFloat padding = (maxLength - fixedSize * count) / (count + 1);
	
	for (NSInteger i = 0; i < count; i++) {
		UIView *button = buttons[i];
		CGFloat sameOffset = horizontally ? fabs(CGRectGetHeight(containerRect)-CGRectGetHeight(button.bounds)) : fabs(CGRectGetWidth(containerRect)-CGRectGetWidth(button.bounds));
		CGFloat diffOffset = padding + i * (fixedSize + padding);
		CGPoint origin = horizontally ? CGPointMake(diffOffset, sameOffset) : CGPointMake(sameOffset, diffOffset);
		if (horizontally) {
			origin.x += CGRectGetMinX(containerRect);
		} else {
			origin.y += CGRectGetMinY(containerRect);
		}
		button.frame = (CGRect){origin, size};
	}
}

- (void)buttonTapped:(id)button
{
	if (button == self.cancelIconButton) {
		if (self.cancelButtonTapped)
			self.cancelButtonTapped();
	}
	else if (button == self.doneIconButton) {
		if (self.doneButtonTapped)
			self.doneButtonTapped();
	}
	else if (button == self.resetButton && self.resetButtonTapped) {
		self.resetButtonTapped();
	}
	else if (button == self.rotateCounterclockwiseButton && self.rotateCounterclockwiseButtonTapped) {
		self.rotateCounterclockwiseButtonTapped();
	}
	else if (button == self.rotateClockwiseButton && self.rotateClockwiseButtonTapped) {
		self.rotateClockwiseButtonTapped();
	}
	else if (button == self.clampButton && self.clampButtonTapped) {
		self.clampButtonTapped();
		return;
	}
}

- (CGRect)clampButtonFrame
{
	return self.clampButton.frame;
}

- (void)setClampButtonHidden:(BOOL)clampButtonHidden {
	if (_clampButtonHidden == clampButtonHidden)
		return;
	
	_clampButtonHidden = clampButtonHidden;
	[self setNeedsLayout];
}

- (void)setResetButtonHidden:(BOOL)resetButtonHidden {
	if (_resetButtonHidden == resetButtonHidden) {
		return;
	}
	
	_resetButtonHidden = resetButtonHidden;
	[self setNeedsLayout];
}

- (void)setClampButtonGlowing:(BOOL)clampButtonGlowing
{
	if (_clampButtonGlowing == clampButtonGlowing)
		return;
	
	_clampButtonGlowing = clampButtonGlowing;
	
	if (_clampButtonGlowing)
		self.clampButton.tintColor = nil;
	else
		self.clampButton.tintColor = [UIColor whiteColor];
}

- (void)setRotateCounterClockwiseButtonHidden:(BOOL)rotateButtonHidden
{
	if (_rotateCounterclockwiseButtonHidden == rotateButtonHidden)
		return;
	
	_rotateCounterclockwiseButtonHidden = rotateButtonHidden;
	[self setNeedsLayout];
}

- (BOOL)resetButtonEnabled
{
	return self.resetButton.enabled;
}

- (void)setResetButtonEnabled:(BOOL)resetButtonEnabled
{
	self.resetButton.enabled = resetButtonEnabled;
}

- (CGRect)doneButtonFrame
{
	return self.doneIconButton.frame;
}

#pragma mark - Image Generation -
+ (UIImage *)doneImage
{
	UIImage *doneImage = nil;
	
	UIGraphicsBeginImageContextWithOptions((CGSize){17,14}, NO, 0.0f);
	{
		//// Rectangle Drawing
		UIBezierPath* rectanglePath = UIBezierPath.bezierPath;
		[rectanglePath moveToPoint: CGPointMake(1, 7)];
		[rectanglePath addLineToPoint: CGPointMake(6, 12)];
		[rectanglePath addLineToPoint: CGPointMake(16, 1)];
		[UIColor.whiteColor setStroke];
		rectanglePath.lineWidth = 2;
		[rectanglePath stroke];
		
		
		doneImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
	return doneImage;
}

+ (UIImage *)cancelImage
{
	UIImage *cancelImage = nil;
	
	UIGraphicsBeginImageContextWithOptions((CGSize){16,16}, NO, 0.0f);
	{
		UIBezierPath* bezierPath = UIBezierPath.bezierPath;
		[bezierPath moveToPoint: CGPointMake(15, 15)];
		[bezierPath addLineToPoint: CGPointMake(1, 1)];
		[UIColor.whiteColor setStroke];
		bezierPath.lineWidth = 2;
		[bezierPath stroke];
		
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(1, 15)];
		[bezier2Path addLineToPoint: CGPointMake(15, 1)];
		[UIColor.whiteColor setStroke];
		bezier2Path.lineWidth = 2;
		[bezier2Path stroke];
		
		cancelImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
	return cancelImage;
}

+ (UIImage *)rotateCCWImage
{
	UIImage *rotateImage = nil;
	
	UIGraphicsBeginImageContextWithOptions((CGSize){18,21}, NO, 0.0f);
	{
		//// Rectangle 2 Drawing
		UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(0, 9, 12, 12)];
		[UIColor.whiteColor setFill];
		[rectangle2Path fill];
		rectangle2Path.lineWidth = 1;
		[UIColor.whiteColor setStroke];
		[rectangle2Path stroke];


		//// Rectangle 3 Drawing
		UIBezierPath* rectangle3Path = UIBezierPath.bezierPath;
		[rectangle3Path moveToPoint: CGPointMake(5, 3)];
		[rectangle3Path addLineToPoint: CGPointMake(10, 6)];
		[rectangle3Path addLineToPoint: CGPointMake(10, 0)];
		[rectangle3Path addLineToPoint: CGPointMake(5, 3)];
		[rectangle3Path closePath];
		[UIColor.whiteColor setFill];
		[rectangle3Path fill];


		//// Bezier Drawing
		UIBezierPath* bezierPath = UIBezierPath.bezierPath;
		[bezierPath moveToPoint: CGPointMake(10, 3)];
		[bezierPath addCurveToPoint: CGPointMake(17.5, 11) controlPoint1: CGPointMake(15, 3) controlPoint2: CGPointMake(17.5, 5.91)];
		[UIColor.whiteColor setStroke];
		bezierPath.lineWidth = 1;
		[bezierPath stroke];
		rotateImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
	return rotateImage;
}

+ (UIImage *)rotateCWImage
{
	UIImage *rotateCCWImage = [self.class rotateCCWImage];
	UIGraphicsBeginImageContextWithOptions(rotateCCWImage.size, NO, rotateCCWImage.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, rotateCCWImage.size.width, rotateCCWImage.size.height);
	CGContextRotateCTM(context, M_PI);
	CGContextDrawImage(context,CGRectMake(0,0,rotateCCWImage.size.width,rotateCCWImage.size.height),rotateCCWImage.CGImage);
	UIImage *rotateCWImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return rotateCWImage;
}

+ (UIImage *)resetImage
{
	UIImage *resetImage = nil;
	
	UIGraphicsBeginImageContextWithOptions((CGSize){22,18}, NO, 0.0f);
	{
		
		//// Bezier 2 Drawing
		UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
		[bezier2Path moveToPoint: CGPointMake(22, 9)];
		[bezier2Path addCurveToPoint: CGPointMake(13, 18) controlPoint1: CGPointMake(22, 13.97) controlPoint2: CGPointMake(17.97, 18)];
		[bezier2Path addCurveToPoint: CGPointMake(13, 16) controlPoint1: CGPointMake(13, 17.35) controlPoint2: CGPointMake(13, 16.68)];
		[bezier2Path addCurveToPoint: CGPointMake(20, 9) controlPoint1: CGPointMake(16.87, 16) controlPoint2: CGPointMake(20, 12.87)];
		[bezier2Path addCurveToPoint: CGPointMake(13, 2) controlPoint1: CGPointMake(20, 5.13) controlPoint2: CGPointMake(16.87, 2)];
		[bezier2Path addCurveToPoint: CGPointMake(6.55, 6.27) controlPoint1: CGPointMake(10.1, 2) controlPoint2: CGPointMake(7.62, 3.76)];
		[bezier2Path addCurveToPoint: CGPointMake(6, 9) controlPoint1: CGPointMake(6.2, 7.11) controlPoint2: CGPointMake(6, 8.03)];
		[bezier2Path addLineToPoint: CGPointMake(4, 9)];
		[bezier2Path addCurveToPoint: CGPointMake(4.65, 5.63) controlPoint1: CGPointMake(4, 7.81) controlPoint2: CGPointMake(4.23, 6.67)];
		[bezier2Path addCurveToPoint: CGPointMake(7.65, 1.76) controlPoint1: CGPointMake(5.28, 4.08) controlPoint2: CGPointMake(6.32, 2.74)];
		[bezier2Path addCurveToPoint: CGPointMake(13, 0) controlPoint1: CGPointMake(9.15, 0.65) controlPoint2: CGPointMake(11, 0)];
		[bezier2Path addCurveToPoint: CGPointMake(22, 9) controlPoint1: CGPointMake(17.97, 0) controlPoint2: CGPointMake(22, 4.03)];
		[bezier2Path closePath];
		[UIColor.whiteColor setFill];
		[bezier2Path fill];
		
		
		//// Polygon Drawing
		UIBezierPath* polygonPath = UIBezierPath.bezierPath;
		[polygonPath moveToPoint: CGPointMake(5, 15)];
		[polygonPath addLineToPoint: CGPointMake(10, 9)];
		[polygonPath addLineToPoint: CGPointMake(0, 9)];
		[polygonPath addLineToPoint: CGPointMake(5, 15)];
		[polygonPath closePath];
		[UIColor.whiteColor setFill];
		[polygonPath fill];
		
		
		resetImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
	return resetImage;
}

+ (UIImage *)clampImage
{
	UIImage *clampImage = nil;
	
	UIGraphicsBeginImageContextWithOptions((CGSize){22,16}, NO, 0.0f);
	{
		//// Color Declarations
		UIColor* outerBox = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.553];
		UIColor* innerBox = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.773];
		
		//// Rectangle Drawing
		UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 3, 13, 13)];
		[UIColor.whiteColor setFill];
		[rectanglePath fill];
		
		
		//// Outer
		{
			//// Top Drawing
			UIBezierPath* topPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 22, 2)];
			[outerBox setFill];
			[topPath fill];
			
			
			//// Side Drawing
			UIBezierPath* sidePath = [UIBezierPath bezierPathWithRect: CGRectMake(19, 2, 3, 14)];
			[outerBox setFill];
			[sidePath fill];
		}
		
		
		//// Rectangle 2 Drawing
		UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(14, 3, 4, 13)];
		[innerBox setFill];
		[rectangle2Path fill];
		
		
		clampImage = UIGraphicsGetImageFromCurrentImageContext();
	}
	UIGraphicsEndImageContext();
	
	return clampImage;
}

#pragma mark - Accessors -

- (void)setRotateClockwiseButtonHidden:(BOOL)rotateClockwiseButtonHidden
{
	if (_rotateClockwiseButtonHidden == rotateClockwiseButtonHidden) {
		return;
	}
	
	_rotateClockwiseButtonHidden = rotateClockwiseButtonHidden;
	
	[self setNeedsLayout];
}

- (UIButton *)rotateButton
{
	return self.rotateCounterclockwiseButton;
}

- (void)setStatusBarHeightInset:(CGFloat)statusBarHeightInset
{
	_statusBarHeightInset = statusBarHeightInset;
	[self setNeedsLayout];
}

@end

