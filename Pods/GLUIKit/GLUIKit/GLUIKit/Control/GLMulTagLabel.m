//
//  GLMulTagLabel.m
//  iShopIPhoneLib
//
//  Created by jfzhao on 14-3-31.
//
//

#import "GLMulTagLabel.h"
#import <CoreText/CoreText.h>


@implementation GLMulTagLabel

@synthesize strText;
@synthesize textColor;
@synthesize tagColor;
@synthesize linkColor;
@synthesize attriText;
@synthesize font;
@synthesize textAlignment;
@synthesize isLinkShowUnderline;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor  = tagNormalTextcolor;
        self.font       = [UIFont systemFontOfSize:17];
        self.textAlignment = NSTextAlignmentLeft;
        self.isLinkShowUnderline  = YES;
        self.textVAlignmentCenter  = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _tagRange   = [[NSMutableArray alloc] init];
        _linkRange  = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.clickDelegate = nil;
    
    _tagRange = nil;
    
    _linkRange = nil;
    
    self.strText    = nil;
    self.textColor  = nil;
    self.tagColor   = nil;
    self.linkColor  = nil;
    
    self.attriText  = nil;
    self.font       = nil;
    self.textAlignment =NSTextAlignmentLeft;
    
}

- (void) setText:(NSString *)aText
{
    [self setText:aText tags:nil link:nil];
}

- (void) setText:(NSString *)aText tags:(NSString*)aTags
{
     [self setText:aText tags:aTags link:nil];
}

//strText中包含strTags和arrName
- (void) setText:(NSString *)aText tags:(NSString*)aTags link:(NSArray*)arrName
{
    if (!aText || [aText length] <= 0) {
        return;
    }
    aTags = (aTags)?aTags:@"";
    self.strText = [NSString stringWithFormat:@"%@%@",aTags,aText];
    
    //layout
     [self layoutText:self.strText tags:aTags link:arrName];
    

    if (self.textVAlignmentCenter) {
         _textHeight = [self getCoreTextHeight];
    }
    else{
         _textHeight = self.frame.size.height;
    }
    //draw
    [self setNeedsDisplay];
}


- (void) parserText:(NSString *)aText tags:(NSString*)aTags link:(NSArray*)arrName
{
    [_tagRange removeAllObjects];
    if (aText &&  aTags && [aTags length] > 0)
    {

        NSRange range = [aText rangeOfString:aTags options:NSCaseInsensitiveSearch];
        if (range.length > 0)
        {
            NSValue *value = [NSValue valueWithRange:range];
            [_tagRange addObject:value];
        }
    }
    
    [_linkRange removeAllObjects];
    if (aText && [arrName count] > 0)
    {
        NSInteger nLen = [aText length];
        NSValue *value      = [_tagRange firstObject];
        NSRange keyRange    = (value)?[value rangeValue]:NSMakeRange(0,0);
        NSInteger begin = (keyRange.location + keyRange.length);
        NSRange searchRange = NSMakeRange(begin, nLen - begin);
     
        for (NSInteger i =0;i< [arrName count];i++)
        {
            NSString* strName = [arrName objectAtIndex:i];
            if (strName && [strName length]>0) {
                keyRange = [aText rangeOfString:strName options:NSCaseInsensitiveSearch range:searchRange];
                if (keyRange.length > 0)
                {
                    NSValue *value = [NSValue valueWithRange:keyRange];
                    [_linkRange addObject:value];
                    begin =(keyRange.location + keyRange.length);
                    searchRange = NSMakeRange(begin, nLen - begin);
                }
            }
        }
    }
}

- (void) layoutText:(NSString *)aText tags:(NSString*)aTags link:(NSArray*)arrName
{
    //parser
    [self parserText:aText tags:aTags link:arrName];
    
    if (aText && [aText length] >0 )
    {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:aText];
        [attributedText beginEditing];
        
        [self layoutNormal:aText attribute:attributedText];
        [self layoutNormal:aText tags:aTags attribute:attributedText];
        [self layoutNormal:aText link:arrName attribute:attributedText];

        self.attriText = attributedText;
        [attributedText endEditing];
    }
    else{
         self.attriText = nil;
    }
}

- (void) layoutNormal:(NSString *)aText attribute:(NSMutableAttributedString*)pAttribute
{
    NSInteger len = [aText length];

    //color
    [pAttribute addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.textColor.CGColor range:NSMakeRange(0, len)];
    
    int nNumType = 0;
    CFNumberRef cfNum = CFNumberCreate(NULL, kCFNumberIntType, &nNumType);
    [pAttribute addAttribute:(NSString *)kCTLigatureAttributeName value:(__bridge id)cfNum range:NSMakeRange(0, len)];
    CFRelease(cfNum);
    
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [pAttribute addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)ctFont2 range:NSMakeRange(0, len)];
    CFRelease(ctFont2);
    
    //对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;//默认左对齐
    if (self.textAlignment == NSTextAlignmentCenter) {//居中
        alignment = kCTCenterTextAlignment;
    }else if (self.textAlignment == NSTextAlignmentRight) {//右对齐
        alignment = kCTRightTextAlignment;
    }
    
    //绘制换行
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;//换行模式

    CGFloat lineSpacing = 3;//行间距
    CTParagraphStyleSetting paraStyles[3] = {
        {.spec = kCTParagraphStyleSpecifierLineBreakMode,.valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
        {.spec = kCTParagraphStyleSpecifierAlignment,.valueSize     = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        {.spec = kCTParagraphStyleSpecifierLineSpacing,.valueSize   = sizeof(CGFloat), .value         = (const void*)&lineSpacing},
    };
    CTParagraphStyleRef style = CTParagraphStyleCreate(paraStyles,3);
    [pAttribute addAttribute:(NSString*)(kCTParagraphStyleAttributeName) value:(__bridge id)style range:NSMakeRange(0,len)];
    CFRelease(style);
}

- (void) layoutNormal:(NSString *)aText tags:(NSString*)aTags attribute:(NSMutableAttributedString*)pAttribute
{
    NSInteger nLen = [aText length];
    if (nLen > 0 && self.tagColor && [_tagRange count] > 0)
    {
        for (NSValue *value in _tagRange)
        {
            NSRange keyRange = [value rangeValue];
            if (keyRange.length + keyRange.location <= nLen) {
                [pAttribute addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.tagColor.CGColor range:keyRange];
            }
        }
    }
}

- (void) layoutNormal:(NSString *)aText link:(NSArray*)arrName attribute:(NSMutableAttributedString*)pAttribute
{
    NSInteger nLen = [aText length];
    if (nLen > 0 && self.linkColor && [_linkRange count] > 0)
    {
        for (NSValue *value in _linkRange)
        {
            NSRange keyRange = [value rangeValue];
            if (keyRange.length + keyRange.location <= nLen)
            {
                [pAttribute addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)self.linkColor.CGColor range:keyRange];
                //下划线
                if (self.isLinkShowUnderline) {
                    [pAttribute addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:keyRange];
                }
            }
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    if (!self.strText|| [self.strText length] <= 0 || !self.attriText) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);//重置
    
    //垂直居中
    CGFloat nOffY = 0;
    if (self.textVAlignmentCenter) {
        nOffY = (self.frame.size.height > _textHeight)? ((self.frame.size.height -_textHeight)/2):0;
    }
    
    //y轴高度//x，y轴方向移动/*self.bounds.size.height*/
    //    CGContextTranslateCTM(context,0,0);
    
    //y轴翻转//缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1, -1);
    
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
	CGContextSaveGState(context);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attriText);
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL, CGRectMake(0, -ceill(self.bounds.size.height + nOffY), self.bounds.size.width, self.bounds.size.height));
    //  CGContextTranslateCTM(context, 0, - ceill(self.bounds.size.height));
    //	CGContextSetTextPosition(context, 0, 0); /*ceill(self.bounds.size.height) + 8*/
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), leftColumnPath, NULL);
    CTFrameDraw(leftFrame, context);
    
    //retore
    CGContextRestoreGState(context);
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    CFRelease(leftFrame);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch      = [touches anyObject];
    if(self.clickDelegate && [touch tapCount] == 1 )
    {
        BOOL isLinkClicked  = NO;
        NSInteger  linkIndex      = -1;
        NSRange linkRange   = NSMakeRange(0, 0);
        if (self.attriText && [_linkRange count]>0)
        {
            //点击位置
            CGPoint point = [touch locationInView:self];
            
            //创建CTFrame,attString为NSMutableAttributedString
            CGMutablePathRef mainPath   = CGPathCreateMutable();
            CGPathAddRect(mainPath, NULL, CGRectMake(0, -ceill(self.bounds.size.height), self.bounds.size.width, self.bounds.size.height));
            CTFramesetterRef framesetter= CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attriText);
            CTFrameRef ctframe          = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), mainPath, NULL);
            
            //取文字行数
            NSArray *lines      = (NSArray *)CTFrameGetLines(ctframe);
            NSInteger lineCount = [lines count];
            CGPoint origins[lineCount];
            
            //判断有文字
            if (lineCount != 0)
            {
                //每行起始位置
                CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
                
                //每行
                for (NSInteger i = 0; i < lineCount; i++)
                {
                    CGFloat ascent, descent;
                    
                    //一行起始坐标
                    CGPoint baselineOrigin = origins[i];
                    
                    //取真正起始y
                    baselineOrigin.y    = CGRectGetHeight(self.frame) - baselineOrigin.y;
                    CTLineRef line      = (__bridge CTLineRef)[lines objectAtIndex:i];
    
                    //取行高,行宽
                    CGFloat lineWidth   = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
                    //取一行真正面积
                    CGRect lineFrame    = CGRectMake(baselineOrigin.x, baselineOrigin.y - ascent, lineWidth, ascent + descent);
                    //判断点击在不在范围内
                    if (CGRectContainsPoint(lineFrame, point))
                    {
                        //取被点击字符位置
                        CFIndex index = CTLineGetStringIndexForPosition(line, point);
                        //取所有可以点击的字符range
                        for (NSInteger i=0 ; i < [_linkRange count] ; i++)
                        {
                            NSValue *value      = [_linkRange objectAtIndex:i];
                            NSRange keyRange    = [value rangeValue];
                            //判断,如果点击在range内则执行
                            if (index >= keyRange.location && index <= keyRange.location + keyRange.length )
                            {
                                //通过Key取值,要点击的值
                                if(!isLinkClicked && [self.clickDelegate respondsToSelector: @selector(clickedTag:range:)])
                                {
//                                    [self.clickDelegate clickedTag:i range:keyRange];
                                    linkIndex = i;
                                    linkRange = keyRange;
                                    isLinkClicked = YES;
                                    break;
                                }
                            }
                        }
                    }//end if
                }
            }
            CGPathRelease(mainPath);
            CFRelease(framesetter);
            CFRelease(ctframe);
        }
        
        //notify
        [self.clickDelegate clickedTag:linkIndex range:linkRange];
    
    }
}

-(float)getCoreTextHeight
{
    float nHeight = 0;
    
    //创建CTFrame,attString为NSMutableAttributedString
    CGMutablePathRef mainPath   = CGPathCreateMutable();
    CGPathAddRect(mainPath, NULL, CGRectMake(0, -ceill(self.bounds.size.height), self.bounds.size.width, self.bounds.size.height));
    CTFramesetterRef framesetter= CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attriText);
    CTFrameRef ctframe          = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), mainPath, NULL);
    
    //取文字行数
    NSArray *lines      = (NSArray *)CTFrameGetLines(ctframe);

    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), origins);
    
    NSInteger line_y = (NSInteger) origins[[lines count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineRef line = (__bridge CTLineRef) [lines objectAtIndex:[lines count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    nHeight = self.bounds.size.height - line_y + (NSInteger) descent +1;    //+1为了纠正descent转换成NSInteger小数点后舍去的值
  
    CGPathRelease(mainPath);
    CFRelease(framesetter);
    CFRelease(ctframe);
    
    return nHeight;
}

@end
