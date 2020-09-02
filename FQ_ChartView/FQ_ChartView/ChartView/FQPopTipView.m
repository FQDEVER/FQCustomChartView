//
//  FQPopTipView.m
//  pop_test
//
//  Created by fanqi on 2018/11/21.
//  Copyright © 2018年 tuhui－03. All rights reserved.
//

#import "FQPopTipView.h"
typedef NS_ENUM(NSInteger,FQPopViewPositionType) {
    FQPopViewPositionType_Left = 0, //左边
    FQPopViewPositionType_Right ,   //右边
    FQPopViewPositionType_Center ,   //中间
};

@interface FQPopTipView()

/**
 当前所在位置
 */
@property (nonatomic, assign) FQPopViewPositionType positionType;

/**
 内容字符串文本
 */
@property (nonatomic, strong) UILabel *contentTextLab;

/**
 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 自定义视图
 */
@property (nonatomic, weak) UIView *customView;

/**
 箭头所在位置.上或者下
 */
@property (nonatomic, assign) FQArrowDirection direction;

/**
 maxX popView控件最大X值
 */
@property (nonatomic, assign) CGFloat maxX;

/**
 minX popView控件最小X值
 */
@property (nonatomic, assign) CGFloat minX;

/**
 自定义视图或者文本视图在内容视图上的内边距
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/**
 箭头初始位置点
 */
@property (nonatomic, assign) CGPoint origin;

/**
 箭头layer
 */
@property (nonatomic, strong) CAShapeLayer *triangleLayer;

@end

@implementation FQPopTipView

/**
 如果只有文本展示.则使用该方法
 
 @param direction 箭头在上或下
 @param maxX popView控件最大X值
 @param minX popView控件最小X值
 @param edgeInsets 内间距
 @param contentText 文本内容
 @param textColor 文本颜色
 @param textFont 文本字体
 @return popView
 */
+(instancetype)initWithPopViewWithDirection:(FQArrowDirection )direction maxX:(CGFloat)maxX minX:(CGFloat)minX edge:(UIEdgeInsets)edgeInsets contentText:(NSString *)contentText textColor:(UIColor*)textColor textFont:(UIFont *)textFont
{
    FQPopTipView * popView = [[FQPopTipView alloc]init];
    popView.direction = direction;
    popView.maxX = maxX;
    popView.minX = minX;
    popView.edgeInsets = edgeInsets;
    popView.contentTextLab.text = contentText;
    popView.contentTextLab.textColor = textColor;
    popView.contentTextLab.font = textFont;
    
    //根据contentText
    CGSize textSize = [contentText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textFont} context:nil].size;
    
    CGFloat popViewW = textSize.width + edgeInsets.left + edgeInsets.right;
    CGFloat popViewH = textSize.height + edgeInsets.top + edgeInsets.bottom + popView.marginSpcingH;
    
    popView.frame = CGRectMake(0, 0, popViewW, popViewH);
    popView.contentTextLab.frame = CGRectMake(edgeInsets.left, edgeInsets.top, textSize.width, textSize.height);
    
    return popView;
}

/**
 自定义视图.则使用该方法
 
 @param direction 箭头在上或下
 @param maxX popView控件最大X值
 @param minX popView控件最小X值
 @param edgeInsets 内间距
 @param customView 自定义控件
 @param customViewSize 自定义控件Size.用来获取popView的Size
 @return popView
 */
+(instancetype)initWithPopViewWithDirection:(FQArrowDirection )direction maxX:(CGFloat)maxX minX:(CGFloat)minX edge:(UIEdgeInsets)edgeInsets customView:(UIView *)customView andCustomSize:(CGSize)customViewSize
{
    FQPopTipView * popView = [[FQPopTipView alloc]init];
    popView.direction = direction;
    popView.maxX = maxX;
    popView.minX = minX;
    popView.edgeInsets = edgeInsets;
    [popView.contentView addSubview:customView];
    
    CGFloat popViewW = customViewSize.width + edgeInsets.left + edgeInsets.right;
    CGFloat popViewH = customViewSize.height + edgeInsets.top + edgeInsets.bottom + popView.marginSpcingH;
    
    popView.frame = CGRectMake(0, 0, popViewW, popViewH);
    popView.customView = customView;
    customView.frame = CGRectMake(edgeInsets.left, edgeInsets.top, customViewSize.width, customViewSize.height);
    
    return popView;
}


-(instancetype)init
{
    if (self = [super init])
    {
        //背景颜色为无色
        self.backgroundColor=[UIColor clearColor];
        self.marginSpcingW = 40.0f;
        self.marginSpcingH = 20.0f;
        self.contentView=[[UIView alloc]init];
        self.contentView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
        [self addSubview:self.contentView];
        
        self.triangleLayer = [[CAShapeLayer alloc]init];
        [self.layer addSublayer:self.triangleLayer];
    }
    
    return self;
}

-(void)setOrigin:(CGPoint)origin
{
    _origin = origin;
    CGFloat minX = origin.x - self.frame.size.width * 0.5;
    CGFloat maxX = origin.x + self.frame.size.width * 0.5;
    CGFloat popViewX = 0;
    if (minX >= _minX && maxX <= _maxX) {
        popViewX = minX;
        self.positionType = FQPopViewPositionType_Center;
    }else if(minX < _minX){
        popViewX = _minX;
        self.positionType = FQPopViewPositionType_Left;
    }else if(maxX > _maxX){
        popViewX = _maxX - self.frame.size.width;
        self.positionType = FQPopViewPositionType_Right;
    }
    NSLog(@"------------------x:%f------y:%f----minX:%f------maxX:%f-----popViewX:%f",origin.x,origin.y,minX,maxX,popViewX);
    
    CGFloat startX = 0;
    CGFloat startY = 0;
    if (self.positionType == FQPopViewPositionType_Center) {
        startX = self.frame.size.width * 0.5;
    }else if (self.positionType == FQPopViewPositionType_Left){
        startX = self.origin.x - _minX;
    }else{
        startX = self.origin.x - popViewX;// 计算之后最新的x值
    }
    NSLog(@"------------------startX:%f-----originX:%f",startX,self.frame.origin.x);
    UIBezierPath *path = [[UIBezierPath alloc]init];
    if (_direction == FQArrowDirectionUP) {//箭头在上
        self.frame = CGRectMake(popViewX, origin.y, self.frame.size.width, self.frame.size.height);
        self.contentView.frame = CGRectMake(0,self.marginSpcingH, self.frame.size.width, self.frame.size.height - self.marginSpcingH);
        [path moveToPoint:CGPointMake(startX, startY)];
        [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 - self.marginSpcingW * 0.5, startY + self.marginSpcingH + self.cornerRadius)];
        [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 + self.marginSpcingW * 0.5, startY + self.marginSpcingH + self.cornerRadius)];
        
        
        self.triangleLayer.path = path.CGPath;
        self.triangleLayer.fillColor = self.contentView.backgroundColor.CGColor;
        
    }else{
        self.frame = CGRectMake(popViewX, origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.contentView.frame = CGRectMake(0,0, self.frame.size.width, self.frame.size.height - self.marginSpcingH);
        
        startY = self.frame.size.height;
        [path moveToPoint:CGPointMake(startX, startY)];
        [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 - self.marginSpcingW * 0.5, startY - self.marginSpcingH - self.cornerRadius)];
        [path addLineToPoint:CGPointMake(self.frame.size.width * 0.5 + self.marginSpcingW * 0.5, startY - self.marginSpcingH - self.cornerRadius)];
        
        self.triangleLayer.path = path.CGPath;
        self.triangleLayer.fillColor = self.contentView.backgroundColor.CGColor;
    }
    
    if (self.isShadow) {
        [self setLayerShadow:[[UIColor blackColor] colorWithAlphaComponent:0.3] offset:CGSizeMake(0, 3) radius:5.0];
    }
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = 1;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

-(void)setMarginSpcingH:(CGFloat)marginSpcingH
{
    _marginSpcingH = marginSpcingH;
    
    if (_customView) {
        
        CGFloat popViewH = self.customView.frame.size.height + self.edgeInsets.top + self.edgeInsets.bottom + marginSpcingH;
        self.frame = CGRectMake(0, 0, self.frame.size.width, popViewH);
    }
    
    if (_contentTextLab) {
        CGFloat popViewH = self.contentTextLab.frame.size.height + self.edgeInsets.top + self.edgeInsets.bottom + marginSpcingH;
        self.frame = CGRectMake(0, 0, self.frame.size.width, popViewH);
    }
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
    self.contentView.layer.masksToBounds = YES;
}

-(void)setContentBackColor:(UIColor *)contentBackColor
{
    _contentBackColor = contentBackColor;
    self.contentView.backgroundColor = contentBackColor;
}

-(void)setContentTextStr:(NSString *)contentTextStr
{
    _contentTextStr = contentTextStr;
    if (_contentTextLab) {
        _contentTextLab.text = contentTextStr;
        //根据contentText
        CGSize textSize = [contentTextStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentTextLab.font} context:nil].size;
        
        CGFloat popViewW = textSize.width + self.edgeInsets.left + self.edgeInsets.right;
        CGFloat popViewH = textSize.height + self.edgeInsets.top + self.edgeInsets.bottom + self.marginSpcingH;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, popViewW, popViewH);
        _contentTextLab.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, textSize.width, textSize.height);
    }
}

/**
 开始绘制的原点位置
 
 @param origin 原点
 */
-(void)fq_drawRectWithOrigin:(CGPoint)origin
{
    self.origin = origin;
    //更新位置.
    //    [self setNeedsDisplay];
}
//
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context=UIGraphicsGetCurrentContext();
//
//    CGFloat startX = 0;
//    CGFloat startY = 0;
//    if (self.positionType == FQPopViewPositionType_Center) {
//        startX = self.frame.size.width * 0.5;
//    }else if (self.positionType == FQPopViewPositionType_Left){
//        startX = self.origin.x - _minX;
//    }else{
//        startX = self.origin.x - self.frame.origin.x;
//    }
//
//    if (_direction == FQArrowDirectionUP) //箭头在上
//    {
//        CGContextMoveToPoint(context, startX, startY);//设置起点
//        CGContextAddLineToPoint(context, self.frame.size.width * 0.5 - self.marginSpcingW * 0.5, startY + self.marginSpcingH + self.cornerRadius);
//        CGContextAddLineToPoint(context, self.frame.size.width * 0.5 + self.marginSpcingW * 0.5, startY+ self.marginSpcingH + self.cornerRadius);
//
//    }else if (_direction == FQArrowDirectionDOWN) //箭头在下
//    {
//        startY = self.frame.size.height;
//        CGContextMoveToPoint(context, startX, startY);//设置起点
//        CGContextAddLineToPoint(context, self.frame.size.width * 0.5 - self.marginSpcingW * 0.5, startY - self.marginSpcingH - self.cornerRadius);
//        CGContextAddLineToPoint(context, self.frame.size.width * 0.5 + self.marginSpcingW * 0.5, startY- self.marginSpcingH - self.cornerRadius);
//
//    }
//
//    CGContextClosePath(context);
//    [self.contentView.backgroundColor setFill];
//    [self.backgroundColor setStroke];
//    CGContextDrawPath(context, kCGPathFillStroke);
//
//}

-(UILabel *)contentTextLab
{
    if (!_contentTextLab) {
        _contentTextLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentTextLab.numberOfLines = 0;
        [self.contentView addSubview:_contentTextLab];
    }
    return _contentTextLab;
}


@end
