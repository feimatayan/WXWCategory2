//
//  WDIEImageEditor.m
//  WDImageEditor
//
//  Created by WangYiqiao on 2018/1/10.
//  Copyright © 2018年 weidian. All rights reserved.
//

#import "WDIEImageEditor.h"
#import "WDIEImageCanvas.h"
#import "WDIEUtils.h"
#import <Masonry/Masonry.h>
#import "WDIEColorBar.h"
#import "WDIEDrawLineView.h"
#import "WDIECropViewController.h"
#import "WDIETextEditView.h"
#import "WDIETextLabel.h"
#import "WDIETextDisplayView.h"
#import "WDIEMacros.h"
#import "WDIETranslucentView.h"
#import "WDIEStatisticsDefines.h"

@interface WDIEImageEditor () <WDIEDrawLineViewDelegate, WDIECropViewControllerDelegate, WDIETextEditViewDelegate, WDIETextDisplayViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) WDIEImageCanvas *canvas;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *finishButton;

@property (nonatomic, strong) UIButton *drawButton;

@property (nonatomic, strong) UIButton *textButton;

@property (nonatomic, strong) UIButton *cropButton;

@property (nonatomic, strong) UIButton *cleanButton;

@property (nonatomic, strong) WDIEColorBar *colorBar;

@property (nonatomic, strong) UIButton *deleteTextButton;

@property (nonatomic, strong) WDIETranslucentView *bottomBgView;

@property (nonatomic, strong) WDIETranslucentView *topBgView;

@property (nonatomic, assign) BOOL isShowTools;

@property (nonatomic, assign) BOOL isAddNewText;

@property (nonatomic, weak) WDIETextDisplayView *selectedDisplayView;

@property (nonatomic, strong) NSMutableArray *displayTextViews;

@end

@implementation WDIEImageEditor

#pragma mark - Getters & Setters

- (NSMutableArray *)displayTextViews {
	
	if(!_displayTextViews) {
		_displayTextViews = [NSMutableArray array];
	}
	
	return _displayTextViews;
}

- (instancetype)initWithImage:(UIImage *)image {
	return [self initWithImage:image delegate:nil];
}

- (instancetype)initWithImage:(UIImage *)image delegate:(id<WDIEImageEditorDelegate>)delegate {
	if (self = [super init]) {
		_image = image;
		_isShowTools = YES;
		_delegate = delegate;
	}
	
	return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	WDIE_STATISTICS(WDIESID_060101,nil);
	
	[self setupUI];
	
	[self makeConstraints];
}

#pragma mark - Setup

- (void)setupUI {
	
	self.view.backgroundColor = UIColor.blackColor;
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnView:)];
	self.view.userInteractionEnabled = YES;
	tapGesture.delegate = self;
	[self.view addGestureRecognizer:tapGesture];
	
	_canvas = [[WDIEImageCanvas alloc] init];
	_canvas.image = self.image;
	[_canvas setDrawLineViewDelegate:self];
	[self.view addSubview:_canvas];
	
	_bottomBgView = [[WDIETranslucentView alloc] initWithStartPoint:CGPointMake(0, 0) andEndPoint:CGPointMake(0, 1)];
	_bottomBgView.backgroundColor = [[WDIEUtils wdie_colorFromRGB:0x4B4B4B] colorWithAlphaComponent:0.5];
	[self.view addSubview:_bottomBgView];
	
	_topBgView = [[WDIETranslucentView alloc] initWithStartPoint:CGPointMake(0, 1) andEndPoint:CGPointMake(0, 0)];
	_topBgView.backgroundColor = [[WDIEUtils wdie_colorFromRGB:0x4B4B4B] colorWithAlphaComponent:0.5];
	[self.view addSubview:_topBgView];
	
	_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[_cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[_cancelButton addTarget:self action:@selector(tappedOnCancelButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_cancelButton];
	
	_finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_finishButton setTitle:@"完成" forState:UIControlStateNormal];
	[_finishButton setTitleColor:[WDIEUtils wdie_colorFromRGB:0xF6402B] forState:UIControlStateNormal];
	[_finishButton addTarget:self action:@selector(tappedOnFinishButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_finishButton];
	
	_drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_drawButton setImage:[UIImage imageNamed:@"WDIE_Draw_Unselected"] forState:UIControlStateNormal];
	[_drawButton setImage:[UIImage imageNamed:@"WDIE_Draw_Selected"] forState:UIControlStateSelected];
	[_drawButton setImage:[UIImage imageNamed:@"WDIE_Draw_Selected"] forState:UIControlStateHighlighted];
	[_drawButton addTarget:self action:@selector(tappedOnDrawButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_drawButton];
	
	_textButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_textButton setImage:[UIImage imageNamed:@"WDIE_Text_UnSelected"] forState:UIControlStateNormal];
	[_textButton setImage:[UIImage imageNamed:@"WDIE_Text_Selected"] forState:UIControlStateSelected];
	[_textButton setImage:[UIImage imageNamed:@"WDIE_Text_Selected"] forState:UIControlStateHighlighted];
	[_textButton addTarget:self action:@selector(tappedOnTextButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_textButton];
	
	_cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cropButton setImage:[UIImage imageNamed:@"WDIE_Crop"] forState:UIControlStateNormal];
	[_cropButton setImage:[UIImage imageNamed:@"WDIE_Crop"] forState:UIControlStateSelected];
	[_cropButton setImage:[UIImage imageNamed:@"WDIE_Crop_Highlighted"] forState:UIControlStateHighlighted];
	[_cropButton addTarget:self action:@selector(tappedOnCropButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_cropButton];
	
	_colorBar = [[WDIEColorBar alloc] init];
	__weak typeof (self) weak_self = self;
	_colorBar.selectedColorBlock = ^(UIColor *color, NSUInteger index) {
		[weak_self.canvas setDrawLineColor:color];
	};
	_colorBar.hidden = YES;
	_colorBar.selectedIndex = 2;
	[self.view addSubview:_colorBar];
	
	_cleanButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cleanButton setImage:[UIImage imageNamed:@"WDIE_Draw_Clean"] forState:UIControlStateNormal];
	[_cleanButton setImage:[UIImage imageNamed:@"WDIE_Draw_Clean"] forState:UIControlStateHighlighted];
	[_cleanButton setImage:[UIImage imageNamed:@"WDIE_Draw_Clean"] forState:UIControlStateSelected];
	[_cleanButton setImage:[UIImage imageNamed:@"WDIE_Draw_Clean_Disabled"] forState:UIControlStateDisabled];
	[_cleanButton addTarget:self action:@selector(tappedOnCleanButton:) forControlEvents:UIControlEventTouchUpInside];
	_cleanButton.hidden = YES;
	_cleanButton.enabled = NO;
	[self.view addSubview:_cleanButton];
	
	_deleteTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_deleteTextButton.hidden = YES;
	[_deleteTextButton setImage:[UIImage imageNamed:@"WDIE_Text_Trash"] forState:UIControlStateNormal];
	[_deleteTextButton setImage:[UIImage imageNamed:@"WDIE_Text_Trash_Highlighed"] forState:UIControlStateHighlighted];
	[_deleteTextButton setTitle:@"拖到此处删除" forState:UIControlStateNormal];
	[_deleteTextButton setTitle:@"松手即可删除" forState:UIControlStateHighlighted];
	[_deleteTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[_deleteTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	_deleteTextButton.titleEdgeInsets = UIEdgeInsetsMake(24, -20, 0, 0);
	_deleteTextButton.imageEdgeInsets = UIEdgeInsetsMake(-16, 48, 0, -30);
	_deleteTextButton.titleLabel.font = [UIFont systemFontOfSize:12];
	[self.view addSubview:_deleteTextButton];
}

- (void)makeConstraints {
	UIView *superview = self.view;
	CGFloat padding = 20;
	
	[_canvas mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(superview);
	}];
	
    CGFloat bottomHeight = 0;
    CGFloat topHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        bottomHeight = mainWindow.safeAreaInsets.bottom;
        topHeight = mainWindow.safeAreaInsets.top;
    }
	[_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.bottom.equalTo(superview);
//        make.height.equalTo(WDIE_IS_DEVICE_IPHONE_X ? @(128 + WDIE_IPHONE_X_TOOLBAR_HEIGHT) : @128);
        make.height.equalTo(@(128 + bottomHeight));
	}];
	
	[_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.top.equalTo(superview);
//        make.height.equalTo(WDIE_IS_DEVICE_IPHONE_X ? @(64 + WDIE_IPHONE_X_STATUS_HEIGHT) : @(64));
        make.height.equalTo(@(64 + topHeight));
	}];
	
	[_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(superview).offset(padding);
//        make.top.equalTo(superview).offset(WDIE_IS_DEVICE_IPHONE_X ? padding + WDIE_IPHONE_X_STATUS_HEIGHT : padding);
        make.top.equalTo(superview).offset(padding + topHeight);
	}];
	
	[_finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(superview).offset(WDIE_IS_DEVICE_IPHONE_X ? padding + WDIE_IPHONE_X_STATUS_HEIGHT : padding);
        make.top.equalTo(superview).offset(padding + topHeight);
		make.right.equalTo(superview).offset(-padding);
	}];
	
	[_textButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(superview);
//        make.bottom.equalTo(superview).offset(WDIE_IS_DEVICE_IPHONE_X ? -padding - WDIE_IPHONE_X_TOOLBAR_HEIGHT : -padding);
        make.bottom.equalTo(superview).offset(-padding - bottomHeight);
		make.width.equalTo(@32);
		make.height.equalTo(@32);
	}];
	
	[_drawButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.textButton.mas_left).offset(-56);
//        make.bottom.equalTo(superview).offset(WDIE_IS_DEVICE_IPHONE_X ? -padding - WDIE_IPHONE_X_TOOLBAR_HEIGHT : -padding);
        make.bottom.equalTo(superview).offset(-padding - bottomHeight);
		make.width.equalTo(@32);
		make.height.equalTo(@32);
	}];
	
	[_cropButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.textButton.mas_right).offset(56);
//        make.bottom.equalTo(superview).offset(WDIE_IS_DEVICE_IPHONE_X ? -padding - WDIE_IPHONE_X_TOOLBAR_HEIGHT : -padding);
        make.bottom.equalTo(superview).offset(-padding - bottomHeight);
		make.width.equalTo(@32);
		make.height.equalTo(@32);
	}];
	
	[_cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.textButton.mas_top).offset(-padding * 2);
		make.right.equalTo(superview).offset(-padding);
		make.width.equalTo(@30);
		make.height.equalTo(@34);
	}];
	
	[_deleteTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(superview);
		make.width.equalTo(self.view);
		make.height.equalTo(@56);
		make.top.equalTo(superview.mas_bottom);
	}];
	
	CGFloat colorBarWidth = [UIScreen mainScreen].bounds.size.width;
	if (colorBarWidth > 1080) {
		colorBarWidth = 1080;
	}
	//减去两遍的间距和cleanButton的宽度
	colorBarWidth = colorBarWidth - 20 - 30 - 20 - 20;
	[_colorBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.cleanButton.mas_left).offset(-padding);
		make.centerY.equalTo(self.cleanButton);
		make.width.equalTo(@(colorBarWidth));
		make.height.equalTo(@60);
	}];
}

#pragma mark - Private Helper

- (void)showOrHideTools:(BOOL)show delay:(NSTimeInterval)delay
{	
	dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay);
	__weak typeof (self) weak_self = self;
	dispatch_after(delayTime, dispatch_get_main_queue(), ^{
		[UIView transitionWithView:weak_self.view duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			weak_self.cancelButton.hidden = !show;
			weak_self.finishButton.hidden = !show;
			weak_self.drawButton.hidden = !show;
			weak_self.textButton.hidden = !show;
			weak_self.cropButton.hidden = !show;
			weak_self.bottomBgView.hidden = !show;
			weak_self.topBgView.hidden = !show;
			if(weak_self.drawButton.isSelected) {
				weak_self.colorBar.hidden = !show;
				weak_self.cleanButton.hidden = !show;
			}
			
		} completion:nil];
	});
}

- (void)showTrashButton:(BOOL)show {
	self.deleteTextButton.hidden = !show;
	
    CGFloat bottomHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        bottomHeight = mainWindow.safeAreaInsets.bottom;
    }
    
	[_deleteTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.width.equalTo(self.view);
//        make.height.equalTo(WDIE_IS_DEVICE_IPHONE_X ? @(56+WDIE_IPHONE_X_TOOLBAR_HEIGHT): @56);
        make.height.equalTo(@(56 + bottomHeight));
		if(show){
			make.bottom.equalTo(self.view);
		} else {
			make.top.equalTo(self.view.mas_bottom);
		}
	}];
	
	[UIView animateWithDuration:0.25 animations:^{
		[self.view layoutIfNeeded];
	}];
}

- (void)clearCanvas {
	
	// 清空画板
	for(UIView *view in self.displayTextViews) {
		[view removeFromSuperview];
	}
	
	self.selectedDisplayView = nil;
}

- (void)hideTextBorder {
	for(WDIETextDisplayView *view in self.displayTextViews) {
		view.borderHidden = YES;
	}
}

#pragma mark - User Interaction

- (void)tappedOnCancelButton:(UIButton *)button {
	[self.delegate imageEditorDidCancel:self];
	
	WDIE_STATISTICS(WDIESID_060102,@{WDIESParamsKey:@"取消"});
}

- (void)tappedOnFinishButton:(UIButton *)button {
	
	// 隐藏文本框的边框
	[self hideTextBorder];
	[self.canvas resetZoomScale];
	
	UIImage *image = [self.canvas generateImage];
	[self.delegate imageEditor:self finishWithImage:image];
	
	WDIE_STATISTICS(WDIESID_060102,@{WDIESParamsKey:@"完成"});
}

- (void)tappedOnDrawButton:(UIButton *)button {
	button.selected = !button.selected;
	self.colorBar.hidden = !button.selected;
	self.cleanButton.hidden = !button.selected;
	[self.canvas enableDraw:button.selected];
}

- (void)tappedOnTextButton:(UIButton *)button {
	
	WDIETextEditView *textEditView = [[WDIETextEditView alloc] init];
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	textEditView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
	textEditView.delegate = self;
	[textEditView presentFromView:self.view animated:YES completion:nil];
	
	self.isAddNewText = YES;
	
	WDIE_STATISTICS(WDIESID_060103,nil);
}

- (void)tappedOnCropButton:(UIButton *)button {
	
	[self hideTextBorder];
	[self.canvas resetZoomScale];
	UIImage *image = [self.canvas generateImage];
	
	WDIECropViewController *cropper = [[WDIECropViewController alloc] initWithImage:image];
	cropper.aspectRatioPickerButtonHidden = YES;
	cropper.resetButtonHidden = YES;
	cropper.rotateClockwiseButtonHidden = YES;
	cropper.delegate = self;
	[self presentViewController:cropper animated:YES completion:nil];
	
	WDIE_STATISTICS(WDIESID_060106, nil);
}

- (void)tappedOnCleanButton:(UIButton *)button {
	[self.canvas cleanLastLine];
}

- (void)tappedOnView:(UIGestureRecognizer *)gesture {
	
	if(self.selectedDisplayView && !self.selectedDisplayView.borderHidden) {
		self.selectedDisplayView.borderHidden = YES;
		return;
	}
	
	self.isShowTools = !self.isShowTools;
	[self showOrHideTools:self.isShowTools delay:0];
}

#pragma mark - Public

#pragma mark - WDIEDrawLineView Delegate

- (void)drawLineView:(WDIEDrawLineView *)drawLineView lineCountChanged:(NSUInteger)lineCount {
	self.cleanButton.enabled = lineCount > 0;
}

- (void)darwLineViewTouchMoved:(WDIEDrawLineView *)drawLineView {
	if (self.isShowTools) {
		self.isShowTools = NO;
		[self showOrHideTools:NO delay:0];
	}
}

- (void)darwLineViewTouchEnded:(WDIEDrawLineView *)drawLineView {
	if (!self.isShowTools) {
		self.isShowTools = YES;
		[self showOrHideTools:YES delay:0.5];
	}
}

#pragma mark - WDIECropViewControllerDelegate

- (void)cropViewController:(WDIECropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
	[cropViewController dismissViewControllerAnimated:NO completion:nil];
	WDIE_STATISTICS(WDIESID_060107, @{WDIESParamsKey:@"取消"});
}

- (void)cropViewController:(nonnull WDIECropViewController *)cropViewController didCropToImage:(nonnull UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle  {
	[cropViewController dismissViewControllerAnimated:NO completion:nil];
	self.canvas.image = image;
	
	[self clearCanvas];
	
	WDIE_STATISTICS(WDIESID_060107, @{WDIESParamsKey:@"完成"});
}

#pragma mark - WDIETextEditView Delegate

- (void)textEditViewDidCancel:(WDIETextEditView *)textEditView {
	[textEditView dismissWithAnimated:YES completion:nil];
	
	WDIE_STATISTICS(WDIESID_060104, @{WDIESParamsKey:@"取消"});
}

- (void)textEditView:(WDIETextEditView *)textEditView didFinishWithText:(NSString *)text andColor:(UIColor *)color {
	
	[textEditView dismissWithAnimated:YES completion:nil];
	
	if(!text || text.length <= 0) {
		if(!self.isAddNewText && self.selectedDisplayView) {
			[self.displayTextViews removeObject:self.selectedDisplayView];
			[self.selectedDisplayView removeFromSuperview];
		}
		return;
	}
	
	WDIETextDisplayView *displyView;
	
	if(!self.isAddNewText && self.selectedDisplayView) {
		displyView = self.selectedDisplayView;
		displyView.anchor = displyView.center;
		displyView.borderHidden = NO;
	} else {
		displyView = [[WDIETextDisplayView alloc] init];
		displyView.anchor = CGPointMake(CGRectGetMidX(self.canvas.drawView.bounds), CGRectGetMidY(self.canvas.drawView.bounds));
		[self.canvas.drawView addSubview:displyView];
		
		self.selectedDisplayView = displyView;
		[self.displayTextViews addObject:displyView];
	}
	
	CGFloat preferredTextWidth = [UIScreen mainScreen].bounds.size.width - 40;
	displyView.index = textEditView.selectedIndex;
	displyView.text = text;
	displyView.textColor = color;
	displyView.preferredTextWidth = preferredTextWidth;
	displyView.delegate = self;
	
	WDIE_STATISTICS(WDIESID_060104, @{WDIESParamsKey:@"完成"});
}

#pragma mark - WDIETextDisplayViewDelegate

- (void)textDisplayViewMoved:(WDIETextDisplayView *)textDisplayView
{
	if(self.deleteTextButton.isHidden) {
		[self showOrHideTools:NO delay:0];
		[self showTrashButton:YES];
	}
	
	// 检测是否滑动到底部删除按钮区域
	CGPoint center = [self.canvas.drawView convertPoint:textDisplayView.center toView:self.view];
	if(CGRectContainsPoint(self.deleteTextButton.frame, center)) {
		self.deleteTextButton.highlighted = YES;
	} else {
		self.deleteTextButton.highlighted = NO;
	}
	
	WDIE_STATISTICS(WDIESID_060104, @{WDIESParamsKey:@"删除"});
}

- (void)textDisplayViewDidEndMove:(WDIETextDisplayView *)textDisplayView {
	
	CGPoint center = [self.canvas.drawView convertPoint:textDisplayView.center toView:self.view];
	
	// 检测是否滑动到底部删除按钮区域 是则移除
	if(CGRectContainsPoint(self.deleteTextButton.frame, center)) {
		[textDisplayView removeFromSuperview];
		self.deleteTextButton.highlighted = NO;
		[self.displayTextViews removeObject:textDisplayView];
		self.selectedDisplayView = nil;
	}
	// 检测是否超出可滑动区域 超出则滑动到中心点
	else if(!CGRectContainsPoint(self.canvas.drawView.bounds, textDisplayView.center)) {
		[UIView animateWithDuration:0.25 animations:^{
			textDisplayView.center = CGPointMake((CGRectGetMidX(self.canvas.drawView.bounds)), CGRectGetMidY(self.canvas.drawView.bounds));
		}];
	}
	
	[self showTrashButton:NO];
	[self showOrHideTools:YES delay:0];
}

- (void)textDisplayViewDidBecomeActive:(WDIETextDisplayView *)textDisplayView {
	if(self.selectedDisplayView != textDisplayView) {
		self.selectedDisplayView.borderHidden = YES;
		self.selectedDisplayView = textDisplayView;
	}
}

- (void)textDisplayViewTaped:(WDIETextDisplayView *)textDisplayView {
	if(textDisplayView.borderHidden) {
		textDisplayView.borderHidden = NO;
	} else {
		WDIETextEditView *textEditView = [[WDIETextEditView alloc] init];
		CGSize screenSize = [UIScreen mainScreen].bounds.size;
		textEditView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
		textEditView.selectedIndex = textDisplayView.index;
		textEditView.text = textDisplayView.text;
		textEditView.delegate = self;
		[textEditView presentFromView:self.view animated:YES completion:nil];
		
		self.isAddNewText = NO;
	}
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
	
	// 如果Tap手势在colorbar和cleanButton区域 则取消处理
	if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
		CGPoint location = [(UITapGestureRecognizer *)gestureRecognizer locationInView:self.view];
		
		if(!self.colorBar.isHidden && CGRectContainsPoint(self.colorBar.frame, location)) {
			return NO;
		}
		
		if(!self.cleanButton.isHidden && CGRectContainsPoint(self.cleanButton.frame, location)) {
			return NO;
		}
	}
	
	return YES;
}

@end
