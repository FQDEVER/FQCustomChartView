//
//  FQChartView.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQChartView.h"
#import "FQPopTipView.h"

#define PieColorLayerW 4
#define PieColorLayerH 16
#define PieTextLayerMargin 5
#define PieTextItemHeight 15

typedef struct {
    unsigned int tapSelectItem  :1;
    unsigned int panBeginItem :1;
    unsigned int panChangeItem :1;
    unsigned int chartViewPanGestureEnd :1;
    unsigned int changePopViewPositionWithView    :1;
} flag;

@interface FQChartView()

#pragma mark - 数据相关

/**
 配置文件
 */
@property (nonatomic, strong) FQChartConfiguration *configuration;

/**
 代理标识
 */
@property (nonatomic, assign) flag delegateFlag;

/**
 弹出提示视图
 */
@property (nonatomic, strong) FQPopTipView *popTipView;

/**
 整个背景layer
 */
@property (nonatomic, strong) CALayer *chartViewBackGroundLayer;

#pragma mark - Y轴相关

/**
 Y轴左侧展示数据.
 */
@property (nonatomic, strong) NSArray *yLeftAxisShowArr;

/**
 Y轴右侧展示数据
 */
@property (nonatomic, strong) NSArray *yRightAxisShowArr;

/**
 Y轴左侧参考数据
 */
@property (nonatomic, strong) NSArray *yLeftAxisArr;

/**
 Y轴右侧参考数据
 */
@property (nonatomic, strong) NSArray *yRightAxisArr;

/**
 y轴左侧最大值
 */
@property (nonatomic, assign) CGFloat yAxisLeftMaxValue;

/**
 y轴左侧最小值
 */
@property (nonatomic, assign) CGFloat yAxisLeftMinValue;

/**
 y轴右侧最大值
 */
@property (nonatomic, assign) CGFloat yAxisRightMaxValue;

/**
 y轴右侧最小值
 */
@property (nonatomic, assign) CGFloat yAxisRightMinValue;

#pragma mark - X轴相关

/**
 X轴展示数据.没有就用空格展示.保证能对应上.不能使用等分
 */
@property (nonatomic, strong) NSArray *xAxisShowArr;

/**
 X轴参考数量.一共有多少个点.就展示多少个x轴点.并且等分
 */
@property (nonatomic, assign) NSInteger xAxisCount;

/**
 X轴最大值
 */
@property (nonatomic, assign) CGFloat xAxisMaxValue;

/**
 X轴最小
 */
@property (nonatomic, assign) CGFloat xAxisMinValue;

/**
 纪录每一种图表的点数组.
 */
@property (nonatomic, strong) NSArray *elementPointsArr;

/**
纪录x轴的所有textLayer.方便更新调整状态
*/
@property (nonatomic, strong) NSMutableArray<CATextLayer *>* xAiaxTextLayers;

#pragma mark - 图表绘制相关

/**
 背景线相关 - 参考线 - 默认为 y轴5条.x轴有多少就是多少条
 */
@property (nonatomic, weak) CAReplicatorLayer *rowReplicatorLayer;
@property (nonatomic, weak) CAReplicatorLayer *columnReplicatorLayer;
@property (nonatomic, weak) CAShapeLayer *rowBackLine;
@property (nonatomic, weak) CAShapeLayer *columnBackLine;

/**
 内容图表视图
 */
@property (nonatomic, weak) UIView *mainContainer;
@property (nonatomic, assign) CGFloat mainContainerW;
@property (nonatomic, assign) CGFloat mainContainerH;

/**
 Y轴的最大宽度 - 左右均算 - 默认为40
 */
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginRight;
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginLeft;

//Y轴的上下边距

/**
 上下默认为20
 */
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginTop;
@property (nonatomic, assign) CGFloat yAxisLabelsContainerMarginBot;

/**
 平均线数组
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *averageLineLayerArr;

/**
 当前选中线
 */
@property (nonatomic, strong) UIView *currentLineView;
@property (nonatomic, weak) CAShapeLayer *currentlineLayer;

/**
 线条的绘制数据数组
 */
@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *lineElements;

/**
 柱状图绘制数据数组
 */
@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *barElements;

///**
// 点图绘制数据数组
// */
//@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *pointElements;

/**
 圆饼绘制数据数组
 */
@property (nonatomic, strong) NSMutableArray<FQSeriesElement *> *pieElements;

/**
 水平柱状图数据数组
 */
@property (nonatomic, strong) NSMutableArray<FQHorizontalBarElement *> *horBarElements;


/**
 选中点数组.全部记录下来.并且隐藏
 */
@property (nonatomic, strong) NSMutableArray<NSArray *> *pointLayerArrs;

/**
 当前选中索引.默认为0.
 */
@property (nonatomic, assign) NSInteger selectIndex;

/*---------------------------------------------赛程标识数据----------------------------------------*/
#pragma mark - 赛程标识数据
@property (nonatomic, strong) NSMutableArray<UIView *> * sportSchedulesLayerArr ;


/*---------------------------------------------绘制折线----------------------------------------*/

/**
 折线数组.一个layer即一条折线.用于多条折线重叠样式
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *lineLayerArr;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *lineBackLayerArr;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *linePathArr;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *lineBackPathArr;
@property (nonatomic, strong) NSMutableArray<CAGradientLayer *> *lineGradientLayerArr;
@property (nonatomic, strong) NSMutableArray<CAGradientLayer *> *lineBackGradientLayerArr;

/*---------------------------------------------绘制柱状.-只允许一组----------------------------------------*/

/**
 柱状图.多个柱状Layer数组
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *barLayerArr;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *barBackLayerArr;
@property (nonatomic, strong) CAGradientLayer *barGradientLayer;
@property (nonatomic, strong) CALayer *barContainerLayer;//添加一个柱状图所有容器.方便做渐变


/*---------------------------------------------圆饼图 - 只允许一组.----------------------------------------*/

/**
 圆饼图每个分饼layer数组
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *pieLayerArr;
@property (nonatomic, strong) NSArray <NSNumber *>*pieItemAccountedArr;//圆饼图各元素占比
@property (nonatomic, strong) NSArray<NSString *> *showPieNameDatas;//圆饼图描述昵称
@property (nonatomic, strong) NSArray<NSNumber *> *pieStrokeStartArray;//起点绘制数组
@property (nonatomic, strong) NSArray<NSNumber *> *pieStrokeEndArray;//终点绘制数组
@property (nonatomic, strong) CAShapeLayer *pieCenterMaskLayer; //圆饼图PieLayer
@property (nonatomic, strong) CAShapeLayer *pieBackLayer; //圆饼图默认背景色


/*---------------------------------------------水平柱状图 = 只有一组----------------------------------------*/


/**
 水平柱状图layer数组
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *horBarLayerArr;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *horBarBackLayerArr;
@property (nonatomic, strong) CAGradientLayer *horBarGradientLayer;
@property (nonatomic, strong) CALayer *horBarContainerLayer;//添加一个柱状图所有容器.方便做渐变
@property (nonatomic, strong) NSMutableArray<NSValue *> *horBarPointArr;//每个柱状图的高度
@property (nonatomic, strong) NSMutableArray<NSString *> *horBarXLeftAxisArr;//x轴左侧展示数组
@property (nonatomic, strong) NSMutableArray<NSString *> *horBarContentArr;//图表展示内容数组
@property (nonatomic, strong) NSMutableArray<NSString *> *horBarTopDescArr;//图表顶部描述
@property (nonatomic, strong) NSMutableArray<NSString *> *horBarxRightAxisArr;//x轴右侧展示数组


/*---------------------------------------------网状图 = 只有一组----------------------------------------*/


/**
 网状图layer数组
 */
//@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *horBarLayerArr;
//@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *horBarBackLayerArr;
//@property (nonatomic, strong) CAGradientLayer *horBarGradientLayer;
//@property (nonatomic, strong) CALayer *horBarContainerLayer;//添加一个柱状图所有容器.方便做渐变
//@property (nonatomic, strong) NSMutableArray<NSValue *> *horBarPointArr;//每个柱状图的高度
//@property (nonatomic, strong) NSMutableArray<NSString *> *horBarXLeftAxisArr;//x轴左侧展示数组
//@property (nonatomic, strong) NSMutableArray<NSString *> *horBarContentArr;//图表展示内容数组
//@property (nonatomic, strong) NSMutableArray<NSString *> *horBarTopDescArr;//图表顶部描述
//@property (nonatomic, strong) NSMutableArray<NSString *> *horBarxRightAxisArr;//x轴右侧展示数组

/*---------------------------------------------双向柱状----------------------------------------*/

/**
 左侧双向柱状视图数组
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *leftBothwayBarLayerArr;

/**
 右侧双向柱状视图数组
 */
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *rightBothwayBarLayerArr;

/**
 中间文本layer数组
 */
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *midTextBothwayBarLayerArr;

/**
 右侧文本layer
 */
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *rightTextBothwayBarLayerArr;

/**
 左侧文本layer
 */
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *leftTextBothwayBarLayerArr;



#pragma mark - 获取.文本的宽与高 - 后续用到.

/**
 y轴Label的高度，默认取根据列标字体自动计算高度
 */
@property (nonatomic, assign) CGFloat yAxisLabelsHeight;

/**
 x轴Label的宽度，默认根据行标的文字自动计算
 */
@property (nonatomic, assign) CGFloat xAxisLabelsWidth;

@end

@implementation FQChartView

-(instancetype)initWithFrame:(CGRect)frame withConfiguation:(FQChartConfiguration *)configuration
{
    if (self = [super initWithFrame:frame]) {
        self.configuration = configuration;
    }
    return self;
}

-(void)fq_creatUI{
    
    _chartViewBackGroundLayer = [[CALayer alloc]init];
    _chartViewBackGroundLayer.cornerRadius = 5.0f;
    _chartViewBackGroundLayer.masksToBounds = YES;
    _chartViewBackGroundLayer.backgroundColor = self.configuration.chartBackLayerColor.CGColor;
    _chartViewBackGroundLayer.drawsAsynchronously = YES;
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
            CAShapeLayer *curveLineLayer = [CAShapeLayer new];
            curveLineLayer.fillColor = nil;
            curveLineLayer.lineJoin = kCALineCapRound;
            curveLineLayer.drawsAsynchronously = YES;
            [mainContainer.layer addSublayer:curveLineLayer];
            [self.lineLayerArr addObject:curveLineLayer];
            
            CAShapeLayer * backLayer = [CAShapeLayer new];
            backLayer.drawsAsynchronously = YES;
            [mainContainer.layer addSublayer:backLayer];
            [self.lineBackLayerArr addObject:backLayer];
            
            if (element.gradientColors.count > 0) {
                CAGradientLayer *lineGradientLayer = [CAGradientLayer new];
                lineGradientLayer.startPoint = CGPointMake(1, 1);
                lineGradientLayer.endPoint = CGPointMake(1, 0);
                lineGradientLayer.drawsAsynchronously = YES;
                [_mainContainer.layer addSublayer:lineGradientLayer];
                [self.lineGradientLayerArr addObject:lineGradientLayer];
                
                CAGradientLayer *backGradientLayer = [CAGradientLayer new];
                backGradientLayer.startPoint = CGPointMake(1, 1);
                backGradientLayer.endPoint = CGPointMake(1, 0);
                backGradientLayer.drawsAsynchronously = YES;
                [_mainContainer.layer addSublayer:backGradientLayer];
                [self.lineBackGradientLayerArr addObject:backGradientLayer];
            }
            
            [self.lineElements addObject:element];
            
        }else if (element.chartType == FQChartType_Bar){
            if (self.barElements.count > 0) {
                continue;
            }
            
            self.barContainerLayer  = [[CALayer alloc]init];
            self.barContainerLayer.drawsAsynchronously = YES;
            self.barContainerLayer.frame = self.mainContainer.bounds;
            [self.mainContainer.layer addSublayer:self.barContainerLayer];
            
            for (int i = 0; i < element.orginDatas.count; ++i) {
                
                CAShapeLayer * backLayer = [CAShapeLayer new];
                backLayer.fillColor = nil;
                backLayer.drawsAsynchronously = YES;
                [mainContainer.layer addSublayer:backLayer];
                [self.barBackLayerArr addObject:backLayer];
                
                CAShapeLayer *barLayer = [CAShapeLayer new];
                barLayer.fillColor = nil;
                barLayer.drawsAsynchronously = YES;
                [self.barContainerLayer addSublayer:barLayer];
                [self.barLayerArr addObject:barLayer];
                
            }
            
            if (element.gradientColors.count > 0) {
                CAGradientLayer *barGradientLayer = [CAGradientLayer new];
                barGradientLayer.startPoint = CGPointMake(1, 1);
                barGradientLayer.endPoint = CGPointMake(1, 0);
                barGradientLayer.drawsAsynchronously = YES;
                [mainContainer.layer addSublayer:barGradientLayer];
                self.barGradientLayer = barGradientLayer;
            }
            
            [self.barElements addObject:element];
            
        }
        //        else if (element.chartType == FQChartType_Point){
        //            [self.pointElements addObject:element];
        //        }
        
        CAShapeLayer * averagelineLayer = [CAShapeLayer new];
        [self.averageLineLayerArr addObject:averagelineLayer];
        averagelineLayer.drawsAsynchronously = YES;
        [mainContainer.layer addSublayer:averagelineLayer];
    }
    
    if (self.pieElements.count == 0) {
        
        _currentLineView = [[UIView alloc]init];
        _currentLineView.backgroundColor = UIColor.clearColor;
        _currentLineView.hidden = self.configuration.isHiddenCurrentLine;
        [_mainContainer addSubview:_currentLineView];
        
        CAShapeLayer *currentLineLayer = [CAShapeLayer new];
        _currentlineLayer = currentLineLayer;
        _currentlineLayer.drawsAsynchronously = YES;
        [_currentLineView.layer addSublayer:currentLineLayer];
    }
}

#pragma mark - 私有方法 - setter methods

-(void)setChartDelegate:(id<FQChartViewDelegate>)chartDelegate{
    _chartDelegate = chartDelegate;
    _delegateFlag.tapSelectItem = [chartDelegate respondsToSelector:@selector(chartView:tapSelectItem:location:index:)];
    _delegateFlag.panBeginItem = [chartDelegate respondsToSelector:@selector(chartView:panBeginItem:location:index:)];
    _delegateFlag.panChangeItem = [chartDelegate respondsToSelector:@selector(chartView:panChangeItem:location:index:)];
    _delegateFlag.chartViewPanGestureEnd = [chartDelegate respondsToSelector:@selector(chartViewPanGestureEnd:)];
    _delegateFlag.changePopViewPositionWithView = [chartDelegate respondsToSelector:@selector(chartView:changePopViewPositionWithView:itemData:)];
}

-(void)setConfiguration:(FQChartConfiguration *)configuration
{
    _configuration = configuration;
    
    if (configuration.yAxisLeftTitle.length != 0 && configuration.unitDescrType == ChartViewUnitDescrType_LeftRight) {
        
        self.yAxisLabelsContainerMarginLeft =  configuration.kChartViewAndYAxisLabelMargin + ((!configuration.hiddenLeftYAxis) ? configuration.kChartViewWidthMargin +configuration.kYAxisLabelMargin : 0);
    }else{
        self.yAxisLabelsContainerMarginLeft = ((!configuration.hiddenLeftYAxis) ? configuration.kChartViewWidthMargin + configuration.kYAxisLabelMargin : 0);
    }
    
    if (configuration.yAxisRightTitle.length != 0 && configuration.unitDescrType == ChartViewUnitDescrType_LeftRight) {
        
        self.yAxisLabelsContainerMarginRight = configuration.kChartViewAndYAxisLabelMargin + ((!configuration.hiddenRightYAxis) ?configuration.kChartViewWidthMargin +configuration.kYAxisLabelMargin : 0);
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
    
    self.yAxisLabelsContainerMarginLeft += self.configuration.chartViewEdgeInsets.left;
    self.yAxisLabelsContainerMarginRight += self.configuration.chartViewEdgeInsets.right;
    self.yAxisLabelsContainerMarginTop += self.configuration.chartViewEdgeInsets.top;
    self.yAxisLabelsContainerMarginBot += self.configuration.chartViewEdgeInsets.bottom;
}


#pragma mark - 私有方法 - 绘制X.Y轴

- (void)fq_setYAxisLabelsContainer{
//数据数组.
    FQSeriesElement * element = self.configuration.elements.firstObject;
    NSArray<FQXAxisItem *>*dataArr = element.orginDatas;
    NSArray * pointValueArr = self.elementPointsArr;
    for (int i = 0; i < dataArr.count; ++i) {
        FQXAxisItem * axisItem = dataArr[i];
        NSString *valueStr = [NSString stringWithFormat:@"%@%@", axisItem.dataValue.stringValue,element.unitStr];
        CGPoint point = [pointValueArr.firstObject[i] CGPointValue];
        CATextLayer * textlayer = [[CATextLayer alloc]init];
//        textlayer.backgroundColor = UIColor.redColor.CGColor;
        textlayer.drawsAsynchronously = YES;
        textlayer.foregroundColor = self.configuration.xAxisLabelsTitleColor.CGColor;
        textlayer.string = valueStr;
        textlayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef fontName = (__bridge CFStringRef)self.configuration.xAxisLabelsTitleFont.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textlayer.font = fontRef;
        textlayer.fontSize = self.configuration.xAxisLabelsTitleFont.pointSize;
        CGFontRelease(fontRef);
        textlayer.alignmentMode = kCAAlignmentCenter;
        textlayer.wrapped = NO;
        CGSize size = [self fq_sizeWithString:valueStr font:self.configuration.xAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
       textlayer.frame = CGRectMake(point.x, point.y, size.width, size.height);
        [self.layer addSublayer:textlayer];
    }
    
}

- (void)fq_setXAxisLabelsContainer{
    if (!_xAxisShowArr.count) {
        return;
    }
    //获取所有文本的总长度.然后再
    
    __block CGFloat lastX = self.yAxisLabelsContainerMarginLeft + _configuration.kYAxisChartViewMargin;
    
    CGFloat average = _mainContainerW / self.xAxisCount;
    BOOL xyAxisCustomStrTypeLeftRight = self.configuration.showXAxisStringDatas.count > 0 && self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_LeftRight;
    BOOL xyAxisCustomStrTypeCenter = self.configuration.showXAxisStringDatas.count > 0 && self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_Center;
    BOOL xyAxisCustomStrTypeData = self.xAxisShowArr.count > 0 && self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_Corresponding_Data;
    
    if (xyAxisCustomStrTypeCenter) { //如果有指定的数据.则使用指定布局
        average = _mainContainerW / self.configuration.showXAxisStringDatas.count;
    }
    
    //如果是左右
    if (xyAxisCustomStrTypeLeftRight && self.configuration.showXAxisStringDatas.count > 1) { //如果有指定的数据.则使用指定布局
        //实际布局宽度
        CGFloat currentW = _mainContainerW ;
        if (self.configuration.startPointType == ChartViewStartPointType_Center) {
            currentW = _mainContainerW * (self.xAxisCount - 1 ) /self.xAxisCount;
        }
        average =  currentW / (self.configuration.showXAxisStringDatas.count - 1);
        lastX = self.yAxisLabelsContainerMarginLeft + _configuration.kYAxisChartViewMargin;
        if (self.configuration.startPointType == ChartViewStartPointType_Center) {
            lastX = self.yAxisLabelsContainerMarginLeft + _configuration.kYAxisChartViewMargin + (_mainContainerW - currentW) * 0.5;
        }
    }
    
    //如果是对应上.则没有变化
    
    [_xAxisShowArr enumerateObjectsUsingBlock:^(NSString *columnName, NSUInteger idx, BOOL *stop) {
        
        //分出两种.一个是大圆点.一个是小圆点
        if ([columnName isEqualToString:kXAxisShowNameWithSmoDot]) {
            CATextLayer * smoDot = [[CATextLayer alloc]init];
            smoDot.backgroundColor = rgba(216, 216, 216, 1.0).CGColor;
            smoDot.cornerRadius = 2.0f;
            smoDot.masksToBounds = YES;
            
            CGSize size = CGSizeMake(4.0, 4.0);
            CGFloat smoDotX =  xyAxisCustomStrTypeLeftRight ? (lastX + idx * average - size.width * 0.5) : lastX + (idx + 1) * average - average * 0.5 - size.width * 0.5;
            CGFloat smoDotY = self.configuration.xAxisIsBottom ? self.frame.size.height - self.yAxisLabelsContainerMarginBot +self.configuration.kXAxisLabelTop : self.yAxisLabelsContainerMarginTop - self.configuration.kXAxisLabelTop - size.height;
            smoDot.frame = CGRectMake(smoDotX, smoDotY, size.width, size.height);
            [self.layer addSublayer:smoDot];
            [self.xAiaxTextLayers addObject:smoDot];
        }else if([columnName isEqualToString:kXAxisShowNameWithBigDot]){
            CATextLayer * bigDot = [[CATextLayer alloc]init];
            bigDot.backgroundColor = rgba(102, 102, 102, 1).CGColor;
            bigDot.cornerRadius = 3.0f;
            bigDot.masksToBounds = YES;
            
            CGSize size = CGSizeMake(6.0, 6.0);
            CGFloat bigDotX = xyAxisCustomStrTypeLeftRight ? (lastX + idx * average - size.width * 0.5) : lastX + (idx + 1) * average - average * 0.5 - size.width * 0.5;
            CGFloat bigDotY = self.configuration.xAxisIsBottom ? self.frame.size.height - self.yAxisLabelsContainerMarginBot +self.configuration.kXAxisLabelTop : self.yAxisLabelsContainerMarginTop - self.configuration.kXAxisLabelTop - size.height;
            bigDot.frame = CGRectMake(bigDotX, bigDotY, size.width, size.height);
            [self.layer addSublayer:bigDot];
            [self.xAiaxTextLayers addObject:bigDot];
        }else{
            CATextLayer * textlayer = [[CATextLayer alloc]init];
            textlayer.contentsScale = [[UIScreen mainScreen]scale];
            textlayer.drawsAsynchronously = YES;
            textlayer.foregroundColor = self.configuration.xAxisLabelsTitleColor.CGColor;
            textlayer.string = columnName;
            textlayer.contentsScale = [UIScreen mainScreen].scale;
            CFStringRef fontName = (__bridge CFStringRef)self.configuration.xAxisLabelsTitleFont.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textlayer.font = fontRef;
            textlayer.fontSize = self.configuration.xAxisLabelsTitleFont.pointSize;
            CGFontRelease(fontRef);
            textlayer.alignmentMode = kCAAlignmentCenter;
            textlayer.wrapped = NO;
            //            textlayer.truncationMode = kCATruncationEnd;
            
            CGSize size = [self fq_sizeWithString:columnName font:self.configuration.xAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
            
            CGFloat textLayerX = xyAxisCustomStrTypeLeftRight ? (lastX + idx * average - size.width * 0.5) : (lastX + (idx + 1) * average - average * 0.5 - size.width * 0.5);
            if (xyAxisCustomStrTypeData) {
                if (self.elementPointsArr.count > 0) {
                    NSArray * points = self.elementPointsArr.firstObject;
                    if (points.count > idx) {
                        NSNumber * number = points[idx];
                        CGPoint point = [number CGPointValue];
                        textLayerX = point.x + lastX - size.width * 0.5;
                    }
                }
            }
            
            
            CGFloat textLayerY = self.configuration.xAxisIsBottom ? self.frame.size.height - self.yAxisLabelsContainerMarginBot +self.configuration.kXAxisLabelTop : self.yAxisLabelsContainerMarginTop - self.configuration.kXAxisLabelTop - size.height;
            //只有一条数据时
            if (self->_xAxisShowArr.count == 1) {
                textlayer.frame = CGRectMake( CGRectGetMinX(self->_mainContainer.frame) + (self->_mainContainerW - size.width) * 0.5,  textLayerY, size.width, size.height);
            }else{
                textlayer.frame = CGRectMake( textLayerX,  textLayerY, size.width, size.height);
            }
            [self.layer addSublayer:textlayer];
            //当小于平均值时。就旋转-30度
            if (size.width > average) {
                textlayer.transform = CATransform3DRotate(textlayer.transform, -M_PI_2 * 0.5, 0, 0, 1);
            }
            [self.xAiaxTextLayers addObject:textlayer];
        }
    }];
    
}

- (void)fq_setYAxisLeftLabelsContainer{
    
    if (!self.configuration.hiddenLeftYAxisText) {
        if (!self.configuration.hiddenLeftYAxis) {
            if (!_yLeftAxisShowArr.count && _yRightAxisShowArr.count > 0) {
                _yLeftAxisShowArr = _yRightAxisShowArr;
            }
            [self fq_getYAxisDataLabelLayerWithShowArr:_yLeftAxisShowArr left:YES];
        }
    }
}

- (void)fq_setYAxisRightLabelsContainer{
    
    if (!self.configuration.hiddenRightYAxisText) {
        if (!self.configuration.hiddenRightYAxis) {
            //            if (!_yRightAxisShowArr.count && _yLeftAxisShowArr.count > 0) {
            //                _yRightAxisShowArr = _yLeftAxisShowArr;
            //            }
            //            [self fq_getYAxisDataLabelLayerWithShowArr:_yRightAxisShowArr left:NO];
            if (_yRightAxisShowArr.count == 0) {
                return;
            }else{
                [self fq_getYAxisDataLabelLayerWithShowArr:_yRightAxisShowArr left:NO];
            }
        }
    }
}

-(void)fq_drawYAxisTitleViewLeft:(BOOL)isYAxisLeft{
    
    NSString * unitStr = isYAxisLeft ? self.configuration.yAxisLeftTitle : self.configuration.yAxisRightTitle;
    UIColor * unitColor = isYAxisLeft ? self.configuration.yAxisLeftTitleColor : self.configuration.yAxisRightTitleColor;
    UIFont * unitFont = isYAxisLeft ? self.configuration.yAxisLeftTitleFont : self.configuration.yAxisRightTitleFont;
    CATextLayer * textlayer = [[CATextLayer alloc]init];
    textlayer.drawsAsynchronously = YES;
    textlayer.foregroundColor = unitColor.CGColor;
    textlayer.string = unitStr;
    textlayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef fontName = (__bridge CFStringRef)unitFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textlayer.font = fontRef;
    textlayer.fontSize = unitFont.pointSize;
    CGFontRelease(fontRef);
    textlayer.alignmentMode = isYAxisLeft ? kCAAlignmentRight : kCAAlignmentLeft;
    textlayer.wrapped = NO;
    //    textlayer.truncationMode = kCATruncationEnd;
    
    CGSize size = [self fq_sizeWithString:unitStr font:unitFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    if (self.configuration.unitDescrType == ChartViewUnitDescrType_Top) {
        CGFloat textLayerW = size.width;
        //        if (size.width < _configuration.kChartViewWidthMargin) {
        //            textlayer.alignmentMode = kCAAlignmentCenter;
        //            textLayerW = _configuration.kChartViewWidthMargin;
        //        }
        CGFloat yAxisTextLayerX = 0;
        if (size.width < _configuration.kChartViewWidthMargin) {
            textLayerW = textLayerW + 1;
            if (isYAxisLeft) {
                if (_configuration.yAxisLeftTitleType == ChartViewTitleDescType_Right) {
                    yAxisTextLayerX = self.yAxisLabelsContainerMarginLeft - size.width - (self.configuration.hiddenLeftYAxis ? 0 :self.configuration. kYAxisLabelMargin);
                }else{
                    yAxisTextLayerX = self.yAxisLabelsContainerMarginLeft;
                }
                
            }else{
                
                if (_configuration.yAxisRightTitleType == ChartViewTitleDescType_Left) {
                    yAxisTextLayerX = self.frame.size.width - self.yAxisLabelsContainerMarginRight + (self.configuration.hiddenRightYAxis ? 0 : self.configuration.kYAxisLabelMargin);
                }else{
                    yAxisTextLayerX = self.frame.size.width - self.yAxisLabelsContainerMarginRight - size.width;
                }
            }
        }else{
            
            yAxisTextLayerX = isYAxisLeft ? _configuration.kYAxisChartViewMargin : self.frame.size.width - _configuration.kYAxisChartViewMargin - textLayerW;
        }
        
        textlayer.frame = CGRectMake(yAxisTextLayerX, self.yAxisLabelsContainerMarginTop - size.height -_configuration.kYTitleLabelBot, textLayerW , size.height);
        
    }else{
        if (isYAxisLeft) {
            textlayer.frame = CGRectMake(size.height * 0.5 - MAX(size.height, size.width) , _mainContainer.center.y - MAX(size.height, size.width) * 0.5, MAX(size.height, size.width) * 2.0, size.height);
            textlayer.transform = CATransform3DRotate(textlayer.transform, M_PI_2, 0, 0, 1);
        }else{
            textlayer.frame = CGRectMake(self.frame.size.width - MAX(size.height, size.width) - size.height * 0.5 , _mainContainer.center.y - MAX(size.height, size.width) * 0.5 ,MAX(size.height, size.width) * 2.0, size.height);
            textlayer.transform = CATransform3DRotate(textlayer.transform, -M_PI_2, 0, 0, 1);
        }
    }
    [self.layer addSublayer:textlayer];
}

-(void)fq_getYAxisDataLabelLayerWithShowArr:(NSArray *)showArr left:(BOOL)isLeft{
    
    [self fq_drawYAxisTitleViewLeft:isLeft];
    
    if (!showArr.count) {
        return;
    }
    
    CGSize yAxisSize = [self fq_sizeWithString:@"" font:self.configuration.yAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    BOOL xyAxisCustomStrTypeLeftRight = NO;
    BOOL xyAxisCustomStrTypeCenter = NO;
    if (isLeft) {
        xyAxisCustomStrTypeLeftRight = self.yLeftAxisShowArr.count > 0 && (self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_LeftRight ||self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_Corresponding
                                                                           ||self.configuration.xyAxisCustomStrType ==ChartViewXYAxisCustomStrType_Corresponding_Data);
        xyAxisCustomStrTypeCenter = self.yLeftAxisShowArr.count > 0 && self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_Center;
    }else{
        
        xyAxisCustomStrTypeLeftRight = self.yRightAxisShowArr.count > 0 && (self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_LeftRight ||self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_Corresponding
                                                                            ||self.configuration.xyAxisCustomStrType ==ChartViewXYAxisCustomStrType_Corresponding_Data);
        xyAxisCustomStrTypeCenter = self.yRightAxisShowArr.count > 0 && self.configuration.xyAxisCustomStrType == ChartViewXYAxisCustomStrType_Center;
    }
    
    //这种方式针对.居中对齐
    CGFloat rowSpacing =  0;
    
    if (showArr.count != 1) {
        rowSpacing = (self.frame.size.height - self.yAxisLabelsContainerMarginTop - self.yAxisLabelsContainerMarginBot - yAxisSize.height * showArr.count) / (showArr.count - 1);
        if (xyAxisCustomStrTypeCenter) {
            rowSpacing = (self.frame.size.height - self.yAxisLabelsContainerMarginTop - self.yAxisLabelsContainerMarginBot)/(showArr.count);
        }
        
        if (xyAxisCustomStrTypeLeftRight) {
            rowSpacing = (self.frame.size.height - self.yAxisLabelsContainerMarginTop - self.yAxisLabelsContainerMarginBot)/(showArr.count - 1);
        }
        
        if (rowSpacing <= 0) {
            NSLog(@"y轴labels文字过多或字体过大，布局可能有问题");
        }
    }
    
    __block CGFloat lastY = - rowSpacing + self.yAxisLabelsContainerMarginTop;
    if (xyAxisCustomStrTypeCenter) {
        lastY = - rowSpacing + self.yAxisLabelsContainerMarginTop + rowSpacing * 0.5;
    }
    __block CGFloat maxWidth = 0;
    BOOL yAxisIsReverse = isLeft ? self.configuration.yLeftAxisIsReverse : self.configuration.yRightAxisIsReverse;
    
    NSArray* reversedArray = nil;
    if (self.configuration.xAxisIsBottom) {
        if (yAxisIsReverse == YES) {
            reversedArray = showArr;
        }else{
            reversedArray = [[showArr reverseObjectEnumerator] allObjects];
        }
    }else{
        if (yAxisIsReverse == YES) {
            reversedArray = [[showArr reverseObjectEnumerator] allObjects];
        }else{
            reversedArray = showArr;
        }
    }
    
    [reversedArray enumerateObjectsUsingBlock:^(NSString *rowName, NSUInteger idx, BOOL *stop) {
        CATextLayer * textlayer = [[CATextLayer alloc]init];
        textlayer.drawsAsynchronously = YES;
        textlayer.foregroundColor = self.configuration.yAxisLabelsTitleColor.CGColor;
        textlayer.string = rowName;
        textlayer.contentsScale = [UIScreen mainScreen].scale;
        
        CFStringRef fontName = (__bridge CFStringRef)self.configuration.yAxisLabelsTitleFont.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        textlayer.font = fontRef;
        textlayer.fontSize = self.configuration.yAxisLabelsTitleFont.pointSize;
        CGFontRelease(fontRef);
        textlayer.alignmentMode = kCAAlignmentCenter;
        textlayer.wrapped = NO;
        //        textlayer.truncationMode = kCATruncationEnd;
        
        CGSize size = [self fq_sizeWithString:rowName font:self.configuration.yAxisLabelsTitleFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGFloat textLayerY = lastY + rowSpacing;
        //找到对应的Y轴点.去掉了
        //        if (isLeft && (self.configuration.showLeftYAxisDatas.count > 0)) {
        //
        //            CGFloat axisYValue = 0;
        //            if (self.configuration.xAxisIsBottom) {
        //                if (yAxisIsReverse) {
        //                    axisYValue = [self.configuration.showLeftYAxisDatas[idx] floatValue];
        //                }else{
        //                    axisYValue = [self.configuration.showLeftYAxisDatas[reversedArray.count - idx - 1] floatValue];
        //                }
        //            }else{
        //                if (yAxisIsReverse) {
        //                    axisYValue = [self.configuration.showLeftYAxisDatas[reversedArray.count - idx - 1] floatValue];
        //                }else{
        //                    axisYValue = [self.configuration.showLeftYAxisDatas[idx] floatValue];
        //                }
        //            }
        //            if (yAxisIsReverse) {
        //
        //                if (self.configuration.xAxisIsBottom) {
        //                    textLayerY = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH  + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }else{
        //                    textLayerY = (1 - (axisYValue - self.self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }
        //
        //            }else{
        //
        //                if (self.configuration.xAxisIsBottom) {
        //                    textLayerY = (1 - (axisYValue - self.self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }else{
        //                    textLayerY = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }
        //            }
        //
        //        }
        //
        //        if (!isLeft && (self.configuration.showRightYAxisDatas.count > 0)) {
        //
        //            CGFloat axisYValue = 0;
        //            if (self.configuration.xAxisIsBottom) {
        //                if (yAxisIsReverse) {
        //                    axisYValue = [self.configuration.showRightYAxisDatas[idx] floatValue];
        //                }else{
        //                    axisYValue = [self.configuration.showRightYAxisDatas[reversedArray.count - idx - 1] floatValue];
        //                }
        //            }else{
        //                if (yAxisIsReverse) {
        //                    axisYValue = [self.configuration.showRightYAxisDatas[reversedArray.count - idx - 1] floatValue];
        //                }else{
        //                    axisYValue = [self.configuration.showRightYAxisDatas[idx] floatValue];
        //                }
        //            }
        //
        //            if (yAxisIsReverse) {
        //
        //                if (self.configuration.xAxisIsBottom) {
        //                    textLayerY = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }else{
        //                    textLayerY = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }
        //
        //            }else{
        //                if (self.configuration.xAxisIsBottom) {
        //                    textLayerY = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }else{
        //                    textLayerY = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH + self.yAxisLabelsContainerMarginTop - size.height * 0.5;
        //                }
        //            }
        //        }
        
        CGFloat yAxisTextLayerX = 0;
        CGFloat yAxisTextLayerOffY = 0;
        if (isLeft) {
            //如果使用的是默认的
            yAxisTextLayerX = self.yAxisLabelsContainerMarginLeft - size.width - (self.configuration.hiddenLeftYAxis ? 0 :self.configuration. kYAxisLabelMargin);
            yAxisTextLayerOffY = (self.yLeftAxisShowArr.count > 0 ? yAxisSize.height * 0.5 : 0);
        }else{
            yAxisTextLayerX = self.frame.size.width - self.yAxisLabelsContainerMarginRight + (self.configuration.hiddenRightYAxis ? 0 : self.configuration.kYAxisLabelMargin);
            yAxisTextLayerOffY = (self.yRightAxisShowArr.count > 0 ? yAxisSize.height * 0.5 : 0);
        }
        
        textlayer.frame = CGRectMake(yAxisTextLayerX,textLayerY - yAxisTextLayerOffY, size.width, size.height); //size.width
        
        [self.layer addSublayer:textlayer];
        lastY = CGRectGetMaxY(textlayer.frame) - yAxisTextLayerOffY;
        if (size.width > maxWidth) {
            maxWidth = size.width;
        }
    }];
}

#pragma mark - 私有方法 - 更新最新的frame
/**
 更新最新的frame
 */
- (void)fq_setMainContainer{
    _mainContainer.backgroundColor = self.configuration.mainContainerBackColor;
    _mainContainerW = self.frame.size.width - self.yAxisLabelsContainerMarginLeft - self.yAxisLabelsContainerMarginRight - 2 * _configuration.kYAxisChartViewMargin;
    _mainContainerH = self.frame.size.height - self.yAxisLabelsContainerMarginTop - self.yAxisLabelsContainerMarginBot;
    _mainContainer.frame = CGRectMake(self.yAxisLabelsContainerMarginLeft + _configuration.kYAxisChartViewMargin , self.yAxisLabelsContainerMarginTop, _mainContainerW, _mainContainerH);
    
    //提示竖直线
    _currentLineView.frame = CGRectMake(0, 0, 1, _mainContainerH);
    _currentlineLayer.frame = _currentLineView.bounds;
    [self drawLineOfDashByCAShapeLayer:_currentlineLayer lineLength:1.0 lineSpacing: self.configuration.selectLineType == ChartSelectLineType_SolidLine ? 0 : 2.0 lineColor:self.configuration.currentLineColor directionHorizonal:NO];
    _currentLineView.alpha = 0;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    
    CGFloat rowSpacing = 0;
    if (self.configuration.gridRowCount - 1 > 0) {
        rowSpacing = (_mainContainerH - self.configuration.gridRowCount * self.configuration.gridLineWidth) / (self.configuration.gridRowCount - 1);
    }
    
    CGFloat columnSpacing = 0;
    if (self.configuration.gridColumnCount - 1 > 0) {
        columnSpacing = (_mainContainerW - self.configuration.gridColumnCount * self.configuration.gridLineWidth) / (self.configuration.gridColumnCount - 1);
    }
    
    //绘制横竖网格线
    _rowReplicatorLayer.instanceCount = self.configuration.gridRowCount;
    _rowBackLine.frame = CGRectMake(0, 0, _mainContainerW, self.configuration.gridLineWidth);
    [self drawLineOfDashByCAShapeLayer:_rowBackLine lineLength:self.configuration.gridlineLength lineSpacing:self.configuration.gridlineSpcing lineColor:self.configuration.gridLineColor directionHorizonal:YES];
    _rowReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, rowSpacing + self.configuration.gridLineWidth, 0);
    _rowReplicatorLayer.hidden  = self.configuration.yAxisGridHidden;
    
    _columnReplicatorLayer.instanceCount = self.configuration.gridColumnCount;
    _columnReplicatorLayer.frame = _rowReplicatorLayer.frame = _mainContainer.bounds;
    _columnBackLine.frame = CGRectMake(0, 0, self.configuration.gridLineWidth, _mainContainerH);
    [self drawLineOfDashByCAShapeLayer:_columnBackLine lineLength:self.configuration.gridlineLength lineSpacing:self.configuration.gridlineSpcing lineColor:self.configuration.gridLineColor directionHorizonal:NO];
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
            
            if (self.configuration.yLeftAxisIsReverse) {
                if (self.configuration.xAxisIsBottom) {
                    averageLineValue = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH;
                }else{
                    averageLineValue = (1 - (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH;
                }
            }else{
                if (self.configuration.xAxisIsBottom) {
                    averageLineValue = (1 - (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue)) * self.mainContainerH;
                }else{
                    averageLineValue = (axisYValue - self.yAxisLeftMinValue)/(self.yAxisLeftMaxValue - self.yAxisLeftMinValue) * self.mainContainerH;
                }
            }
        }else{
            if (self.configuration.yRightAxisIsReverse) {
                if (self.configuration.xAxisIsBottom) {
                    averageLineValue = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH;
                }else{
                    averageLineValue = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH;
                }
            }else{
                
                if (self.configuration.xAxisIsBottom) {
                    averageLineValue = (1 - (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue)) * self.mainContainerH;
                }else{
                    averageLineValue = (axisYValue - self.yAxisRightMinValue)/(self.yAxisRightMaxValue - self.yAxisRightMinValue) * self.mainContainerH;
                }
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
        barLayer.drawsAsynchronously = YES;
        
        if (barElement.gradientColors.count > 0) {
            CAGradientLayer * barGradientLayer = self.barGradientLayer;
            barGradientLayer.frame = _mainContainer.bounds;
            barGradientLayer.colors = barElement.gradientColors;
            barGradientLayer.mask = self.barContainerLayer;
        }
    }
    
    [CATransaction commit];
}

#pragma mark - 私有方法 - 添加手势

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
    if (!_elementPointsArr.count) {
        return;
    }
    
    NSArray * pointArr = _elementPointsArr.firstObject;
    if (!pointArr.count) {
        return;
    }
    
    //取消隐藏方法
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fq_endChangCurveView) object:nil];
    
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
        NSArray * pointLayerArr;
        if (self.configuration.isShowSelectPoint && !self.configuration.isShowAllPoint) {
            if (self.pointLayerArrs.count > i) {
                pointLayerArr = self.pointLayerArrs[i];
                if (pointLayerArr.count > self.selectIndex) {
                    CAShapeLayer *oldPointLayer = pointLayerArr[self.selectIndex];
                    oldPointLayer.opacity = 0.0f;
                }
            }
        }
        
        if (element.orginDatas.count > index) {
            FQXAxisItem * xAxisItem = element.orginDatas[index];
            if (muStr.length != 0) {
                [muStr appendString:@","];
            }
            [valueArr addObject:xAxisItem];
            [selectPointArr addObject:pointArr[index]];
            NSString * xAxisItemStr = xAxisItem.dataValue.stringValue;
            [muStr appendString:xAxisItemStr];
            
            if (self.configuration.isShowSelectPoint && !self.configuration.isShowAllPoint) {
                if (pointLayerArr.count > index) {
                    CAShapeLayer *selectPointLayer = pointLayerArr[index];
                    selectPointLayer.opacity = 1.0f;
                }
            }
        }
    }
    
    self.selectIndex = index;
    self.popTipView.layer.opacity = 1.0;
    CGPoint selectLinePoint = [pointArr[index] CGPointValue];
    _currentLineView.alpha = 1.0f;
    _currentLineView.frame = CGRectMake(selectLinePoint.x, 0, 1, _mainContainerH);
    self.popTipView.contentTextStr = muStr.copy;
    
    if (_delegateFlag.tapSelectItem) {
        [_chartDelegate chartView:self tapSelectItem:valueArr.copy location:selectPointArr index:index];
    }
    if (_tapSelectItemBlock) {
        _tapSelectItemBlock(self,valueArr.copy,selectPointArr,index);
    }
    
    if (_delegateFlag.changePopViewPositionWithView) {
        [_chartDelegate chartView:self changePopViewPositionWithView:_popTipView itemData:valueArr.copy];
    }
    if (_changePopViewPositionBlock) {
        _changePopViewPositionBlock(self,_popTipView,valueArr.copy);
    }
    if (self.configuration.showXAxisSelectColor) {
        for (CATextLayer * textLayer in self.xAiaxTextLayers) {
            textLayer.foregroundColor = self.configuration.xAxisLabelsTitleColor.CGColor;
        }
        CATextLayer * selectTextLayer = self.xAiaxTextLayers[index];
        selectTextLayer.foregroundColor = self.configuration.xAxisSelectTitleColor.CGColor;
    }
    
    [self.popTipView fq_drawRectWithOrigin:CGPointMake(currentPoint.x, self.yAxisLabelsContainerMarginTop)];
    
    //3s消失
    [self performSelector:@selector(fq_endChangCurveView) withObject:nil afterDelay:3.0f];
}

- (void)fq_panGesture:(UIPanGestureRecognizer *)gesture{
    if (!_elementPointsArr.count) {
        return;
    }
    
    NSArray * pointArr = _elementPointsArr.firstObject;
    if (!pointArr.count) {
        return;
    }
    
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
        NSArray * pointLayerArr;
        if (self.configuration.isShowSelectPoint && !self.configuration.isShowAllPoint) {
            if (self.pointLayerArrs.count > i) {
                pointLayerArr = self.pointLayerArrs[i];
                if (pointLayerArr.count > self.selectIndex) {
                    CAShapeLayer *oldPointLayer = pointLayerArr[self.selectIndex];
                    oldPointLayer.opacity = 0.0f;
                }
            }
        }
        
        if (element.orginDatas.count > index) {
            FQXAxisItem * xAxisItem = element.orginDatas[index];
            if (muStr.length != 0) {
                [muStr appendString:@","];
            }
            //            NSString * xAxisItemStr = [NSString stringWithFormat:@"x:%@,y:%@",xAxisItem.dataNumber,xAxisItem.dataValue];
            //默认为dataValue
            NSString * xAxisItemStr = [NSString stringWithFormat:@"%@",xAxisItem.dataValue];
            [muStr appendString:xAxisItemStr];
            [valueArr addObject:xAxisItem];
            [selectPointArr addObject:pointArr[index]];
            
            if (self.configuration.isShowSelectPoint && !self.configuration.isShowAllPoint) {
                if (pointLayerArr.count > index) {
                    CAShapeLayer *selectPointLayer = pointLayerArr[index];
                    selectPointLayer.opacity = 1.0f;
                }
            }
        }
    }
    
    self.selectIndex = index;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_delegateFlag.panBeginItem) {
            [_chartDelegate chartView:self panBeginItem:valueArr.copy location:selectPointArr.copy index:index];
        }
        
        if (_delegateFlag.changePopViewPositionWithView) {
            [_chartDelegate chartView:self changePopViewPositionWithView:_popTipView itemData:valueArr.copy];
        }
        
        //取消隐藏方法
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fq_endChangCurveView) object:nil];
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        self.popTipView.layer.opacity = 1.0;
        CGPoint selectLinePoint = [pointArr[index] CGPointValue];
        _currentLineView.alpha = 1.0;
        _currentLineView.frame = CGRectMake(selectLinePoint.x, 0, 1, _mainContainerH);
        self.popTipView.contentTextStr = muStr.copy;
        
        if (_delegateFlag.panChangeItem) {
            [_chartDelegate chartView:self panChangeItem:valueArr.copy location:selectPointArr index:index];
        }
        if (_panChangeItemBlock) {
            _panChangeItemBlock(self,valueArr.copy,selectPointArr,index);
        }
        
        if (_delegateFlag.changePopViewPositionWithView) {
            [_chartDelegate chartView:self changePopViewPositionWithView:_popTipView itemData:valueArr.copy];
        }
        if (_changePopViewPositionBlock) {
            _changePopViewPositionBlock(self,_popTipView,valueArr.copy);
        }
        
        if (self.configuration.showXAxisSelectColor) {
            for (CATextLayer * textLayer in self.xAiaxTextLayers) {
                textLayer.foregroundColor = self.configuration.xAxisLabelsTitleColor.CGColor;
            }
            CATextLayer * selectTextLayer = self.xAiaxTextLayers[index];
            selectTextLayer.foregroundColor = self.configuration.xAxisSelectTitleColor.CGColor;
        }
        
        [self.popTipView fq_drawRectWithOrigin:CGPointMake(currentPoint.x, self.yAxisLabelsContainerMarginTop)];
    }
    
    if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed) {
        if (_delegateFlag.chartViewPanGestureEnd) {
            [_chartDelegate chartViewPanGestureEnd:self];
        }
        if (_panGestureEndBlock) {
            _panGestureEndBlock(self);
        }
        //3s消失
        [self performSelector:@selector(fq_endChangCurveView) withObject:nil afterDelay:3.0f];
    }
}

/**
获取当前索引下的textLayer
*/
-(NSString *)getCurrentXAxisTextLayer:(NSInteger)index{
    CATextLayer * textLayer = self.xAiaxTextLayers[index];
    return textLayer.string;
}

/**
 隐藏popView
 */
-(void)fq_hiddenCurveView{
    [self fq_endChangCurveView];
}

//3s消失
-(void)fq_endChangCurveView{
    
    self.currentLineView.alpha = 0.0f;
    self.popTipView.layer.opacity = 0.0f;
    
    if (self.configuration.isShowSelectPoint && !self.configuration.isShowAllPoint) {
        for (int i = 0; i < self.configuration.elements.count; ++i) {
            if (self.pointLayerArrs.count > i) {
                NSArray * pointLayerArr = self.pointLayerArrs[i];
                if (pointLayerArr.count > self.selectIndex) {
                    //显示选中点.
                    CAShapeLayer *oldPointLayer = pointLayerArr[self.selectIndex];
                    oldPointLayer.opacity = 0.0f;
                }
            }
        }
    }
}

#pragma mark - 私有方法 - 根据数据转换为点数据.并绘制

/**
 绘制对应的图标
 */
-(void)fq_getChartPointAndPath{
    
    //获取每个点对应的位置.
    [self fq_getChartViewPointArr];
    
    //只需要依据一组的x轴即可
    NSArray * pointArr = self.elementPointsArr.firstObject;
    if (self.configuration.sportSchedulesIndex.count > 0 || self.configuration.sportSchedulesprogress.count > 0) {
        
        BOOL isSportSchedulesIndex = self.configuration.sportSchedulesIndex.count > 0;
        
        NSArray * sportSchedulesArr = isSportSchedulesIndex ? self.configuration.sportSchedulesIndex : self.configuration.sportSchedulesprogress;
        
        if (isSportSchedulesIndex) {
            for (int i = 0; i < pointArr.count; i++) {
                for (int j = 0; j < sportSchedulesArr.count; j++) {
                    NSNumber * sportSchedulesIndex = sportSchedulesArr[j];
                    if ([sportSchedulesIndex intValue] == i) {
                        NSValue * pointValue = pointArr[i];
                        CGPoint point = [pointValue CGPointValue];
                        [self fq_setSportEventSchedulesWithViewX:point.x];
                        
                    }
                }
            }
        }else{
            for (int i = 0; i < sportSchedulesArr.count; i++) {
                [self fq_setSportEventSchedulesWithViewX:[sportSchedulesArr[i] floatValue] * _mainContainerW];
            }
        }
    }
    
    NSInteger lineElementIndex = 0;
    NSInteger barElementIndex = 0;
    //开始绘制折线
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        FQSeriesElement * element = self.configuration.elements[i];
        NSArray * pointArr = self.elementPointsArr[i];
        
        //添加选中点页面
        if (self.configuration.isShowSelectPoint) {
            NSMutableArray * pointViewArr = [NSMutableArray array];
            for (NSValue * pointValue in pointArr) {
                CAShapeLayer * pointLayer = [self pointLayerWithDiameter:self.configuration.isSelectPointBorder ? 10.0 : 8.0 color:element.isShowSelectPoint ? element.selectPointColor : UIColor.clearColor center:[pointValue CGPointValue] borderColor:element.isShowSelectPoint ? self.configuration.pointBorderColor : UIColor.clearColor borderW:self.configuration.isSelectPointBorder ? 2.0 : 0.0];
                pointLayer.opacity = self.configuration.isShowAllPoint ? 1.0f : 0.0f;
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
        }
    }
}

/**
 根据x值.绘制标识
 
 @param viewX x轴x值
 */
-(void)fq_setSportEventSchedulesWithViewX:(CGFloat)viewX{
    CGFloat sportSchedulesWH = 16;
    UIView * sportSchedulesView = [[UIView alloc]init];
    sportSchedulesView.frame = CGRectMake(viewX - sportSchedulesWH * 0.5, 0, sportSchedulesWH, _mainContainerH);
    
    UIImageView * imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon16／sportsdetails_charts_daylinepoint_icon"]];
    imgView.frame = CGRectMake(0, -sportSchedulesWH * 0.8, sportSchedulesWH, sportSchedulesWH);
    [sportSchedulesView addSubview:imgView];
    
    UILabel * labelIndex = [[UILabel alloc]init];
    labelIndex.text = @(self.sportSchedulesLayerArr.count + 1).stringValue;
    labelIndex.textColor = UIColor.whiteColor;
    labelIndex.font = [UIFont systemFontOfSize:8];
    labelIndex.frame = CGRectMake(0, -sportSchedulesWH * 0.8, sportSchedulesWH, sportSchedulesWH);
    labelIndex.textAlignment = NSTextAlignmentCenter;
    [sportSchedulesView addSubview:labelIndex];
    
    UIView * layerView = [[UIView alloc]init];
    layerView.frame = CGRectMake((sportSchedulesWH - 1) * 0.5, sportSchedulesWH * 0.2, 1, _mainContainerH - sportSchedulesWH * 0.2);
    //创建虚线直线
    CAShapeLayer * sportSchedulesLayer = [CAShapeLayer new];
    sportSchedulesLayer.drawsAsynchronously = YES;
    //提示竖直线
    sportSchedulesLayer.frame = layerView.bounds;
    [self drawLineOfDashByCAShapeLayer:sportSchedulesLayer lineLength:1.0 lineSpacing: 1.0 lineColor:rgba(0, 0, 0, 0.2) directionHorizonal:NO];
    [layerView.layer addSublayer:sportSchedulesLayer];
    
    [sportSchedulesView addSubview:layerView];
    [_mainContainer addSubview:sportSchedulesView];
    [self.sportSchedulesLayerArr addObject:sportSchedulesView];
}


/**
 计算出每个点的位置
 */
-(void)fq_getChartViewPointArr{
    
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
    
    if (ymaxValue == yminValue) {
        ymaxValue += 1;
    }
    //x轴最大最小值
    CGFloat xmaxValue = self.xAxisMaxValue;
    CGFloat xminValue = self.xAxisMinValue;
    
    CGFloat average = 0;
    if (self.xAxisCount > 0) {
        average = _mainContainerW / self.xAxisCount;
    }
    for (FQXAxisItem * dataItem in element.orginDatas) {
        
        //获取最大值.
        CGFloat xAxisNumber = dataItem.dataNumber.floatValue;
        CGFloat yAxisValue = dataItem.dataValue.floatValue;
        
        CGFloat x = 0;
        if (xmaxValue != xminValue) {
            x = (xAxisNumber - xminValue)/(xmaxValue - xminValue) * (_mainContainerW - (self.configuration.startPointType == ChartViewStartPointType_Center ? average : 0)) + (self.configuration.startPointType == ChartViewStartPointType_Center ?  average * 0.5 : 0);
        }else{
            x = _mainContainerW * 0.5;
        }
        
        CGFloat y = 0;
        
        if (element.yAxisAligmentType == FQChartYAxisAligmentType_Left) {
            if (self.configuration.yLeftAxisIsReverse == YES) {
                y = self.configuration.xAxisIsBottom ? (yAxisValue - yminValue)/(ymaxValue - yminValue) * _mainContainerH : (1 - (yAxisValue - yminValue)/(ymaxValue - yminValue)) * _mainContainerH;
                
            }else{
                y = self.configuration.xAxisIsBottom ? (1 - (yAxisValue - yminValue)/(ymaxValue - yminValue)) * _mainContainerH : (yAxisValue - yminValue)/(ymaxValue - yminValue) * _mainContainerH;
                //针对现有需求调整最小高度.其他不变
                if (element.minHeight != 0) {
                    if (self.configuration.xAxisIsBottom) {
                        y = (_mainContainerH - element.minHeight) * y / _mainContainerH;
                    }
                }
            }
        }else{
            if (self.configuration.yRightAxisIsReverse == YES) {
                y = self.configuration.xAxisIsBottom ? (yAxisValue - yminValue)/(ymaxValue - yminValue) * _mainContainerH : (1 - (yAxisValue - yminValue)/(ymaxValue - yminValue)) * _mainContainerH;
            }else{
                y = self.configuration.xAxisIsBottom ? (1 - (yAxisValue - yminValue)/(ymaxValue - yminValue)) * _mainContainerH : (yAxisValue - yminValue)/(ymaxValue - yminValue) * _mainContainerH;
            }
        }
        
        [pointArr addObject: [NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
    }
    
    return pointArr.copy;
}



/**
 获取X轴相关数据
 */
-(void)fq_getChartViewXAxisDataArr{
    
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
    self.xAxisCount = MAX(self.configuration.showXAxisStringDatas.count, maxCount);
    
    //等分展示
    if (self.configuration.showXAxisStringDatas && self.configuration.showXAxisStringDatas.count) {
        self.xAxisShowArr = self.configuration.showXAxisStringDatas;
        return;
    }
    
    NSMutableArray * muXAxisIntervalArr = [NSMutableArray array];
    
    if (self.configuration.showXAxisStringNumberDatas && self.configuration.showXAxisStringNumberDatas.count) {
        //从里面选出最大的
        for (FQXAxisItem * axAxisItem in maxCountElement.orginDatas) {
            if ([self.configuration.showXAxisStringNumberDatas containsObject:axAxisItem.dataNumber]) {
                [muXAxisIntervalArr addObject:[axAxisItem.dataNumber stringValue]];
            }else{
                [muXAxisIntervalArr addObject:@""];
            }
        }
        self.xAxisShowArr = muXAxisIntervalArr;
        return;
    }
    
    //隔几个显示一个
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
    
    //有多少展示多少
    for (int i = 0; i < maxCount; ++i) {
        FQXAxisItem * item = maxCountElement.orginDatas[i];
        [muXAxisIntervalArr addObject:[item.dataNumber stringValue]];
    }
    self.xAxisShowArr = muXAxisIntervalArr.copy;
}

/**
 获取圆饼图数据
 
 @param elements 饼状图数据源对象
 */
-(void)fq_getPieChartViewDataArrWithElement:(FQSeriesElement *)elements{
    
    CGFloat subNum = 0;
    for (NSNumber * numValue in elements.orginNumberDatas) {
        subNum += [numValue floatValue];
    }
    //占比-
    NSMutableArray * accounted = [NSMutableArray array];
    //开始比例
    NSMutableArray * startAccounted = [NSMutableArray array];
    //结束比例
    NSMutableArray * endAccounted = [NSMutableArray array];
    
    CGFloat startFloat = 0; //起始点.
    for (int i = 0; i < elements.orginNumberDatas.count; ++i) {
        NSNumber *numValue = elements.orginNumberDatas[i];
        [startAccounted addObject:@(startFloat)];
        CGFloat itemValue = 0;
        if (subNum != 0) {
            itemValue = [numValue floatValue] / subNum;
        }
        CGFloat piItemValue = itemValue ;
        [accounted addObject:@(itemValue)];
        startFloat += piItemValue;
        if (i == elements.orginNumberDatas.count - 1) {
            [endAccounted addObject:@(1)];
        }else{
            [endAccounted addObject:@(startFloat)];
        }
    }
    
    self.pieItemAccountedArr = accounted.copy;
    self.pieStrokeStartArray = startAccounted.copy;
    self.pieStrokeEndArray = endAccounted.copy;
    
    //默认对应的昵称.使用dataName
    if (elements.showPieNameDatas.count) {
        self.showPieNameDatas = elements.showPieNameDatas;
    }else{
        NSMutableArray * pieNameDatas = [NSMutableArray array];
        for (NSNumber *numValue  in elements.orginNumberDatas) {
            [pieNameDatas addObject:numValue.stringValue];
        }
        self.showPieNameDatas = pieNameDatas.copy;
    }
    
    //绘制.
    [self fq_makePiePathWithElement:elements];
}

/**
 获取水平柱状图的数据
 
 @param element 水平柱状图数据模型
 */
-(void)fq_getHorizontalBarChartViewDataArrWithElement:(FQHorizontalBarElement *)element{
    
    CGFloat maxBarItem = 0;
    NSArray * horBarItemArr = element.horizontalBarItemArr;
    //比较获取最大值.作为最大参考
    for (FQHorizontalBarItem *barItem in horBarItemArr) {
        maxBarItem = MAX(barItem.valueData.floatValue, maxBarItem);
    }
    
    //占最大值得比数组
    NSMutableArray * horBarPointArr = [NSMutableArray array];
    //x轴左侧展示数组
    NSMutableArray * xLeftAxisArr = [NSMutableArray array];
    //图表展示内容数组
    NSMutableArray * contentArr = [NSMutableArray array];
    //图表顶部描述
    NSMutableArray * topDescArr = [NSMutableArray array];
    //x轴右侧展示数组
    NSMutableArray * xRightAxisArr = [NSMutableArray array];
    
    //计算心率desc文本的高度
    CGFloat contentLabelH = [self fq_sizeWithString:@" " font:element.contentLabFont maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    
    CGFloat horBarItemH = element.horizontalBarContentType == ChartHorizontalBarContentType_Top ? element.horBarHeight + contentLabelH + self.configuration.kHorizontalBarItemMargin + element.horBarMargin : element.horBarHeight + self.configuration.kHorizontalBarItemMargin;
    
    CGFloat insideOffY = (horBarItemH - element.horBarHeight) * 0.5;
    CGFloat changMaxW = _mainContainerW  - element.narrowestW;
    for (int i = 0; i < horBarItemArr.count; ++i) {
        FQHorizontalBarItem *barItem = horBarItemArr[i];
        
        CGFloat itemAccount = 0;
        if(maxBarItem != 0){
            itemAccount = barItem.valueData.floatValue / maxBarItem;
        }
        itemAccount = (floorf(itemAccount*100 + 0.5))/100;
        
        if (element.horizontalBarContentType == ChartHorizontalBarContentType_Top) {
            CGFloat pointX = element.narrowestW + itemAccount * changMaxW;
            CGFloat pointY = i * horBarItemH + contentLabelH + element.horBarMargin + element.horBarHeight * 0.5;
            CGPoint point = CGPointMake(pointX,pointY);
            NSValue * value = [NSValue valueWithCGPoint:point];
            [horBarPointArr addObject:value];
        }else{
            CGFloat pointX = element.narrowestW + itemAccount * changMaxW;
            CGFloat pointY = i * horBarItemH + insideOffY + element.horBarHeight * 0.5;
            CGPoint point = CGPointMake(pointX,pointY);
            NSValue * value = [NSValue valueWithCGPoint:point];
            [horBarPointArr addObject:value];
        }
        
        if (element.isShowXLeftAxisStr) {
            [xLeftAxisArr addObject:barItem.xLeftAxisStr ? : @""];
        }
        [contentArr addObject:barItem.contentStr ? : @""];
        [topDescArr addObject:barItem.barTopStr ? : @""];
        if (element.isShowXRightAxisStr) {
            [xRightAxisArr addObject:barItem.xRightAxisStr ? : @""];
        }
    }
    
    self.horBarPointArr = horBarPointArr;
    self.horBarXLeftAxisArr = xLeftAxisArr;
    self.horBarContentArr = contentArr;
    self.horBarTopDescArr = topDescArr;
    self.horBarxRightAxisArr = xRightAxisArr;
    
    //绘制.
    [self fq_makeHorizontalPathWithElement:element];
}

/**
 获取水平双向柱状图的数据
 
 @param element 水平双向柱状图数据模型
 */
-(void)fq_getBothwayBarChartViewDataArrWithElement:(FQBothwayBarElement *)element{
    
    //左侧最大值item
    CGFloat leftMaxBarItem = 0;
    //右侧最大值item
    CGFloat rightMaxBarItem = 0;
    
    //比较获取最大值.作为最大参考
    for (FQBothwayBarItem *barItem in element.orginDatas) {
        leftMaxBarItem = MAX(barItem.leftData.floatValue, leftMaxBarItem);
        rightMaxBarItem = MAX(barItem.rightData.floatValue, rightMaxBarItem);
    }
    
    //左侧设定的点数组
    NSMutableArray * leftHorBarPointArr = [NSMutableArray array];
    //右侧设定的点数组
    NSMutableArray * rightHorBarPointArr = [NSMutableArray array];
    //左侧展示数组
    NSMutableArray * leftDataArr = [NSMutableArray array];
    //右侧展示数组
    NSMutableArray * rightDataArr = [NSMutableArray array];
    
    CGFloat startOffY = element.bothwayTopMargin;
    CGFloat midContentW = element.bothwayMidContentW;
    CGFloat barHeight = element.bothwayBarH;
    CGFloat barMargin = element.bothwayBarMargin;
    CGFloat textBarMargin = element.bothwayTextBarMargin;
    CGFloat leftMaxW = self.bounds.size.width * 0.5 - midContentW * 0.5 - element.barLeftMargin;
    CGFloat rightMaxW = self.bounds.size.width * 0.5 - midContentW * 0.5 - element.barRightMargin;
    
    for (int i = 0; i < element.orginDatas.count; i++) {
        FQBothwayBarItem *barItem = element.orginDatas[i];
        CGPoint midPoint = CGPointMake(self.bounds.size.width * 0.5, startOffY);
        startOffY += (barHeight + barMargin);
        
        CGFloat leftItemAccount = 0;
        CGFloat rightItemAccount = 0;
        if(leftMaxBarItem != 0){
            leftItemAccount = barItem.leftData.floatValue / leftMaxBarItem;
        }
        if (rightMaxBarItem != 0) {
            rightItemAccount = barItem.rightData.floatValue / rightMaxBarItem;
        }
        leftItemAccount = (floorf(leftItemAccount*100 + 0.5))/100;
        rightItemAccount = (floorf(rightItemAccount*100 + 0.5))/100;
        
        
        CGFloat leftPointX =  midPoint.x - midContentW * 0.5 - leftItemAccount * leftMaxW;
        CGFloat leftPointY = midPoint.y + barHeight * 0.5;
        CGPoint leftPoint = CGPointMake(leftPointX,leftPointY);
        NSValue * leftValue = [NSValue valueWithCGPoint:leftPoint];
        [leftHorBarPointArr addObject:leftValue];
        
        
        CGFloat rightPointX =  midPoint.x + midContentW * 0.5 + rightItemAccount * rightMaxW;
        CGFloat rightPointY = midPoint.y + barHeight * 0.5;
        CGPoint rightPoint = CGPointMake(rightPointX,rightPointY);
        NSValue * rightValue = [NSValue valueWithCGPoint:rightPoint];
        [rightHorBarPointArr addObject:rightValue];
        
        [leftDataArr addObject:barItem.leftData];
        [rightDataArr addObject:barItem.rightData];
        
    }
    
    CGFloat midContentH = element.dateTextFont.lineHeight + 1;
    CGFloat leftContentH = element.leftDataTextFont.lineHeight + 1;
    CGFloat rightContentH = element.rightDataTextFont.lineHeight + 1;
    
    //计算每个layer的点坐标.
    for (int i = 0; i < element.orginDatas.count; ++i) {
        CAShapeLayer * leftBarLayer = self.leftBothwayBarLayerArr[i];
        CAShapeLayer * rightBarLayer = self.rightBothwayBarLayerArr[i];
        CATextLayer * midTextLayer = self.midTextBothwayBarLayerArr[i];
        CATextLayer * leftTextLayer = self.leftTextBothwayBarLayerArr[i];
        CATextLayer * rightTextLayer = self.rightTextBothwayBarLayerArr[i];
        
        CGPoint leftPoint = [leftHorBarPointArr[i] CGPointValue];
        CGPoint rightPoint = [rightHorBarPointArr[i] CGPointValue];
        
        midTextLayer.frame = CGRectMake(self.bounds.size.width * 0.5 - midContentW * 0.5,leftPoint.y - midContentH * 0.5, midContentW, midContentH);
        leftTextLayer.frame = CGRectMake(0,leftPoint.y - leftContentH * 0.5, leftPoint.x - textBarMargin, leftContentH);
        rightTextLayer.frame = CGRectMake(rightPoint.x + textBarMargin, rightPoint.y - rightContentH * 0.5, self.bounds.size.width - rightPoint.x - textBarMargin, rightContentH);
        
        // 创建柱状图
        UIBezierPath *leftBarPath = [UIBezierPath bezierPath];
        UIBezierPath *rightBarPath = [UIBezierPath bezierPath];
        
        [self setShapeLayerWithPath:leftBarPath point:leftPoint barW:barHeight isLeft:YES];
        [self setShapeLayerWithPath:rightBarPath point:rightPoint barW:barHeight isLeft:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            leftBarLayer.path = leftBarPath.CGPath;
            rightBarLayer.path = rightBarPath.CGPath;
            leftBarLayer.strokeEnd = 1;
            rightBarLayer.strokeEnd = 1;
            //绘制左侧.内容.topBar.右侧描述文本
            //            [self fq_drawHorBarTextWithElement:horBarElement andIndex:i];
            //绘制中间layer.绘制左右的layer.
        });
    }
}

-(void)setShapeLayerWithPath:(UIBezierPath *)barPath point:(CGPoint)point barW:(CGFloat)barW isLeft:(BOOL)isLeft{
    CGFloat midContentW = 28;
    CGFloat startPointX = isLeft ? (self.bounds.size.width * 0.5 - midContentW * 0.5) : (self.bounds.size.width * 0.5 + midContentW * 0.5);
    
    if (isLeft) {
        if (startPointX - point.x < barW * 0.5 && startPointX - point.x > 0) {
            
            CGFloat startAngle =  M_PI_2;
            CGFloat endAngle = 2 * M_PI - M_PI_2;
            //如果
            [barPath moveToPoint:CGPointMake(point.x, point.y + barW * 0.5)];
            [barPath addArcWithCenter:point radius:barW * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
            
        }else{
            
            CGFloat startAngle = M_PI_2;
            CGFloat endAngle = 2 * M_PI - M_PI_2;
            CGPoint center = CGPointMake(point.x + barW * 0.5, point.y);
            
            [barPath moveToPoint:CGPointMake(startPointX, point.y + barW * 0.5)];
            [barPath addLineToPoint:CGPointMake(point.x + barW * 0.5, point.y + barW * 0.5)];
            [barPath addArcWithCenter:center radius:barW * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
            [barPath addLineToPoint:CGPointMake(startPointX, point.y - barW * 0.5)];
        }
    }else{
        if (point.x - startPointX < barW * 0.5 && point.x - startPointX > 0) {
            
            CGFloat startAngle = 2 * M_PI - M_PI_2;
            CGFloat endAngle = M_PI_2;
            [barPath moveToPoint:CGPointMake(point.x, point.y - barW * 0.5)];
            [barPath addArcWithCenter:point radius:barW * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
            
        }else{
            
            CGFloat startAngle = 2 * M_PI - M_PI_2;
            CGFloat endAngle = M_PI_2;
            CGPoint center = CGPointMake(point.x - barW * 0.5, point.y);
            
            [barPath moveToPoint:CGPointMake(startPointX, point.y - barW * 0.5)];
            [barPath addLineToPoint:CGPointMake(point.x - barW * 0.5, point.y - barW * 0.5)];
            [barPath addArcWithCenter:center radius:barW * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
            [barPath addLineToPoint:CGPointMake(startPointX, point.y + barW * 0.5)];
        }
    }
}


/**
 获取Y轴相关数据
 */
-(void)fq_getChartViewYAxisDataArr{
    
    //根据x轴的值.给出源数据值
    if (self.configuration.elements.count != 0 && self.configuration.elements) {
        
        CGFloat leftMaxValue = -1000000;
        CGFloat leftMinValue = CGFLOAT_MAX;
        CGFloat rightMaxValue = -1000000;
        CGFloat rightMinValue = CGFLOAT_MAX;
        
        for (FQSeriesElement *element in self.configuration.elements) {
            if (element.yAxisAligmentType == FQChartYAxisAligmentType_Left) {
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
        
        if (self.yAxisLeftMinValue == CGFLOAT_MAX) {
            self.yAxisLeftMinValue = 0;
        }
        
        if (self.yAxisRightMinValue == CGFLOAT_MAX) {
            self.yAxisRightMinValue = 0;
        }
        
        if (self.yAxisLeftMaxValue == self.yAxisLeftMinValue) { //防止最大最小一样.没有区间展示效果
            if (self.yAxisLeftMaxValue > 4) {
                self.yAxisLeftMinValue = self.yAxisLeftMaxValue - 4;
            }else if(self.yAxisLeftMaxValue > 0 && self.yAxisLeftMaxValue <= 4){
                self.yAxisLeftMinValue = 0;
            }else{
                self.yAxisLeftMaxValue = self.yAxisLeftMinValue + 100;
            }
        }
        
        if (self.yAxisRightMaxValue == self.yAxisRightMinValue) { //防止最大最小一样.没有区间展示效果
            if (self.yAxisRightMaxValue > 4) {
                self.yAxisRightMinValue = self.yAxisRightMaxValue - 4;
            }else if(self.yAxisRightMaxValue > 0 && self.yAxisRightMaxValue <= 4){
                self.yAxisRightMinValue = 0;
            }else{
                self.yAxisRightMaxValue = self.yAxisRightMinValue + 100;
            }
        }
        
        if (self.configuration.showLeftYAxisNames && self.configuration.showLeftYAxisNames.count) {
            self.yLeftAxisShowArr = self.configuration.showLeftYAxisNames.mutableCopy;
        }else{
            if (self.yAxisLeftMinValue < MAXFLOAT &&  self.yAxisLeftMaxValue != -1000000) {//self.yLeftAxisShowArr.count == 0  &&
                CGFloat average = (self.yAxisLeftMaxValue - self.yAxisLeftMinValue)*1.0 / (_configuration.kDefaultYAxisNames - 1);
                NSMutableArray * muarr = [NSMutableArray array];
                for (int i = 0; i < _configuration. kDefaultYAxisNames; ++i) {
                    
                    if (self.configuration.leftDecimalCount == 0) {
                        [muarr addObject:[NSString stringWithFormat:@"%d",(int)ceil(self.yAxisLeftMinValue + average * i)]];
                    }else if(self.configuration.leftDecimalCount == 1){
                        [muarr addObject:[NSString stringWithFormat:@"%.1f",self.yAxisLeftMinValue + average * i]];
                    }else if(self.configuration.leftDecimalCount == 2){
                        [muarr addObject:[NSString stringWithFormat:@"%.2f",self.yAxisLeftMinValue + average * i]];
                    }else if (self.configuration.leftDecimalCount == 3){
                        [muarr addObject:[NSString stringWithFormat:@"%.3f",self.yAxisLeftMinValue + average * i]];
                    }else{
                        [muarr addObject:[NSString stringWithFormat:@"%d",(int)ceil(self.yAxisLeftMinValue + average * i)]];
                    }
                }
                self.yLeftAxisShowArr = muarr;
            }
        }
        
        if (self.configuration.showRightYAxisNames && self.configuration.showRightYAxisNames.count) {
            self.yRightAxisShowArr = self.configuration.showRightYAxisNames;
        }else{
            if (self.yAxisRightMinValue < MAXFLOAT && self.yAxisRightMaxValue != -1000000) {//self.yRightAxisShowArr.count == 0 &&
                CGFloat average = (self.yAxisRightMaxValue - self.yAxisRightMinValue) * 1.0 / (_configuration.kDefaultYAxisNames - 1);
                NSMutableArray * muarr = [NSMutableArray array];
                for (int i = 0; i < _configuration.kDefaultYAxisNames; ++i) {
                    
                    if (self.configuration.rightDecimalCount == 0) {
                        [muarr addObject:[NSString stringWithFormat:@"%d",(int)ceil(self.yAxisRightMinValue + average * i)]];
                    }else if(self.configuration.rightDecimalCount == 1){
                        [muarr addObject:[NSString stringWithFormat:@"%.1f",self.yAxisRightMinValue + average * i]];
                    }else if(self.configuration.rightDecimalCount == 2){
                        [muarr addObject:[NSString stringWithFormat:@"%.2f",self.yAxisRightMinValue + average * i]];
                    }else if (self.configuration.rightDecimalCount == 3){
                        [muarr addObject:[NSString stringWithFormat:@"%.3f",self.yAxisRightMinValue + average * i]];
                    }else{
                        [muarr addObject:[NSString stringWithFormat:@"%d",(int)ceil(self.yAxisRightMinValue + average * i)]];
                    }
                }
                self.yRightAxisShowArr = muarr;
            }
        }
    }
    //    if (self.yAxisLeftMinValue == CGFLOAT_MAX) {
    //        self.yAxisLeftMinValue = 0;
    //    }
    //
    //    if (self.yAxisRightMinValue == CGFLOAT_MAX) {
    //        self.yAxisRightMinValue = 0;
    //    }
    //
    //    if (self.yAxisLeftMaxValue == self.yAxisLeftMinValue) { //防止最大最小一样.没有区间展示效果
    //        self.yAxisLeftMaxValue = self.yAxisLeftMinValue + 100;
    //    }
    //
    //    if (self.yAxisRightMaxValue == self.yAxisRightMinValue) { //防止最大最小一样.没有区间展示效果
    //        self.yAxisRightMaxValue = self.yAxisRightMinValue + 100;
    //    }
}

#pragma mark 绘制线条图表
-(void)fq_makeLinePathWithElement:(FQSeriesElement *)element withArr:(NSArray *)pointArray andChartTypeIndex:(NSInteger)index {
    
    if (pointArray.count == 0) {
        return;
    }
    
    //将最大与最小值均处理一下.
    NSMutableArray * pointMuArr = [NSMutableArray array];
    for (NSValue * pointValue in pointArray) {
        CGPoint point = [pointValue CGPointValue];
        //处理线条越界的问题.
        if (point.y == _mainContainerH) {
            point.y -= 1;
        }
        if (point.y == 0) {
            point.y += 1;
        }
        [pointMuArr addObject:[NSValue valueWithCGPoint:point]];
    }
    pointArray = pointMuArr.copy;
    //针对线条.处理
    UIBezierPath * path = [UIBezierPath bezierPath];
    UIBezierPath *backPath = [UIBezierPath bezierPath];
    
    /*排除为0的情况*/
    if (element.isFilterWithZero) {
        CGFloat minPointY = 0;
        if (element.yAxisAligmentType == FQChartYAxisAligmentType_Left) {
            if (self.configuration.xAxisIsBottom) {
                if (self.configuration.yLeftAxisIsReverse == YES) {
                    minPointY = 1;
                }else{
                    minPointY = _mainContainerH - 1;
                }
            }else{
                if (self.configuration.yLeftAxisIsReverse == YES) {
                    minPointY = _mainContainerH - 1;
                }else{
                    minPointY = 1;
                }
            }
        }else{
            if (self.configuration.xAxisIsBottom) {
                if (self.configuration.yRightAxisIsReverse == YES) {
                    minPointY = 1;
                }else{
                    minPointY = _mainContainerH - 1;
                }
            }else{
                if (self.configuration.yRightAxisIsReverse == YES) {
                    minPointY = _mainContainerH - 1;
                }else{
                    minPointY = 1;
                }
            }
        }
        //排除为空值得情况
        NSMutableArray *currentPointMuArr = [NSMutableArray array];
        for (NSValue * pointValue in pointArray) {
            
            @synchronized (currentPointMuArr) {
                if (pointValue.CGPointValue.y != minPointY) {
                    [currentPointMuArr addObject:pointValue];
                }
            }
        }
        if (currentPointMuArr.count < 1) {
            return;
        }
        
        CGPoint firstPoint = [currentPointMuArr[0] CGPointValue];
        CGPoint lastPoint = [pointArray[currentPointMuArr.count - 1] CGPointValue];
        [path moveToPoint:firstPoint];
        [backPath moveToPoint:CGPointMake(firstPoint.x, self.configuration.xAxisIsBottom ? _mainContainerH : 0)];
        [backPath addLineToPoint:firstPoint];
        
        for (int i = 0; i < currentPointMuArr.count - 1; i++) {
            if (element.modeType == FQModeType_RoundedCorners) {
                
                CGPoint point1 = [currentPointMuArr[i] CGPointValue];
                CGPoint point2 = [currentPointMuArr[i + 1] CGPointValue];
                if (point1.y == minPointY) {
                    
                    continue;
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
                
                NSValue * pointValue = currentPointMuArr[i + 1];
                CGPoint point = [pointValue CGPointValue];
                if (point.y == minPointY) {
                    continue;
                }
                [backPath addLineToPoint:point];
                [path addLineToPoint:point];
            }
        }
        [backPath addLineToPoint:CGPointMake(lastPoint.x, self.configuration.xAxisIsBottom ? _mainContainerH : 0)];
    }else{
        CGPoint firstPoint = [pointArray[0] CGPointValue];
        CGPoint lastPoint = [pointArray[pointArray.count - 1] CGPointValue];
        [path moveToPoint:firstPoint];
        [backPath moveToPoint:CGPointMake(firstPoint.x, self.configuration.xAxisIsBottom ? _mainContainerH : 0)];
        [backPath addLineToPoint:firstPoint];
        
        for (int i = 0; i < pointArray.count - 1; ++i) {
            if (element.modeType == FQModeType_RoundedCorners) {
                CGPoint point1 = [pointArray[i] CGPointValue];
                CGPoint point2 = [pointArray[i + 1] CGPointValue];
                
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
                [backPath addLineToPoint:point];
                [path addLineToPoint:point];
            }
        }
        [backPath addLineToPoint:CGPointMake(lastPoint.x, self.configuration.xAxisIsBottom ? _mainContainerH : 0)];
    }
    
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
    
    UIBezierPath * path;
    if (_linePathArr.count > index) {
        path = _linePathArr[index];
    }
    UIBezierPath * backPath;
    if (_lineBackPathArr.count > index) {
        backPath = _lineBackPathArr[index];
    }
    CAShapeLayer * backLayer;
    if (_lineBackLayerArr.count > index) {
        backLayer = _lineBackLayerArr[index];
    }
    CAShapeLayer * lineLayer ;
    if (_lineLayerArr.count > index) {
        lineLayer = _lineLayerArr[index];
    }
    
    backLayer.path =  backPath.CGPath;
    lineLayer.path = path.CGPath;
    lineLayer.strokeEnd = 1;
    //    if (self.configuration.drawWithAnimation) {
    //        CABasicAnimation *pointAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //        pointAnim.fromValue = @0;
    //        pointAnim.toValue = @1;
    //        pointAnim.duration = self.configuration.drawAnimationDuration;
    //        [lineLayer addAnimation:pointAnim forKey:@"drawLine"];
    //    }
}

#pragma mark 绘制柱状图
-(void)fq_makeBarPathWithElement:(FQSeriesElement *)element withArr:(NSArray *)pointArray andChartTypeIndex:(NSInteger)index {
    
    CGFloat average = _mainContainerW / self.xAxisCount;
    CGFloat barW = element.barWidth ? : average - 2 * element.barSpacing;
    
    //无数据展示样式
    if (!element.orginDatas.count) {
        for (int i = 0; i < self.configuration.showXAxisStringDatas.count; ++i) {
            CAShapeLayer * barBackLayer = self.barBackLayerArr[i];
            UIBezierPath *barBackPath = [UIBezierPath bezierPath];
            CGPoint point = [pointArray[i] CGPointValue];
            
            if (self.configuration.xAxisIsBottom == YES) {
                //圆角样式
                if (element.modeType == FQModeType_RoundedCorners) {
                    [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH - barW * 0.5)];
                    [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, barW * 0.5)];
                    [barBackPath addArcWithCenter:CGPointMake(point.x, barW * 0.5) radius:barW * 0.5 startAngle:M_PI endAngle:0 clockwise:YES];
                    [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH - barW * 0.5)];
                    [barBackPath addArcWithCenter:CGPointMake(point.x, _mainContainerH - barW * 0.5) radius:barW * 0.5 startAngle:0 endAngle:M_PI clockwise:YES];
                }else{
                    
                    [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH)];
                    [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, 0)];
                    [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, 0)];
                    [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH)];
                }
            }else{
                if (element.modeType == FQModeType_RoundedCorners) {
                    [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, barW * 0.5)];
                    [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH - barW * 0.5)];
                    [barBackPath addArcWithCenter:CGPointMake(point.x, _mainContainerH - barW * 0.5) radius:barW * 0.5 startAngle:M_PI endAngle:0 clockwise:NO];
                    [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, barW * 0.5)];
                    [barBackPath addArcWithCenter:CGPointMake(point.x,  barW * 0.5) radius:barW * 0.5 startAngle:0 endAngle:M_PI clockwise:NO];
                }else{
                    
                    [barBackPath moveToPoint:CGPointMake(point.x - barW * 0.5, 0)];
                    [barBackPath addLineToPoint:CGPointMake(point.x - barW * 0.5, _mainContainerH)];
                    [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, _mainContainerH)];
                    [barBackPath addLineToPoint:CGPointMake(point.x + barW *0.5, 0)];
                }
            }
            barBackLayer.path = barBackPath.CGPath;
        }
        
        return;
    }
    
    for (int i = 0; i < element.orginDatas.count; ++i) {
        CAShapeLayer * barLayer = self.barLayerArr[i];
        CAShapeLayer * barBackLayer = self.barBackLayerArr[i];
        CGPoint point = CGPointZero;
        if (pointArray.count > i) {
            point = [pointArray[i] CGPointValue];
        }
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            barBackLayer.path = barBackPath.CGPath;
            barLayer.path = barPath.CGPath;
            barLayer.strokeEnd = 1;
            //            if (self.configuration.drawWithAnimation) {
            //                CABasicAnimation *pointAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            //                pointAnim.fromValue = @0;
            //                pointAnim.toValue = @1;
            //                pointAnim.duration = self.configuration.drawAnimationDuration;
            //                [barLayer addAnimation:pointAnim forKey:@"drawBarLayer"];
            //            }
        });
    }
}

/*---------------------------------------------绘制圆饼图----------------------------------------*/
#pragma mark - 绘制圆饼图
-(void)fq_makePiePathWithElement:(FQSeriesElement *)element{
    
    CGFloat h = element.pieDescFont.lineHeight;
    CGFloat h1 = element.pieAccountedFont.lineHeight;
    CGFloat itemH = MAX(MAX(h, h1), PieColorLayerH);
    CGFloat itemMrgin = PieTextItemHeight;
    CGFloat pieIsDiminishingMrgin = 5;
    
    CGFloat top = self.bounds.size.height * 0.5 - element.pieRadius;
    CGFloat rightTop = 0;
    CGFloat leftTop = 0;
    NSInteger leftCount = 0;
    if (element.pieIsdiminishingRadius) {
        NSInteger rightCount = element.orginNumberDatas.count;
        CGFloat rightItemsH = rightCount * itemH + (rightCount - 1) * pieIsDiminishingMrgin;
        rightTop = (element.pieRadius * 2.0 - rightItemsH) * 0.5 + top;
    }else{
        //左右各几个.
        NSInteger descCount = roundf(element.orginNumberDatas.count * 1.0 / 2.0);
        leftCount = descCount;
        CGFloat leftItemsH = leftCount * itemH + (leftCount - 1) * itemMrgin;
        leftTop = (element.pieRadius * 2.0 - leftItemsH) * 0.5 + top;
        
        NSInteger rightCount = element.orginNumberDatas.count - leftCount;
        CGFloat rightItemsH = rightCount * itemH + (rightCount - 1) * itemMrgin;
        rightTop = (element.pieRadius * 2.0 - rightItemsH) * 0.5 + top;
    }
    
    CGPoint  center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    if (!self.pieLayerArr.count) {
        
        [self newCircleLayer:self.pieBackLayer center:center radius:element.pieCenterMaskRadius borderWidth:element.pieRadius fillColor:[UIColor clearColor] borderColor:[UIColor grayColor] startPercentage:0 endPercentage:1];
    }else{
        CGFloat leftY = leftTop;
        CGFloat rightY = rightTop;
        center = element.pieIsdiminishingRadius ? CGPointMake(self.bounds.size.width * 0.25, CGRectGetMidY(self.bounds)) : center;
        for (int i = 0; i < element.orginNumberDatas.count; ++i) {
            CAShapeLayer *pieLayer = self.pieLayerArr[i];
            [self newCircleLayer:pieLayer center:center radius:element.pieCenterMaskRadius - (element.pieIsdiminishingRadius ? i * 3 : 0) borderWidth:element.pieRadius fillColor:[UIColor clearColor] borderColor:element.pieColors[i] startPercentage:self.pieStrokeStartArray[i].floatValue endPercentage:self.pieStrokeEndArray[i].floatValue];
            CGFloat itemY = 0;
            //是否是递减样式
            if (element.pieIsdiminishingRadius) {
                itemY = rightY + itemH * 0.5;
                rightY += (itemH + pieIsDiminishingMrgin);
            }else{
                if (i < leftCount) {
                    itemY = leftY + itemH * 0.5;
                    leftY += (itemH + itemMrgin);
                }else{
                    itemY = rightY + itemH * 0.5;
                    rightY += (itemH + itemMrgin);
                }
            }
            //绘制颜色 描述文本.以及对应的比例
            [self fq_drawPieWithElement:element textDesc:self.showPieNameDatas[i] color:element.pieColors[i] accounted:self.pieItemAccountedArr[i] centerY:itemY left:element.pieIsdiminishingRadius ? NO : (i < leftCount) index:i];
            
        }
    }
    
    [self newCircleLayer:self.pieCenterMaskLayer center:center radius:element.pieCenterMaskRadius borderWidth:5 fillColor:[UIColor whiteColor] borderColor:[[UIColor whiteColor]colorWithAlphaComponent:0.5] startPercentage:0 endPercentage:1];
    
    //添加描述与单位
    [self fq_drawPieCenterDescAndUnitWithElement:element];
}

-(void)fq_drawPieWithElement:(FQSeriesElement *)element textDesc:(NSString *)textDesc color:(UIColor *)color accounted:(NSNumber *)accounted centerY:(CGFloat)centerY left:(BOOL)isLeft index:(NSInteger)index
{
    NSString * accountedStr = [NSString stringWithFormat:@"%.01f%%",accounted.floatValue * 100.0];
    if (element.pieIsdiminishingRadius) {
        if (element.pieSportTimeStrArr.count > index) {
            accountedStr = [NSString stringWithFormat:@"%@ %@",accountedStr,element.pieSportTimeStrArr[index]];
        }
    }
    
    //色块
    CALayer * colorLayer = [[CALayer alloc]init];
    colorLayer.backgroundColor = color.CGColor;
    colorLayer.frame = CGRectMake(isLeft ? 0 : self.bounds.size.width - PieColorLayerW, centerY - PieColorLayerH * 0.5, PieColorLayerW, PieColorLayerH);
    [self.layer addSublayer:colorLayer];
    
    //比例
    CATextLayer * accountLayer = [[CATextLayer alloc]init];
    accountLayer.foregroundColor = element.pieAccountedColor.CGColor;
    accountLayer.string = accountedStr;
    accountLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef accountFontName = (__bridge CFStringRef)element.pieAccountedFont.fontName;
    CGFontRef accountFontRef = CGFontCreateWithFontName(accountFontName);
    accountLayer.font = accountFontRef;
    accountLayer.fontSize = element.pieAccountedFont.pointSize;
    CGFontRelease(accountFontRef);
    accountLayer.alignmentMode = kCAAlignmentLeft;
    accountLayer.wrapped = NO;
    //    accountLayer.truncationMode = kCATruncationEnd;
    
    CGSize accountLayerSize = [self fq_sizeWithString:accountedStr font:element.pieAccountedFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat accountLayerX = isLeft ? (PieColorLayerW + PieTextLayerMargin) : (self.bounds.size.width - accountLayerSize.width - PieTextLayerMargin - PieColorLayerW);
    CGFloat accountLayerY = centerY - accountLayerSize.height * 0.5;
    
    accountLayer.frame = CGRectMake(accountLayerX,accountLayerY, accountLayerSize.width, accountLayerSize.height);
    [self.layer addSublayer:accountLayer];
    
    //文本
    CATextLayer * textlayer = [[CATextLayer alloc]init];
    textlayer.foregroundColor = element.pieDescColor.CGColor;
    textlayer.string = textDesc;
    textlayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef fontName = (__bridge CFStringRef)element.pieDescFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textlayer.font = fontRef;
    textlayer.fontSize = element.pieDescFont.pointSize;
    CGFontRelease(fontRef);
    textlayer.alignmentMode = kCAAlignmentLeft;
    textlayer.wrapped = NO;
    //    textlayer.truncationMode = kCATruncationEnd;
    
    CGSize size = [self fq_sizeWithString:textDesc font:element.pieDescFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat textLayerX = isLeft ? (CGRectGetMaxX(accountLayer.frame) + PieTextLayerMargin) : (accountLayerX - size.width - PieTextLayerMargin);
    CGFloat textLayerY = centerY - size.height * 0.5;
    textlayer.frame = CGRectMake( textLayerX,  textLayerY, size.width, size.height);
    [self.layer addSublayer:textlayer];
    
    //    如果是递减样式.则需要更改布局样式
    if (element.pieIsdiminishingRadius) {
        colorLayer.frame = CGRectMake(self.bounds.size.width - PieColorLayerW - 110, centerY - PieColorLayerH * 0.5, PieColorLayerW, PieColorLayerH);
        accountLayer.frame = CGRectMake(CGRectGetMaxX(colorLayer.frame) + 8,accountLayerY, accountLayerSize.width, accountLayerSize.height);
        textlayer.frame = CGRectMake( CGRectGetMinX(colorLayer.frame) - 4 - size.width,  textLayerY, size.width, size.height);
    }
    
}

/**
 添加中心圈的描述与单位
 
 @param element 图表数据
 */
-(void)fq_drawPieCenterDescAndUnitWithElement:(FQSeriesElement *)element{
    //描述
    CATextLayer * centerDescLayer = [[CATextLayer alloc]init];
    centerDescLayer.foregroundColor = element.pieCenterDescColor.CGColor;
    centerDescLayer.string = element.pieCenterDesc;
    centerDescLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef centerDescFontName = (__bridge CFStringRef)element.pieCenterDescFont.fontName;
    CGFontRef centerDescFontRef = CGFontCreateWithFontName(centerDescFontName);
    centerDescLayer.font = centerDescFontRef;
    centerDescLayer.fontSize = element.pieCenterDescFont.pointSize;
    CGFontRelease(centerDescFontRef);
    centerDescLayer.alignmentMode = kCAAlignmentCenter;
    centerDescLayer.wrapped = NO;
    //    centerDescLayer.truncationMode = kCATruncationEnd;
    
    //单位
    CATextLayer * centerUnitlayer = [[CATextLayer alloc]init];
    centerUnitlayer.foregroundColor = element.pieCenterUnitColor.CGColor;
    centerUnitlayer.string = element.pieCenterUnit;
    centerUnitlayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef fontName = (__bridge CFStringRef)element.pieCenterUnitFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    centerUnitlayer.font = fontRef;
    centerUnitlayer.fontSize = element.pieCenterUnitFont.pointSize;
    CGFontRelease(fontRef);
    centerUnitlayer.alignmentMode = kCAAlignmentCenter;
    centerUnitlayer.wrapped = NO;
    //    centerUnitlayer.truncationMode = kCATruncationEnd;
    
    
    CGSize centerDescLayerSize = [self fq_sizeWithString:element.pieCenterDesc font:element.pieCenterDescFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGSize centerUnitlayerSize = [self fq_sizeWithString:element.pieCenterUnit font:element.pieCenterUnitFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat centerDescLayerY = (self.bounds.size.height - (centerUnitlayerSize.height + centerDescLayerSize.height)) * 0.5;
    CGFloat centerDescLyaerX = element.pieIsdiminishingRadius ? (self.frame.size.width * 0.25 - centerDescLayerSize.width * 0.5):(self.frame.size.width * 0.5 - centerDescLayerSize.width * 0.5);
    CGFloat centerFontDiff = -element.pieCenterDescFont.descender;
    centerDescLayer.frame = CGRectMake(centerDescLyaerX,centerDescLayerY + centerFontDiff, centerDescLayerSize.width, centerDescLayerSize.height);
    
    CGFloat centerUnitX = element.pieIsdiminishingRadius ? (self.frame.size.width * 0.25 - centerUnitlayerSize.width * 0.5) : (self.frame.size.width * 0.5 - centerUnitlayerSize.width * 0.5);
    CGFloat centerUnitY = CGRectGetMaxY(centerDescLayer.frame) - centerFontDiff;
    centerUnitlayer.frame = CGRectMake(centerUnitX,centerUnitY, centerUnitlayerSize.width, centerUnitlayerSize.height + 1);
    [self.layer addSublayer:centerDescLayer];
    [self.layer addSublayer:centerUnitlayer];
}

#pragma mark 绘制水平柱状图
-(void)fq_makeHorizontalPathWithElement:(FQHorizontalBarElement *)horBarElement{
    
    CGFloat barW = horBarElement.horBarHeight;
    //一共有几组
    NSInteger count = horBarElement.horizontalBarItemArr.count;
    //计算每个layer的点坐标.
    
    for (int i = 0; i < count; ++i) {
        CAShapeLayer * barLayer = self.horBarLayerArr[i];
        CAShapeLayer * barBackLayer = self.horBarBackLayerArr[i];
        CGPoint point = [self.horBarPointArr[i] CGPointValue];
        // 创建柱状图
        UIBezierPath *barPath = [UIBezierPath bezierPath];
        UIBezierPath *barBackPath = [UIBezierPath bezierPath];
        
        if (point.x < barW * 0.5 && point.x > 0) {
            
            CGFloat startAngle = 2 * M_PI - M_PI_2;
            CGFloat endAngle = M_PI_2;
            [barPath moveToPoint:CGPointMake(point.x, point.y - barW * 0.5)];
            [barPath addArcWithCenter:point radius:barW * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
            
        }else{
            
            CGFloat startAngle = 2 * M_PI - M_PI_2;
            CGFloat endAngle = M_PI_2;
            CGPoint center = CGPointMake(point.x - barW * 0.5, point.y);
            
            [barPath moveToPoint:CGPointMake(0, point.y - barW * 0.5)];
            [barPath addLineToPoint:CGPointMake(point.x - barW * 0.5, point.y - barW * 0.5)];
            [barPath addArcWithCenter:center radius:barW * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
            [barPath addLineToPoint:CGPointMake(0, point.y + barW * 0.5)];
        }
        
        [barBackPath moveToPoint:CGPointMake(0, point.y - barW * 0.5)];
        [barBackPath addLineToPoint:CGPointMake(_mainContainerW - barW * 0.5, point.y - barW * 0.5)];
        [barBackPath addArcWithCenter:CGPointMake(_mainContainerW - barW * 0.5, point.y) radius:barW * 0.5 startAngle:2 * M_PI - M_PI_2 endAngle:M_PI_2 clockwise:YES];
        [barBackPath addLineToPoint:CGPointMake(0, point.y + barW * 0.5)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            barBackLayer.path = barBackPath.CGPath;
            barLayer.path = barPath.CGPath;
            barLayer.strokeEnd = 1;
            //绘制左侧.内容.topBar.右侧描述文本
            [self fq_drawHorBarTextWithElement:horBarElement andIndex:i];
        });
    }
    //绘制顶部的标题
    [self fq_drawHorBarTitleWithElement:horBarElement];
    
    //绘制底部的描述
    [self fq_drawHorBarBotDescWithElement:horBarElement];
}

/**
 绘制水平柱状图文本描述
 
 @param element 图表数据
 */
-(void)fq_drawHorBarTextWithElement:(FQHorizontalBarElement *)element andIndex:(NSInteger)index{
    
    NSString * leftText = self.horBarXLeftAxisArr[index];
    NSString * contentStr = self.horBarContentArr[index];
    NSString * topBarStr = self.horBarTopDescArr[index];
    NSString * rightText = self.horBarxRightAxisArr[index];
    CGPoint centerPoint = [self.horBarPointArr[index] CGPointValue];
    FQHorizontalBarItem * barItem = element.horizontalBarItemArr[index];
    BOOL isSelect = barItem.isSelect;
    
    //左侧文本
    CATextLayer * xAxisLeftTextLayer = [[CATextLayer alloc]init];
    xAxisLeftTextLayer.foregroundColor = isSelect ? element.xLeftAxisSelectLabColor.CGColor : element.xLeftAxisLabColor.CGColor;
    xAxisLeftTextLayer.string = leftText;
    xAxisLeftTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef xAxisLeftFontName = (__bridge CFStringRef)(isSelect ? element.xLeftAxisSelectLabFont.fontName : element.xLeftAxisLabFont.fontName);
    CGFontRef xAxisLeftFontRef = CGFontCreateWithFontName(xAxisLeftFontName);
    xAxisLeftTextLayer.font = xAxisLeftFontRef;
    xAxisLeftTextLayer.fontSize = isSelect ? element.xLeftAxisSelectLabFont.pointSize : element.xLeftAxisLabFont.pointSize;
    CGFontRelease(xAxisLeftFontRef);
    xAxisLeftTextLayer.alignmentMode = kCAAlignmentCenter;
    xAxisLeftTextLayer.wrapped = NO;
    //    xAxisLeftTextLayer.truncationMode = kCATruncationEnd;
    
    //内容文本
    CATextLayer * contentlayer = [[CATextLayer alloc]init];
    contentlayer.foregroundColor = element.contentLabColor.CGColor;
    contentlayer.string = contentStr;
    contentlayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef contentName = (__bridge CFStringRef)element.contentLabFont.fontName;
    CGFontRef contentFontRef = CGFontCreateWithFontName(contentName);
    contentlayer.font = contentFontRef;
    contentlayer.fontSize = element.contentLabFont.pointSize;
    CGFontRelease(contentFontRef);
    contentlayer.alignmentMode = kCAAlignmentCenter;
    contentlayer.wrapped = NO;
    //    contentlayer.truncationMode = kCATruncationEnd;
    
    //bar顶部描述
    CATextLayer * topBarTextlayer = [[CATextLayer alloc]init];
    topBarTextlayer.foregroundColor = element.chartTopLabColor.CGColor;
    topBarTextlayer.string = topBarStr;
    topBarTextlayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef topBarTextName = (__bridge CFStringRef)element.chartTopLabFont.fontName;
    CGFontRef topBarTextFontRef = CGFontCreateWithFontName(topBarTextName);
    topBarTextlayer.font = topBarTextFontRef;
    topBarTextlayer.fontSize = element.chartTopLabFont.pointSize;
    CGFontRelease(topBarTextFontRef);
    topBarTextlayer.alignmentMode = kCAAlignmentCenter;
    topBarTextlayer.wrapped = NO;
    //    topBarTextlayer.truncationMode = kCATruncationEnd;
    
    //right描述
    CATextLayer * xAxisRightTextLayer = [[CATextLayer alloc]init];
    xAxisRightTextLayer.foregroundColor = element.xRightAxisLabColor.CGColor;
    xAxisRightTextLayer.string = rightText;
    xAxisRightTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef xAxisRightFontName = (__bridge CFStringRef)element.xRightAxisLabFont.fontName;
    CGFontRef xAxisRightFontRef = CGFontCreateWithFontName(xAxisRightFontName);
    xAxisRightTextLayer.font = xAxisRightFontRef;
    xAxisRightTextLayer.fontSize = element.xRightAxisLabFont.pointSize;
    CGFontRelease(xAxisRightFontRef);
    xAxisRightTextLayer.alignmentMode = kCAAlignmentCenter;
    xAxisRightTextLayer.wrapped = NO;
    //    xAxisRightTextLayer.truncationMode = kCATruncationEnd;
    
    
    CGSize leftTextSize = [self fq_sizeWithString:leftText font:element.xLeftAxisLabFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    xAxisLeftTextLayer.frame = CGRectMake(self.configuration.kHorizontalBarLeftMargin, centerPoint.y - leftTextSize.height * 0.5 + self.configuration.kHorizontalBarTopMargin, MAX(leftTextSize.width, self.configuration.kHorizontalBarXAxisLeftLabW), leftTextSize.height);
    
    CGSize contentStrSize = [self fq_sizeWithString:contentStr font:element.contentLabFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (element.horizontalBarContentType == ChartHorizontalBarContentType_Top) {
        contentlayer.frame = CGRectMake(_mainContainer.frame.origin.x, centerPoint.y - element.horBarMargin - contentStrSize.height - element.horBarHeight * 0.5 + self.configuration.kHorizontalBarTopMargin, contentStrSize.width, contentStrSize.height);
    }else{
        contentlayer.frame = CGRectMake(_mainContainer.frame.origin.x + 3, centerPoint.y - contentStrSize.height * 0.5 + self.configuration.kHorizontalBarTopMargin, contentStrSize.width, contentStrSize.height);
    }
    
    CGSize topBarStrSize = [self fq_sizeWithString:topBarStr font:element.chartTopLabFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    topBarTextlayer.frame = CGRectMake(centerPoint.x + 2 + self.mainContainer.frame.origin.x, centerPoint.y - topBarStrSize.height * 0.5 + self.configuration.kHorizontalBarTopMargin, topBarStrSize.width, topBarStrSize.height);
    
    CGSize rightTextSize = [self fq_sizeWithString:rightText font:element.xRightAxisLabFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    xAxisRightTextLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.kHorizontalBarRightMargin - rightTextSize.width, centerPoint.y - rightTextSize.height * 0.5 + self.configuration.kHorizontalBarTopMargin, rightTextSize.width, rightTextSize.height);
    
    [self.layer addSublayer:xAxisLeftTextLayer];
    [self.layer addSublayer:contentlayer];
    [self.layer addSublayer:topBarTextlayer];
    [self.layer addSublayer:xAxisRightTextLayer];
}

/**
 绘制水平柱状图标题
 
 @param element 图表数据
 */
-(void)fq_drawHorBarTitleWithElement:(FQHorizontalBarElement *)element{
    
    NSString * leftText = element.xLeftAxisTitle;
    if (leftText && [leftText isKindOfClass:[NSString class]]) {
        //左侧标题
        CATextLayer * xAxisLeftTextLayer = [[CATextLayer alloc]init];
        xAxisLeftTextLayer.foregroundColor = element.titleColor.CGColor;
        xAxisLeftTextLayer.string = leftText;
        xAxisLeftTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef xAxisLeftFontName = (__bridge CFStringRef)element.titleFont.fontName;
        CGFontRef xAxisLeftFontRef = CGFontCreateWithFontName(xAxisLeftFontName);
        xAxisLeftTextLayer.font = xAxisLeftFontRef;
        xAxisLeftTextLayer.fontSize = element.titleFont.pointSize;
        CGFontRelease(xAxisLeftFontRef);
        xAxisLeftTextLayer.alignmentMode = kCAAlignmentCenter;
        xAxisLeftTextLayer.wrapped = NO;
        //        xAxisLeftTextLayer.truncationMode = kCATruncationEnd;
        xAxisLeftTextLayer.frame = CGRectMake(0, 0, self.mainContainer.frame.origin.x, self.configuration.kHorizontalBarTopMargin);
        [self.layer addSublayer:xAxisLeftTextLayer];
    }
    
    NSString * contentStr = element.contentTitle;
    if (contentStr && [contentStr isKindOfClass:[NSString class]]) {
        //内容标题
        CATextLayer * contentlayer = [[CATextLayer alloc]init];
        contentlayer.foregroundColor = element.titleColor.CGColor;
        contentlayer.string = contentStr;
        contentlayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef contentName = (__bridge CFStringRef)element.titleFont.fontName;
        CGFontRef contentFontRef = CGFontCreateWithFontName(contentName);
        contentlayer.font = contentFontRef;
        contentlayer.fontSize = element.titleFont.pointSize;
        CGFontRelease(contentFontRef);
        contentlayer.alignmentMode = kCAAlignmentCenter;
        contentlayer.wrapped = NO;
        //        contentlayer.truncationMode = kCATruncationEnd;
        CGSize contentStrSize = [self fq_sizeWithString:contentStr font:element.contentLabFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        contentlayer.frame = CGRectMake(_mainContainer.frame.origin.x, 0, contentStrSize.width, self.configuration.kHorizontalBarTopMargin);
        [self.layer addSublayer:contentlayer];
    }
    
    NSString * rightText = element.xRightTitle;
    if (rightText && [rightText isKindOfClass:[NSString class]]) {
        //右侧标题
        CATextLayer * xAxisRightTextLayer = [[CATextLayer alloc]init];
        xAxisRightTextLayer.foregroundColor = element.titleColor.CGColor;
        xAxisRightTextLayer.string = rightText;
        xAxisRightTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef xAxisRightFontName = (__bridge CFStringRef)element.titleFont.fontName;
        CGFontRef xAxisRightFontRef = CGFontCreateWithFontName(xAxisRightFontName);
        xAxisRightTextLayer.font = xAxisRightFontRef;
        xAxisRightTextLayer.fontSize = element.titleFont.pointSize;
        CGFontRelease(xAxisRightFontRef);
        xAxisRightTextLayer.alignmentMode = kCAAlignmentCenter;
        xAxisRightTextLayer.wrapped = NO;
        //        xAxisRightTextLayer.truncationMode = kCATruncationEnd;
        CGSize rightTextSize = [self fq_sizeWithString:rightText font:element.xRightAxisLabFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        xAxisRightTextLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.kHorizontalBarRightMargin - rightTextSize.width, 0, rightTextSize.width, self.configuration.kHorizontalBarTopMargin);
        [self.layer addSublayer:xAxisRightTextLayer];
    }
    
}

-(void)fq_drawHorBarBotDescWithElement:(FQHorizontalBarElement *)element{
    
    NSString * leftText = element.horBarBotLeftDesc;
    if (leftText && [leftText isKindOfClass:[NSString class]]) {
        //左侧内容描述
        CATextLayer * xAxisLeftTextLayer = [[CATextLayer alloc]init];
        xAxisLeftTextLayer.foregroundColor = element.horBarBotLeftDescColor.CGColor;
        xAxisLeftTextLayer.string = leftText;
        xAxisLeftTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef xAxisLeftFontName = (__bridge CFStringRef)element.horBarBotLeftDescFont.fontName;
        CGFontRef xAxisLeftFontRef = CGFontCreateWithFontName(xAxisLeftFontName);
        xAxisLeftTextLayer.font = xAxisLeftFontRef;
        xAxisLeftTextLayer.fontSize = element.horBarBotLeftDescFont.pointSize;
        CGFontRelease(xAxisLeftFontRef);
        xAxisLeftTextLayer.alignmentMode = kCAAlignmentCenter;
        xAxisLeftTextLayer.wrapped = NO;
        //        xAxisLeftTextLayer.truncationMode = kCATruncationEnd;
        
        CGSize leftTextSize = [self fq_sizeWithString:leftText font:element.horBarBotLeftDescFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        xAxisLeftTextLayer.frame = CGRectMake(0, CGRectGetMaxY(self.mainContainer.frame) + self.configuration.kHorizontalBarItemMargin, self.mainContainer.frame.origin.x, leftTextSize.height);
        [self.layer addSublayer:xAxisLeftTextLayer];
    }
    
    NSString * contentStr = element.horBarBotDesc;
    if (contentStr && [contentStr isKindOfClass:[NSString class]]) {
        //底部内容描述
        CATextLayer * contentlayer = [[CATextLayer alloc]init];
        contentlayer.foregroundColor = element.horBarBotDescColor.CGColor;
        contentlayer.string = contentStr;
        contentlayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef contentName = (__bridge CFStringRef)element.horBarBotDescFont.fontName;
        CGFontRef contentFontRef = CGFontCreateWithFontName(contentName);
        contentlayer.font = contentFontRef;
        contentlayer.fontSize = element.horBarBotDescFont.pointSize;
        CGFontRelease(contentFontRef);
        contentlayer.alignmentMode = kCAAlignmentCenter;
        contentlayer.wrapped = NO;
        //        contentlayer.truncationMode = kCATruncationEnd;
        CGSize contentStrSize = [self fq_sizeWithString:contentStr font:element.horBarBotDescFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        contentlayer.frame = CGRectMake(_mainContainer.frame.origin.x, CGRectGetMaxY(self.mainContainer.frame) + self.configuration.kHorizontalBarItemMargin, contentStrSize.width, contentStrSize.height);
        [self.layer addSublayer:contentlayer];
    }
    
    NSString * rightText = element.horBarBotRightDesc;
    if (rightText && [rightText isKindOfClass:[NSString class]]) {
        //右侧描述
        CATextLayer * xAxisRightTextLayer = [[CATextLayer alloc]init];
        xAxisRightTextLayer.foregroundColor = element.horBarBotRightDescColor.CGColor;
        xAxisRightTextLayer.string = rightText;
        xAxisRightTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef xAxisRightFontName = (__bridge CFStringRef)element.horBarBotRightDescFont.fontName;
        CGFontRef xAxisRightFontRef = CGFontCreateWithFontName(xAxisRightFontName);
        xAxisRightTextLayer.font = xAxisRightFontRef;
        xAxisRightTextLayer.fontSize = element.horBarBotRightDescFont.pointSize;
        CGFontRelease(xAxisRightFontRef);
        xAxisRightTextLayer.alignmentMode = kCAAlignmentCenter;
        xAxisRightTextLayer.wrapped = NO;
        //        xAxisRightTextLayer.truncationMode = kCATruncationEnd;
        CGSize rightTextSize = [self fq_sizeWithString:rightText font:element.horBarBotRightDescFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        xAxisRightTextLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.kHorizontalBarRightMargin - rightTextSize.width, CGRectGetMaxY(self.mainContainer.frame) + self.configuration.kHorizontalBarItemMargin, rightTextSize.width, rightTextSize.height);
        [self.layer addSublayer:xAxisRightTextLayer];
    }
    
}

#pragma mark 绘制网状图
-(void)fq_makeMeshChartPathWithElement:(FQMeshElement *)meshElement{
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat nameH = meshElement.nameFont.lineHeight;
    CGFloat valueH = meshElement.valueFont.lineHeight;
    
    CGFloat chartCententH = (self.bounds.size.height - nameH * 2.0 - valueH * 2.0 - 4 * 10);
    // + 10是去掉上下的间距.让中间的网状图尽可能大
    meshElement.maxRadius = MIN(chartCententH / (1 + sqrt(3) * 0.5), meshElement.maxRadius) + 10;
    // -5是去掉上面的间距
    CGFloat centerPointY = nameH + 10 + valueH + 10 + meshElement.maxRadius - 5;
    
    CGPoint centerPoint = CGPointMake(self.bounds.size.width * 0.5, centerPointY);
    //全长半径
    CGFloat radius = meshElement.maxRadius;
    CGFloat radiusDiff = radius / meshElement.borderLineCount;
    //单个的角度
    CGFloat itemAngle = M_PI * 2.0 / meshElement.orginDatas.count * 1.0;
    //开始角度
    CGFloat startAngle = M_PI * 2.0 - M_PI  * 0.5;
    //展示最小值
    CGFloat showMin = 1.0 / meshElement.borderLineCount;
    NSMutableArray * positionMuArr = [NSMutableArray array];
    
    /*
     绘制背景色
     */
    for (int i = 0; i < meshElement.borderLineCount; i++) {
        CAShapeLayer *backGroundSpiderLayer = [CAShapeLayer layer];
        [self.layer addSublayer:backGroundSpiderLayer];
        CGFloat currentRadius = radius - radiusDiff * i;
        NSMutableArray * pointMuArr = [self backgroundSpiderLayer:backGroundSpiderLayer count:meshElement.orginDatas.count radius:currentRadius startAngle:startAngle centerPoint:centerPoint];
        if (i == 0) {
            positionMuArr = pointMuArr;
        }
    }
    
    /*
     绘制内部的点和线
     */
    CAShapeLayer * contentFillLayer = [[CAShapeLayer alloc]init];
    [self.layer addSublayer:contentFillLayer];
    contentFillLayer.strokeColor = meshElement.fillLineColor.CGColor;
    contentFillLayer.fillColor = meshElement.fillLayerBackgroundColor.CGColor;
    contentFillLayer.lineWidth = 2.0f;
    //绘制网状路径
    UIBezierPath *contentFillLayerPath = [UIBezierPath bezierPath];
    //绘制对应的点
    for (int i = 0; i < meshElement.orginDatas.count; i++) {
        
        FQMeshItem * meshItem = meshElement.orginDatas[i];
        //所占的比例.
        CGFloat progress = MAX(meshItem.value.floatValue / meshElement.maxValue, showMin);
        
        CGFloat currentRadius = radius * progress;
        
        //当前角度
        CGFloat currentAngle = startAngle - itemAngle * i;
        
        CGFloat pointW = currentRadius*cosf(currentAngle);
        CGFloat pointH = currentRadius*sinf(currentAngle);
        CGPoint point = CGPointMake(centerPoint.x+pointW, centerPoint.y+pointH);
        
        //首先根据点.绘制点视图
        CAShapeLayer * pointLayer = [self pointLayerWithDiameter:15 color:meshItem.color center:point borderColor:UIColor.whiteColor borderW:2.0];
        pointLayer.opacity = 1.0f;
        [self.layer addSublayer:pointLayer];
        
        CGPoint positionPoint = [positionMuArr[i] CGPointValue];
        //绘制文本
        [self meshElementChartViewWithMeshItem:meshItem meshElement:meshElement point:positionPoint centerPoint:centerPoint];
        
        //随后创建一个线条的视图
        if (i == 0 ) {
            [contentFillLayerPath moveToPoint:point];
        }else{
            [contentFillLayerPath addLineToPoint:point];
        }
    }
    [contentFillLayerPath closePath];
    contentFillLayer.path = contentFillLayerPath.CGPath;
    
}

/**
 绘制网状图上文本
 
 @param meshItem 网状图每项数据
 @param meshElement 网状图图表元素数据
 @param positionPoint 文本内容展示基点位置
 */
-(void)meshElementChartViewWithMeshItem:(FQMeshItem *)meshItem meshElement:(FQMeshElement *)meshElement point:(CGPoint)positionPoint centerPoint:(CGPoint)centerPoint{
    
    
    CGSize nameTextSize = [self fq_sizeWithString:meshItem.name font:meshElement.nameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize descTextSize = [self fq_sizeWithString:meshItem.desc font:meshElement.descFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize valueTextSize = [self fq_sizeWithString:meshItem.valueStr font:meshElement.valueFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    //标题
    CATextLayer * nameTextLayer = [[CATextLayer alloc]init];
    nameTextLayer.foregroundColor = meshElement.nameColor.CGColor;
    nameTextLayer.string = meshItem.name;
    nameTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef nameFontName = (__bridge CFStringRef)meshElement.nameFont.fontName;
    CGFontRef nameFontRef = CGFontCreateWithFontName(nameFontName);
    nameTextLayer.font = nameFontRef;
    nameTextLayer.fontSize = meshElement.nameFont.pointSize;
    CGFontRelease(nameFontRef);
    nameTextLayer.alignmentMode = kCAAlignmentCenter;
    nameTextLayer.wrapped = NO;
    
    //区间描述
    CATextLayer * descTextLayer = [[CATextLayer alloc]init];
    descTextLayer.foregroundColor = meshElement.descColor.CGColor;
    descTextLayer.string = meshItem.desc;
    descTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef descFonttName = (__bridge CFStringRef)meshElement.descFont.fontName;
    CGFontRef descFontRef = CGFontCreateWithFontName(descFonttName);
    descTextLayer.font = descFontRef;
    descTextLayer.fontSize = meshElement.descFont.pointSize;
    CGFontRelease(descFontRef);
    descTextLayer.alignmentMode = kCAAlignmentCenter;
    descTextLayer.wrapped = NO;
    
    
    //数据与时长
    CATextLayer * valueTextLayer = [[CATextLayer alloc]init];
    valueTextLayer.foregroundColor = meshElement.valueColor.CGColor;
    valueTextLayer.string = meshItem.valueStr;
    valueTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef valueFonttName = (__bridge CFStringRef)meshElement.valueFont.fontName;
    CGFontRef valueFontRef = CGFontCreateWithFontName(valueFonttName);
    valueTextLayer.font = valueFontRef;
    valueTextLayer.fontSize = meshElement.valueFont.pointSize;
    CGFontRelease(valueFontRef);
    valueTextLayer.alignmentMode = kCAAlignmentCenter;
    valueTextLayer.wrapped = NO;
    
    //文本最大宽度.设定位置以这个为准
    CGFloat wMax = MAX(nameTextSize.width + descTextSize.width + 2, valueTextSize.width);
    CGFloat wMin = MIN(nameTextSize.width + descTextSize.width + 2, valueTextSize.width);
    CGFloat wDiff = (wMax - wMin) * 0.5;
    
    //根据point点与self.center点之间的偏移获取其准确的位置
    if (positionPoint.x < centerPoint.x && positionPoint.y < centerPoint.y) { //最左侧.//极限的位置
        CGFloat nameLayerX = positionPoint.x - wMax - 10;
        CGFloat valueLayerX =  nameLayerX + wDiff;
        if (valueTextSize.width == wMax) { //底部长.
            
            valueLayerX = positionPoint.x - wMax - 10;
            nameLayerX = valueLayerX + wDiff;
            
        }
        CGFloat valueLyaerY = positionPoint.y + 2;
        CGFloat nameLayerY = positionPoint.y - 2 - nameTextSize.height;
        CGFloat descLayerX = nameLayerX + 2 + nameTextSize.width;
        CGFloat descLayerY = nameLayerY + nameTextSize.height - descTextSize.height;
        valueTextLayer.frame = CGRectMake(valueLayerX, valueLyaerY, valueTextSize.width, valueTextSize.height);
        nameTextLayer.frame = CGRectMake(nameLayerX, nameLayerY, nameTextSize.width, nameTextSize.height);
        descTextLayer.frame = CGRectMake(descLayerX, descLayerY, descTextSize.width, descTextSize.height);
    }else if(positionPoint.x < centerPoint.x  && positionPoint.y > centerPoint.y){//左下
        //无氧耐力的位置
        CGFloat nameLayerX = positionPoint.x - wMax + 10;
        CGFloat valueLayerX =  nameLayerX + wDiff;
        if (valueTextSize.width == wMax) { //底部长.
            valueLayerX = positionPoint.x - wMax + 10;
            nameLayerX = valueLayerX + wDiff;
        }
        
        CGFloat nameLayerY = positionPoint.y + 9;
        CGFloat descLayerY = nameLayerY + nameTextSize.height - descTextSize.height;
        CGFloat valueLyaerY = nameLayerY + nameTextSize.height + 4;
        
        CGFloat descLayerX = nameLayerX + 2 + nameTextSize.width;
        valueTextLayer.frame = CGRectMake(valueLayerX, valueLyaerY, valueTextSize.width, valueTextSize.height);
        nameTextLayer.frame = CGRectMake(nameLayerX, nameLayerY, nameTextSize.width, nameTextSize.height);
        descTextLayer.frame = CGRectMake(descLayerX, descLayerY, descTextSize.width, descTextSize.height);
    }else if(positionPoint.x > centerPoint.x && positionPoint.y >centerPoint.y) {//右下
        //有氧耐力位置
        CGFloat nameLayerX = positionPoint.x - 10;
        CGFloat valueLayerX =  nameLayerX + wDiff;
        if (valueTextSize.width == wMax) { //底部长.
            valueLayerX = positionPoint.x - 10;
            nameLayerX = valueLayerX + wDiff;
        }
        
        CGFloat nameLayerY = positionPoint.y + 9;
        CGFloat descLayerY = nameLayerY + nameTextSize.height - descTextSize.height;
        CGFloat valueLyaerY = nameLayerY + nameTextSize.height + 4;
        
        CGFloat descLayerX = nameLayerX + 2 + nameTextSize.width;
        valueTextLayer.frame = CGRectMake(valueLayerX, valueLyaerY, valueTextSize.width, valueTextSize.height);
        nameTextLayer.frame = CGRectMake(nameLayerX, nameLayerY, nameTextSize.width, nameTextSize.height);
        descTextLayer.frame = CGRectMake(descLayerX, descLayerY, descTextSize.width, descTextSize.height);
    }else if(positionPoint.x > centerPoint.x && positionPoint.y < centerPoint.y){//最右侧
        
        //燃脂
        CGFloat nameLayerX = positionPoint.x + 10;
        CGFloat valueLayerX =  nameLayerX + wDiff;
        if (valueTextSize.width == wMax) { //底部长.
            
            valueLayerX = positionPoint.x + 10;
            nameLayerX = valueLayerX + wDiff;
            
        }
        CGFloat valueLyaerY = positionPoint.y + 2;
        CGFloat nameLayerY = positionPoint.y - 2 - nameTextSize.height;
        CGFloat descLayerX = nameLayerX + 2 + nameTextSize.width;
        CGFloat descLayerY = nameLayerY + nameTextSize.height - descTextSize.height;
        valueTextLayer.frame = CGRectMake(valueLayerX, valueLyaerY, valueTextSize.width, valueTextSize.height);
        nameTextLayer.frame = CGRectMake(nameLayerX, nameLayerY, nameTextSize.width, nameTextSize.height);
        descTextLayer.frame = CGRectMake(descLayerX, descLayerY, descTextSize.width, descTextSize.height);
    }else{ //最上部
        //热身的位置
        CGFloat nameLayerX = positionPoint.x  - wMax * 0.5;
        CGFloat valueLayerX =  nameLayerX + wDiff;
        if (valueTextSize.width == wMax) { //底部长.
            valueLayerX = positionPoint.x  - wMax * 0.5;
            nameLayerX = valueLayerX + wDiff;
        }
        CGFloat valueLyaerY = positionPoint.y - valueTextSize.height  - 10;
        CGFloat nameLayerY = valueLyaerY - 4 - nameTextSize.height;
        CGFloat descLayerX = nameLayerX + 2 + nameTextSize.width;
        CGFloat descLayerY = nameLayerY + nameTextSize.height - descTextSize.height;
        valueTextLayer.frame = CGRectMake(valueLayerX, valueLyaerY, valueTextSize.width, valueTextSize.height);
        nameTextLayer.frame = CGRectMake(nameLayerX, nameLayerY, nameTextSize.width, nameTextSize.height);
        descTextLayer.frame = CGRectMake(descLayerX, descLayerY, descTextSize.width, descTextSize.height);
    }
    
    [self.layer addSublayer:valueTextLayer];
    [self.layer addSublayer:nameTextLayer];
    [self.layer addSublayer:descTextLayer];
}

/**
 绘制背景色layer
 
 @param layer 需要添加线条的layer
 @param count 总的点数
 @param currentRadius 当前角度
 @param startAngle 开始角度
 */
- (NSMutableArray *)backgroundSpiderLayer:(CAShapeLayer*)layer count:(NSInteger)count radius:(CGFloat)currentRadius startAngle:(CGFloat)startAngle centerPoint:(CGPoint)centerPoint {
    //单个的角度
    CGFloat itemAngle = M_PI * 2.0 / count * 1.0;
    
    //绘制网状路径
    UIBezierPath *backGroundSpiderLayerPath = [UIBezierPath bezierPath];
    NSMutableArray * muArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) { //从顶点开始绘制
        
        //当前角度
        CGFloat currentAngle = startAngle - itemAngle * i;
        CGFloat pointW = currentRadius*cosf(currentAngle);
        CGFloat pointH = currentRadius*sinf(currentAngle);
        CGPoint point = CGPointMake(centerPoint.x+pointW, centerPoint.y+pointH);
        if (i == 0 ) {
            point = CGPointMake(self.center.x, centerPoint.y + pointH);
            [backGroundSpiderLayerPath moveToPoint:point];
        }else{
            [backGroundSpiderLayerPath addLineToPoint:point];
        }
        NSValue * pointValue = [NSValue valueWithCGPoint:point];
        [muArr addObject:pointValue];
    }
    [backGroundSpiderLayerPath closePath];
    layer.path = backGroundSpiderLayerPath.CGPath;
    layer.strokeColor = UIColor.clearColor.CGColor;
    layer.fillColor = rgba(51, 51, 51, 0.04).CGColor;
    layer.lineWidth = 0.8f;
    return muArr;
    
}


#pragma mark - 公共方法

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

/**
 获取默认柱状图样式
 
 @param xAxisStrArr x展示视图
 @param frame 布局尺寸
 @return chartView
 */
+(instancetype)getDefaultHistogramChartViewWithArr:(NSArray *)xAxisStrArr withFrame:(CGRect)frame{
    NSMutableArray * muDataArr = [NSMutableArray array];
    for (int i = 0; i < xAxisStrArr.count; ++i) {
        [muDataArr addObject:@0];
    }
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.orginNumberDatas = muDataArr.copy;
    element.barPlaceholderColor = rgba(180, 180, 180, 1.0);
    element.barWidth = 20;
    element.modeType = FQModeType_RoundedCorners;
    
    //创建图表.
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element]; //如果没有数据.
    chartConfiguration.showXAxisStringDatas = xAxisStrArr;
    
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.hiddenLeftYAxisText = YES;
    chartConfiguration.hiddenRightYAxisText = YES;
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    chartConfiguration.isShowPopView = NO;
    chartConfiguration.currentLineColor = UIColor.clearColor;
    chartConfiguration.isShowSelectPoint = NO;
    
    chartConfiguration.chartBackLayerColor = rgba(240, 240, 240, 1.0);
    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(13, 0, 0, 0);
    chartConfiguration.chartBackLayerEdgeInsets = UIEdgeInsetsMake(0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin, 0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin);
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:frame];
    return curveView;
}

/**
 开始绘制
 */
- (void)fq_drawCurveView{
    
    /*
     圆饼图
     */
    for (FQSeriesElement *element in self.configuration.elements) {
        if (element.chartType == FQChartType_Pie) {
            [self fq_drawCurvePieChartViewWithElement:element];
            return;
        }
        
        if (element.chartType == FQChartType_Frequency) {
            [self fq_drawCurveOtherChartViewWithElement:element];
            return;
        }
    }
    
    /*
     水平柱状图
     */
    if (self.configuration.horBarElement) {
        [self fq_drawCurveHorizontalBarChartViewWithElement:self.configuration.horBarElement];
        return;
    }
    
    /*
     网状图
     */
    if (self.configuration.meshElement) {
        [self fq_drawCurveMeshChartViewWithElement:self.configuration.meshElement];
        return;
    }
    
    /*
     水平双向柱状图
     */
    if (self.configuration.bothwayBarElement) {
        [self fq_drawCurveBothwayBarChartViewWithElement:self.configuration.bothwayBarElement];
        return;
    }
    
    
    /*
     其他折线样式
     */
    [self fq_drawCurveOtherChartViewWithElement:nil];
}

/**
 绘制运动频率样式
 
 @param element 数据样式
 */
-(void)fq_drawCurveFrequencyChartViewWithElement:(FQSeriesElement *)element{
    
    if (element.frequencyDataArr.count == 0 || element.frequencyDataArr.count == 1) {
        return;
    }
    
    CGFloat leftMargin = 42;
    CGFloat rightMargin = 16;
    CGFloat contentMargin = self.mainContainerH / (element.frequencyDataArr.count - 1);
    CGFloat contentChartW = self.bounds.size.width - leftMargin - rightMargin;
    CGFloat barH = 12;
    
    CGFloat y = 0;
    if (self.configuration.yLeftAxisIsReverse == YES) {
        if (self.configuration.xAxisIsBottom) { //在底部.并且倒序
            y = CGRectGetMinY(self.mainContainer.frame);
            contentMargin *= 1;
        }else{
            y = CGRectGetMaxY(self.mainContainer.frame);
            contentMargin *= -1;
        }
    }else{
        if (self.configuration.xAxisIsBottom) {
            y = CGRectGetMaxY(self.mainContainer.frame);
            contentMargin *= -1;
        }else{
            y = CGRectGetMinY(self.mainContainer.frame);
            contentMargin *= 1;
        }
    }
    
    
    NSMutableArray * muArr = [NSMutableArray array];
    //获取多组起点.终点的数组
    for (int i = 0; i < element.frequencyDataArr.count ; i++) {
        
        CGFloat pointY = y + i * contentMargin;
        
        FQFrequencyTimeItem * frequencyItem = element.frequencyDataArr[i];
        CALayer * barContainerLayer = [[CALayer alloc]init];
        barContainerLayer.backgroundColor = UIColor.clearColor.CGColor;
        barContainerLayer.frame = CGRectMake(0, pointY - barH * 0.5, self.bounds.size.width, barH);
        [self.layer addSublayer:barContainerLayer];
        
        CALayer *tempLayer = [[CALayer alloc]init];
        tempLayer.frame = barContainerLayer.bounds;
        [barContainerLayer addSublayer:tempLayer];
        
        for (NSArray * valueArr in frequencyItem.dataItemArr) {
            
            NSNumber * startValue = valueArr.firstObject;
            NSNumber * endValue = valueArr.lastObject;
            CGFloat startPointX = (startValue.floatValue / 24.0) * contentChartW + leftMargin;
            CGFloat endPointX = (endValue.floatValue / 24.0) * contentChartW + leftMargin;
            
            //保存self.layer
            [muArr addObject:@[[NSValue valueWithCGPoint:CGPointMake(startPointX, pointY)],[NSValue valueWithCGPoint:CGPointMake(endPointX, pointY)]]];
            
            CALayer * barLayer = [[CALayer alloc]init];
            barLayer.backgroundColor = UIColor.grayColor.CGColor;
            barLayer.frame = CGRectMake(startPointX, 0, endPointX - startPointX, barH);
            [tempLayer addSublayer:barLayer];
            
        }
        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
        gradientLayer.frame = barContainerLayer.bounds;
        gradientLayer.colors = frequencyItem.itemColors;
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(0, 0);
        [barContainerLayer addSublayer:gradientLayer];
        gradientLayer.mask = tempLayer;
    }
    
    
}

/**
 绘制主要的折线.柱状.叠加图等
 
 @param element 空
 */
-(void)fq_drawCurveOtherChartViewWithElement:(FQSeriesElement *)element{
    [self fq_creatUI];
    [self layoutIfNeeded];
    //获取X.Y轴相关数据.包含.最大值.最小值.展示值数组.参考值数组
    [self fq_getChartViewYAxisDataArr];
    [self fq_getChartViewXAxisDataArr];
    //初始化图表相关属性
    [self fq_setMainContainer];
    
    if (element.frequencyDataArr.count) {
        //X.Y轴的描述
        [self fq_setXAxisLabelsContainer];
        [self fq_setYAxisLeftLabelsContainer];
        [self fq_setYAxisRightLabelsContainer];
        //如果是频率
        [self fq_drawCurveFrequencyChartViewWithElement:element];
    }else{
        //如果是其他
        //获取图表的点与路径.并绘制
        [self fq_getChartPointAndPath];
        //X.Y轴的描述
        [self fq_setXAxisLabelsContainer];
        //针对只有柱状.并且显示y轴上的数据时
        if (self.barElements.count == 1) {
            FQSeriesElement * barElement = self.barElements.firstObject;
            if (barElement.showYValueLab) {
                [self fq_setYAxisLabelsContainer];
            }
        }
        [self fq_setYAxisLeftLabelsContainer];
        [self fq_setYAxisRightLabelsContainer];
        //添加手势
        [self fq_addGesture];
        //添加提示视图
        if (self.configuration.isShowPopView) {
            [self.layer addSublayer:self.popTipView.layer];
            self.popTipView.layer.opacity = 0.0;
            [self.popTipView fq_drawRectWithOrigin:CGPointMake(self.mainContainerW + self->_configuration.kYAxisChartViewMargin, self.yAxisLabelsContainerMarginTop)];
        }
    }
}

/**
 开始绘制饼状图样式
 */
- (void)fq_drawCurvePieChartViewWithElement:(FQSeriesElement *)pieElement{
    
    for (int i = 0; i < pieElement.orginNumberDatas.count; ++i) {
        CAShapeLayer *pieLayer = [CAShapeLayer new];
        pieLayer.fillColor = nil;
        [self.layer addSublayer:pieLayer];
        [self.pieLayerArr addObject:pieLayer];
    }
    
    CAShapeLayer * pieBackLayer = [[CAShapeLayer alloc]init];
    pieBackLayer.fillColor = nil;
    [self.layer addSublayer:pieBackLayer];
    self.pieBackLayer = pieBackLayer;
    
    CAShapeLayer * pieCenterLayer = [[CAShapeLayer alloc]init];
    pieCenterLayer.fillColor = nil;
    [self.layer addSublayer:pieCenterLayer];
    self.pieCenterMaskLayer = pieCenterLayer;
    
    [self.pieElements addObject:pieElement];
    
    [self fq_getPieChartViewDataArrWithElement:self.pieElements.firstObject];
}

/**
 开始绘制网状图样式
 */
- (void)fq_drawCurveMeshChartViewWithElement:(FQMeshElement *)meshElement{
    //开始绘制网状样式
    [self fq_makeMeshChartPathWithElement:meshElement];
}

/**
 绘制水平柱状图.包含配速图.心率区间图等
 
 @param horBarElement 水平柱状数据元素
 */
-(void)fq_drawCurveHorizontalBarChartViewWithElement:(FQHorizontalBarElement *)horBarElement{
    //主网格曲线视图容器
    UIView *mainContainer = [UIView new];
    _mainContainer = mainContainer;
    _mainContainer.backgroundColor = self.configuration.mainContainerBackColor;
    [self addSubview:mainContainer];
    
    _mainContainer.backgroundColor = self.configuration.mainContainerBackColor;
    _mainContainerW = self.frame.size.width - self.configuration.kHorizontalBarLeftMargin - self.configuration.kHorizontalBarXAxisLeftLabW - horBarElement.barLeftMargin - horBarElement.barContentMargin -horBarElement.barTopStrWidth - horBarElement.barRightMargin - self.configuration.kHorizontalBarXAxisRightLabW - self.configuration.kHorizontalBarRightMargin;
    _mainContainerH = [self getCurrentHorizontalBarHeight] - self.configuration.kHorizontalBarTopMargin - self.configuration.kHorizontalBarBotMargin;
    _mainContainer.frame = CGRectMake(self.configuration.kHorizontalBarLeftMargin + self.configuration.kHorizontalBarXAxisLeftLabW + horBarElement.barLeftMargin , self.configuration.kHorizontalBarTopMargin, _mainContainerW, _mainContainerH);
    
    self.horBarContainerLayer  = [[CALayer alloc]init];
    self.horBarContainerLayer.drawsAsynchronously = YES;
    self.horBarContainerLayer.backgroundColor = UIColor.clearColor.CGColor;
    self.horBarContainerLayer.frame = self.mainContainer.bounds;
    [self.mainContainer.layer addSublayer:self.horBarContainerLayer];
    
    
    for (int i = 0; i < horBarElement.horizontalBarItemArr.count; ++i) {
        
        
        UIColor *color = horBarElement.mainColor;
        if (horBarElement.colors > 0) {
            color = horBarElement.colors[i%horBarElement.colors.count];
        }
        
        CAShapeLayer * backLayer = [CAShapeLayer new];
        backLayer.fillColor = horBarElement.barPlaceholderColor.CGColor;
        backLayer.lineWidth = 1.0f;
        backLayer.drawsAsynchronously = YES;
        [self.mainContainer.layer addSublayer:backLayer];
        [self.horBarBackLayerArr addObject:backLayer];
        
        CAShapeLayer *barLayer = [CAShapeLayer new];
        barLayer.fillColor = color.CGColor;
        barLayer.lineWidth = 1.0f;
        barLayer.drawsAsynchronously = YES;
        [self.horBarContainerLayer addSublayer:barLayer];
        [self.horBarLayerArr addObject:barLayer];
        
    }
    
    if (horBarElement.gradientColors.count > 0) {
        CAGradientLayer *barGradientLayer = [CAGradientLayer new];
        barGradientLayer.frame = _mainContainer.bounds;
        barGradientLayer.startPoint = CGPointMake(1, 1);
        barGradientLayer.endPoint = CGPointMake(0, 1);
        barGradientLayer.colors = horBarElement.gradientColors;
        barGradientLayer.drawsAsynchronously = YES;
        [mainContainer.layer addSublayer:barGradientLayer];
        self.horBarGradientLayer = barGradientLayer;
        barGradientLayer.mask = self.horBarContainerLayer;
    }
    
    [self.horBarElements addObject:horBarElement];
    
    [self fq_getHorizontalBarChartViewDataArrWithElement:self.horBarElements.firstObject];
}


/**
 绘制双向柱状图
 
 @param bothwayElement 双向柱状视图数据
 */
-(void)fq_drawCurveBothwayBarChartViewWithElement:(FQBothwayBarElement *)bothwayElement{
    
    //设定宽度为28.
    NSInteger barCount = bothwayElement.orginDatas.count;
    CGFloat topBotMargin = bothwayElement.bothwayTopMargin;
    CGFloat midContentW = bothwayElement.bothwayMidContentW;
    CGFloat barH = bothwayElement.bothwayBarH;
    CGFloat barMargin = bothwayElement.bothwayBarMargin;
    CGFloat descBarMargin = 4;
    
    CALayer *rightContainerLayer = [[CALayer alloc]init];
    rightContainerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    rightContainerLayer.backgroundColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:rightContainerLayer];
    
    CALayer *leftContainerLayer = [[CALayer alloc]init];
    leftContainerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    leftContainerLayer.backgroundColor = UIColor.clearColor.CGColor;
    [self.layer addSublayer:leftContainerLayer];
    
    for (int i = 0; i < bothwayElement.orginDatas.count; ++i) {
        
        FQBothwayBarItem * bothwayBarItem = bothwayElement.orginDatas[i];
        
        CAShapeLayer *leftBarLayer = [CAShapeLayer new];
        leftBarLayer.fillColor = UIColor.grayColor.CGColor;
        leftBarLayer.lineWidth = 1.0f;
        leftBarLayer.drawsAsynchronously = YES;
        [leftContainerLayer addSublayer:leftBarLayer];
        [self.leftBothwayBarLayerArr addObject:leftBarLayer];
        
        CAShapeLayer *rightBarLayer = [CAShapeLayer new];
        rightBarLayer.fillColor = UIColor.grayColor.CGColor;
        rightBarLayer.lineWidth = 1.0f;
        rightBarLayer.drawsAsynchronously = YES;
        [rightContainerLayer addSublayer:rightBarLayer];
        [self.rightBothwayBarLayerArr addObject:rightBarLayer];
        
        CATextLayer * midTextLayer = [[CATextLayer alloc]init];
        midTextLayer.drawsAsynchronously = YES;
        midTextLayer.foregroundColor = bothwayElement.dateTextColor.CGColor;
        midTextLayer.string = bothwayBarItem.dateStr;
        midTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef fontName = (__bridge CFStringRef)bothwayElement.dateTextFont.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        midTextLayer.font = fontRef;
        midTextLayer.fontSize = bothwayElement.dateTextFont.pointSize;
        CGFontRelease(fontRef);
        midTextLayer.alignmentMode = kCAAlignmentCenter;
        midTextLayer.wrapped = NO;
        [self.midTextBothwayBarLayerArr addObject:midTextLayer];
        
        CATextLayer * leftTextLayer = [[CATextLayer alloc]init];
        leftTextLayer.drawsAsynchronously = YES;
        leftTextLayer.foregroundColor = bothwayElement.leftDataTextColor.CGColor;
        leftTextLayer.string = bothwayBarItem.leftData.integerValue == 0 ? @"" : bothwayBarItem.leftData;
        leftTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef leftFontName = (__bridge CFStringRef)bothwayElement.leftDataTextFont.fontName;
        CGFontRef leftFontRef = CGFontCreateWithFontName(leftFontName);
        leftTextLayer.font = leftFontRef;
        leftTextLayer.fontSize = bothwayElement.leftDataTextFont.pointSize;
        CGFontRelease(leftFontRef);
        leftTextLayer.alignmentMode = kCAAlignmentRight;
        leftTextLayer.wrapped = NO;
        [self.layer addSublayer:leftTextLayer];
        [self.leftTextBothwayBarLayerArr addObject:leftTextLayer];
        
        CATextLayer * rightTextLayer = [[CATextLayer alloc]init];
        rightTextLayer.drawsAsynchronously = YES;
        rightTextLayer.foregroundColor = bothwayElement.rightDataTextColor.CGColor;
        rightTextLayer.string = bothwayBarItem.rightData.integerValue == 0 ? @"" : bothwayBarItem.rightData;
        rightTextLayer.contentsScale = [UIScreen mainScreen].scale;
        CFStringRef rightFontName = (__bridge CFStringRef)bothwayElement.rightDataTextFont.fontName;
        CGFontRef rightFontRef = CGFontCreateWithFontName(rightFontName);
        rightTextLayer.font = rightFontRef;
        rightTextLayer.fontSize = bothwayElement.rightDataTextFont.pointSize;
        CGFontRelease(rightFontRef);
        rightTextLayer.alignmentMode = kCAAlignmentLeft;
        rightTextLayer.wrapped = NO;
        [self.layer addSublayer:rightTextLayer];
        [self.rightTextBothwayBarLayerArr addObject:rightTextLayer];
    }
    
    CAGradientLayer *rightBarGradientLayer = [CAGradientLayer new];
    rightBarGradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    rightBarGradientLayer.startPoint = CGPointMake(0, 0);
    rightBarGradientLayer.endPoint = CGPointMake(1, 0);
    rightBarGradientLayer.locations = @[@0.5,@0.75,@1.0];
    rightBarGradientLayer.colors = bothwayElement.rightBarColors;
    rightBarGradientLayer.drawsAsynchronously = YES;
    [self.layer addSublayer:rightBarGradientLayer];
    rightBarGradientLayer.mask = rightContainerLayer;
    
    CAGradientLayer *leftBarGradientLayer = [CAGradientLayer new];
    leftBarGradientLayer.frame = leftContainerLayer.frame;
    leftBarGradientLayer.startPoint = CGPointMake(1, 1);
    leftBarGradientLayer.endPoint = CGPointMake(0, 1);
    leftBarGradientLayer.colors = bothwayElement.leftBarColors;
    leftBarGradientLayer.drawsAsynchronously = YES;
    [self.layer addSublayer:leftBarGradientLayer];
    leftBarGradientLayer.mask = leftContainerLayer;
    
    CATextLayer * leftDescTextLayer = [[CATextLayer alloc]init];
    leftDescTextLayer.drawsAsynchronously = YES;
    leftDescTextLayer.foregroundColor = bothwayElement.descTextColor.CGColor;
    leftDescTextLayer.string = bothwayElement.leftDescStr;
    leftDescTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef leftFontName = (__bridge CFStringRef)bothwayElement.descTextFont.fontName;
    CGFontRef leftFontRef = CGFontCreateWithFontName(leftFontName);
    leftDescTextLayer.font = leftFontRef;
    leftDescTextLayer.fontSize = bothwayElement.descTextFont.pointSize;
    CGFontRelease(leftFontRef);
    leftDescTextLayer.alignmentMode = kCAAlignmentRight;
    leftDescTextLayer.wrapped = NO;
    [self.layer addSublayer:leftDescTextLayer];
    leftDescTextLayer.frame = CGRectMake(0, barCount * barH + (barCount - 1) * barMargin + topBotMargin + descBarMargin, self.bounds.size.width * 0.5 - midContentW * 0.5 - descBarMargin, bothwayElement.descTextFont.lineHeight + 1);
    
    CATextLayer * rightDescTextLayer = [[CATextLayer alloc]init];
    rightDescTextLayer.drawsAsynchronously = YES;
    rightDescTextLayer.foregroundColor = bothwayElement.descTextColor.CGColor;
    rightDescTextLayer.string = bothwayElement.rightDescStr;
    rightDescTextLayer.contentsScale = [UIScreen mainScreen].scale;
    CFStringRef rightFontName = (__bridge CFStringRef)bothwayElement.descTextFont.fontName;
    CGFontRef rightFontRef = CGFontCreateWithFontName(rightFontName);
    rightDescTextLayer.font = rightFontRef;
    rightDescTextLayer.fontSize = bothwayElement.descTextFont.pointSize;
    CGFontRelease(rightFontRef);
    rightDescTextLayer.alignmentMode = kCAAlignmentLeft;
    rightDescTextLayer.wrapped = NO;
    [self.layer addSublayer:rightDescTextLayer];
    rightDescTextLayer.frame = CGRectMake(self.bounds.size.width * 0.5 + midContentW * 0.5 + descBarMargin, barCount * barH + (barCount - 1) * barMargin + topBotMargin + descBarMargin, self.bounds.size.width * 0.5 - midContentW * 0.5 -descBarMargin, bothwayElement.descTextFont.lineHeight + 1);
    
    CALayer * midLayer = [[CALayer alloc]init];
    midLayer.backgroundColor = UIColor.whiteColor.CGColor;
    midLayer.frame = CGRectMake(self.bounds.size.width * 0.5 - midContentW * 0.5, 0, midContentW, barCount * barH + (barCount - 1) * barMargin + topBotMargin * 2.0);
    midLayer.shadowColor = [UIColor.blackColor colorWithAlphaComponent:0.2].CGColor;
    midLayer.shadowRadius = 5.0;
    midLayer.shadowOffset = CGSizeMake(0, 3);
    midLayer.shadowOpacity = 1;
    midLayer.shouldRasterize = YES;
    midLayer.rasterizationScale = [UIScreen mainScreen].scale;
    midLayer.cornerRadius = 5.0;
    [self.layer addSublayer:midLayer];
    
    for (CATextLayer * midTextLayer in self.midTextBothwayBarLayerArr) {
        [self.layer addSublayer:midTextLayer];
    }
    
    [self fq_getBothwayBarChartViewDataArrWithElement:bothwayElement];
    
    
}

/**
 根据新配置文件.重新刷新图表
 
 @param configuration 配置文件
 */
-(void)fq_refreshChartViewWithConfiguration:(FQChartConfiguration *)configuration
{
    self.configuration = configuration;
    
    //清空图表
    [self fq_clearChartView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fq_drawCurveView];
    });
}

/**
 根据最新的itemdata数据.刷新图表 - 针对柱状图以及折线图
 
 @param axisItemDataArrs 图表数据数组.
 */
-(void)fq_refreshChartViewWithDataArr:(NSArray *)axisItemDataArrs
{
    //清空图表
    [self fq_clearChartView];
    
    for (int i = 0; i < self.configuration.elements.count; ++i) {
        if (axisItemDataArrs.count > i) { //防止原本两个图表.只传入一个数据.
            NSArray * axisItemArr = axisItemDataArrs[i];
            FQSeriesElement * element = self.configuration.elements[i];
            if ([axisItemArr isKindOfClass:[NSArray class]]) {
                element.orginNumberDatas = axisItemArr;
            }
        }
    }
    
    [self fq_drawCurveView];
}

/**
 根据最新的element数据.刷新图表 - 针对圆饼图
 
 @param element 图表数据数组.
 */
-(void)fq_refreshPieChartViewWithElement:(FQSeriesElement *)element
{
    //清空图表
    [self fq_clearChartView];
    
    self.configuration.elements = @[element];
    
    [self fq_drawCurveView];
}

/**
 清空图表位置.
 */
-(void)fq_clearChartView{
    
    [_mainContainer removeFromSuperview];
    [_barElements removeAllObjects];
    [_lineElements removeAllObjects];
    //    [_pointElements removeAllObjects];
    [_pieElements removeAllObjects];
    [_horBarElements removeAllObjects];
    [_linePathArr removeAllObjects];
    [_lineLayerArr removeAllObjects];
    [_lineBackPathArr removeAllObjects];
    [_lineGradientLayerArr removeAllObjects];
    [_barLayerArr removeAllObjects];
    [_barBackLayerArr removeAllObjects];
    [_lineBackGradientLayerArr removeAllObjects];
    [_pieLayerArr removeAllObjects];
    [_pointLayerArrs removeAllObjects];
    [_horBarLayerArr removeAllObjects];
    [_horBarBackLayerArr removeAllObjects];
    [_leftBothwayBarLayerArr removeAllObjects];
    [_rightBothwayBarLayerArr removeAllObjects];
    [_midTextBothwayBarLayerArr removeAllObjects];
    [_leftTextBothwayBarLayerArr removeAllObjects];
    [_rightTextBothwayBarLayerArr removeAllObjects];
    [_sportSchedulesLayerArr removeAllObjects];
    NSInteger count = self.layer.sublayers.count;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i < count; ++i) {
            CALayer *layer = self.layer.sublayers[0];
            [layer removeFromSuperlayer];
        }
    });
}

/**
 获取当前水平柱状图的高度
 
 @return  获取当前水平柱状的高度
 */
-(CGFloat)getCurrentHorizontalBarHeight{
    if (self.configuration.horBarElement) {
        
        FQHorizontalBarElement * element = self.configuration.horBarElement;
        //计算心率desc文本的高度
        CGFloat contentLabelH = [self fq_sizeWithString:@" " font:element.contentLabFont maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
        CGFloat horBarItemH = element.horizontalBarContentType == ChartHorizontalBarContentType_Top ? element.horBarHeight + contentLabelH + self.configuration.kHorizontalBarItemMargin + element.horBarMargin : element.horBarHeight + self.configuration.kHorizontalBarItemMargin;
        return horBarItemH * element.horizontalBarItemArr.count + self.configuration.kHorizontalBarTopMargin + self.configuration.kHorizontalBarBotMargin;
    }
    return 0;
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
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //设置虚线宽度
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
}

- (void)newCircleLayer:(CAShapeLayer*)circle
                center:(CGPoint)center
                radius:(CGFloat)radius
           borderWidth:(CGFloat)borderWidth
             fillColor:(UIColor*)fillColor
           borderColor:(UIColor*)borderColor
       startPercentage:(CGFloat)startPercentage
         endPercentage:(CGFloat)endPercentage {
    
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:M_PI_2 * 3
                                                     clockwise:YES];
    
    circle.fillColor = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.strokeStart = startPercentage;
    circle.strokeEnd = endPercentage;
    circle.lineWidth = borderWidth;
    circle.path = path.CGPath;
}

/**
 获取指定颜色的选中点
 
 @param diameter 直径值
 @param color 主要颜色
 @param center 中心点
 @param borderColor 边框色
 @param borderW 边框宽度
 @return 纯色选中点
 */
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

/**
 获取纯色的选中点带白边框
 
 @param diameter 直径
 @param color 主要颜色
 @param center 中心点
 @return 选中点
 */
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

/**
 获取两个点之间的桥接点
 
 @param p1 点1
 @param p2 点2
 @return 桥节点
 */
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

/**
 获取两个点之间的中心点
 
 @param p1 点1
 @param p2 点2
 @return 中心点
 */
- (CGPoint)centerWithP1:(CGPoint)p1 p2:(CGPoint)p2 {
    return CGPointMake((p1.x + p2.x) / 2.0f, (p1.y + p2.y) / 2.0f);
}


#pragma mark - 懒加载

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
////点图绘制数据数组
//-(NSMutableArray<FQSeriesElement *> *)pointElements
//{
//    if (!_pointElements) {
//        _pointElements = [NSMutableArray array];
//    }
//    return _pointElements;
//}

-(NSMutableArray<FQSeriesElement *> *)pieElements
{
    if (!_pieElements) {
        _pieElements = [NSMutableArray array];
    }
    return _pieElements;
}

-(NSMutableArray<FQHorizontalBarElement *> *)horBarElements
{
    if (!_horBarElements) {
        _horBarElements = [NSMutableArray array];
    }
    return _horBarElements;
}

-(FQPopTipView *)popTipView
{
    if (!_popTipView) {
        if (self.configuration.customPopTip) {
            _popTipView = self.configuration.customPopTip;
        }else{
            _popTipView = [FQPopTipView initWithPopViewWithDirection:self.configuration.popArrowDirection maxX:self.bounds.size.width minX:0 edge:UIEdgeInsetsMake(5, 5, 5, 5) contentText:@"x:y:" textColor:self.configuration.popTextColor textFont:self.configuration.popTextFont];
            _popTipView.marginSpcingW = 10;
            _popTipView.marginSpcingH =  5;
            _popTipView.cornerRadius = 5.0f;
            _popTipView.isShadow = self.configuration.isPopViewAddShadow;
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

-(NSMutableArray<CAShapeLayer *> *)pieLayerArr
{
    if (!_pieLayerArr) {
        _pieLayerArr = [NSMutableArray array];
    }
    return _pieLayerArr;
}

-(NSMutableArray<CAShapeLayer *> *)horBarLayerArr{
    if (!_horBarLayerArr) {
        _horBarLayerArr = [NSMutableArray array];
    }
    return _horBarLayerArr;
}

-(NSMutableArray<CAShapeLayer *> *)horBarBackLayerArr{
    if (!_horBarBackLayerArr) {
        _horBarBackLayerArr = [NSMutableArray array];
    }
    return _horBarBackLayerArr;
}

-(NSMutableArray<CAShapeLayer *> *)leftBothwayBarLayerArr
{
    if (!_leftBothwayBarLayerArr) {
        _leftBothwayBarLayerArr = [NSMutableArray array];
    }
    return _leftBothwayBarLayerArr;
}

-(NSMutableArray<CAShapeLayer *> *)rightBothwayBarLayerArr
{
    if (!_rightBothwayBarLayerArr) {
        _rightBothwayBarLayerArr = [NSMutableArray array];
    }
    return _rightBothwayBarLayerArr;
}

-(NSMutableArray<CATextLayer *> *)midTextBothwayBarLayerArr
{
    if (!_midTextBothwayBarLayerArr) {
        _midTextBothwayBarLayerArr = [NSMutableArray array];
    }
    return _midTextBothwayBarLayerArr;
}

-(NSMutableArray<CATextLayer *> *)leftTextBothwayBarLayerArr
{
    if (!_leftTextBothwayBarLayerArr) {
        _leftTextBothwayBarLayerArr = [NSMutableArray array];
    }
    return _leftTextBothwayBarLayerArr;
}

-(NSMutableArray<CATextLayer *> *)rightTextBothwayBarLayerArr
{
    if (!_rightTextBothwayBarLayerArr) {
        _rightTextBothwayBarLayerArr = [NSMutableArray array];
    }
    return _rightTextBothwayBarLayerArr;
}

-(NSMutableArray<UIView *> *)sportSchedulesLayerArr
{
    if (!_sportSchedulesLayerArr) {
        _sportSchedulesLayerArr = [NSMutableArray array];
    }
    return _sportSchedulesLayerArr;
}

-(NSMutableArray<CATextLayer *> *)xAiaxTextLayers
{
    if (!_xAiaxTextLayers) {
        _xAiaxTextLayers = [NSMutableArray array];
    }
    return _xAiaxTextLayers;
}

@end
