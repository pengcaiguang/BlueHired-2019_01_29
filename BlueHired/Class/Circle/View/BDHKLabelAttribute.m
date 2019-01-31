//
//  BDHKLabelAttribute.m
//  BlueHired
//
//  Created by iMac on 2018/11/21.
//  Copyright © 2018 lanpin. All rights reserved.
//


#import "BDHKLabelAttribute.h"
//#import "UIView+BDHKUtil.h"
#import <CoreText/CoreText.h>

@interface BDHKLabelAttribute()

@property (nonatomic, copy) NSMutableAttributedString *attributedString;
@property (nonatomic, assign) BOOL isDisplay;
@property (nonatomic, assign) BOOL isText;

@end


@implementation BDHKLabelAttribute

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _margin = UIEdgeInsetsZero;
        _verticalTextAlignment = BDHKVerticalTextAlignmentTop;
        _isDisplay = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _margin = UIEdgeInsetsZero;
        _verticalTextAlignment = BDHKVerticalTextAlignmentTop;
        _isDisplay = YES;
    }
    return self;
}

-(void)dealloc
{
    _attributedString = nil;
    _truncationEndAttributedString = nil;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (self.text.length == 0 && self.attributedText == nil) {
        return;
    }
    
    if (_isDisplay) {
        if (_isText) {
            self.attributedString = [self attributedStringAddStyle:self.text];
        }
        else {
            self.attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        }
        _isDisplay = NO;
    }
    
    if (!_attributedString) {
        return;
    }
    
    CGRect drawRect = CGRectMake(_margin.left, _margin.top, self.bounds.size.width - _margin.left - _margin.right, self.bounds.size.height - _margin.top - _margin.bottom);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    CGMutablePathRef forecastPath = CGPathCreateMutable();
    //CGPathAddRect(forecastPath, NULL ,self.bounds);
    CGPathAddRect(forecastPath, NULL ,drawRect);
    CTFrameRef forecastFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), forecastPath , NULL);
    CFArrayRef forecastLines = CTFrameGetLines(forecastFrame);
    long forecastMaxLineNumber = (long)CFArrayGetCount(forecastLines);
    
    //CGRect drawingRect = CGRectMake(0, 0, self.bounds.size.width, CGFLOAT_MAX);
    CGRect drawingRect = CGRectMake(drawRect.origin.x, drawRect.origin.y, drawRect.size.width, 100000000);
    CGMutablePathRef textpath = CGPathCreateMutable();
    CGPathAddRect(textpath, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), textpath, NULL);
    CFArrayRef textlines = CTFrameGetLines(textFrame);
    long textMaxLineNumber = (long)CFArrayGetCount(textlines);
    
    long minLinesNumber = MIN(forecastMaxLineNumber, textMaxLineNumber);
    _drawOfLines = (int)(self.numberOfLines == 0 ? minLinesNumber : MIN(minLinesNumber, self.numberOfLines));
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    
    CGPoint lineOrigins[_drawOfLines];
    CTFrameGetLineOrigins(forecastFrame,CFRangeMake(0,_drawOfLines), lineOrigins);
    
    for(int lineIndex = 0;lineIndex < _drawOfLines;lineIndex++) {
        CTLineRef line = CFArrayGetValueAtIndex(forecastLines,lineIndex);
        CGPoint lineOrigin;
        
        if (forecastMaxLineNumber >= _drawOfLines && _verticalTextAlignment != BDHKVerticalTextAlignmentTop) {
            if (_verticalTextAlignment == BDHKVerticalTextAlignmentMiddle) {
                float topMargin = lineOrigins[_drawOfLines - 1].y / 2.0;
                lineOrigin = lineOrigins[lineIndex];
                lineOrigin = CGPointMake(lineOrigin.x,lineOrigin.y - floorf(topMargin));
            }
            else if(_verticalTextAlignment == BDHKVerticalTextAlignmentBottom){
                CGFloat ascent;
                CGFloat descent;
                CGFloat leading;
                CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
                lineOrigin = lineOrigins[_drawOfLines - 1 - lineIndex];
                lineOrigin = CGPointMake(lineOrigin.x, (self.frame.size.height - floorf(lineOrigin.y + ascent - descent)));
            }
        }
        else {
            lineOrigin = lineOrigins[lineIndex];
        }
        
        CTLineRef lastLine = nil;
        if (_drawOfLines < textMaxLineNumber) {
            if (lineIndex == _drawOfLines - 1) {
                CFRange range  = CTLineGetStringRange(line);
                NSDictionary *attributes = [_attributedString attributesAtIndex:range.location + range.length - 1 effectiveRange:NULL];
                NSAttributedString *token = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:attributes];
                if (_truncationEndAttributedString != nil) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:token];
                    [attributedString appendAttributedString:[[NSMutableAttributedString alloc]initWithString:_truncationEndAttributedString]];
                    token = attributedString;
                }
                CFAttributedStringRef tokenRef = (__bridge CFAttributedStringRef)token;
                CTLineRef truncationToken = CTLineCreateWithAttributedString(tokenRef);
                
                NSRange lastLineRange = NSMakeRange(range.location, 0);
                lastLineRange.length = [_attributedString length] - lastLineRange.location;
                CFAttributedStringRef longString = (__bridge CFAttributedStringRef)[_attributedString attributedSubstringFromRange:lastLineRange];
                CTLineRef endLine = CTLineCreateWithAttributedString(longString);
                //lastLine = CTLineCreateTruncatedLine(endLine, self.width - _lastLineRightIndent, kCTLineTruncationEnd, truncationToken);
                lastLine = CTLineCreateTruncatedLine(endLine, self.frame.size.width, kCTLineTruncationEnd, truncationToken);
                
                if (truncationToken) {
                    CFRelease(truncationToken);
                }
                if (endLine) {
                    CFRelease(endLine);
                }
            }
        }
        if (lastLine) {
            CGContextSetTextPosition(context,lineOrigin.x,lineOrigin.y);
            CTLineDraw(lastLine,context);
            
            //从一行中得到CTRun数组,最后一个字的位置
            //CFArrayRef runs = CTLineGetGlyphRuns(lastLine);
            //long runCount = (long)CFArrayGetCount(runs);
            //CTLineGetOffsetForStringIndex(line, runCount - 1, NULL);
            
            CFRelease(lastLine);
        }
        else {
            CGContextSetTextPosition(context,lineOrigin.x,lineOrigin.y);
            CTLineDraw(line,context);
        }
    }
    
    UIGraphicsPushContext(context);
    CFRelease(textpath);
    CFRelease(textFrame);
    CFRelease(forecastFrame);
    CFRelease(forecastPath);
    CFRelease(framesetter);
}

#pragma mark --

- (NSMutableAttributedString *)attributedStringAddStyle:(NSString *)string
{
    if (!string) {
        return nil;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = (_linesSpace > 0) ? _linesSpace : 4 ;
    style.paragraphSpacing = 0;
    style.alignment = self.textAlignment;
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc]initWithString:string];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:self.textColor,NSFontAttributeName:self.font,NSParagraphStyleAttributeName:style};
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    return attributedString;
}

#pragma mark --

- (void)setText:(NSString *)text
{
    self.isDisplay = YES;
    self.isText = YES;
    [super setText:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    self.isDisplay = YES;
    self.isText = NO;
    [super setAttributedText:attributedText];
}

- (void)setTextColor:(UIColor *)textColor
{
    self.isDisplay = YES;
    [super setTextColor:textColor];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.isDisplay = YES;
    [super setTextAlignment:textAlignment];
}

-(void)setFont:(UIFont *)font
{
    self.isDisplay = YES;
    [super setFont:font];
}

-(void)setLinesSpace:(CGFloat)linesSpace
{
    self.isDisplay = YES;
    _linesSpace = linesSpace;
    [self setNeedsDisplay];
}

-(void)setVerticalTextAlignment:(BDHKVerticalTextAlignment)verticalTextAlignment
{
    _verticalTextAlignment = verticalTextAlignment;
    [self setNeedsDisplay];
}

-(void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    [self setNeedsDisplay];
}

@end


@implementation NSString(BDHKLabelAttribute)

- (CGSize)sizeWithFont:(UIFont *)font width:(CGFloat)width linesSpace:(CGFloat)linesSpace numberOfLines:(NSInteger)numberOfLines
{
    if (self.length <= 0) {
        return CGSizeZero;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = linesSpace ;
    style.paragraphSpacing = 0;
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:font,NSParagraphStyleAttributeName:style};
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    if (numberOfLines == 0) {
        CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, 100000000), NULL);
        size = CGSizeMake(ceilf(size.width), ceilf(size.height));
        CFRelease(framesetter);
        return size;
    }
    
    
    CGRect drawingRect = CGRectMake(0, 0, width, 100000000);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CFArrayRef lines = CTFrameGetLines(frameRef);
    long linesNumber = (long)CFArrayGetCount(lines);
    if (linesNumber < 1) {//没有内容
        CGPathRelease(path);
        CFRelease(frameRef);
        CFRelease(framesetter);
        return CGSizeZero;
    }
    
    numberOfLines = (numberOfLines == 0) ? linesNumber : MIN(linesNumber, numberOfLines);
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frameRef,CFRangeMake(0,numberOfLines), lineOrigins);
    
    long lastLineNumber = MAX(numberOfLines - 1, 0);
    CGPoint lineOrigin = lineOrigins[lastLineNumber];//最后一行line的位置
    CTLineRef line = CFArrayGetValueAtIndex(lines, lastLineNumber);
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    /*
     CGFloat height = drawingRect.size.height - floorf(lineOrigin.y) + ceilf(lineDescent);
     if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
     height += ceilf(lineAscent / 2.0) + 2;
     }
     */
    
    CGFloat height = ceilf(drawingRect.size.height - lineOrigin.y + descent + leading);
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        height += ceilf(descent);
    }
    
    CGPathRelease(path);
    CFRelease(frameRef);
    CFRelease(framesetter);
    
    return CGSizeMake(drawingRect.size.width, height);
}

@end

