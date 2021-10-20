//
//  GLLineLabel.m
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC，turn on arc for this file use '-fobjc-arc' in Targets -> Build Phases -> Compile Sources
#endif

#import "GLLineLabel.h"
#import <CoreText/CoreText.h>
#import "NSString+GLString.h"

typedef NS_ENUM(NSUInteger, GLLabelLineType)
{
    GLLabelLineTypeNone = 0,
    GLLabelLineTypeUp,
    GLLabelLineTypeMiddle,
    GLLabelLineTypeBottom,
};

static inline CTTextAlignment CTTextAlignmentFromNSTextAlignment(NSTextAlignment alignment) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    switch (alignment) {
        case NSTextAlignmentLeft: return kCTLeftTextAlignment;
        case NSTextAlignmentCenter: return kCTCenterTextAlignment;
        case NSTextAlignmentRight: return kCTRightTextAlignment;
        default: return kCTNaturalTextAlignment;
    }
#else
    switch (alignment) {
        case UITextAlignmentLeft: return kCTLeftTextAlignment;
        case UITextAlignmentCenter: return kCTCenterTextAlignment;
        case UITextAlignmentRight: return kCTRightTextAlignment;
        default: return kCTNaturalTextAlignment;
    }
#endif
}


@interface GLLineLabel()

/**
 *  默认LineTypeNone
 */
@property (assign) GLLabelLineType lineType;

@end


@implementation GLLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineType   = GLLabelLineTypeNone;
        _lineHeight = 1.0f;
    }
    return self;
}


- (UIColor *)lineColor
{
    if (!_lineColor)
    {
        //default textcolor
        _lineColor = self.textColor;
    }
    return _lineColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor != lineColor)
    {
        _lineColor = lineColor;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    self.lineColor = textColor;
}

- (CGSize)optimumSize
{
    if (CGSizeEqualToSize(CGSizeZero, _optimumSize))
    {
        [self render];
    }
    return _optimumSize;
}

- (void)render
{
#ifdef DEBUG
    NSLog(@"You call default implementation <%@> in father class,You should rewrite it in your subClass!",NSStringFromSelector(_cmd));
#endif
    
    
    CGRect rect = self.bounds;
    CGSize textSize;
    if ([self.text respondsToSelector:@selector(sizeWithAttributes:)])
    {
        textSize = [[self text] sizeWithAttributes:@{NSFontAttributeName: self.font}];
    }else
    {
        textSize = [[self text] glSizeWithFont:[self font]];
    }
    
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect = CGRectZero;
    CGFloat origin_x = 0;
    CGFloat origin_y = 0;
    
#ifdef __IPHONE_6_0
    if ([self textAlignment] == NSTextAlignmentRight)
    {
        origin_x = rect.size.width - strikeWidth;
    } else if ([self textAlignment] == NSTextAlignmentCenter)
    {
        origin_x = (rect.size.width - strikeWidth)/2 ;
    } else
    {
        origin_x = 0;
    }
#else
    if ([self textAlignment] == UITextAlignmentRight)
    {
        origin_x = rect.size.width - strikeWidth;
    } else if ([self textAlignment] == UITextAlignmentCenter)
    {
        origin_x = (rect.size.width - strikeWidth)/2 ;
    } else
    {
        origin_x = 0;
    }
#endif
    
    switch (self.lineType)
    {
        case GLLabelLineTypeUp:
            origin_y = 2;
            break;
            
        case GLLabelLineTypeMiddle:
            origin_y = (rect.size.height - _lineHeight)/2;
            break;
            
        case GLLabelLineTypeBottom:
            origin_y = rect.size.height - 2 - _lineHeight;
            break;
            
        default:
            break;
    }
    
    lineRect = CGRectMake(origin_x , origin_y, strikeWidth, _lineHeight);
    
    if (self.lineType != GLLabelLineTypeNone) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
        CGContextMoveToPoint(context, lineRect.origin.x, lineRect.origin.y);
        CGContextSetLineWidth(context, _lineHeight);
        CGContextAddLineToPoint(context, CGRectGetMaxX(lineRect), CGRectGetMaxY(lineRect));
        
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    self.optimumSize = textSize;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    if (self.text) {
        [self render];
    }
    
}


@end


#pragma mark - Subclass, Middle
#pragma mark -

@implementation GLMiddleLineLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.lineType = GLLabelLineTypeMiddle;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (self.text) {
        [self render];
    }
}

- (void)render
{
    CGRect rect = self.bounds;
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:self.text];
    
    //对齐方式,字体,下划线，下划线颜色,文字颜色
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionary];
    
    CTTextAlignment alignment = CTTextAlignmentFromNSTextAlignment(self.textAlignment);
    CTParagraphStyleSetting alignmentSetting;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    alignmentSetting.value = &alignment;
    CTParagraphStyleSetting settings[1] = {alignmentSetting};
    CFIndex settingCount = 1;
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, settingCount);
    
    [mutableAttributes setObject:(__bridge id)(paragraphRef)
                          forKey:(NSString *)kCTParagraphStyleAttributeName];
    CTFontRef fontRef =
    CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [mutableAttributes setObject:(__bridge id)(fontRef)
                          forKey:(NSString *)kCTFontAttributeName];
    [mutableAttributes setObject:(id)self.textColor.CGColor
                          forKey:(NSString *)kCTForegroundColorAttributeName];
    [attributedString addAttributes:mutableAttributes
                              range:NSMakeRange(0, attributedString.length)];
    
    CFRelease(fontRef);
    CFRelease(paragraphRef);
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGRect textRect = [self textRect];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(framesetter);
    if (frame == NULL)
    {
        CFRelease(path);
        return ;
    }
    
    //计算文字占用行数
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = 0;
    if (self.numberOfLines == 0)
        numberOfLines = CFArrayGetCount(lines);
    else
        numberOfLines = MIN(self.numberOfLines, CFArrayGetCount(lines));
    if (numberOfLines == 0)
    {
        CFRelease(frame);
        CFRelease(path);
        return ;
    }
    
    //每行文字的绘制起始点
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    //转换坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, rect.origin.x, rect.size.height - textRect.origin.y - textRect.size.height);
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
    {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
        CTLineDraw(line, context);//绘制文字
        
        CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
        CGContextSetLineWidth(context, 1);
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        
        //绘制划线
        CGContextMoveToPoint(context, lineOrigin.x, yMin + (ascent + descent) / 2);
        CGContextAddLineToPoint(context, lineOrigin.x+width, yMin + (ascent + descent) / 2);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    CFRelease(frame);
    CFRelease(path);
}

- (CGRect)textRect
{
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    textRect.size.height += 10;
    
    return textRect;
}

@end


#pragma mark - Subclass, Bottom
#pragma mark - 

@implementation GLBottomLineLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.lineType = GLLabelLineTypeBottom;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (self.text) {
        [self render];
    }
    
}

- (void)render
{
    CGRect rect = self.bounds;
    UIEdgeInsets insertRect = UIEdgeInsetsZero;
    CGRect insetRect = UIEdgeInsetsInsetRect(rect, insertRect);
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:self.text];
    
    //对齐方式,字体,下划线，下划线颜色,文字颜色
    CTTextAlignment alignment = CTTextAlignmentFromNSTextAlignment(self.textAlignment);
    CTParagraphStyleSetting alignmentSetting;
    alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
    alignmentSetting.valueSize = sizeof(CTTextAlignment);
    alignmentSetting.value = &alignment;
    CTParagraphStyleSetting settings[1] = {alignmentSetting};
    CFIndex settingCount = 1;
    CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(settings, settingCount);
    
    NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionary];
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [mutableAttributes setObject:(__bridge id)(fontRef) forKey:(NSString *)kCTFontAttributeName];
    [mutableAttributes setObject:(id)self.textColor.CGColor forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableAttributes setObject:@(YES) forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableAttributes setObject:(id)self.lineColor.CGColor forKey:(NSString *)kCTUnderlineColorAttributeName];
    [mutableAttributes setObject:(__bridge id)(paragraphRef) forKey:(NSString *)kCTParagraphStyleAttributeName];
    [attributedString addAttributes:mutableAttributes range:NSMakeRange(0, attributedString.length)];
    
    CFRelease(fontRef);
    CFRelease(paragraphRef);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGContextSetTextMatrix(c, CGAffineTransformIdentity);
    
    // Inverts the CTM to match iOS coordinates (otherwise text draws upside-down; Mac OS's system is different)
    CGContextTranslateCTM(c, 0.0f, insetRect.size.height);
    CGContextScaleCTM(c, 1.0f, -1.0f);
    
    CFRange textRange = CFRangeMake(0, (CFIndex)[attributedString length]);
    
    // First, get the text rect (which takes vertical centering into account)
    CGRect textRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    
    // CoreText draws it's text aligned to the bottom, so we move the CTM here to take our vertical offsets into account
    CGContextTranslateCTM(c, insetRect.origin.x,
                          insetRect.size.height - textRect.origin.y - textRect.size.height);
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    [self drawFramesetter:framesetter
         attributedString:attributedString
                textRange:textRange
                   inRect:textRect context:c];
    
    CGSize constraint = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    self.optimumSize =
    CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                 CFRangeMake(0, [attributedString length]),
                                                 nil, constraint, NULL);
    CFRelease(framesetter);
    CGContextRestoreGState(c);
}

- (void)drawFramesetter:(CTFramesetterRef)framesetter
       attributedString:(NSAttributedString *)attributedString
              textRange:(CFRange)textRange
                 inRect:(CGRect)rect
                context:(CGContextRef)c
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, textRange, path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = 0;
    if (self.numberOfLines == 0)
        numberOfLines = CFArrayGetCount(lines);
    else
        numberOfLines = MIN(self.numberOfLines, CFArrayGetCount(lines));
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
    {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CGContextSetTextPosition(c, lineOrigin.x, lineOrigin.y);
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CTLineDraw(line, c);
    }
    
    CFRelease(frame);
    CFRelease(path);
}

@end

