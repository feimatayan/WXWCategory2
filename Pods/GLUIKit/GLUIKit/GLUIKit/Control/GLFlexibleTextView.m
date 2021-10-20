//
//  GLFlexibleTextView.m
//  GLUIKit
//
//  Created by Kevin on 15/10/12.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLFlexibleTextView.h"
#import "GLUIKitUtils.h"
#import "NSString+GLString.h"
#import "NSAttributedString+GLAttributedString.h"

static CGFloat kLineSpacing = 4;
@interface GLFlexibleTextView()

@property (nonatomic, assign) BOOL displayedYet;

@end


@implementation GLFlexibleTextView

static CGFloat kFontHeight = 0;

#pragma mark - Life Cycle
#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UITextViewTextDidChangeNotification
     object:nil];
    [self removeObserver:self forKeyPath:@"text"];
}

#pragma mark - UI
#pragma mark -

- (void)drawRect:(CGRect)rect
{
    CGFloat contentOffsetY = self.contentOffset.y;
    if (contentOffsetY < 0)
    {
        contentOffsetY = - contentOffsetY + 8;
    } else {
        contentOffsetY = 8;
    }
    if (self.contentOffsetX == 0) {
        self.contentOffsetX = 8;
    }
    CGRect offsetRect = CGRectInset(rect, self.contentOffsetX, contentOffsetY);
    if (self.text == nil || self.text.length < 1) {
        // zhengxf modify 2016-01-11 修改颜色 [UIColor colorWithWhite:0.6 alpha:0.5]
        if (!self.placeHolderColor) {
            self.placeHolderColor = UIColorFromRGB(0xd6d6d6);
        }
        [self.placeHolder glDrawInRect:offsetRect withFont:self.font withColor:self.placeHolderColor];
    }
    
    [super drawRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.text.length > 1 && _isFlexibleHeight) {
        if (_maxFlexibleLineNum == 0) {
            _maxFlexibleLineNum = 10; // 默认10行
        }
        CGRect frame = self.frame;
        CGSize currentSize = [self.attributedText glSizeWithConstrainedSize:CGSizeMake(frame.size.width - 8, 10000)];
        
        int numLines = currentSize.height / kFontHeight;
        
        if (numLines <= _maxFlexibleLineNum) {
            CGFloat maxHeight  = rintf(_maxFlexibleLineNum * kFontHeight + 14);
            CGFloat trueHeight = rintf(numLines * kFontHeight + 14);
            
            if (trueHeight > maxHeight) {
                frame.size.height = maxHeight;
            }
            else if(trueHeight < _minFlexHeight) {
                frame.size.height = _minFlexHeight;
            }
            else {
                frame.size.height = trueHeight;
            }
            
            
            if (_glDelegate && [_glDelegate respondsToSelector:@selector(glFlexibleTextView:willChangeSize:)]) {
                [_glDelegate glFlexibleTextView:self willChangeSize:frame.size];
            }
            
            self.frame = frame;
            
            if (_glDelegate && [_glDelegate respondsToSelector:@selector(glFlexibleTextView:didChangeSize:)]) {
                [_glDelegate glFlexibleTextView:self didChangeSize:frame.size];
            }
        }
        else if (_displayedYet == NO)
        {
            frame.size.height = rintf(MAX(numLines * kFontHeight, _minFlexHeight));
            
            int offsetHeight = 0;
            if (numLines > 2) {
                offsetHeight = 15;
            }
            frame.size.height = (int)MIN(_maxFlexibleLineNum * kFontHeight + offsetHeight,
                                         frame.size.height + offsetHeight);
            
            if (_glDelegate && [_glDelegate respondsToSelector:@selector(glFlexibleTextView:willChangeSize:)]) {
                [_glDelegate glFlexibleTextView:self willChangeSize:frame.size];
            }
            
            self.frame = frame;
            
            if (_glDelegate && [_glDelegate respondsToSelector:@selector(glFlexibleTextView:didChangeSize:)]) {
                [_glDelegate glFlexibleTextView:self didChangeSize:frame.size];
            }
            
            _displayedYet = YES;
        }
    }
}


#pragma mark - KVO Callback & Notification
#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *textView = (UITextView *)object;
    if (textView == self)
    {
        if ([keyPath isEqualToString:@"text"])
        {
            [self updateTextViewSpacing:textView];
            [self setNeedsDisplay];
            if (_isFlexibleHeight)
            {
                [self setNeedsLayout];
            }
        }
    }
}

- (void)textChanged:(NSNotification *)notification
{
    [self setNeedsDisplay];
    if (_isFlexibleHeight) {
        [self setNeedsLayout];
    }
    if (_glDelegate && [_glDelegate respondsToSelector:@selector(glFlexibleTextViewTextChanged:)]) {
        [_glDelegate glFlexibleTextViewTextChanged:self];
    }
}

- (void)updateTextViewSpacing:(UITextView *)textview
{
    textview.attributedText = [[NSAttributedString alloc] initWithString:textview.text attributes:[self getTextViewAttributes]];
}

#pragma mark - Initialized
#pragma mark -

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    //MARK: [Acorld] ---->KVO 监听-text 变化
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)initComponents
{
    self.font = [UIFont systemFontOfSize:16];
    kFontHeight = [self.font lineHeight];
    
    [self addNotification];
}

#pragma mark - Setter & Getter
#pragma mark -

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    kFontHeight = [font lineHeight];
}


- (void)setFlexibleHeight:(BOOL)flexibleHeight
{
    _isFlexibleHeight = flexibleHeight;
}

- (NSDictionary *)getTextViewAttributes
{
    //    textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kLineSpacing;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    return attributes;
}
@end
