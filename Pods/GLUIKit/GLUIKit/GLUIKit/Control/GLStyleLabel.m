//
//  GLPadEditLabel.m
//  iShoppingIPadLib
//
//  Created by GuDongHui on 13-12-25.
//
//

#import "GLStyleLabel.h"
#import <CoreText/CoreText.h>
#import "GLUIKitUtils.h"
#import "NSString+GLString.h"


typedef void(^ClickKeyWordBlock) (id);

@interface GLStyleLabel ()

//@property (nonatomic, assign) NSInteger offsetInt; ///< 用于计算位置
@property (nonatomic, strong) NSMutableAttributedString *attriText;
@property (nonatomic, strong) ClickKeyWordBlock clickKeyWordBlock;


@end


@implementation GLStyleLabel


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];

        self.text = @"";
        _stringColor = [UIColor blackColor];
        _keywordColor = UIColorFromRGB(0xbe0c0c);
        _clickKeyColor = UIColorFromRGB(0xbe0c0c);
        _compareOptionsType = 0;
        
        _keywordList = [[NSMutableArray alloc] init];
        _clickArr = [[NSMutableArray alloc] init];
//        _offsetInt = 0;

    }
    return self;
}



#pragma mark - ********************** 设置字符串颜色和关键字颜色 **********************

- (void)setUIlabelTextColor:(UIColor *)strColor andKeyWordColor: (UIColor *) keyColor {
    self.stringColor  = strColor;
    self.keywordColor = keyColor;
    self.clickKeyColor = keyColor;
}



#pragma mark - ********************** 设置显示的字符串和关键字。即将显示时调用此函数 **********************

- (void) setUILabelText:(NSString *)string andKeyWord:(NSString *)keyword {
    [_keywordList removeAllObjects];
    [_clickArr removeAllObjects];

    if (self.text != string) {
        self.text = string;
    }
    
    [self addKeyword:keyword];
}



#pragma mark - ********************** 设置显示的字符串、关键字、可点击关键字。即将显示时调用此函数 **********************

- (void)setUI2LabelText:(NSString *)string andKeyWord_StrOrArr:(id)keyWordStrOrArr fromClick_StrOrArr:(id)keyLickStrOrArr {
    [_keywordList removeAllObjects];
    [_clickArr removeAllObjects];
    
    if (self.text != string && [string length]>0) {
        self.text = string;
    }
    
    if (keyWordStrOrArr != nil) {
        if ([keyWordStrOrArr isKindOfClass:[NSArray class]] && [keyWordStrOrArr count] > 0) {
            for (NSString *keywordString in keyWordStrOrArr) {
                //self.offsetInt += [keywordString length];
                [self addKeyword:keywordString];
            }
        }else if([keyWordStrOrArr isKindOfClass:[NSString class]] && [keyWordStrOrArr length] > 0){
            //self.offsetInt = [keyWordStrOrArr length];
            [self addKeyword:keyWordStrOrArr];
        }
    }
    
    if (keyLickStrOrArr != nil) {
        if ([keyLickStrOrArr isKindOfClass:[NSArray class]] && [keyLickStrOrArr count] > 0) {
            for (id kewLick in keyLickStrOrArr) {
                [self addKeyLickRangeOfText:kewLick];
            }
        }else if([keyLickStrOrArr isKindOfClass:[NSString class]] && [keyLickStrOrArr length] > 0){
            [self addKeyLickRangeOfText:keyLickStrOrArr];
        }
    }
    
    [self setNeedsDisplay];
}



#pragma mark - ********************** 将关键字的位置和长度，存放在keywordList中 **********************

- (void)addKeyword:(NSString *)keyWord {
    NSString *textString = self.text;

    if (keyWord != nil && [keyWord length] > 0 && textString && [textString length] > 0) {
        NSRange range;
        if (_compareOptionsType == 1) {
            range = [textString rangeOfString:keyWord options:NSCaseInsensitiveSearch];//NSCaseInsensitiveSearch 不区分大小写
        } else {
            range  = [textString rangeOfString:keyWord];
        }

        NSValue *value = [NSValue valueWithRange:range];
        if (range.length > 0) {
            [_keywordList addObject:value];
        }
    }
}



#pragma mark - ********************** 将可点击关键字在Text中的位置信息，存放在clickArr中 **********************

- (void)addKeyLickRangeOfText:(id)keyLickWord
{
    if ([keyLickWord isKindOfClass:[NSString class]]  && [self.text length]>0) {
        NSString *textString = self.text;//[self.text substringFromIndex:_offsetInt];
        
        if (keyLickWord != nil && [keyLickWord length] > 0) {
            NSRange range;
            if (_compareOptionsType == 1) {
                range = [textString rangeOfString:keyLickWord options:NSCaseInsensitiveSearch];//NSCaseInsensitiveSearch 不区分大小写
            } else {
                range  = [textString rangeOfString:keyLickWord];
            }
            //range.location += _offsetInt;
            NSValue *value = [NSValue valueWithRange:range];
            if (range.length > 0) {
                [self.clickArr addObject:value];
            }
        }
    }
    
    
}


#pragma mark - ********************** 绘制 **********************

- (void)drawRect:(CGRect)rect
{
    NSString *text = self.text;
    
    //设置颜色属性和字体属性
    //绘制不同颜色
    NSUInteger len = [text length];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText beginEditing];

    [attributedText addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.stringColor.CGColor range:NSMakeRange(0, len)];
    if (self.keywordColor != nil  && [_keywordList count] > 0){
        for (NSValue *value in _keywordList){
            NSRange keyRange = [value rangeValue];
            NSUInteger maxLength = keyRange.location + keyRange.length;
            if (maxLength <= len) {
                [attributedText addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.keywordColor.CGColor range:keyRange];
            }
        }
    }
    
    if (self.clickKeyColor != nil && [_clickArr count] > 0){
        for (NSValue *value in _clickArr){
            NSRange keyRange = [value rangeValue];
            if (keyRange.length + keyRange.location <= len) {
                [attributedText addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.clickKeyColor.CGColor range:keyRange];
                //下划线
                if (_isShowUnderline) {
                    [attributedText addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:keyRange];
                }
            }
        }
    }
    
    
    NSInteger nNumType = 0;
    CFNumberRef cfNum = CFNumberCreate(NULL, kCFNumberIntType, &nNumType);
    [attributedText addAttribute:(NSString *)kCTLigatureAttributeName value:(__bridge id)cfNum range:NSMakeRange(0, len)];
    CFRelease(cfNum);

    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [attributedText addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont2 range:NSMakeRange(0, len)];
    CFRelease(ctFont2);

 
    //对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;//默认左对齐
    if (self.textAlignment == NSTextAlignmentCenter) {//居中
        alignment = kCTCenterTextAlignment;
    }
    else if (self.textAlignment == NSTextAlignmentRight) {//右对齐
        alignment = kCTRightTextAlignment;
    }

    
    
    //绘制换行
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;//换行模式
    //if (self.lineBreakMode == NSLineBreakByTruncatingTail) {
    //      lineBreakMode = kCTLineBreakByTruncatingTail;	/* Truncate at tail of line: "abcd..." */
    //}

    
    CGFloat lineSpacing = 3;//行间距
    CTParagraphStyleSetting paraStyles[3] = {
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
        {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        {.spec = kCTParagraphStyleSpecifierLineSpacing,.valueSize = sizeof(CGFloat), .value = (const void*)&lineSpacing},
    };
    CTParagraphStyleRef style = CTParagraphStyleCreate(paraStyles,3);
    [attributedText addAttribute:(NSString*)(kCTParagraphStyleAttributeName) value:(__bridge id)style range:NSMakeRange(0,[text length])];
    CFRelease(style);

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);//重置
    
    //y轴高度//x，y轴方向移动/*self.bounds.size.height*/
//    CGContextTranslateCTM(context,0,0);
    
    //y轴翻转//缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1, -1);
    
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
	CGContextSaveGState(context);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedText);
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL, CGRectMake(0, -ceill(self.bounds.size.height), self.bounds.size.width, self.bounds.size.height));

    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), leftColumnPath, NULL);
    CTFrameDraw(leftFrame, context);
    CGContextRestoreGState(context);
    UIGraphicsPushContext(context);
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    CFRelease(leftFrame);
//    if ([_clickArr count] > 0 && _clickKeyWordBlock != nil) {
        self.attriText = attributedText;
//    }
    [attributedText endEditing];
}



- (void)setClickKeyWordFromBlock:(void(^)(id clickInfo))clickBlock {
    if (clickBlock) {
        self.userInteractionEnabled = YES;
        self.clickKeyWordBlock = clickBlock;
    }else {
        self.userInteractionEnabled = NO;
        self.clickKeyWordBlock = nil;
    }
}

//执行事件
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_clickArr count] > 0 && _clickKeyWordBlock != nil && _attriText != nil){
        UITouch *touch = [touches anyObject];
        
        if ([touch tapCount] == 1) {
            BOOL isEditLick = YES;
            
            //取点击位置
            CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
            
            //创建CTFrame,attString为NSMutableAttributedString
            CGMutablePathRef mainPath = CGPathCreateMutable();
            CGPathAddRect(mainPath, NULL, CGRectMake(0, -ceill(self.bounds.size.height), self.bounds.size.width, self.bounds.size.height));
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attriText);
            CTFrameRef ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), mainPath, NULL);
            
            //取文字行数
            NSArray *lines = (NSArray *)CTFrameGetLines(ctframe);
            NSInteger lineCount = [lines count];
            CGPoint origins[lineCount];
            
            //判断有文字
            if (lineCount != 0) {
                //每行起始位置
                CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
                
                //每行
                for (NSInteger i = 0; i < lineCount; i++) {
                    //一行起始坐标
                    CGPoint baselineOrigin = origins[i];
                    
                    //取真正起始y
                    baselineOrigin.y = CGRectGetHeight(self.frame) - baselineOrigin.y;
                    
                    CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
                    CGFloat ascent, descent;
                    //取行高,行宽
                    CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
                    //取一行真正面积
                    CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
                    //判断点击在不在范围内
                    if (CGRectContainsPoint(lineFrame, point)) {
                        CGPoint wPoint = point;
                        wPoint.x += lineFrame.origin.x;
                        //取被点击字符位置
                        CFIndex index = CTLineGetStringIndexForPosition(line, wPoint);
                        //取所有可以点击的字符range
                        if ([_clickArr count] > 0) {
                            for (NSInteger i=0 ; i < [_clickArr count] ; i++){
                                NSValue *value = [_clickArr objectAtIndex:i];
                                NSRange keyRange = [value rangeValue];
                                //判断,如果点击在range内则执行
                                if (index >= keyRange.location && index <= keyRange.location + keyRange.length ) {
                                    //通过Key取值,要点击的值
                                    if (isEditLick) {
                                        if(_clickKeyWordBlock) {
                                            _clickKeyWordBlock([NSNumber numberWithInteger:i]);
                                        }
                                        isEditLick = NO;
                                    }
                                    //做动作
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            
            CGPathRelease(mainPath);
            CFRelease(framesetter);
            CFRelease(ctframe);
        }
    }
}

@end

