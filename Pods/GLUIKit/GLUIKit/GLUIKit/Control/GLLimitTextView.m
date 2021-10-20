//
//  GLLimitTextView.m
//  GLUIKit
//
//  Created by 杨磊 on 2018/10/9.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "GLLimitTextView.h"
#import "UIView+GLFrame.h"
#import "GLUIKitUtils.h"

/// 文本类型，默认TextView
typedef enum : NSUInteger {
    GLLimitTextViewTypeTextView,
    GLLimitTextViewTypeTextField,
} GLLimitTextViewType;

static CGFloat kMarginLeft = 5;
static CGFloat kMarginTop = 5;

@interface GLLimitTextView()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, assign) GLLimitTextViewType textViewType;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *limitLabel; // 仅TextView有效
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation GLLimitTextView
@synthesize text = _text;
@synthesize textFont = _textFont;
@synthesize textColor = _textColor;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

+ (instancetype)makeTextView:(CGRect)frame
{
    return [[GLLimitTextView alloc] initWithFrame:frame];
}

+ (instancetype)makeTextField:(CGRect)frame
{
    return [[GLLimitTextView alloc] initWithFrame:frame textViewType:GLLimitTextViewTypeTextField];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        return [self initWithFrame:frame textViewType:GLLimitTextViewTypeTextView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                 textViewType:(GLLimitTextViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textViewType = type ? type : GLLimitTextViewTypeTextView;
        [self initComponents];
        if (type == GLLimitTextViewTypeTextView) {
            NSAssert(self.frame.size.height >= 50, @"请调整文本框高度!!!");
        }
    }
    return self;
}

#pragma mark - TextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(limitTextViewDidBeginEditing:)]) {
        [self.delegate limitTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(limitTextViewDidEndEditing:)]) {
        [self.delegate limitTextViewDidEndEditing:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    
    // 当前光标位置
    UITextRange *currSelectedRange = textView.selectedTextRange;
    
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        textView.text = [[self class] subStringWith:toBeString maxNumber:self.limit];
    } else { // 高亮选择部分不做处理
        
    }
    
    // 系统键盘高亮输入字符串超长时对字符串进行处理
    if(textView.text.length > self.limit) {
        textView.text = [[self class] subStringWith:textView.text maxNumber:self.limit];
    }
    
    // 还原光标位置
    textView.selectedTextRange = currSelectedRange;
    
    self.placeholderLabel.hidden = textView.text.length > 0;
    
    [self updateLimit:textView.text];
    [self limitTextViewDidChange];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return [self limitTextViewShouldChangeCharactersInRange:range textViewValue:textView.text replacementString:text];
}

#pragma mark - TextFiled

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    if ([self.delegate respondsToSelector:@selector(limitTextViewDidBeginEditing:)]) {
        [self.delegate limitTextViewDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(limitTextViewDidEndEditing:)]) {
        [self.delegate limitTextViewDidEndEditing:self];
    }
}

- (void)textFieldTextDidChange:(NSNotification *)aNotification
{
    UITextField *textField = (UITextField *)aNotification.object;
    NSString *toBeString = textField.text;
    // 当前光标位置
    UITextRange *currSelectedRange = textField.selectedTextRange;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        textField.text = [[self class] subStringWith:toBeString maxNumber:self.limit];
    } else { // 高亮选择部分不做处理
        
    }
    
    // 系统键盘高亮输入字符串超长时对字符串进行处理
    if(textField.text.length > self.limit) {
        textField.text = [[self class] subStringWith:textField.text maxNumber:self.limit];
    }
    
    // 还原光标位置
    textField.selectedTextRange = currSelectedRange;
    // 多个文本框来回切换时，文本框发生变化，保证文本框一致
    self.textField = textField;
    [self limitTextViewDidChange];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self limitTextViewShouldChangeCharactersInRange:range textViewValue:textField.text replacementString:string];
}

#pragma - private

- (void)updateLimit:(NSString *)text
{
    if (self.limit == 0) return;
    if (self.limit > 0 && text.length > self.limit - 10) {
        self.limitLabel.hidden = NO;
        self.limitLabel.text = [NSString stringWithFormat:@"%zd/%zd",text.length, self.limit];
    } else {
        self.limitLabel.hidden = YES;
    }
}

- (void)limitTextViewDidChange
{
    if ([self.delegate respondsToSelector:@selector(limitTextViewDidChanged:)]) {
        [self.delegate limitTextViewDidChanged:self];
    }
}

//防止原生emoji表情被截断
+ (NSString *)subStringWith:(NSString *)toBeString maxNumber:(NSInteger)maxNumber
{
    NSString *result = @"";
    if(toBeString.length > maxNumber && maxNumber > 0) {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNumber-1];
        
        if (rangeIndex.length == 1)
        {
            result = [toBeString substringToIndex:maxNumber];
        }
        else if ((rangeIndex.location == maxNumber -1) && rangeIndex.length >= 2)
        { // 清除最后的表情
            result = [toBeString substringWithRange:NSMakeRange(0, maxNumber - rangeIndex.length + 1)];
        } else { // 保证截取的字符串表情不被截断
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxNumber];
            result = [toBeString substringToIndex:(rangeIndex.location)];
        }
    } else {
        result = toBeString;
    }
    
    return result;
}

- (BOOL)limitTextViewShouldChangeCharactersInRange:(NSRange)range textViewValue:(NSString *)textViewValue replacementString:(NSString *)string
{
    if(NSMaxRange(range) > textViewValue.length) {
        return NO;
    }
    NSString *nText = [textViewValue stringByReplacingCharactersInRange:range withString:string];
    
    if(self.limit > 0) { // 字符串有限制
        BOOL can = nText.length <= self.limit;
        if(!can) { // 文本框是否可编辑
            return NO;
        }
    }
    return YES;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutComponents];
}

- (void)updateTextViewFrame
{
    CGFloat textViewX = self.marginLeft >0 ? self.marginLeft : kMarginLeft;
    CGFloat textViewY = kMarginTop;
    CGFloat textViewW = self.width - 2 * textViewX;
    CGFloat textViewH = self.height - textViewY;
    self.textView.frame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
    
    self.placeholderLabel.frame = CGRectMake(2, 8, self.width-10, 20);
    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.frame = CGRectMake(2, 8, self.width-20, self.placeholderLabel.height);
    
    if (self.limit > 0) {
        CGFloat limitLabelW = 150;
        CGFloat limitLabelH = 16;
        CGFloat limitLabelX = self.width - limitLabelW - 10;
        CGFloat offsetY = 5;
        self.textView.height = self.height - 2*kMarginTop - limitLabelH - offsetY;
        
        CGFloat limitLabelY = self.textView.maxY + offsetY;
        self.limitLabel.frame = CGRectMake(limitLabelX, limitLabelY, limitLabelW, limitLabelH);
    }
}

- (void)layoutComponents
{
    if (self.textViewType == GLLimitTextViewTypeTextView) {
        [self updateTextViewFrame];
    } else {
        CGFloat textFieldX = self.marginLeft >0 ? self.marginLeft : kMarginLeft;
        self.textField.frame = CGRectMake(textFieldX, 0, self.width-2*textFieldX, self.height);
    }
}

#pragma mark - Initialized

- (void)initComponents
{
    if (self.textViewType == GLLimitTextViewTypeTextView) {
        [self addSubview:self.textView];
        [self addSubview:self.limitLabel];
        [self.textView addSubview:self.placeholderLabel];
    } else {
        [self addSubview:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

#pragma mark - Getter&Setter

- (void)setText:(NSString *)text
{
    _text = text;
    self.placeholder = @"";
    if (self.textViewType == GLLimitTextViewTypeTextView) {
        self.textView.text = text;
    } else {
        self.textField.text = text;
    }
}

- (NSString *)text
{
    if (self.textViewType == GLLimitTextViewTypeTextView) {
        return self.textView.text;
    } else {
        return self.textField.text;
    }
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.textView.font = textFont;
    self.textField.font = textFont;
    self.placeholderLabel.font = textFont;
}

- (UIFont *)textFont
{
    if (self.textViewType == GLLimitTextViewTypeTextView) {
        return self.textView.font;
    } else {
        return self.textField.font;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textView.textColor = textColor;
    self.textField.textColor = textColor;
}

- (UIColor *)textColor
{
    if (self.textViewType == GLLimitTextViewTypeTextView) {
        return self.textView.textColor;
    } else {
        return self.textField.textColor;
    }
}

- (void)setLimit:(NSInteger)limit
{
    _limit = limit;
    if (limit > 0 && self.textViewType == GLLimitTextViewTypeTextView) {
        self.limitLabel.hidden = NO;
    } else {
        self.limitLabel.hidden = YES;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (self.textViewType != GLLimitTextViewTypeTextView) {
        self.textField.placeholder = _placeholder;
    } else {
        self.placeholderLabel.text = _placeholder;
        self.placeholderLabel.hidden = self.text.length > 0;
    }
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = UIColorFromRGB(0x222222);
        _textField.layer.masksToBounds = YES;
        _textField.delegate = self;
    }
    return _textField;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = UIColorFromRGB(0x222222);
        _textView.layer.masksToBounds = YES;
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

- (UILabel *)placeholderLabel
{
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = UIColorFromRGB(0xCACACA);
        _placeholderLabel.numberOfLines = 0;
    }
    return _placeholderLabel;
}

- (UILabel *)limitLabel
{
    if (_limitLabel == nil) {
        _limitLabel = [[UILabel alloc] init];
        _limitLabel.font = [UIFont systemFontOfSize:10];
        _limitLabel.textAlignment = NSTextAlignmentRight;
        _limitLabel.textColor = UIColorFromRGB(0x9A9A9A);
        _limitLabel.hidden = YES;
    }
    return _limitLabel;
}
@end
