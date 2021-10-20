//
//  GLInputViewController.m
//  GLUIKit
//
//  Created by Kevin on 15/10/14.
//  Copyright (c) 2015年 koudai. All rights reserved.
//

#import "GLInputViewController.h"
#import "GLUIKitUtils.h"
#import "GLAlertViewController.h"
#import "NSString+GLString.h"
#import "GLUIKit.h"

const CGFloat kMarginVertical   = 15.0f;
const CGFloat kMarginHorizontal = 5.0f;
const CGFloat kMinInputViewHeight = 120.0f;
const CGFloat kCharacterLabelPadding = 5.0f; // 字符统计文本框距离底部间距

@interface GLInputViewController()<GLFlexibleTextViewDelegate>




@end

@implementation GLInputViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initNav];
    [self initComponents];
}

#pragma mark - Action
#pragma mark -

- (void)doneEditing {
    
    self.text = _textView.text;
    
    if (self.delegate) {
        
        [_textView resignFirstResponder];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputViewDidEndEditing:)]) {
            [self.delegate inputViewDidEndEditing:self];
        }
    }
}

- (void)back
{
    if ([_originalText isEqualToString:_textView.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        GLAlertViewController *alc = [[GLAlertViewController alloc] initWithStyle:GLAlertViewStyleAlert
                                                                            title:@""
                                                                              msg:@"退出此次编辑？"];
        
        [alc addButtonWithIndex:0 title:@"否" clickBlock:^(NSUInteger clickedIndex) {
            
        }];
        
        [alc addButtonWithIndex:1 title:@"是" clickBlock:^(NSUInteger clickedIndex) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alc show];
    }
}

#pragma mark - GLFlexibleTextViewDelegate
#pragma mark -

- (void)glFlexibleTextView:(GLFlexibleTextView *)textView didChangeSize:(CGSize)size
{
    [self refreshLayoutComponents];
}

- (void)glFlexibleTextViewTextChanged:(GLFlexibleTextView *)textView
{
    [self updateCharacterLabelText];
    // 无值时重置UI
    if (!textView.text || [textView.text isEqualToString:@""]) {
        [self layoutComponents];
    }
}

- (void)updateCharacterLabelText
{
    if (self.showCharactersCount) {
        self.characterLabel.text = [NSString stringWithFormat:@"%zd/%zd",_textView.text.length,self.maxCharacterCount];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.maxCharacterCount == 0) return YES;
    
    NSString *nText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    BOOL isOK = nText.length <= self.maxCharacterCount;
    
    if(!isOK)
    {
        CGPoint offsetPt = CGPointZero;
        if(GL_DEVICE_IPHONE_5)
        {
            offsetPt = CGPointMake(0,-30);
        }
    }
    
    return isOK;
}

#pragma mark - Layout
#pragma mark -

- (void)layoutComponents
{
    self.contentBg.frame = CGRectMake(0,
                                      0,
                                      self.view.frame.size.width,
                                      kMinInputViewHeight);
    
    self.textView.frame = CGRectMake(kMarginHorizontal,
                                     kMarginHorizontal,
                                     _contentBg.frame.size.width - 2*kMarginHorizontal,
                                     _contentBg.frame.size.height-kMarginHorizontal);
    
    
    if (self.showCharactersCount) {
        self.characterContainerView.y = _contentBg.maxY;
        self.hintLabel.y = 10 + self.characterContainerView.maxY;
    } else {
        self.hintLabel.y = 10 + _contentBg.maxY;
    }
}

- (void)refreshLayoutComponents
{
    self.contentBg.height = kMinInputViewHeight;
    if (self.textView.maxY > kMinInputViewHeight) { // 文本框变大
        self.contentBg.height = self.textView.maxY;
    }
    
    if (self.showCharactersCount) {
        self.characterContainerView.y = _contentBg.maxY;
        self.hintLabel.y = 10 + self.characterContainerView.maxY;
    } else {
        
        self.hintLabel.y = 10 + _contentBg.maxY;
    }
}

#pragma mark - Initialized
#pragma mark -

- (void)initComponents
{
    self.maxCharacterCount = 140;
    // 背景
    self.contentBg = [[GLView alloc] init];
    self.contentBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentBg];
    
    // textview
    self.textView = [[GLFlexibleTextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.glDelegate = self;
    self.textView.delegate = self;
    self.textView.isFlexibleHeight = YES;
    self.textView.maxFlexibleLineNum = 10;
    [self.contentBg addSubview:self.textView];
    
    self.characterContainerView.hidden = YES;
    [self.view addSubview:self.characterContainerView];
    
    // set default text
    if (_contentText && ![_contentText isKindOfClass:[NSNull class]]) {
        _textView.text = _contentText;
    }
    else {
        _textView.text = @"";
    }
    [self layoutComponents];
}

- (void)initNav
{
    self.view.backgroundColor = GLUIKIT_COLOR_BG_DEFAULT;
    
    self.navigationItem.leftBarButtonItem = [GLUIKitUtils leftBarButtonItemWithTarget:self
                                                                             selector:@selector(back)
                                                                             andTitle:@""];
    
    self.navigationItem.rightBarButtonItem = [GLUIKitUtils rightBarButtonItemWithTarget:self
                                                                               selector:@selector(doneEditing)
                                                                                  image:nil
                                                                               andTitle:@"完成"];
    _rightButtonItem = (GLBarButtonItem *)self.navigationItem.rightBarButtonItem;
}

#pragma mark - Setter & Getter
#pragma mark -

- (void)setMaxCharacterCount:(NSInteger)maxCharacterCount
{
    _maxCharacterCount = maxCharacterCount;
    [self updateCharacterLabelText];
}

- (void)setShowCharactersCount:(BOOL)showCharactersCount
{
    _showCharactersCount = showCharactersCount;
    self.characterContainerView.hidden = !showCharactersCount;
    [self layoutComponents];
    [self updateCharacterLabelText];
}

- (void)setText:(NSString*)text {
    
    if (_contentText != text) {
        _contentText = [text copy];
    }
    _textView.text = _contentText;
    _originalText = _textView.text;
    [self updateCharacterLabelText];
}


- (NSString *)text {
    return _contentText;
}

- (void)setHintText:(NSString*)hintText
{
    if ([hintText length] > 0) {
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2;
        
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : self.hintLabel.font,
                                   NSParagraphStyleAttributeName : style
                                   };
        
        self.hintLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:hintText attributes:attrDict];
        CGFloat offy = 10 + _contentBg.maxY;
        CGFloat hintLabelX = 10;
        CGFloat hintLabelW = self.view.frame.size.width - 2 * hintLabelX;
        self.hintLabel.frame = CGRectMake(hintLabelX, offy, hintLabelW, 80);
        [self.hintLabel sizeToFit];
        self.hintLabel.width = hintLabelW;
    }
    else {
        [_hintLabel removeFromSuperview];
        _hintLabel = nil;
    }
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.numberOfLines   = 0;
        _hintLabel.textAlignment   = NSTextAlignmentLeft;
        _hintLabel.font            = [UIFont systemFontOfSize:12];
        _hintLabel.backgroundColor = [UIColor clearColor];
        _hintLabel.textColor       = UIColorFromRGB(0x737373);
        [self.view addSubview:_hintLabel];
    }
    return _hintLabel;
}
- (UIView *)characterContainerView
{
    if (!_characterContainerView) {
        _characterContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentBg.maxY, self.view.width, 24)];
        _characterContainerView.backgroundColor = [UIColor whiteColor];
        [_characterContainerView addSubview:self.characterLabel];
    }
    return _characterContainerView;
}

- (UILabel *)characterLabel
{
    if (!_characterLabel) {
        CGFloat characterLabelH = self.characterContainerView.height;
        CGFloat characterLabelX = 10;
        CGFloat characterLabelW = self.view.width - 2 * characterLabelX;

        _characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(characterLabelX, 0, characterLabelW, characterLabelH)];
        _characterLabel.font = [UIFont systemFontOfSize:12];
        _characterLabel.textColor = UIColorFromRGB(0x9a9a9a);
        _characterLabel.textAlignment = NSTextAlignmentRight;
    }
    return _characterLabel;
}
@end
