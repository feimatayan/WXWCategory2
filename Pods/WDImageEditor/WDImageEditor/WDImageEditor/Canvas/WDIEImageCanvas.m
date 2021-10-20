//
//  WDIEImageCanvas.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/10.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEImageCanvas.h"
#import "WDIEDrawLineView.h"
#import "WDIEUtils.h"
#import "WDIETextLabel.h"

@interface WDIEImageCanvas () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *mImageView;

@property (nonatomic, assign) BOOL enableDraw;

@property (nonatomic, assign) CGRect orignalDrawViewFrame;

@end

@implementation WDIEImageCanvas

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.delegate = self;
		[self setMinimumZoomScale:1.0];
		[self setMaximumZoomScale:3.0];
		[self setZoomScale:1.0];
		[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[self setContentSize:frame.size];
		
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator   = NO;
		
		_mImageView = [[UIImageView alloc] initWithFrame:frame];
		_mImageView.contentMode = UIViewContentModeScaleAspectFit;
		_mImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:_mImageView];
		
		_drawView = [[WDIEDrawLineView alloc] init];
		_drawView.currentPaintBrushColor = UIColor.redColor;
		_drawView.currentPaintBrushWidth = 3.0;
//		_drawView.backgroundColor = [UIColor colorWithRed:0.8 green:0.5 blue:0.3 alpha:0.5];
		
		self.panGestureRecognizer.delegate = self;
		
		[self addSubview:_drawView];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
{
	if ((self = [self initWithFrame:frame]))
	{
		_mImageView.image = image;
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect imageFrame = [self imageFrameForImageView:_mImageView];
	_orignalDrawViewFrame = imageFrame;
	self.drawView.frame = imageFrame;
}

#pragma mark - Getter & Setter

- (void)setImage:(UIImage *)image
{
	self.zoomScale = 1;
	self.mImageView.image = image;
	
	[self.drawView cleanAllDrawBySelf];
	[self setNeedsLayout];
}

- (UIImage *)image
{
	return self.mImageView.image;
}

#pragma mark - Public

- (void)resetZoomScale {
	self.zoomScale = 1.0;
	self.drawView.transform = CGAffineTransformIdentity;
}

- (void)setDrawLineColor:(UIColor *)lineColor {
	self.drawView.currentPaintBrushColor = lineColor;
}

- (void)setDrawLineWidth:(CGFloat)lineWidth {
	self.drawView.currentPaintBrushWidth = lineWidth;
}

- (void)setDrawLineViewDelegate:(id<WDIEDrawLineViewDelegate>)delegate {
	self.drawView.delegate = delegate;
}

- (void)cleanLastLine {
	[self.drawView cleanFinallyDraw];
}

- (void)enableDraw:(BOOL)enable {
	self.scrollEnabled = !enable;
	self.enableDraw = enable; 
	self.drawView.enableDraw = enable;
}

- (UIImage *)screenshotOfView:(UIView *)view
{
	UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage *)generateImage {
	
	UIImage *cavasImage = [self screenshotOfView:self.drawView];
	UIImage *realImage = [WDIEUtils wdie_copyImage:self.image];
	CGFloat width = realImage.size.width;
	CGFloat height = realImage.size.height;
	
	UIGraphicsBeginImageContextWithOptions(realImage.size, NO, 0.0);
	[realImage drawInRect:CGRectMake(0, 0, width, height)];
	[cavasImage drawInRect:CGRectMake(0, 0, width, height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

#pragma mark - Private

/**
 获取ImageView中image的frame
 */
- (CGRect)imageFrameForImageView:(UIImageView *)imageView{
	
	UIImage *image = imageView.image;
	
	if(!image || image.size.width < 0.01 || image.size.height < 0.01) {
		return CGRectZero;
	}
	
	//图片宽高
	CGFloat wi = image.size.width;
	CGFloat hi = image.size.height;
	
	//ImageView宽高
	CGFloat wv = imageView.frame.size.width;
	CGFloat hv = imageView.frame.size.height;
	
	//图片高宽比 与ImageView高宽比
	CGFloat ri = hi / wi;
	CGFloat rv = hv / wv;
	
	CGFloat x, y, w, h;
	if (ri > rv) {
		h = hv;
		w = h / ri;
		x = (wv / 2) - (w / 2);
		y = 0;
	} else {
		w = wv;
		h = w * ri;
		x = 0;
		y = (hv / 2) - (h / 2);
	}
	
	return CGRectMake(x, y, w, h);
}

#pragma mark - UIScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.mImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
	self.drawView.enableDraw = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
	self.drawView.enableDraw = self.enableDraw;
	self.drawView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	self.drawView.transform = CGAffineTransformMakeScale(scrollView.zoomScale, scrollView.zoomScale);
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	
	// 防止pan文字框(WDIETextDisplayView)时发生手势冲突
	if(gestureRecognizer == self.panGestureRecognizer && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
		return YES;
	}
	
	return NO;
}

@end
