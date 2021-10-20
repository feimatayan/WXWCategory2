//
//  WDIETextEditView.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/2/7.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIETextEditView.h"
#import "WDIEColorBar.h"
#import "WDIEUtils.h"
#import <Masonry/Masonry.h>
#import "WDIEMacros.h"

#define kWDIEColorBarWidth [UIScreen mainScreen].bounds.size.width > 1080 ? 1080 : [UIScreen mainScreen].bounds.size.width

@interface WDIETextEditView() <UITextViewDelegate>

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIVisualEffectView *visualView;

@property (nonatomic, strong) WDIEColorBar *colorBar;

@property (nonatomic, strong) UITextView *textView;

@end


@implementation WDIETextEditView

#pragma mark - Getter & Setter

- (NSString *)text {
	return self.textView.text;
}

- (void)setText:(NSString *)text {
	self.textView.text = text;
}

- (void)setColors:(NSArray<UIColor *> *)colors {
	self.colorBar.colors = colors;
}

- (NSArray<UIColor *> *)colors {
	return self.colorBar.colors;
}

- (NSUInteger)selectedIndex {
	return self.colorBar.selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
	self.colorBar.selectedIndex = selectedIndex;
	self.textView.textColor = self.colorBar.selectedColor;
}

#pragma mark - Init

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init {
	return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		
		_limitLength = 100;
		
		[self setupViews];
		[self setupConstraints];
		[self setupObservers];
	}
	
	return self;
}

#pragma mark - Setup

- (void)setupViews
{
	self.backgroundColor = UIColor.clearColor;
	
	UIBlurEffect *bluerEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	_visualView = [[UIVisualEffectView alloc] initWithEffect:bluerEffect];
	[self addSubview:_visualView];
	
	_textView = [[UITextView alloc] init];
	_textView.font = [UIFont systemFontOfSize:32];
	_textView.textColor = [WDIEUtils wdie_colorFromRGB:0xFFFFFF];
	_textView.backgroundColor = UIColor.clearColor;
	_textView.delegate = self;
	[self addSubview:_textView];
	
	_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[_cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[_cancelButton addTarget:self action:@selector(tappedOnCancelButton:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_cancelButton];
	
	_doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_doneButton setTitle:@"完成" forState:UIControlStateNormal];
	[_doneButton setTitleColor:[WDIEUtils wdie_colorFromRGB:0xF6402B] forState:UIControlStateNormal];
	[_doneButton addTarget:self action:@selector(tappedOnDoneButton:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_doneButton];
	
	NSArray *colors = @[
						[WDIEUtils wdie_colorFromRGB:0xF7F7F7],
						[WDIEUtils wdie_colorFromRGB:0x2B2B2B],
						[WDIEUtils wdie_colorFromRGB:0xFF1D12],
						[WDIEUtils wdie_colorFromRGB:0xFBF606],
						[WDIEUtils wdie_colorFromRGB:0x14E213],
						[WDIEUtils wdie_colorFromRGB:0x199BFF],
						[WDIEUtils wdie_colorFromRGB:0x8C06FF],
						[WDIEUtils wdie_colorFromRGB:0xF902FF]
						];
	_colorBar = [[WDIEColorBar alloc] initWithColors:colors];
	_colorBar.selectedIndex = 0;
	__weak typeof (self) weakSelf = self;
	_colorBar.selectedColorBlock = ^(UIColor *color, NSUInteger index) {
		weakSelf.textView.textColor = color;
	};
	[self addSubview:_colorBar];
}

- (void)setupConstraints
{
	UIView *superView = self;
	CGFloat padding = 20;
	
	[_visualView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(superView);
	}];
	
    CGFloat bottomHeight = 0;
    CGFloat topHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        bottomHeight = mainWindow.safeAreaInsets.bottom;
        topHeight = mainWindow.safeAreaInsets.top;
    }
    
	[_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(superView).offset(padding);
//        make.top.equalTo(superView).offset(WDIE_IS_DEVICE_IPHONE_X ? padding + 24 : padding);
        make.top.equalTo(superView).offset(padding + topHeight);
	}];
	
	[_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superView).offset(WDIE_IS_DEVICE_IPHONE_X ? padding + 24 : padding);
        make.top.equalTo(superView).offset(padding + topHeight);
		make.right.equalTo(superView).offset(-padding);
	}];
	
	[_textView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.cancelButton.mas_bottom).offset(padding);
		make.left.equalTo(superView).offset(padding);
		make.right.equalTo(superView).offset(-padding);
		make.bottom.equalTo(self.colorBar.mas_top).offset(-padding);
	}];

	[_colorBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(superView);
		make.width.equalTo(@(kWDIEColorBarWidth - 40));
		make.height.equalTo(@60);
		make.bottom.equalTo(superView).offset(-padding);
	}];
}

- (void)setupObservers {
	
	// 注册键盘出现的通知
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification object:nil];
	// 注册键盘消失的通知
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard

- (void) keyboardWillShow:(NSNotification *)notification
{
	NSDictionary* info = [notification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	
	[self.colorBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.width.equalTo(@(kWDIEColorBarWidth - 40));
		make.height.equalTo(@60);
		make.bottom.equalTo(self).offset(-kbSize.height);
	}];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self layoutIfNeeded];
	}];
}

- (void) keyboardWillHide:(NSNotification *)notification
{
	[self.colorBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.width.equalTo(@(kWDIEColorBarWidth - 40));
		make.height.equalTo(@60);
		make.bottom.equalTo(self).offset(-20);
	}];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self layoutIfNeeded];
	}];
}

#pragma mark - User Interaction

- (void)tappedOnCancelButton:(UIButton *)button
{
	if(_delegate && [_delegate respondsToSelector:@selector(textEditViewDidCancel:)]) {
		[_delegate textEditViewDidCancel:self];
	}
	
	[self.textView resignFirstResponder];
}

- (void)tappedOnDoneButton:(UIButton *)button
{
	if(_delegate && [_delegate respondsToSelector:@selector(textEditView:didFinishWithText:andColor:)]) {
		NSString *text = [NSString stringWithString:self.text];
		UIColor *color = [UIColor colorWithCGColor:self.textView.textColor.CGColor];
		[_delegate textEditView:self didFinishWithText:text andColor:color];
	}
	
	[self.textView resignFirstResponder];
}

#pragma mark - Public

- (void)presentFromView:(UIView *)view animated:(BOOL)animated completion:(void(^)(void))completion {
	
	if(!animated) {
		[view addSubview:self];
		if(completion) {
			completion();
		}
		return;
	}
	
	CGRect rect = self.frame;
	rect.origin.y = [UIScreen mainScreen].bounds.size.height;
	self.frame = rect;
	[view addSubview:self];
	[UIView animateWithDuration:0.5 animations:^{
		CGRect rect = self.frame;
		rect.origin.y = 0;
		self.frame = rect;
	} completion:^(BOOL finished){
		if(completion) {
			completion();
		}
		[self.textView becomeFirstResponder];
	}];
}

- (void)dismissWithAnimated:(BOOL)animated completion:(void(^)(void))completion; {
	
	if(!animated) {
		[self removeFromSuperview];
		if(completion){
			completion();
		}
		return;
	}
	
	[UIView animateWithDuration:0.5 animations:^{
		CGRect rect = self.frame;
		rect.origin.y = [UIScreen mainScreen].bounds.size.height;
		self.frame = rect;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		if(completion) {
			completion();
		}
	}];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
	if(textView.text && textView.text.length > _limitLength) {
		textView.text = [textView.text substringToIndex:_limitLength];
	}
}

@end


