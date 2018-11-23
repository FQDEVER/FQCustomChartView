//
//  FQChartView.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQChartView.h"
#import "FQPopTipView.h"

typedef struct {
    unsigned int tapSelectItem  :1;
    unsigned int panBeginItem :1;
    unsigned int panChangeItem :1;
    unsigned int chartViewPanGestureEnd :1;
    unsigned int changePopViewPositionWithView    :1;
} flag;

@interface FQChartView()

#pragma mark - 数据相关
//配置文件
@property (nonatomic, strong) FQChartConfiguration *configuration;
//代理标识
@property (nonatomic, assign) flag delegateFlag;
//弹出提示视图
@property (nonatomic, strong) FQPopTipView *popTipView;
//整个背景layer
@property (nonatomic, strong) CALayer *chartViewBackGroundLayer;

#pragma mark - Y轴相关
//Y轴左侧展示数据.
@property (nonatomic, strong) NSArray *yLeftAxisShowArr;
//Y轴右侧展示数据
@property (nonatomic, strong) NSArray *yRightAxisShowArr;

//Y轴左侧参考数据.
@property (nonatomic, strong) NSArray *yLeftAxisArr;
//Y轴右侧参考数据
@property (nonatomic, strong) NSArray *yRightAxisArr;

@property (nonatomic, assign) CGFloat yAxisLeftMaxValue;
@property (nonatomic, assign) CGFloat yAxisLeftMinValue;
@property (nonatomic, assign) CGFloat yAxisRightMaxValue;
@property (nonatomic, assign) CGFloat yAxisRightMinValue;

#pragma mark - X轴相关

//X轴展示数据.没有就用空格展示.保证能对应上.不能使用等分
@property (nonatomic, strong) NSArray *xAxisShowArr;

//X轴参考数量.一共有多少个点.就展示多少个x轴点.并且等分
@property (nonatomic, assign) NSInteger xAxisCount;

//X轴最大值
@property (nonatomic, assign) CGFloat xAxisMaxValue;

//X轴最小
@property (nonatomic, assign) CGFloat xAxisMinValue;

//纪录每一种图表的点数组.
@property (nonatomic, strong) NSArray *elementPointsArr;

#pragma mark - 图表绘制相关

//背景线相关 - 参考线 - 默认为 y轴5条.x轴有多少就是多少条
@property (nonatomic, weak) CAReplicatorLayer *rowReplicatorLayer;
@property (nonatomic, weak) CAReplicatorLayer *columnReplicatorLayer;
@property (nonatomic, weak) CAShapeLayer *rowBackLine;
@property (nonatomic, weak) CAShapeLayer *columnBackLine;

//内容图表视图
@property (nonatomic, weak) UIView *mainContainer;
@property (nonatomic, assign) CGFloat mainContainerW;
@property (nonatomic, assign) CGFloat mainContainerH;

//Y轴的最大宽度 - 左右均算 - 默认为40
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginRight;
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginLeft;

//Y轴的上下边距
//#define kChartViewMargin 0 //上下默认为20
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginTop;
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginBot;

//平均线数组
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *averageLineLayerArr;

//当前选中线
@property (nonatomic, weak) CAShapeLayer *currentlineLayer;

//线条的绘制数据数组
@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *lineElements;
//柱状图绘制数据数组
@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *barElements;
//点图绘制数据数组
@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *pointElements;

/**
 绘制折线
 */
//每一条线条就是一个Item
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *lineLayerArr;

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *lineBackLayerArr;

@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *linePathArr;

@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *lineBackPathArr;

@property (nonatomic, strong) NSMutableArray<CAGradientLayer *> *lineGradientLayerArr;

@property (nonatomic, strong) NSMutableArray<CAGradientLayer *> *lineBackGradientLayerArr;

/**
 绘制柱状.-只允许一组.太多会显示比较杂乱.
 */

//需要有多组.所以也需要有多组柱状图layer.//<每一个柱子是一个Item>
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *barLayerArr;

@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *barBackLayerArr;
//柱状图渐变.整体渐变
@property (nonatomic, strong) NSMutableArray<CAGradientLayer *> *barGradientLayerArr;


/**
 选中点数组.全部记录下来.并且隐藏
 */
@property (nonatomic, strong) NSMutableArray<NSArray *> *pointLayerArrs;

/**
 当前选中索引.默认为0.
 */
@property (nonatomic, assign) NSInteger selectIndex;

#pragma mark - 获取.文本的宽与高

//y轴Label的高度，默认取根据列标字体自动计算高度
@property (nonatomic, assign) CGFloat yAxisLabelsHeight;
//x轴Label的宽度，默认根据行标的文字自动计算
@property (nonatomic, assign) CGFloat xAxisLabelsWidth;

@end

@implementation FQChartView

/**
 快捷创建对应的图表
 
 @param configuration 默认设置
 @return 图表视图
 */
+ (instancetype)getChartViewWithConfiguration:(FQChartConfiguration *)configuration withFrame:(CGRect)frame
{
    FQChartView * chartView = [[FQChartView alloc]initWithFrame:frame withConfiguation:configuration];
    return chartView;
}

-(instancetype)initWithFrame:(CGRect)frame withConfiguation:(FQChartConfiguration *)configuration
{
    if (self = [super initWithFrame:frame]) {
        self.configuration = configuration;
        [self creatUI];
    }
    return self;
}

-(void)setConfiguration:(FQChartConfiguration *)configuration
{
    _configuration = configuration;
    //获取当前的原点.这样好做提前调换.
    
    if (configuration.yAxisLeftTitle.length != 0 && configuration.unitDescrType == ChartViewUnitDescrType_LeftRight) {
        
        self.yAxisLabelsContainerMarginLeft =  20 + ((!configuration.hiddenLeftYAxis) ? configuration.kChartViewWidthMargin +configuration.kYAxisLabelMargin : 0);
    }else{
        self.yAxisLabelsContainerMarginLeft = ((!configuration.hiddenLeftYAxis) ? configuration.kChartViewWidthMargin + configuration.kYAxisLabelMargin : 0);
    }
    
    if (configuration.yAxisRightTitle.length != 0 && configuration.unitDescrType == ChartViewUnitDescrType_LeftRight) {
        
        self.yAxisLabelsContainerMarginRight = 20 + ((!configuration.hiddenRightYAxis) ?configuration.kChartViewWidthMargin +configuration.kYAxisLabelMargin : 0);
    }else{
        self.yAxisLabelsContainerMarginRight = ((!configuration.hiddenRightYAxis) ?configuration.kChartViewWidthMargin +configuration.kYAxisLabelMargin : 0);
    }
    
    
    if (configuration.xAxisIsBottom) {
        if (configuration.yAxisLeftTitle.length == 0 && configuration.yAxisRightTitle.length == 0) {
            self.yAxisLabelsContainerMarginTop =configuration.kChartViewHeightMargin * 0.5;
        }else{
            self.yAxisLabelsContainerMarginTop = configuration.unitDescrType == ChartViewUnitDescrType_Top ?configuration.kChartViewHeightMargin :configuration.kChartViewHeightMargin * 0.5;
        }
        
        if (configuration.hiddenXAxis) {
            self.yAxisLabelsContainerMarginBot =configuration.kChartViewHeightMargin * 0.5;
        }else{
            self.yAxisLabelsContainerMarginBot =configuration.kChartViewHeightMargin;
        }
        
    }else{
        
        if (configuration.yAxisLeftTitle.length == 0 && configuration.yAxisRightTitle.length == 0 && configuration.hiddenXAxis) {
            self.yAxisLabelsContainerMarginTop = configuration.unitDescrType == ChartViewUnitDescrType_Top ?configuration.kChartViewHeightMargin :configuration.kChartViewHeightMargin * 0.5;
        }else{
            self.yAxisLabelsContainerMarginTop =configuration.kChartViewHeightMargin;
        }
        self.yAxisLabelsContainerMarginBot =configuration.kChartViewHeightMargin * 0.5;
    }
#warning  - 更改背景图
    self.yAxisLabelsContainerMarginLeft += self.configuration.chartViewEdgeInsets.left;
    self.yAxisLabelsContainerMarginRight += self.configuration.chartViewEdgeInsets.right;
    self.yAxisLabelsContainerMarginTop += self.configuration.chartViewEdgeInsets.top;
    self.yAxisLabelsContainerMarginBot += self.configuration.chartViewEdgeInsets.bottom;
}

-(void)creatUI{
    
    _chartViewBackGroundLayer = [[CALayer alloc]init];
    _chartViewBackGroundLayer.cornerRadius = 5.0f;
    _chartViewBackGroundLayer.masksToBounds = YES;
    _chartViewBackGroundLayer.backgroundColor = self.configuration.chartBackLayerColor.CGColor;
    _chartViewBackGroundLayer.frame = CGRectMake(self.configuration.chartBackLayerEdgeInsets.left, self.configuration.chartBackLayerEdgeInsets.top, self.bounds.size.width - self.configuration.chartBackLayerEdgeInsets.left - self.configuration.chartBackLayerEdgeInsets.right , self.bounds.size.height - self.configuration.chartBackLayerEdgeInsets.top - self.configuration.chartBackLayerEdgeInsets.bottom);
    [self.layer addSublayer:_chartViewBackGroundLayer];
    
    //主网格曲线视图容器
    UIView *mainContainer = [UIView new];
    _mainContainer = mainContainer;
    _mainContainer.backgroundColor = self.configuration.mainContainerBackColor;
    [self addSubview:mainContainer];
    
    //网格横线
    CAReplicatorLayer *rowReplicatorLayer = [CAReplicatorLayer new];
    _rowReplicatorLayer = rowReplicatorLayer;
    rowReplicatorLayer.position = CGPointMake(0, 0);
    CAShapeLayer *rowBackLine = [CAShapeLayer new];
    _rowBackLine = rowBackLine;
    [rowReplicatorLayer addSublayer:rowBackLine];
    [mainContainer.layer addSublayer:rowReplicatorLayer];
    //网格列线
    CAReplicatorLayer *columnReplicatorLayer = [CAReplicatorLayer new];
    _columnReplicatorLayer = columnReplicatorLayer;
    columnReplicatorLayer.position = CGPointMake(0, 0);
    CAShapeLayer *columnBackLine = [CAShapeLayer new];
    _columnBackLine = columnBackLine;
    [columnReplicatorLayer addSublayer:columnBackLine];
    [mainContainer.layer addSublayer:columnReplicatorLayer];
    
    
    for (FQSeriesElement *element in self.configuration.elements) {
        
        if (element.chartType == FQChartType_Line) {
#pragma mark - 折线
            //主曲线
            CAShapeLayer *curveLineLayer = [CAShapeLayer new];
            curveLineLayer.fillColor = nil;
            curveLineLayer.lineJoin = kCALineCapRound;
            [mainContainer.layer addSublayer:curveLineLayer];
            [self.lineLayerArr addObject:curveLineLayer];
            
            //折线渲染背景的layer
            CAShapeLayer * backLayer = [CAShapeLayer new];
            [mainContainer.layer addSublayer:backLayer];
            [self.lineBackLayerArr addObject:backLayer];
            
            //线条的渐变layer
            if (element.gradientColors.count > 0) {
                CAGradientLayer *lineGradientLayer = [CAGradientLayer new];
                lineGradientLayer.startPoint = CGPointMake(1, 1);
                lineGradientLayer.endPoint = CGPointMake(1, 0);
                [_mainContainer.layer addSublayer:lineGradientLayer];
                [self.lineGradientLayerArr addObject:lineGradientLayer];
                
                //渲染背景的layer
                CAGradientLayer *backGradientLayer = [CAGradientLayer new];
                backGradientLayer.startPoint = CGPointMake(1, 1);
                backGradientLayer.endPoint = CGPointMake(1, 0);
                [_mainContainer.layer addSublayer:backGradientLayer];
                [self.lineBackGradientLayerArr addObject:backGradientLayer];
            }
            
            [self.lineElements addObject:element];
            
        }else if (element.chartType == FQChartType_Bar){ //绘制柱状图
            //保障只有一个柱状图显示.
            if (self.barElements.count > 0) {
                continue;
            }
            
            //给每一个柱状图一个layer显示
            for (int i = 0; i < element.orginDatas.count; ++i) {
                
                //柱状图每个柱子的背景色.
                CAShapeLayer * backLayer = [CAShapeLayer new];
                backLayer.fillColor = nil;
                [mainContainer.layer addSublayer:backLayer];
                [self.barBackLayerArr addObject:backLayer];
                
                //柱状图的每个柱子
                CAShapeLayer *barLayer = [CAShapeLayer new];
                barLayer.fillColor = nil;
                [mainContainer.layer addSublayer:barLayer];
                [self.barLayerArr addObject:barLayer];
                
                //柱状的渐变色
                if (element.gradientColors.count > 0) {
                    CAGradientLayer *barGradientLayer = [CAGradientLayer new];
                    barGradientLayer.startPoint = CGPointMake(1, 1);
                    barGradientLayer.endPoint = CGPointMake(1, 0);
                    [mainContainer.layer addSublayer:barGradientLayer];
                    [self.barGradientLayerArr addObject: barGradientLayer];
                }
            }
            [self.barElements addObject:element];
            
        }else if (element.chartType == FQChartType_Point){
            [self.pointElements addObject:element];
        }
        
        CAShapeLayer * averagelineLayer = [CAShapeLayer new];
        [self.averageLineLayerArr addObject:averagelineLayer];
        [mainContainer.layer addSublayer:averagelineLayer];
    }
    
    //添加一个随着手势实时变化的线条
    CAShapeLayer *currentLineLayer = [CAShapeLayer new];
    _currentlineLayer = currentLineLayer;
    [_mainContainer.layer addSublayer:currentLineLayer];
    
    if (self.configuration.isShowPopView) {
        [self.layer addSublayer:self.popTipView.layer];
        self.popTipView.layer.opacity = 0.0;
        [self.popTipView fq_drawRectWithOrigin:CGPointMake(self.mainContainerW + _configuration.kYAxisChartViewMargin, self.yAxisLabelsContainerMarginTop)];
    }
}



#pragma mark - setter methods

- (void)setDelegate:(id<FQChartViewDelegate>)delegate{
    _delegate = delegate;
    _delegateFlag.tapSelectItem = [delegate respondsToSelector:@selector(chartView:tapSelectItem:location:index:)];
    _delegateFlag.panBeginItem = [delegate respondsToSelector:@selector(chartView:panBeginItem:location:index:)];
    _delegateFlag.panChangeItem = [delegate respondsToSelector:@selector(chartView:panChangeItem:location:index:)];
    _delegateFlag.chartViewPanGestureEnd = [delegate respondsToSelector:@selector(chartViewPanGestureEnd:)];
    _delegateFlag.changePopViewPositionWithView = [delegate respondsToSelector:@selector(chartView:changePopViewPositionWithView:itemData:)];
}


#pragma mark - private methods

- (void)fq_setXAxisLabelsContainer{
    if (!_xAxisShowArr.count) {
        return;
    }
    CGFloat average = _mainContainerW / self.xAxisCount;
    __block CGFloat lastX = self.yAxisLabelsContainerMarginLeft + _configuration.kYAxisChartViewMargin;
    [_xAxisShowArr enumerateObjectsUsingBlock:^(NSString *columnName, NSUInteger idx, BOOL *stop) {
        CATextLayer * textlayer = [[CATextLayer alloc]init];
        textlayer.foregroundColor = self.configuration.xAxisLabelsTitleColor.CGColor;
        textlayer.string = columnName;
        textlayer.contentsScale = [UIScreen mainScreen].scale;
        // 字体名称、大小
        CFStringRef fontName = (__bridge CFStringRef)self.configuration.xAxisLabelsTitleFont.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textlayer.font = fontRef;
        textlayer.fontSize = self.configuration.xAxisLabelsTitleFont.pointSize;
        CGFontRelease(fontRef);
        // 字体对方方式
        textlayer.alignmentMode = kCAAlignmentCenter;
        // 分行显示
        textlayer.wrapped = NO;
        // 超长显示时，省略号位置
        textlayer.truncationMode = kCATruncationEnd;
        
        CGSize size = [self fq_sizeWithString:columnName font:self.configuration.xAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        CGFloat textLayerX = lastX + (idx + 1) * average - average * 0.5 - size.width * 0.5;
        CGFloat textLayerY = self.configuration.xAxisIsBottom ? self.frame.size.height - self.yAxisLabelsContainerMarginBot +self.configuration.kXAxisLabelTop : self.yAxisLabelsContainerMarginTop - self.configuration.kXAxisLabelTop - size.height;
        textlayer.frame = CGRectMake( textLayerX,  textLayerY, size.width, size.height);
        [self.layer addSublayer:textlayer];
    }];
    
}


- (void)fq_setYAxisLeftLabelsContainer{
    
    if (!self.configuration.hiddenLeftYAxis) {
        if (!_yLeftAxisShowArr.count && _yRightAxisShowArr.count > 0) {
            _yLeftAxisShowArr = _yRightAxisShowArr;
        }
        [self getYAxisDataLabelLayerWithShowArr:_yLeftAxisShowArr left:YES];
    }
}

- (void)fq_setYAxisRightLabelsContainer{
    
    if (!self.configuration.hiddenRightYAxis) {
        if (!_yRightAxisShowArr.count && _yLeftAxisShowArr.count > 0) {
            _yRightAxisShowArr = _yLeftAxisShowArr;
        }
        [self getYAxisDataLabelLayerWithShowArr:_yRightAxisShowArr left:NO];
    }
}

-(void)drawYAxisTitleViewLeft:(BOOL)isYAxisLeft{
    
    NSString * unitStr = isYAxisLeft ? self.configuration.yAxisLeftTitle : self.configuration.yAxisRightTitle;
    UIColor * unitColor = isYAxisLeft ? self.configuration.yAxisLeftTitleColor : self.configuration.yAxisRightTitleColor;
    UIFont * unitFont = isYAxisLeft ? self.configuration.yAxisLeftTitleFont : self.configuration.yAxisRightTitleFont;
    CATextLayer * textlayer = [[CATextLayer alloc]init];
    textlayer.foregroundColor = unitColor.CGColor;
    textlayer.string = unitStr;
    textlayer.contentsScale = [UIScreen mainScreen].scale;
    // 字体名称、大小
    CFStringRef fontName = (__bridge CFStringRef)unitFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textlayer.font = fontRef;
    textlayer.fontSize = unitFont.pointSize;
    CGFontRelease(fontRef);
    // 字体对方方式
    textlayer.alignmentMode = isYAxisLeft ? kCAAlignmentLeft : kCAAlignmentRight;
    // 分行显示
    textlayer.wrapped = NO;
    // 超长显示时，省略号位置
    textlayer.truncationMode = kCATruncationEnd;
    
    CGSize size = [self fq_sizeWithString:unitStr font:unitFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    if (self.configuration.unitDescrType == ChartViewUnitDescrType_Top) {
        CGFloat textLayerW = size.width;
        if (size.width < _configuration.kChartViewWidthMargin) {
            textlayer.alignmentMode = kCAAlignmentCenter;
            textLayerW = _configuration.kChartViewWidthMargin;
        }
        textlayer.frame = CGRectMake(isYAxisLeft ? _configuration.kYAxisChartViewMargin : self.frame.size.width - _configuration.kYAxisChartViewMargin - textLayerW , self.yAxisLabelsContainerMarginTop - size.height -_configuration.kYTitleLabelBot, textLayerW , size.height);
    }else{
        if (isYAxisLeft) { //左侧
            textlayer.frame = CGRectMake(size.height * 0.5 - MAX(size.height, size.width) , _mainContainer.center.y, MAX(size.height, size.width) * 2.0, size.height);
            textlayer.transform = CATransform3DRotate(textlayer.transform, M_PI_2, 0, 0, 1);
        }else{ //右侧
            textlayer.frame = CGRectMake(self.frame.size.width - MAX(size.height, size.width) - size.height * 0.5 , _mainContainer.center.y ,MAX(size.height, size.width) * 2.0, size.height);
            textlayer.transform = CATransform3DRotate(textlayer.transform, -M_PI_2, 0, 0, 1);
            
        }
    }
    [self.layer addSublayer:textlayer];
}

-(void)getYAxisDataLabelLayerWithShowArr:(NSArray *)showArr left:(BOOL)isLeft{
    
    //标题描述.
    [self drawYAxisTitleViewLeft:isLeft];
    
    if (!showArr.count) {
        return;
    }
    
    CGSize yAxisSize = [self fq_sizeWithString:@"" font:self.configuration.yAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    //这种方式针对平均布局
    CGFloat rowSpacing = (self.frame.size.height - self.yAxisLabelsContainerMarginTop - self.yAxisLabelsContainerMarginBot - yAxisSize.height * showArr.count) / (showArr.count - 1);
    if (rowSpacing <= 0) {
        NSLog(@"y轴labels文字过多或字体过大，布局可能有问题");
    }
    
    __block CGFloat lastY = - rowSpacing + self.yAxisLabelsContainerMarginTop;
    __block CGFloat maxWidth = 0;
    
#warning 调试Y轴翻转

    NSArray* reversedArray = nil;
    if (self.configuration.xAxisIsBottom) {
        if (self.configuration.yAxisIsReverse == YES) {
            reversedArray = showArr;
        }else{
            reversedArray = [[showArr reverseObjectEnumerator] allObjects];
        }
    }else{
        if (self.configuration.yAxisIsReverse == YES) {
            reversedArray = [[showArr reverseObjectEnumerator] allObjects];
        }else{
            reversedArray = showArr;
        }
    }
    
    [reversedArray enumerateObjectsUsingBlock:^(NSString *rowName, NSUInteger idx, BOOL *stop) {
        CATextLayer * textlayer = [[CATextLayer alloc]init];
        textlayer.foregroundColor = self.configuration.yAxisLabelsTitleColor.CGColor;
        textlayer.string = rowName;
        textlayer.contentsScale = [UIScreen mainScreen].scale;
        
        // 字体名称、大小
        CFStringRef fontName = (__bridge CFStringRef)self.configuration.yAxisLabelsTitleFont.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textlayer.font = fontRef;
        textlayer.fontSize = self.configuration.yAxisLabelsTitleFont.pointSize;
        CGFontRelease(fontRef);
        // 字体对方方式
        textlayer.alignmentMode = kCAAlignmentCenter;
        // 分行显示
        textlayer.wrapped = NO;
        // 超长显示时，省略号位置
        textlayer.truncationMode = kCATruncationEnd;
        
        CGSize size = [self fq_sizeWithString:rowName font:self.configuration.yAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGFloat textLayerY = lastY + rowSpacing;
        //如果是self.configuration.showLeftYAxisDatas 针对这种样式绘制.那么就是对应最大与最小.去找到对应的绘制点.
        if (isLeft && (self.configuration.showLeftYAxisDatas.count > 0)) {
            
            CGFloat axisYValue = 0;
            if (self.configuration.xAxisIsBottom) {
                if (self.configuration.yAxisIsReverse) {
                    axisYValue = [self.configuration.showLeftYAxisDatas[idx] floatValue];
                }else{
                    axisYValue = [self.configuration.showLeftYAxisDatas[reversedArray.count - idx - 1] floatValue];
                }
            }else{
                if (self.configuration.yAxisIsReverse) {
                    axisYValue = [self.configuration.showLeftYAxisDatas[reversedArray.count - idx - 1] floatValue];
                }else{
                    axisYValue = [self.configuration.showLeftYAxisDatas[idx] floatValue];
                }
            }
#warning y轴翻转

            if (self.configuration.yAxisIsReverse) {

                if (self.configuration.xAxisIsBottom) {
                    textLayerY = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH  + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }else{
                    textLayerY = (1 - (axisYValue - self.self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }

            }else{

                if (self.configuration.xAxisIsBottom) {
                    textLayerY = (1 - (axisYValue - self.self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }else{
                    textLayerY = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }
            }
        
        }
        
        if (!isLeft && (self.configuration.showRightYAxisDatas.count > 0)) {
            
            CGFloat axisYValue = 0;
            if (self.configuration.xAxisIsBottom) {
                if (self.configuration.yAxisIsReverse) {
                    axisYValue = [self.configuration.showRightYAxisDatas[idx] floatValue];
                }else{
                    axisYValue = [self.configuration.showRightYAxisDatas[reversedArray.count - idx - 1] floatValue];
                }
            }else{
                if (self.configuration.yAxisIsReverse) {
                    axisYValue = [self.configuration.showRightYAxisDatas[reversedArray.count - idx - 1] floatValue];
                }else{
                    axisYValue = [self.configuration.showRightYAxisDatas[idx] floatValue];
                }
            }
#warning y轴翻转
            if (self.configuration.yAxisIsReverse) {

                if (self.configuration.xAxisIsBottom) {
                    textLayerY = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }else{
                    textLayerY = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }
                
            }else{
                if (self.configuration.xAxisIsBottom) {
                    textLayerY = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }else{
                    textLayerY = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
                }
            }
        }
        
        CGFloat yAxisTextLayerX = 0;
        if (isLeft) {
            yAxisTextLayerX = self.yAxisLabelsContainerMarginLeft - size.width - (self.configuration.hiddenLeftYAxis ? 0 :self.configuration. kYAxisLabelMargin);
        }else{
            yAxisTextLayerX = self.frame.size.width - self.yAxisLabelsContainerMarginRight + (self.configuration.hiddenRightYAxis ? 0 : self.configuration.kYAxisLabelMargin);
        }
        textlayer.frame = CGRectMake(yAxisTextLayerX,textLayerY, size.width, size.height); //size.width
        
        [self.layer addSublayer:textlayer];
        
        lastY = CGRectGetMaxY(textlayer.frame); //取最大高度
        if (size.width > maxWidth) {
            maxWidth = size.width;
        }
    }];
}


//更新最新的frame
- (void)fq_setMainContainer{
    _mainContainer.backgroundColor = self.configuration.mainContainerBackColor;
    _mainContainerW = self.frame.size.width - self.yAxisLabelsContainerMarginLeft - self.yAxisLabelsContainerMarginRight - 2 * _configuration.kYAxisChartViewMargin;
    _mainContainerH = self.frame.size.height - self.yAxisLabelsContainerMarginTop - self.yAxisLabelsContainerMarginBot;
    _mainContainer.frame = CGRectMake(self.yAxisLabelsContainerMarginLeft + _configuration.kYAxisChartViewMargin , self.yAxisLabelsContainerMarginTop, _mainContainerW, _mainContainerH);
    
    //提示竖直线
    _currentlineLayer.frame = CGRectMake(0, 0, 1, _mainContainerH);
    [self drawLineOfDashByCAShapeLayer:_currentlineLayer lineLength:5.0 lineSpacing: self.configuration.selectLineType == ChartSelectLineType_SolidLine ? 0 : 5.0 lineColor:self.configuration.currentLineColor directionHorizonal:NO];
    _currentlineLayer.opacity = 0.0f;

    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    
    CGFloat rowSpacing = (_mainContainerH - self.configuration.gridRowCount * self.configuration.gridLineWidth) / (self.configuration.gridRowCount - 1);
    CGFloat columnSpacing = (_mainContainerW - self.configuration.gridColumnCount * self.configuration.gridLineWidth) / (self.configuration.gridColumnCount - 1);
    
    //绘制横竖网格线
    _rowReplicatorLayer.instanceCount = self.configuration.gridRowCount;
    _rowBackLine.frame = CGRectMake(0, 0, _mainContainerW, self.configuration.gridLineWidth);
    [self drawLineOfDashByCAShapeLayer:_rowBackLine lineLength:5.0 lineSpacing:5.0 lineColor:self.configuration.gridLineColor directionHorizonal:YES];
    _rowReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, rowSpacing + self.configuration.gridLineWidth, 0);
    _rowReplicatorLayer.hidden  = self.configuration.yAxisGridHidden;
    
    _columnReplicatorLayer.instanceCount = self.configuration.gridColumnCount;
    _columnReplicatorLayer.frame = _rowReplicatorLayer.frame = _mainContainer.bounds;
    _columnBackLine.frame = CGRectMake(0, 0, self.configuration.gridLineWidth, _mainContainerH);
    [self drawLineOfDashByCAShapeLayer:_columnBackLine lineLength:5.0 lineSpacing:5.0 lineColor:self.configuration.gridLineColor directionHorizonal:NO];
    _columnReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(columnSpacing + self.configuration.gridLineWidth, 0, 0);
    _columnReplicatorLayer.hidden = self.configuration.xAxisGridHidden;
    
    //绘制x.y轴分割线
    CGFloat avageDistance = _mainContainerW / self.xAxisCount;
    if (self.configuration.isShowXAxisFlag) {
        for (int i = 0; i < self.xAxisCount - 1; ++i) {
            CALayer * xAxisFlag = [[CALayer alloc]init];
            if (self.configuration.xAxisIsBottom == YES) {
                xAxisFlag.frame = CGRectMake((i + 1)*avageDistance, _mainContainerH, 1.0f, 4.0f);
            }else{
                xAxisFlag.frame = CGRectMake((i + 1)*avageDistance, -4.0, 1.0f, 4.0f);
            }
            xAxisFlag.backgroundColor = [UIColor grayColor].CGColor;
            [_mainContainer.layer addSublayer:xAxisFlag];
        }
    }
    
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        
        CAShapeLayer * averageLineLayer = self.averageLineLayerArr[i];
        averageLineLayer.frame = CGRectMake(0,0, _mainContainerW, 1);
        FQSeriesElement *element = self.configuration.elements[i];
        [self drawLineOfDashByCAShapeLayer:averageLineLayer lineLength:5.0 lineSpacing: element.averageLineType == ChartSelectLineType_SolidLine ? 0 : 5.0 lineColor:element.averageLineColor directionHorizonal:YES];
        
        CGFloat averageLineValue = 0;
        CGFloat axisYValue = element.averageNum.floatValue;
        if (element.yAxisAligmentType == FQChartYAxisAligmentType_Left) {
            if (self.configuration.xAxisIsBottom) {
                averageLineValue = (1 - (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH;
            }else{
                averageLineValue = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH;
            }
        }else{
            if (self.configuration.xAxisIsBottom) {
                averageLineValue = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH;
            }else{
                averageLineValue = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH;
            }
        }
        averageLineLayer.frame = CGRectMake(0,averageLineValue, _mainContainerW, 1);
    }

    
    //绘制折线图
    for (int i = 0; i < self.lineElements.count; ++i) {
        
        FQSeriesElement * element = self.lineElements[i];
        CAShapeLayer * lineLayer = _lineLayerArr[i];
        lineLayer.strokeColor = element.mainColor.CGColor;
        lineLayer.lineWidth = element.lineWidth;
        
        CAShapeLayer * backLayer = _lineBackLayerArr[i];
        backLayer.fillColor = element.fillLayerBackgroundColor.CGColor;
        backLayer.hidden = element.fillLayerHidden;
        
        if (element.gradientColors.count > 0) {
            CAGradientLayer * lineGradientLayer = _lineGradientLayerArr[i];
            lineGradientLayer.mask = lineLayer;
            lineGradientLayer.colors = element.gradientColors;
            lineGradientLayer.frame = _mainContainer.bounds;
            
            if (element.isGradientFillLayer) {
                CAGradientLayer * backGradientLayer = _lineBackGradientLayerArr[i];
                backGradientLayer.mask = backLayer;
                backGradientLayer.colors = element.gradientColors;
                backGradientLayer.frame = _mainContainer.bounds;
            }
        }
    }
    
    //绘制柱状图
    FQSeriesElement * barElement = self.barElements.firstObject;
    for (int i = 0; i < barElement.orginDatas.count; ++i) {
        
        UIColor *color = barElement.mainColor;
        if (barElement.barColors > 0) {
            color = barElement.barColors[i%barElement.barColors.count];
        }
        
        CAShapeLayer * backLayer = _barBackLayerArr[i];
        backLayer.fillColor = barElement.barPlaceholderColor.CGColor;
        backLayer.lineWidth = 1.0f;

        CAShapeLayer * barLayer = _barLayerArr[i];
        barLayer.fillColor = color.CGColor;
        barLayer.lineWidth = 1.0f;
        
        if (barElement.gradientColors.count > 0) {
            CAGradientLayer * barGradientLayer = _barGradientLayerArr[i];
            barGradientLayer.frame = _mainContainer.bounds;
            barGradientLayer.colors = barElement.gradientColors;
            barGradientLayer.mask = barLayer;
        }
    }
    
    [CATransaction commit];
}

#pragma mark - 添加手势

- (void)fq_addGesture{
    if (!self.configuration.gestureEnabel) {
        return;
    }
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fq_tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [_mainContainer addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(fq_panGesture:)];
    [_mainContainer addGestureRecognizer:panGesture];
}

- (void)fq_tapGesture:(UITapGestureRecognizer *)gesture{
    //暂时设定为.x轴均为一组对应的上.滑动一种手势的.
    if (!_elementPointsArr.count) { //topView上显示当前图表对应数据所有数据
        return;
    }
    
    NSArray * pointArr = _elementPointsArr.firstObject;
    if (!pointArr.count) {
        return;
    }
    
    //取消隐藏方法
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(endChangCurveView) object:nil];
    
    CGPoint currentPoint = [gesture locationInView:_mainContainer];
    NSUInteger index = 0;
    CGFloat distace = MAXFLOAT;
    CGFloat x = 0;
    for (NSNumber *pointValue in pointArr) {
        CGPoint point = [pointValue CGPointValue];
        if (fabs(point.x - currentPoint.x) < distace) {
            index = [pointArr indexOfObject:pointValue];
            distace = fabs(point.x - currentPoint.x);
            x = point.x;
        }
    }
    currentPoint = [_mainContainer convertPoint:[pointArr[index] CGPointValue] toView:self];
    
    NSMutableArray * valueArr = [NSMutableArray array];
    NSMutableArray * selectPointArr = [NSMutableArray array];
    NSMutableString * muStr = [NSMutableString string];
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        FQSeriesElement * element = self.configuration.elements[i];
        NSArray * pointArr = self.elementPointsArr[i];
        NSArray * pointLayerArr = self.pointLayerArrs[i];
        
        if (pointLayerArr.count > self.selectIndex) {
            //显示选中点.
            CAShapeLayer *oldPointLayer = pointLayerArr[self.selectIndex];
            oldPointLayer.opacity = 0.0f;
        }
        
        if (element.orginDatas.count > index) {
            FQXAxisItem * xAxisItem = element.orginDatas[index];
            if (muStr.length != 0) {
                [muStr appendString:@"\n"];
            }
            [valueArr addObject:xAxisItem];
            [selectPointArr addObject:pointArr[index]];
            NSString * xAxisItemStr = [NSString stringWithFormat:@"x:%@,y:%@\n",xAxisItem.dataNumber,xAxisItem.dataValue];
            [muStr appendString:xAxisItemStr];
            
            //显示选中点.
            CAShapeLayer *selectPointLayer = pointLayerArr[index];
            selectPointLayer.opacity = 1.0f;
        }
    }
    
    self.selectIndex = index;
    _currentlineLayer.opacity = 1.0f;
    self.popTipView.layer.opacity = 1.0;
    //更新选中线条以及
    CGPoint selectLinePoint = [pointArr[index] CGPointValue];
    _currentlineLayer.frame = CGRectMake(selectLinePoint.x, 0, 1, _mainContainerH);
    self.popTipView.contentTextStr = muStr.copy;
    
    if (_delegateFlag.tapSelectItem) {
        [_delegate chartView:self tapSelectItem:valueArr.copy location:selectPointArr index:index];
    }
    
    if (_delegateFlag.changePopViewPositionWithView) {
        [_delegate chartView:self changePopViewPositionWithView:_popTipView itemData:valueArr.copy];
    }
    
    [self.popTipView fq_drawRectWithOrigin:CGPointMake(currentPoint.x, self.yAxisLabelsContainerMarginTop)];
    
    //3s消失
    [self performSelector:@selector(endChangCurveView) withObject:nil afterDelay:3.0f];
}

- (void)fq_panGesture:(UIPanGestureRecognizer *)gesture{
    //暂时设定为.x轴均为一组对应的上.滑动一种手势的.
    if (!_elementPointsArr.count) { //topView上显示当前图表对应数据所有数据
        return;
    }
    
    NSArray * pointArr = _elementPointsArr.firstObject;
    if (!pointArr.count) {
        return;
    }
    
    CGPoint currentPoint = [gesture locationInView:_mainContainer];// [gesture locationOfTouch:0 inView:self];
    NSUInteger index = 0;
    CGFloat distace = MAXFLOAT;
    CGFloat x = 0;
    for (NSNumber *pointValue in pointArr) {
        CGPoint point = [pointValue CGPointValue];
        if (fabs(point.x - currentPoint.x) < distace) {
            index = [pointArr indexOfObject:pointValue];
            distace = fabs(point.x - currentPoint.x);
            x = point.x;
        }
    }
    currentPoint = [_mainContainer convertPoint:[pointArr[index] CGPointValue] toView:self];
    
    NSMutableArray * valueArr = [NSMutableArray array];
    NSMutableArray * selectPointArr = [NSMutableArray array];
    NSMutableString * muStr = [NSMutableString string];
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        FQSeriesElement * element = self.configuration.elements[i];
        NSArray * pointArr = self.elementPointsArr[i];
        NSArray * pointLayerArr = self.pointLayerArrs[i];
        
        if (pointLayerArr.count > self.selectIndex) {
            //显示选中点.
            CAShapeLayer *oldPointLayer = pointLayerArr[self.selectIndex];
            oldPointLayer.opacity = 0.0f;
        }
        
        if (element.orginDatas.count > index) {
            FQXAxisItem * xAxisItem = element.orginDatas[index];
            if (muStr.length != 0) {
                [muStr appendString:@"\n"];
            }
            NSString * xAxisItemStr = [NSString stringWithFormat:@"x:%@,y:%@",xAxisItem.dataNumber,xAxisItem.dataValue];
            [muStr appendString:xAxisItemStr];
            [valueArr addObject:xAxisItem];
            [selectPointArr addObject:pointArr[index]];
            
            //显示选中点.
            CAShapeLayer *selectPointLayer = pointLayerArr[index];
            selectPointLayer.opacity = 1.0f;
        }
    }
    
    self.selectIndex = index;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_delegateFlag.panBeginItem) {
            [_delegate chartView:self panBeginItem:valueArr.copy location:selectPointArr.copy index:index];
        }
        
        if (_delegateFlag.changePopViewPositionWithView) {
            [_delegate chartView:self changePopViewPositionWithView:_popTipView itemData:valueArr.copy];
        }
        
        //取消隐藏方法
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(endChangCurveView) object:nil];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        _currentlineLayer.opacity = 1.0f;
        self.popTipView.layer.opacity = 1.0;
        //更新选中线条以及
        CGPoint selectLinePoint = [pointArr[index] CGPointValue];
        _currentlineLayer.frame = CGRectMake(selectLinePoint.x, 0, 1, _mainContainerH);
        self.popTipView.contentTextStr = muStr.copy;
        
        if (_delegateFlag.panChangeItem) {
            [_delegate chartView:self panChangeItem:valueArr.copy location:selectPointArr index:index];
        }
        
        if (_delegateFlag.changePopViewPositionWithView) {
            [_delegate chartView:self changePopViewPositionWithView:_popTipView itemData:valueArr.copy];
        }
        
        [self.popTipView fq_drawRectWithOrigin:CGPointMake(currentPoint.x, self.yAxisLabelsContainerMarginTop)];
    }
    
    if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed) {
        if (_delegateFlag.chartViewPanGestureEnd) {
            [_delegate chartViewPanGestureEnd:self];
        }
        //3s消失
        [self performSelector:@selector(endChangCurveView) withObject:nil afterDelay:3.0f];
    }
}


//3s消失
-(void)endChangCurveView{
    
    self.currentlineLayer.opacity = 0.0f;
    self.popTipView.layer.opacity = 0.0f;
    
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        NSArray * pointLayerArr = self.pointLayerArrs[i];
        if (pointLayerArr.count > self.selectIndex) {
            //显示选中点.
            CAShapeLayer *oldPointLayer = pointLayerArr[self.selectIndex];
            oldPointLayer.opacity = 0.0f;
        }
    }
}



#pragma mark - Tool

- (CGSize)fq_sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (CGSize)fq_sizeWithString:(NSString *)str attrs:(NSDictionary *)attrs maxSize:(CGSize)maxSize{
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(CAShapeLayer *)shapeLayer lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor directionHorizonal:(BOOL)isHorizonal {
    
    if (isHorizonal) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(shapeLayer.frame) / 2, CGRectGetHeight(shapeLayer.frame))];
        
    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(shapeLayer.frame) / 2, CGRectGetHeight(shapeLayer.frame)/2)];
    }
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(shapeLayer.frame)];
    } else {
        [shapeLayer setLineWidth:CGRectGetWidth(shapeLayer.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(shapeLayer.frame), 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(shapeLayer.frame));
    }
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
}

#pragma mark - 根据数据转换为点数据
/**
 计算出每个点的位置.左右均为60.上下均保留60.中间使用
 */
-(void)getChartViewPointArr{
    
    NSMutableArray *muArr  = [NSMutableArray array];
    for (FQSeriesElement *element in self.configuration.elements) {
        
        NSArray * elementPointArr = [self fq_changePointFromValue:element];
        [muArr addObject:elementPointArr];
    }
    self.elementPointsArr = muArr.copy;
}

/**
 *  将传入的点根据值转换为坐标
 */
- (NSArray *)fq_changePointFromValue:(FQSeriesElement *)element{
    NSMutableArray * pointArr = [NSMutableArray array];
    //y轴最大.最小值
    CGFloat ymaxValue = element.yAxisAligmentType == FQChartYAxisAligmentType_Left ? self.yAxisLeftMaxValue : self.yAxisRightMaxValue;
    CGFloat yminValue = element.yAxisAligmentType == FQChartYAxisAligmentType_Left ? self.yAxisLeftMinValue : self.yAxisRightMinValue;
    //x轴最大最小值
    CGFloat xmaxValue = self.xAxisMaxValue;
    CGFloat xminValue = self.xAxisMinValue;
    
    CGFloat average = _mainContainerW / self.xAxisCount;
    for (FQXAxisItem * dataItem in element.orginDatas) {
        
        //获取最大值.
        CGFloat xAxisNumber = dataItem.dataNumber.floatValue;
        CGFloat yAxisValue = dataItem.dataValue.floatValue;
        
        CGFloat x = (xAxisNumber - xminValue)/(xmaxValue - xminValue) * (_mainContainerW - average) + average * 0.5;
#warning - 调整Y轴上下关系
        
        CGFloat y = 0;
        if (self.configuration.yAxisIsReverse == YES) {
            y = self.configuration.xAxisIsBottom ? (yAxisValue - yminValue)/(ymaxValue - yminValue) * _mainContainerH : (1 - (yAxisValue - yminValue)/(ymaxValue - yminValue)) * _mainContainerH;
        }else{
            y = self.configuration.xAxisIsBottom ? (1 - (yAxisValue - yminValue)/(ymaxValue - yminValue)) * _mainContainerH : (yAxisValue - yminValue)/(ymaxValue - yminValue) * _mainContainerH;
        }

        [pointArr addObject: [NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }
    
    return pointArr.copy;
}



/**
 获取X轴相关数据
 */
-(void)getChartViewXAxisDataArr{
    
    CGFloat xAxisMax = 0;
    CGFloat xAxisMin = CGFLOAT_MAX;
    NSInteger maxCount = 0;
    FQSeriesElement *maxCountElement;
    for (FQSeriesElement *element in self.configuration.elements) {
        if (element.orginDatas.count > maxCount) {
            maxCount = element.orginDatas.count;
            maxCountElement = element;
        }
        
        FQXAxisItem *xAxisMaxItem =  element.orginDatas.lastObject;
        if (xAxisMaxItem.dataNumber.floatValue > xAxisMax) {
            xAxisMax = xAxisMaxItem.dataNumber.floatValue;
        }
        
        FQXAxisItem *xAxisMinItem =  element.orginDatas.firstObject;
        if (xAxisMinItem.dataNumber.floatValue < xAxisMin) {
            xAxisMin = xAxisMinItem.dataNumber.floatValue;
        }
    }
    self.xAxisMaxValue = xAxisMax;
    self.xAxisMinValue = xAxisMin;
    self.xAxisCount = maxCount;
    
    //这种样式就是等分展示
    if (self.configuration.showXAxisStringDatas && self.configuration.showXAxisStringDatas.count) {
        self.xAxisShowArr = self.configuration.showXAxisStringDatas;
        return;
    }
    
    NSMutableArray * muXAxisIntervalArr = [NSMutableArray array];
    //这种有争议 - 这种方式虽然是展示这种.不过不是等分.需要根据真实的数据显示.比较
    if (self.configuration.showXAxisStringNumberDatas && self.configuration.showXAxisStringNumberDatas.count) {
        //从里面选出最大的
        for (FQXAxisItem * axAxisItem in maxCountElement.orginDatas) {
            if ([self.configuration.showXAxisStringNumberDatas containsObject:axAxisItem.dataNumber.stringValue]) {
                [muXAxisIntervalArr addObject:[axAxisItem.dataNumber stringValue]];
            }else{
                [muXAxisIntervalArr addObject:@""];
            }
        }
        self.xAxisShowArr = muXAxisIntervalArr;
        return;
    }
    
    
    //还有一种隔几个显示一个
    if (self.configuration.showXAxisInterval > 0) {
        for (int i = 0; i < maxCount; ++i) {
            if (i%(int)(self.configuration.showXAxisInterval + 1) == 0) {
                FQXAxisItem * item = maxCountElement.orginDatas[i];
                [muXAxisIntervalArr addObject:[item.dataNumber stringValue]];
            }else{
                [muXAxisIntervalArr addObject:@""];
            }
        }
        self.xAxisShowArr = muXAxisIntervalArr.copy;
        return;
    }
    
    //最后一种就是有多少展示多少
    for (int i = 0; i < maxCount; ++i) {
        FQXAxisItem * item = maxCountElement.orginDatas[i];
        [muXAxisIntervalArr addObject:[item.dataNumber stringValue]];
    }
    self.xAxisShowArr = muXAxisIntervalArr.copy;
}

/**
 获取Y轴相关数据
 */
-(void)getChartViewYAxisDataArr{
    
    //根据x轴的值.给出源数据值
    if (self.configuration.elements.count != 0 && self.configuration.elements) {
        
        CGFloat leftMaxValue = 0;
        CGFloat leftMinValue = CGFLOAT_MAX;
        CGFloat rightMaxValue = 0;
        CGFloat rightMinValue = CGFLOAT_MAX;
        
        for (FQSeriesElement *element in self.configuration.elements) {
            if (element.yAxisAligmentType == FQChartYAxisAligmentType_Left) { //如果两组均为左侧.那么就以两组数据中的最大值
                //计算左Y轴的显示Arr
                for (FQXAxisItem * xAxisItem in element.orginDatas) {
                    if (xAxisItem.dataValue.floatValue > leftMaxValue) {
                        leftMaxValue = xAxisItem.dataValue.floatValue;
                    }
                    
                    if (xAxisItem.dataValue.floatValue < leftMinValue) {
                        leftMinValue = xAxisItem.dataValue.floatValue;
                    }
                }
            }else{
                //计算右Y轴的显示Arr
                for (FQXAxisItem * xAxisItem in element.orginDatas) {
                    if (xAxisItem.dataValue.floatValue > rightMaxValue) {
                        rightMaxValue = xAxisItem.dataValue.floatValue;
                    }
                    
                    if (xAxisItem.dataValue.floatValue < rightMinValue) {
                        rightMinValue = xAxisItem.dataValue.floatValue;
                    }
                }
            }
        }
        
        if (self.configuration.yLeftAxisMaxNumber && self.configuration.yLeftAxisMaxNumber.floatValue > leftMaxValue) {
            self.yAxisLeftMaxValue = self.configuration.yLeftAxisMaxNumber.floatValue;
        }else{
            self.yAxisLeftMaxValue = leftMaxValue;
        }
        
        if (self.configuration.yLeftAxisMinNumber && self.configuration.yLeftAxisMinNumber.floatValue < leftMinValue) {
            self.yAxisLeftMinValue = self.configuration.yLeftAxisMinNumber.floatValue;
        }else{
            self.yAxisLeftMinValue = leftMinValue;
        }
        
        if (self.configuration.yRightAxisMaxNumber && self.configuration.yRightAxisMaxNumber.floatValue > rightMaxValue) {
            self.yAxisRightMaxValue = self.configuration.yRightAxisMaxNumber.floatValue;
        }else{
            self.yAxisRightMaxValue = rightMaxValue;
        }
        
        if (self.configuration.yRightAxisMinNumber && self.configuration.yRightAxisMinNumber.floatValue < rightMinValue) {
            self.yAxisRightMinValue = self.configuration.yRightAxisMinNumber.floatValue;
        }else{
            self.yAxisRightMinValue = rightMinValue;
        }
        
        //如果设置的这种.也需要更新最大值与最小值
        NSArray *yLeftAxisDatas = self.configuration.showLeftYAxisDatas;
        
        if (yLeftAxisDatas.count != 0 && yLeftAxisDatas) {
            //使用yAxisDatas的值作为y坐标的标准
            self.yLeftAxisArr = yLeftAxisDatas;
            
            //获取最大值.
            if ([yLeftAxisDatas.lastObject floatValue] > self.yAxisLeftMaxValue) {
                self.yAxisLeftMaxValue = [yLeftAxisDatas.lastObject floatValue];
            }
            
            if (self.yAxisLeftMinValue > [yLeftAxisDatas.firstObject floatValue]) {
                self.yAxisLeftMinValue = [yLeftAxisDatas.firstObject floatValue];
            }
            
            NSMutableArray * muarr = [NSMutableArray array];
            for (NSNumber * leftAxisNumber in self.yLeftAxisArr) {
                [muarr addObject:leftAxisNumber.stringValue];
            }
            self.yLeftAxisShowArr = muarr;
        }
        
        NSArray *yRightAxisDatas = self.configuration.showRightYAxisDatas;
        
        if (yRightAxisDatas.count != 0 && yRightAxisDatas) {
            //使用yAxisDatas的值作为y坐标的标准
            self.yRightAxisArr = yRightAxisDatas;
            
            //获取最大值.
            if ([yRightAxisDatas.lastObject floatValue] > self.yAxisRightMaxValue) {
                self.yAxisRightMaxValue = [yRightAxisDatas.lastObject floatValue];
            }
            
            if (self.yAxisRightMinValue > [yRightAxisDatas.firstObject floatValue]) {
                self.yAxisRightMinValue = [yRightAxisDatas.firstObject floatValue];
            }
            
            
            NSMutableArray * muarr = [NSMutableArray array];
            for (NSNumber * leftAxisNumber in self.yRightAxisArr) {
                [muarr addObject:leftAxisNumber.stringValue];
            }
            self.yRightAxisShowArr = muarr;
        }
        
        if (self.configuration.showLeftYAxisNames && self.configuration.showLeftYAxisNames.count) {
            self.yLeftAxisShowArr = self.configuration.showLeftYAxisNames.mutableCopy;
        }else{
            if (self.yLeftAxisShowArr.count == 0  && self.yAxisLeftMinValue < MAXFLOAT) {
                CGFloat average = (self.yAxisLeftMaxValue - self.yAxisLeftMinValue)*1.0 / (_configuration.kDefaultYAxisNames - 1);
                NSMutableArray * muarr = [NSMutableArray array];
                for (int i = 0; i < _configuration. kDefaultYAxisNames; ++i) {
                    
                    [muarr addObject:[NSString stringWithFormat:@"%.1f",self.yAxisLeftMinValue + average * i]];
                }
                self.yLeftAxisShowArr = muarr;
            }
        }
        
        if (self.configuration.showRightYAxisNames && self.configuration.showRightYAxisNames.count) {
            self.yRightAxisShowArr = self.configuration.showRightYAxisNames;
        }else{
            if (self.yRightAxisShowArr.count == 0 && self.yAxisRightMinValue < MAXFLOAT) {
                CGFloat average = (self.yAxisRightMaxValue - self.yAxisRightMinValue) * 1.0 / (_configuration.kDefaultYAxisNames - 1);
                NSMutableArray * muarr = [NSMutableArray array];
                for (int i = 0; i < _configuration.kDefaultYAxisNames; ++i) {
                    
                    [muarr addObject:[NSString stringWithFormat:@"%.1f",self.yAxisRightMinValue + average * i]];
                }
                self.yRightAxisShowArr = muarr;
            }
        }
    }
}

#pragma mark - 绘制线条
-(void)fq_makeLinePathWithElement:(FQSeriesElement *)element withArr:(NSArray *)pointArray andChartTypeIndex:(NSInteger)index {
    //针对线条.处理
    UIBezierPath * path = [UIBezierPath bezierPath];
    UIBezierPath *backPath = [UIBezierPath bezierPath];
    CGPoint firstPoint = [pointArray[0] CGPointValue];
    CGPoint lastPoint = [pointArray[pointArray.count - 1] CGPointValue];
    [path moveToPoint:firstPoint];
    [backPath moveToPoint:CGPointMake(firstPoint.x, self.configuration.xAxisIsBottom ? _mainContainerH : 0)];
    for (int i = 0; i < pointArray.count - 1; ++i) {
        if (element.modeType == FQModeType_RoundedCorners) {
            CGPoint point1 = [pointArray[i] CGPointValue];
            CGPoint point2 = [pointArray[i + 1] CGPointValue];
            if (i == 0) {
                [backPath addLineToPoint:point1];
            }
            
            CGPoint midPoint = [self centerWithP1:point1 p2:point2];
            [backPath addQuadCurveToPoint:midPoint
                             controlPoint:[self controlPointWithP1:midPoint p2:point1]];
            [backPath addQuadCurveToPoint:point2
                             controlPoint:[self controlPointWithP1:midPoint p2:point2]];
            
            [path addQuadCurveToPoint:midPoint
                         controlPoint:[self controlPointWithP1:midPoint p2:point1]];
            [path addQuadCurveToPoint:point2
                         controlPoint:[self controlPointWithP1:midPoint p2:point2]];
            
        }else{
            NSValue * pointValue = pointArray[i + 1];
            CGPoint point = [pointValue CGPointValue];
            if (pointValue == pointArray[0]) {
                [backPath addLineToPoint:point];
                continue;
            }
            [backPath addLineToPoint:point];
            [path addLineToPoint:point];
        }
    }
    
    [backPath addLineToPoint:CGPointMake(lastPoint.x, self.configuration.xAxisIsBottom ? _mainContainerH : 0)];
    
    [self.linePathArr addObject: path];
    [self.lineBackPathArr addObject:backPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fq_drawLineWithPathWithIndex:index];
    });
}

/**
 *  根据path位置曲线
 */
- (void)fq_drawLineWithPathWithIndex:(NSInteger)index{
    UIBezierPath * path = _linePathArr[index];
    UIBezierPath * backPath = _lineBackPathArr[index];
    CAShapeLayer * backLayer = _lineBackLayerArr[index];
    CAShapeLayer * lineLayer = _lineLayerArr[index];
    
    backLayer.path =  backPath.CGPath;
    lineLayer.path = path.CGPath;
    lineLayer.strokeEnd = 1;
    if (self.configuration.drawWithAnimation) {
        CABasicAnimation *pointAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pointAnim.fromValue = @0;
        pointAnim.toValue = @1;
        pointAnim.duration = self.configuration.drawAnimationDuration;
        [lineLayer addAnimation:pointAnim forKey:@"drawLine"];
    }
}

#pragma mark - 绘制柱状图
-(void)fq_makeBarPathWithElement:(FQSeriesElement *)element withArr:(NSArray *)pointArray andChartTypeIndex:(NSInteger)index {
    
    CGFloat average = _mainContainerW / self.xAxisCount;
    CGFloat barW = element.barWidth ? : average - 2 * element.barSpacing;
    
    for (int i = 0; i < element.orginDatas.count; ++i) {
        CAShapeLayer * barLayer = self.barLayerArr[i];
        CAShapeLayer * barBackLayer = self.barBackLayerArr[i];
        CGPoint point = [pointArray[i] CGPointValue];
        // 创建柱状图
        UIBezierPath *barPath = [UIBezierPath bezierPath];
        UIBezierPath *barBackPath = [UIBezierPath bezierPath];
        
        if (self.configuration.xAxisIsBottom == YES) {
            //圆角样式
            if (element.modeType == FQModeType_RoundedCorners) {
                if (point.y > _mainContainerH - barW) {
                    //实际宽度
                    CGFloat spcing = (_mainContainerH - point.y) * 0.5;
                    CGFloat sinH = barW * 0.5 - spcing;
                    CGFloat sinR = barW * 0.5;
                    CGFloat angle = acos(sinH / sinR) * 2.0;
                    
                    CGFloat otherAngle = (M_PI - angle) * 0.5;
                    CGFloat topStartAngle = M_PI + otherAngle;
                    CGFloat topEndAngle = 2 * M_PI - otherAngle;
                    
                    CGFloat neBarW = sqrt(sinR * sinR - sinH * sinH);
                    CGFloat botStartAngle = otherAngle;
                    CGFloat botEndAndgle = M_PI - otherAngle;
                    
                    CGPoint topCenter = CGPointMake(point.x, point.y + sinR);
                    CGPoint botCenter = CGPointMake(point.x, _mainContainerH - sinR);
                    
                    [barPath moveToPoint:CGPointMake(point.x - neBarW, _mainContainerH - spcing)];
                    [barPath addArcWithCenter:topCenter radius:sinR startAngle:topStartAngle endAngle:topEndAngle clockwise:YES];
                    [barPath addArcWithCenter:botCenter radius:sinR startAngle:botStartAngle endAngle:botEndAndgle clockwise:YES];
                    
                }else{
                    
                    [barPath moveToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH - barW * 0.5)];
                    [barPath addLineToPoint:CGPointMake(point.x - barW * 0.5, point.y + barW * 0.5)];
                    [barPath addArcWithCenter:CGPointMake(point.x, point.y + barW * 0.5) radius:barW * 0.5 startAngle:M_PI endAngle:0 clockwise:YES];
                    [barPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH - barW * 0.5)];
                    [barPath addArcWithCenter:CGPointMake(point.x, _mainContainerH - barW * 0.5) radius:barW * 0.5 startAngle:0 endAngle:M_PI clockwise:YES];
                }
                
                [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH - barW * 0.5)];
                [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, barW * 0.5)];
                [barBackPath addArcWithCenter:CGPointMake(point.x, barW * 0.5) radius:barW * 0.5 startAngle:M_PI endAngle:0 clockwise:YES];
                [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH - barW * 0.5)];
                [barBackPath addArcWithCenter:CGPointMake(point.x, _mainContainerH - barW * 0.5) radius:barW * 0.5 startAngle:0 endAngle:M_PI clockwise:YES];
            }else{ //正常的棱角
                [barPath moveToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH)];
                [barPath addLineToPoint:CGPointMake(point.x - barW * 0.5, point.y)];
                [barPath addLineToPoint:CGPointMake(point.x + barW *0.5, point.y)];
                [barPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH)];
                
                [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH)];
                [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, 0)];
                [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, 0)];
                [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH)];
            }
        }else{
            if (element.modeType == FQModeType_RoundedCorners) {
                if (point.y < barW) {
                    //实际宽度
                    CGFloat spcing = point.y * 0.5;
                    CGFloat sinH = barW * 0.5 - spcing;
                    CGFloat sinR = barW * 0.5;
                    CGFloat angle = acos(sinH / sinR) * 2.0;
                    
                    CGFloat otherAngle = (M_PI - angle) * 0.5;
                    CGFloat topStartAngle = M_PI + otherAngle;
                    CGFloat topEndAngle = 2 * M_PI - otherAngle;
                    
                    CGFloat neBarW = sqrt(sinR * sinR - sinH * sinH);
                    CGFloat botStartAngle = otherAngle;
                    CGFloat botEndAndgle = M_PI - otherAngle;
                    
                    CGPoint topCenter = CGPointMake(point.x, sinR);
                    CGPoint botCenter = CGPointMake(point.x, point.y - sinR);
                    
                    [barPath moveToPoint:CGPointMake(point.x - neBarW, spcing)];
                    [barPath addArcWithCenter:topCenter radius:sinR startAngle:topStartAngle endAngle:topEndAngle clockwise:YES];
                    [barPath addArcWithCenter:botCenter radius:sinR startAngle:botStartAngle endAngle:botEndAndgle clockwise:YES];
                }else{
                    
                    [barPath moveToPoint:CGPointMake(point.x - barW * 0.5, barW * 0.5)];
                    [barPath addLineToPoint:CGPointMake(point.x - barW * 0.5, point.y - barW * 0.5)];
                    [barPath addArcWithCenter:CGPointMake(point.x, point.y - barW * 0.5) radius:barW * 0.5 startAngle:M_PI endAngle:0 clockwise:NO];
                    [barPath addLineToPoint:CGPointMake(point.x + barW *0.5, point.y - barW * 0.5)];
                    [barPath addArcWithCenter:CGPointMake(point.x, barW * 0.5) radius:barW * 0.5 startAngle:0 endAngle:M_PI clockwise:NO];
                }
                
                [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, barW * 0.5)];
                [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH - barW * 0.5)];
                [barBackPath addArcWithCenter:CGPointMake(point.x, _mainContainerH - barW * 0.5) radius:barW * 0.5 startAngle:M_PI endAngle:0 clockwise:NO];
                [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, barW * 0.5)];
                [barBackPath addArcWithCenter:CGPointMake(point.x,  barW * 0.5) radius:barW * 0.5 startAngle:0 endAngle:M_PI clockwise:NO];
            }else{
                [barPath moveToPoint:CGPointMake(point.x - barW * 0.5, 0)];
                [barPath addLineToPoint:CGPointMake(point.x - barW * 0.5, point.y)];
                [barPath addLineToPoint:CGPointMake(point.x + barW *0.5, point.y)];
                [barPath addLineToPoint:CGPointMake(point.x + barW *0.5, 0)];
                
                [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, 0)];
                [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH)];
                [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH)];
                [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, 0)];
            }
        }
    
#pragma mark - 柱状图的动画.
        dispatch_async(dispatch_get_main_queue(), ^{
            barBackLayer.path = barBackPath.CGPath;
            barLayer.path = barPath.CGPath;
            barLayer.strokeEnd = 1;
            if (self.configuration.drawWithAnimation) {
                CABasicAnimation *pointAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                pointAnim.fromValue = @0;
                pointAnim.toValue = @1;
                pointAnim.duration = self.configuration.drawAnimationDuration;
                [barLayer addAnimation:pointAnim forKey:@"drawBarLayer"];
            }
        });
    }
    
}

#pragma mark - 绘制点图
-(void)fq_makePointPathWithElement:(FQSeriesElement *)element withArr:(NSArray *)pointArray andChartTypeIndex:(NSInteger)index {
    
}

//这种是纯色
- (CAShapeLayer*)pointLayerWithDiameter:(CGFloat)diameter
                                  color:(UIColor*)color
                                 center:(CGPoint)center
                                  borderColor:(UIColor*)borderColor
                                 borderW:(CGFloat)borderW{
    CAShapeLayer* pointLayer = [CAShapeLayer layer];
    UIBezierPath* path = [UIBezierPath
                          bezierPathWithRoundedRect:CGRectMake(center.x - diameter / 2,
                                                               center.y - diameter / 2, diameter,
                                                               diameter)
                          cornerRadius:diameter / 2];
    pointLayer.path = path.CGPath;
    pointLayer.fillColor = color.CGColor;
    pointLayer.lineWidth = borderW;
    pointLayer.strokeColor = borderColor.CGColor;
    return pointLayer;
}

//这种是有白间距
- (CAShapeLayer*)annularPointLayerWithDiameter:(CGFloat)diameter
                                         color:(UIColor*)color
                                        center:(CGPoint)center {
    CAShapeLayer* pointLayer = [CAShapeLayer layer];
    UIBezierPath* path = [UIBezierPath
                          bezierPathWithRoundedRect:CGRectMake(center.x - diameter / 2,
                                                               center.y - diameter / 2, diameter,
                                                               diameter)
                          cornerRadius:diameter / 2];
    
    pointLayer.path = path.CGPath;
    pointLayer.fillColor = color.CGColor;
    pointLayer.strokeColor = [UIColor whiteColor].CGColor;
    pointLayer.lineWidth = 3;
    return pointLayer;
}


//这边等会看看是否需要处理一下
- (CGPoint)controlPointWithP1:(CGPoint)p1 p2:(CGPoint)p2 {
    CGPoint point = [self centerWithP1:p1 p2:p2];
    CGFloat differY = fabs(p1.y - point.y);
    if (p1.y > p2.y) {
        point.y -= differY;
    } else {
        point.y += differY;
    }
    return point;
}

- (CGPoint)centerWithP1:(CGPoint)p1 p2:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) / 2.0f, (p1.y + p2.y) / 2.0f);
}

//根据传入的数据一一展示X轴
-(void)fq_getChartPointAndPath{
    
    //获取每个点对应的位置.
    [self getChartViewPointArr];
    
    NSInteger lineElementIndex = 0;
    NSInteger barElementIndex = 0;
    NSInteger pointElementIndex = 0;
    //开始绘制折线
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        FQSeriesElement * element = self.configuration.elements[i];
        NSArray * pointArr = self.elementPointsArr[i];
        
        //添加选中点页面
        if (self.configuration.isShowSelectPoint) {
            NSMutableArray * pointViewArr = [NSMutableArray array];
            for (NSValue * pointValue in pointArr) {
                CAShapeLayer * pointLayer = [self pointLayerWithDiameter:10 color:self.configuration.selectPointColor center:[pointValue CGPointValue] borderColor:UIColor.whiteColor borderW:self.configuration.isSelectPointBorder ? 3.0 : 0.0];
                pointLayer.opacity = 0.0f;
                [pointViewArr addObject:pointLayer];
                [_mainContainer.layer addSublayer:pointLayer];
            }
            [self.pointLayerArrs addObject:pointViewArr.copy];
        }
        
        if (element.chartType == FQChartType_Line) {
            [self fq_makeLinePathWithElement:element withArr:pointArr andChartTypeIndex:lineElementIndex];
            lineElementIndex += 1;
        }else if (element.chartType == FQChartType_Bar){
            [self fq_makeBarPathWithElement:element withArr:pointArr andChartTypeIndex:barElementIndex];
            barElementIndex += 1;
        }else if (element.chartType == FQChartType_Point){
            [self fq_makePointPathWithElement:element withArr:pointArr andChartTypeIndex:pointElementIndex];
            pointElementIndex += 1;
        }
    }
}


#pragma mark - pubilic methods

//开始绘制
- (void)fq_drawCurveView{
    [self layoutIfNeeded];
    //获取X.Y轴相关数据.包含.最大值.最小值.展示值数组.参考值数组
    [self getChartViewYAxisDataArr];
    [self getChartViewXAxisDataArr];
    //初始化图表相关属性
    [self fq_setMainContainer];
    //获取图表的点与路径
    [self fq_getChartPointAndPath];
    //X.Y轴的描述
    [self fq_setXAxisLabelsContainer];
    [self fq_setYAxisLeftLabelsContainer];
    [self fq_setYAxisRightLabelsContainer];
    //添加手势
    [self fq_addGesture];
}


/**
 根据新配置文件.重新刷新图表
 
 @param configuration 配置文件
 */
-(void)refreshChartViewWithConfiguration:(FQChartConfiguration *)configuration
{
    self.configuration = configuration;
    
    //清空图表
    [self clearChartView];
    
    [self creatUI];
    
    [self fq_drawCurveView];
}

/**
 根据最新的itemdata数据.刷新图表
 
 @param axisItemDataArrs 图表数据数组.
 */
-(void)refreshChartViewWithDataArr:(NSArray *)axisItemDataArrs
{
    //清空图表
    [self clearChartView];
    
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        if (axisItemDataArrs.count > i) { //防止原本两个图表.只传入一个数据.
            NSArray * axisItemArr = axisItemDataArrs[i];
            FQSeriesElement * element = self.configuration.elements[i];
            if ([axisItemArr isKindOfClass:[NSArray class]]) {
                element.orginNumberDatas = axisItemArr;
            }
        }
    }
    
    [self creatUI];
    
    [self fq_drawCurveView];
}

/**
 清空图表位置.
 */
-(void)clearChartView{
    
    [_mainContainer removeFromSuperview];
    [_barElements removeAllObjects];
    [_lineElements removeAllObjects];
    [_pointElements removeAllObjects];
    [_linePathArr removeAllObjects];
    [_lineLayerArr removeAllObjects];
    [_lineBackPathArr removeAllObjects];
    [_lineGradientLayerArr removeAllObjects];
    [_barLayerArr removeAllObjects];
    [_barBackLayerArr removeAllObjects];
    [_barGradientLayerArr removeAllObjects];
    [_lineBackGradientLayerArr removeAllObjects];
    
    NSInteger count = self.layer.sublayers.count;
    for (int i = 0; i < count; ++i) {
        CALayer *layer = self.layer.sublayers[0];
        [layer removeFromSuperlayer];
    }
}

#pragma mark - 懒加载


#pragma mark - 折线图
-(NSMutableArray<CAShapeLayer *> *)lineLayerArr
{
    if (!_lineLayerArr) {
        _lineLayerArr = [NSMutableArray array];
    }
    return _lineLayerArr;
}

-(NSMutableArray<CAShapeLayer *> *)lineBackLayerArr
{
    if (!_lineBackLayerArr) {
        _lineBackLayerArr = [NSMutableArray array];
    }
    return _lineBackLayerArr;
}

-(NSMutableArray<UIBezierPath *> *)linePathArr
{
    if (!_linePathArr) {
        _linePathArr = [NSMutableArray array];
    }
    return _linePathArr;
}

-(NSMutableArray<UIBezierPath *> *)lineBackPathArr
{
    if (!_lineBackPathArr) {
        _lineBackPathArr = [NSMutableArray array];
    }
    return _lineBackPathArr;
}

-(NSMutableArray<CAGradientLayer *> *)lineGradientLayerArr
{
    if (!_lineGradientLayerArr) {
        _lineGradientLayerArr = [NSMutableArray array];
    }
    return _lineGradientLayerArr;
}

-(NSMutableArray<CAGradientLayer *> *)lineBackGradientLayerArr
{
    if (!_lineBackGradientLayerArr) {
        _lineBackGradientLayerArr = [NSMutableArray array];
    }
    return _lineBackGradientLayerArr;
}

#pragma mark - 柱状图
-(NSMutableArray<CAShapeLayer *> *)barLayerArr
{
    if (!_barLayerArr) {
        _barLayerArr = [NSMutableArray array];
    }
    return _barLayerArr;
}

-(NSMutableArray<CAShapeLayer *> *)barBackLayerArr
{
    if (!_barBackLayerArr) {
        _barBackLayerArr = [NSMutableArray array];
    }
    return _barBackLayerArr;
}

-(NSMutableArray<CAGradientLayer *> *)barGradientLayerArr
{
    if (!_barGradientLayerArr) {
        _barGradientLayerArr = [NSMutableArray array];
    }
    return _barGradientLayerArr;
}

#pragma mark - 各种样式总线条数组
//线条的绘制数据数组
-(NSMutableArray<FQSeriesElement *> *)lineElements
{
    if (!_lineElements) {
        _lineElements = [NSMutableArray array];
    }
    return _lineElements;
}
//柱状图绘制数据数组
-(NSMutableArray<FQSeriesElement *> *)barElements
{
    if (!_barElements) {
        _barElements = [NSMutableArray array];
    }
    return _barElements;
}
//点图绘制数据数组
-(NSMutableArray<FQSeriesElement *> *)pointElements
{
    if (!_pointElements) {
        _pointElements = [NSMutableArray array];
    }
    return _pointElements;
}


-(FQPopTipView *)popTipView
{
    if (!_popTipView) {
        if (self.configuration.customPopTip) {
            _popTipView = self.configuration.customPopTip;
        }else{
            _popTipView = [FQPopTipView initWithPopViewWithDirection:self.configuration.popArrowDirection maxX:self.bounds.size.width minX:0 edge:UIEdgeInsetsMake(5, 5, 5, 5) contentText:@"x:y:" textColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:15]];
            _popTipView.marginSpcingW = 20;
            _popTipView.marginSpcingH = 10;
            _popTipView.cornerRadius = 5.0f;
            _popTipView.contentBackColor = self.configuration.popContentBackColor;
        }
    }
    return _popTipView;
}

-(NSMutableArray<NSArray *> *)pointLayerArrs
{
    if (!_pointLayerArrs) {
        _pointLayerArrs = [NSMutableArray array];
    }
    return _pointLayerArrs;
}

-(NSMutableArray<CAShapeLayer *> *)averageLineLayerArr
{
    if (!_averageLineLayerArr) {
        _averageLineLayerArr = [NSMutableArray array];
    }
    return _averageLineLayerArr;
}

@end
