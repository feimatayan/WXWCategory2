//
//  WDIEDrawLineView.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/11.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEDrawLineView.h"
#import "WDIEDrawLineInfo.h"

@interface WDIEDrawLineView ()

//// 是否开始新画一条线
//@property (nonatomic, assign) BOOL isBenginNewLine;

// 所有的线条信息，包含了颜色，坐标和粗细信息
@property (nonatomic, strong) NSMutableArray *lines;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation WDIEDrawLineView


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		_lines = [[NSMutableArray alloc] initWithCapacity:10];
		self.currentPaintBrushColor = [UIColor blackColor];
		self.backgroundColor = [UIColor clearColor];
		self.currentPaintBrushWidth =  4.f;
		
		_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuestureAction:)];
		_pan.maximumNumberOfTouches = 1;
		_pan.enabled = NO;
		[self addGestureRecognizer:_pan];
	}
	return self;
	
}

- (void)setEnableDraw:(BOOL)enableDraw {
	_enableDraw = enableDraw;
	_pan.enabled = enableDraw;
}

- (void)panGuestureAction:(UIPanGestureRecognizer *)panGesture {

	CGPoint point = [panGesture locationInView:self];
	
	if(panGesture.state == UIGestureRecognizerStateBegan) {
		[self drawPaletteTouchesBeganWithPoint:point];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else if (panGesture.state == UIGestureRecognizerStateChanged) {
		[self drawPaletteTouchesMovedWithPonit:point];
		[self setNeedsLayout];
		[self setNeedsDisplay];
		[self notifyTouchMoved];
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		[self notifyTouchEnded];
	}
}


#pragma  mark - draw event
//根据现有的线条 绘制相应的图画
- (void)drawRect:(CGRect)rect  {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	if (_lines.count>0) {
		for (int i=0; i<[self.lines count]; i++) {
			WDIEDrawLineInfo *line = self.lines[i];
			
			CGContextBeginPath(context);
			CGPoint myStartPoint=[[line.linePoints objectAtIndex:0] CGPointValue];
			CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
			
			if (line.linePoints.count>1) {
				for (int j=0; j<[line.linePoints count]-1; j++) {
					CGPoint myEndPoint=[[line.linePoints objectAtIndex:j+1] CGPointValue];
					CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
				}
			}else {
				CGContextAddLineToPoint(context, myStartPoint.x,myStartPoint.y);
			}
			CGContextSetStrokeColorWithColor(context, line.lineColor.CGColor);
			CGContextSetLineWidth(context, line.lineWidth);
			CGContextStrokePath(context);
		}
	}
	
//	self.transform = CGAffineTransformMakeScale(self.scale, self.scale);
}


#pragma mark - touch event
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	_isBenginNewLine = YES;
	
//	if (touches.count == 1 && _enableDraw) {
//		UITouch* touch=[touches anyObject];
//		[self drawPaletteTouchesBeganWithPoint:[touch locationInView:self]];
//		[self setNeedsDisplay];
//	}
	[self setNeedsDisplay];
}

//触摸移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (!_enableDraw) {
		return;
	}

	UITouch *touch = touches.anyObject;
	if(touch.tapCount == 1) {
		CGPoint touchPoint = [touch locationInView:self];

		if (_isBenginNewLine) {
			[self drawPaletteTouchesBeganWithPoint:touchPoint];
			_isBenginNewLine = NO;
		} else {
			[self drawPaletteTouchesMovedWithPonit:touchPoint];
			[self notifyTouchMoved];
		}

		[self setNeedsDisplay];
	}
	
//	if(touches.count == 1 && _enableDraw) {
//		UITouch *touch = touches.anyObject;
//		[self drawPaletteTouchesMovedWithPonit:[touch locationInView:self]];
//		[self setNeedsDisplay];
//		[self notifyTouchMoved];
//	}
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self notifyTouchEnded];
}
*/
#pragma mark - Private helper

- (void)notifyTouchEnded {
	if (_delegate && [_delegate respondsToSelector:@selector(darwLineViewTouchEnded:)]) {
		[_delegate darwLineViewTouchEnded:self];
	}
}

- (void)notifyTouchMoved {
	if (_delegate && [_delegate respondsToSelector:@selector(darwLineViewTouchMoved:)]) {
		[_delegate darwLineViewTouchMoved:self];
	}
}

- (void)notifyLineCountChanged {
	if (_delegate && [_delegate respondsToSelector:@selector(drawLineView:lineCountChanged:)]) {
		[_delegate drawLineView:self lineCountChanged:self.lines.count];
	}
}

#pragma mark draw info edite event

//在触摸开始的时候 添加一条新的线条 并初始化
- (void)drawPaletteTouchesBeganWithPoint:(CGPoint)bPoint {
	WDIEDrawLineInfo *line = [[WDIEDrawLineInfo alloc] init];
	line.lineColor = self.currentPaintBrushColor;
	line.lineWidth = self.currentPaintBrushWidth;
	[line.linePoints addObject:[NSValue valueWithCGPoint:bPoint]];
	
	[self.lines addObject:line];
	
	[self notifyLineCountChanged];
}

//在触摸移动的时候 将现有的线条的最后一条的 point增加相应的触摸过的坐标
- (void)drawPaletteTouchesMovedWithPonit:(CGPoint)mPoint {
	WDIEDrawLineInfo *lastInfo = [self.lines lastObject];
	[lastInfo.linePoints addObject:[NSValue valueWithCGPoint:mPoint]];
}

- (void)cleanAllDrawBySelf {
	if ([self.lines count] > 0)  {
		[self.lines removeAllObjects];
		[self setNeedsDisplay];
		
		[self notifyLineCountChanged];
	}
}

- (void)cleanFinallyDraw {
	if ([self.lines count] > 0) {
		[self.lines removeLastObject];
		[self setNeedsDisplay];
		
		[self notifyLineCountChanged];
	}
}

@end
