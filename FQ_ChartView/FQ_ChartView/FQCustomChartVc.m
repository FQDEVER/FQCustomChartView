//
//  FQCustomChartVc.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQCustomChartVc.h"
#import "FQChartView.h"
@interface FQCustomChartVc ()<FQChartViewDelegate>

@property (nonatomic, strong) FQChartView *chartView;

@property (nonatomic, weak) UILabel *customLabel;

@property (nonatomic, strong) FQPopTipView *popTipView;

@end

@implementation FQCustomChartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置Large Title偏好设置为True
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //设置Large Title偏好设置为false
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    } else {
        // Fallback on earlier versions
    }
}

-(void)setType:(SpecialChartChartType)type
{
    _type = type;
    if (type == SpecialChartChartType_Histogram)
    {
        [self chartviewSpecialChartChartType_Histogram];
    }else if (type == SpecialChartChartType_BrokenLine) {
        [self chartViewSpecialChartChartType_BrokenLine];
    }else if (type == SpecialChartChartType_Histogram_BrokenLine) {
        [self chartViewSpecialChartChartType_Histogram_BrokenLine];
    }else if (type == SpecialChartChartType_BrokenLine_BrokenLineFill) {
        [self chartViewSpecialChartChartType_BrokenLine_BrokenLineFill];
    }else if (type == SpecialChartChartType_Histogram_Reverse) {
        [self chartViewSpecialChartChartType_Histogram_Reverse];
    }else if (type == SpecialChartChartType_BrokenLine_XReverse) {
        [self chartViewSpecialChartChartType_BrokenLine_XReverse];
    }else if (type == SpecialChartChartType_BrokenLine_YReverse) {
        [self chartViewSpecialChartChartType_BrokenLine_YReverse];
    }else if (type == SpecialChartChartType_RoundCakes) {
        [self chartViewSpecialChartChartType_RoundCakes];
    }else if (type == SpecialChartChartType_NoneDataBar){
        [self chartViewSpecialChartChartType_NoneDataBar];
    }else if (type == SpecialChartChartType_NoneDataPie){
        [self chartViewSpecialChartChartType_NoneDataPie];
    }else if(type == SpecialChartChartType_MeterCircle){
        [self  chartviewSpecialChartChartType_MeterCircle];
    }else if (type == SpecialChartChartType_HeartRate){
        [self  chartviewSpecialChartChartType_HeartRate];
    }else if (type == SpecialChartChartType_CustomCenter){
        [self  chartviewSpecialChartChartType_CustomCenter];
    }else if (type == SpecialChartChartType_CustomLeftRight){
         [self  chartviewSpecialChartChartType_CustomLeftRight];
    }else if (type == SpecialChartChartType_CustomCorresponding){
        [self  chartviewSpecialChartChartType_CustomCorresponding];
    }else if (type == SpecialChartChartType_CustomXAxisItem){
        [self  chartviewSpecialChartChartType_CustomXAxisItem];
    }else if (type == SpecialChartChartType_AdvancedBarTopLine){
        /*进阶9 - 柱状.顶部折线展示(一组数据)*/
        [self  chartviewSpecialChartChartType_AdvancedBarTopLine];
    }else if (type == SpecialChartChartType_AdvancedLineAndDot){
        /*进阶10 - 折线-点图展示(一组数据)*/
        [self  chartviewSpecialChartChartType_AdvancedLineAndDot];
    }else if (type == SpecialChartChartType_AdvancedRadarChart){
        /*进阶11 - 雷达网状图展示*/
        [self  chartviewSpecialChartChartType_AdvancedRadarChart];
    }else if (type == SpecialChartChartType_AdvancedRoundCakesChart){
        /*进阶12 - 炫酷圆饼展示*/
        [self  chartviewSpecialChartChartType_AdvancedRoundCakesChart];
    }else if (type == SpecialChartChartType_AdvancedBothwayBarChart){
        /*进阶13 - 左右横向柱状图展示*/
        [self  chartviewSpecialChartChartType_AdvancedBothwayBarChart];
    }else if (type == SpecialChartChartType_AdvancedTransverseBarChart){
        /*进阶14 - 运动频率图展示*/
        [self  chartviewSpecialChartChartType_AdvancedTransverseBarChart];
    }else if (type == SpecialChartChartType_AdvancedSportScheduleChart){
        /*进阶15 - 多段赛程展示*/
        [self  chartviewSpecialChartChartType_AdvancedSportScheduleChart];
    }else if (type == SpecialChartChartType_HorizontalBarChart){
        [self chartviewSpecialChartChartType_HorizontalBar];
    }else if(type == SpecialChartChartType_Histogram_Gradient){
        [self chartviewSpecialChartChartType_Histogram_Gradient];
    }
    
    //添加一个按钮.用来更新数据.
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 70, 150, 70)];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"更新数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshChartView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //添加一个按钮.用来更新数据.
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, self.view.frame.size.height - 70, 150, 70)];
    [btn1 setBackgroundColor:[UIColor orangeColor]];
    [btn1 setTitle:@"更新整个配置文件" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(refreshChartViewConfiguration) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

/*---------------------------------------------绘制图表----------------------------------------*/
#pragma mark - 绘制图表

/**
 柱状图
 */
-(void)chartviewSpecialChartChartType_Histogram{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@30,@70,@17].mutableCopy;
    element.barPlaceholderColor = [UIColor clearColor];
    element.barColors = @[UIColor.redColor,UIColor.blueColor,UIColor.cyanColor,UIColor.orangeColor].mutableCopy;
    element.fillLayerHidden = NO;
    element.barSpacing = 0;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.showXAxisStringDatas = @[@"极限",@"无氧",@"有氧",@"其他"].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = YES;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
//    curveView.chartDelegate = self;
    curveView.changePopViewPositionBlock = ^(FQChartView * _Nonnull chartView, FQPopTipView * _Nonnull popTipView, NSArray<FQXAxisItem *> * _Nonnull dataItemArr) {
        NSLog(@"-------------xxxxx->popView%@--%@",dataItemArr,popTipView);
        NSMutableString * muStr = [NSMutableString string];
        for (int i = 0; i < dataItemArr.count; ++i) {
            if (i != 0) {
                [muStr appendString:@"\n"];
            }
            FQXAxisItem * xaxisItem = dataItemArr[i];
            [muStr appendString:[NSString stringWithFormat:@"AAAA:%@",xaxisItem.dataValue]];
        }
        
        popTipView.contentTextStr = muStr.copy;
    };
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 折线图
 */
-(void)chartViewSpecialChartChartType_BrokenLine{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@5,@10,@70,@30].mutableCopy;
    element.fillLayerBackgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@70].mutableCopy;
    chartConfiguration.showXAxisStringDatas = @[@"22:99",@"10:20",@"30:10",@"19:20",@"18:00"];
    //设定最大值范围
//    chartConfiguration.yLeftAxisMaxNumber = @70;
//    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
//    
//    chartConfiguration.yRightAxisMaxNumber = @70;
//    chartConfiguration.yRightAxisMinNumber = @0;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    chartConfiguration.yAxisLeftTitleType = ChartViewTitleDescType_Left;
    chartConfiguration.yAxisRightTitleType = ChartViewTitleDescType_Right;
    
    chartConfiguration.mainContainerBackColor = rgba(250, 250, 250, 1.0f);
    chartConfiguration.kYAxisLabelMargin = 10;
    chartConfiguration.kYAxisChartViewMargin = 0;
    chartConfiguration.startPointType = ChartViewStartPointType_Left;
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    chartConfiguration.leftDecimalCount = 4;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
//    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 柱状图-折线图
 */
-(void)chartViewSpecialChartChartType_Histogram_BrokenLine{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@20,@7,@10,@30,@70,@17].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.barSpacing = 5.0f;
    element.barWidth = 20.0;
    element.modeType = FQModeType_RoundedCorners;
    element.barPlaceholderColor = [UIColor grayColor];
    element.averageNum = @30;
    element.averageLineColor = [UIColor redColor];
    element.averageLineType = ChartSelectLineType_DottedLine;
    
    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element1.orginNumberDatas = @[@8,@0,@0,@70,@10].mutableCopy;
    element1.chartType = FQChartType_Line;
    element1.gradientColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_RoundedCorners;
    element1.averageNum = @20;
    element1.averageLineColor = [UIColor blueColor];
    element1.averageLineType = ChartSelectLineType_SolidLine;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    //    chartConfiguration.gridColumnCount = element.orginNumberDatas.count * 2.0 - 1;
    //    chartConfiguration.gridRowCount = 5 * 2 - 1;
    
//        chartConfiguration.showXAxisInterval = 1; //即012345.变为024
    //从小到大
//        chartConfiguration.showXAxisStringDatas = @[@"OC",@"C++",@"C",@"JAVA",@"C",@"AS"].mutableCopy;
//        chartConfiguration.showXAxisStringNumberDatas = @[@"1",@"2",@"5"].mutableCopy;
    //从小到大
    //    chartConfiguration.showLeftYAxisNames = @[@"低",@"中",@"高"].mutableCopy;
//        chartConfiguration.showLeftYAxisDatas = @[@10,@20,@30,@40,@50,@70].mutableCopy;
    //设定最大值范围
//    chartConfiguration.yLeftAxisMaxNumber = @70;
//    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"步频(次/分钟)";
    chartConfiguration.yAxisRightTitle = @"海拔高度(米)";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.isSelectPointBorder = NO;
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_Top;
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    
    chartConfiguration.chartBackLayerColor = rgba(240, 240, 240, 1.0f);
    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(30, 0, 5, 0);
    //------设定刚好把Y轴隔离出背景Layer.
    chartConfiguration.chartBackLayerEdgeInsets = UIEdgeInsetsMake(0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin, 0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin);
    
    chartConfiguration.yLeftAxisIsReverse = NO;//YES;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 折线-折线渲染
 */
-(void)chartViewSpecialChartChartType_BrokenLine_BrokenLineFill{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@7,@10,@30,@70,@17].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    element.isGradientFillLayer = YES;
    element.fillLayerBackgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:1.0];
    element.averageNum = @30;
    element.averageLineColor = [UIColor redColor];
    element.averageLineType = ChartSelectLineType_DottedLine;
    element.selectPointColor = UIColor.redColor;
    
    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element1.orginNumberDatas = @[@8,@7,@10,@30,@70,@17].mutableCopy;
    element1.chartType = FQChartType_Line;
    element1.gradientColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_RoundedCorners;
    element1.averageNum = @20;
    element1.averageLineColor = [UIColor blueColor];
    element1.averageLineType = ChartSelectLineType_SolidLine;
    element1.selectPointColor = UIColor.blueColor;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @80;
    chartConfiguration.yLeftAxisMinNumber = @0;
    chartConfiguration.yRightAxisMaxNumber = @80;
    chartConfiguration.yRightAxisMinNumber = @0;
    chartConfiguration.sportSchedulesprogress = @[@0.2,@0.4,@0.9];
    
    chartConfiguration.yAxisLeftTitle = @"min";//@"步频(次/分钟)";
    chartConfiguration.yAxisRightTitle = @"m/s";//@"海拔高度(米)";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisGridHidden = NO;
    chartConfiguration.xAxisGridHidden = NO;
    chartConfiguration.gridRowCount = 5;
    chartConfiguration.gridColumnCount = 2;
    
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.mainContainerBackColor = rgba(250.0, 250.0, 250.0, 1.0f);
    chartConfiguration.isSelectPointBorder = NO;
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_LeftRight;
    chartConfiguration.yLeftAxisIsReverse = YES;
    chartConfiguration.yRightAxisIsReverse = NO;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 柱状翻转
 */
-(void)chartViewSpecialChartChartType_Histogram_Reverse{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@7,@10,@8,@7,@10,@30,@70,@17,@30,@70,@17,@8,@7,@10,@30,@70,@17,@8,@7,@10,@30,@70,@17].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.barSpacing = 4.0f;
    element.barPlaceholderColor = rgba(230, 230, 230, 1.0);
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    chartConfiguration.showXAxisStringDatas = @[kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"06",kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"12",kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"18",kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"24"].mutableCopy;
    chartConfiguration.xAxisIsBottom = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.popArrowDirection = FQArrowDirectionUP;
    chartConfiguration.popContentBackColor = [UIColor orangeColor];
    chartConfiguration.xAxisLabelsTitleColor = rgba(102, 102, 102, 1);
    chartConfiguration.xAxisLabelsTitleFont = [UIFont systemFontOfSize:9];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 200)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}


/**
 折线翻转 -x轴翻转
 */
-(void)chartViewSpecialChartChartType_BrokenLine_XReverse{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element.orginNumberDatas = @[@10,@20,@10,@30,@70,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@70].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yRightAxisMaxNumber = @70;
    chartConfiguration.yRightAxisMinNumber = @10;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.xAxisIsBottom = NO;
    chartConfiguration.yRightAxisIsReverse = NO;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 折线翻转 -Y轴翻转 - 针对配速图标.也就是数据越大.
 */
-(void)chartViewSpecialChartChartType_BrokenLine_YReverse{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element.orginNumberDatas = @[@10,@20,@10,@30,@70,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.showRightYAxisDatas = @[@10,@20,@30,@40,@50,@70].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yRightAxisMaxNumber = @70;
    chartConfiguration.yRightAxisMinNumber = @10;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_LeftRight;
    chartConfiguration.xAxisIsBottom = YES;
    chartConfiguration.yRightAxisIsReverse = YES;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
    

    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element1.orginNumberDatas = @[@10,@20,@10,@30,@70,@7].mutableCopy;
    element1.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element1.fillLayerHidden = NO;
    element1.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration1 = [[FQChartConfiguration alloc]init];
    chartConfiguration1.elements = @[element1];//element
    chartConfiguration1.hiddenRightYAxis = NO;
    chartConfiguration1.hiddenLeftYAxis = NO;
    chartConfiguration1.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@70].mutableCopy;
    chartConfiguration1.showLeftYAxisDatas = @[@0,@10,@20,@30,@40,@50,@70].mutableCopy;
    //设定最大值范围
    chartConfiguration1.yLeftAxisMaxNumber = @70;
    chartConfiguration1.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration1.yRightAxisMaxNumber = @70;
    chartConfiguration1.yRightAxisMinNumber = @10;
    
    chartConfiguration1.yAxisLeftTitle = @"min";
    chartConfiguration1.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration1.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration1.yAxisRightTitle = @"m/s";
    chartConfiguration1.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration1.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration1.unitDescrType = ChartViewUnitDescrType_LeftRight;
    chartConfiguration1.xAxisIsBottom = NO;
    chartConfiguration1.yLeftAxisIsReverse = NO;

    //自定义提示框
//    _popTipView = [FQPopTipView initWithPopViewWithDirection:FQArrowDirectionDOWN maxX:self.view.bounds.size.width minX:0 edge:UIEdgeInsetsMake(5, 5, 5, 5) contentText:@"x:y:" textColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:15]];
//    _popTipView.marginSpcingW = 20;
//    _popTipView.marginSpcingH = 10;
//    _popTipView.cornerRadius = 5.0f;
//    _popTipView.contentBackColor = [UIColor blueColor];
//    chartConfiguration1.customPopTip = _popTipView;
    //自定义
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    _popTipView = [FQPopTipView initWithPopViewWithDirection:FQArrowDirectionUP maxX:self.view.bounds.size.width minX:0 edge:UIEdgeInsetsMake(5, 5, 5, 5) customView:view andCustomSize:CGSizeMake(100, 30)];
    _popTipView.marginSpcingW = 20;
    _popTipView.marginSpcingH = 10;
    _popTipView.cornerRadius = 5.0f;
    _popTipView.contentBackColor = [UIColor blueColor];
    chartConfiguration1.customPopTip = _popTipView;
    
    FQChartView *curveView1 = [FQChartView getChartViewWithConfiguration:chartConfiguration1 withFrame:CGRectMake(0, 364, self.view.bounds.size.width, 300)];
    curveView1.backgroundColor = [UIColor whiteColor];
    curveView1.chartDelegate = self;
    [self.view addSubview:curveView1];
    [curveView1 fq_drawCurveView];
}

/**
 圆饼图
 */
-(void)chartViewSpecialChartChartType_RoundCakes{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Pie;
    element.orginNumberDatas = @[@60,@30,@20,@10,@10,@9,@7].mutableCopy;
    element.pieColors = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor greenColor],[UIColor lightGrayColor],[UIColor cyanColor]];
    element.showPieNameDatas = @[@"跑步",@"游泳",@"骑行",@"铁人三项",@"夜跑",@"室内跑",@"室内游泳"];
    element.pieRadius = 50.0f;
    element.pieCenterMaskRadius = 60.0f;
    element.pieCenterDesc = @"8623";
    element.pieCenterUnit = @"小时";
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.chartBackLayerColor = rgba(240, 240, 240, 1.0);

    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];

}

/**
 无数据柱状图
 */
-(void)chartViewSpecialChartChartType_NoneDataBar{
    
    
    NSArray * xAxisStrArr = @[@"20",@"21",@"22",@"23",@"24",@"25",@"26"];
    FQChartView *curveView = [FQChartView getDefaultHistogramChartViewWithArr:xAxisStrArr withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
    
}

/**
 无数据的饼状图
 */
-(void)chartViewSpecialChartChartType_NoneDataPie{

    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Pie;
    element.pieRadius = 50.0f;
    element.pieCenterMaskRadius = 60.0f;
    element.pieCenterDesc = @"0000";
    element.pieCenterUnit = @"0000";
    element.pieCenterDescColor = UIColor.redColor;
    element.pieCenterDescFont = [UIFont systemFontOfSize:40];
    element.pieCenterUnitColor = UIColor.redColor;
    element.pieCenterUnitFont = [UIFont systemFontOfSize:40];
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}



/**
 计圈样式
 */
-(void)chartviewSpecialChartChartType_MeterCircle{
    
    FQHorizontalBarItem * barItem = [[FQHorizontalBarItem alloc]init];
    barItem.xLeftAxisStr = @"1";
    barItem.contentStr = @"5'56''";
    barItem.barTopStr = @"+0'56''";
    barItem.xRightAxisStr = @"6:30";
    barItem.valueData = @100;
    barItem.isSelect = YES;
    
    FQHorizontalBarItem * barItem1 = [[FQHorizontalBarItem alloc]init];
    barItem1.xLeftAxisStr = @"2";
    barItem1.contentStr = @"5'56''";
    barItem1.barTopStr = @"-0'23";
    barItem1.xRightAxisStr = @"6:30";
    barItem1.valueData = @50;
    
    FQHorizontalBarItem * barItem2 = [[FQHorizontalBarItem alloc]init];
    barItem2.xLeftAxisStr = @"3";
    barItem2.contentStr = @"5'56''";
    barItem2.barTopStr = @"+1'23";
    barItem2.xRightAxisStr = @"6:30";
    barItem2.valueData = @0;
    
    FQHorizontalBarElement * element = [[FQHorizontalBarElement alloc]init];
    element.horizontalBarItemArr = @[barItem,barItem1,barItem2];
    element.horizontalBarContentType = ChartHorizontalBarContentType_Inside;
    element.isShowXLeftAxisStr = YES;
    element.isShowXRightAxisStr = YES;
    element.barPlaceholderColor = rgba(240, 240, 240, 240);
    //设定他展示的最小值
    element.narrowestW = 66;
    
    element.contentTitle = @"配速";
    element.xRightTitle = @"累计耗时";
    element.horBarBotDesc = @"最后一圈0.89公里,用时8:30";
    element.horBarBotRightDesc = @"22:40:28";
    element.horBarBotLeftDesc = @"其他";
    
    element.titleColor = rgba(102, 102, 102, 1.0f);
    element.titleFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.xLeftAxisLabColor = rgba(102, 102, 102, 1.0f);
    element.xLeftAxisLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.contentLabColor = rgba(255, 255, 255, 1);
    element.contentLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:14];
    element.chartTopLabColor = rgba(153, 153, 153, 1.0f);
    element.chartTopLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:10];
    element.xRightAxisLabColor = rgba(102, 102, 102, 1.0f);
    element.xRightAxisLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.gradientColors = @[(id)rgba(0, 227, 255, 1).CGColor,(id)rgba(0, 122, 255, 1).CGColor];
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.horBarElement = element;
    chartConfiguration.kHorizontalBarBotMargin = 20;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 心率样式
 */
-(void)chartviewSpecialChartChartType_HeartRate{
    FQHorizontalBarItem * barItem = [[FQHorizontalBarItem alloc]init];
    barItem.xLeftAxisStr = @"38%";
    barItem.contentStr = @"热身(95-114)";
    barItem.barTopStr = @"3:58:36";
    barItem.valueData = @0;//时间长度
    FQHorizontalBarItem * barItem1 = [[FQHorizontalBarItem alloc]init];
    barItem1.xLeftAxisStr = @"18%";
    barItem1.contentStr = @"燃脂(115-133)";
    barItem1.barTopStr = @"58:36";
    barItem1.valueData = @2;
    
    FQHorizontalBarItem * barItem2 = [[FQHorizontalBarItem alloc]init];
    barItem2.xLeftAxisStr = @"28%";
    barItem2.contentStr = @"有氧耐力(134-152)";
    barItem2.barTopStr = @"2:28:36";
    barItem2.valueData = @4;
    
    FQHorizontalBarItem * barItem3 = [[FQHorizontalBarItem alloc]init];
    barItem3.xLeftAxisStr = @"68%";
    barItem3.contentStr = @"无氧耐力(153-171)";
    barItem3.barTopStr = @"6:58:36";
    barItem3.valueData = @68;
    
    FQHorizontalBarItem * barItem4 = [[FQHorizontalBarItem alloc]init];
    barItem4.xLeftAxisStr = @"8%";
    barItem4.contentStr = @"极限(172)";
    barItem4.barTopStr = @"28:36";
    barItem4.valueData = @8;
    
    
    FQHorizontalBarElement * element = [[FQHorizontalBarElement alloc]init];
    element.horizontalBarItemArr = @[barItem,barItem1,barItem2,barItem3,barItem4];
    element.horizontalBarContentType = ChartHorizontalBarContentType_Top;
    element.isShowXLeftAxisStr = YES;
    element.xLeftAxisLabColor = rgba(51, 51, 51, 1.0f);
    element.xLeftAxisLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.contentLabColor = rgba(102, 102, 102, 1.0f);
    element.contentLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.chartTopLabColor = rgba(153, 153, 153, 1.0f);
    element.chartTopLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.colors = @[rgba(71, 204, 255, 1),rgba(65, 212, 0, 1),rgba(183, 238, 2, 1),rgba(251,222, 6, 1),rgba(238, 58, 28, 1)];
    element.horBarHeight = 12;
    element.horBarMargin = 2;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.horBarElement = element;
    chartConfiguration.kHorizontalBarTopMargin = 0;
    chartConfiguration.kHorizontalBarXAxisRightLabW = 0;

    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomCenter{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_Center;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomLeftRight{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomCorresponding{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_Corresponding;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomXAxisItem{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    NSArray * xNumberDatas = @[@1.0,@1.5,@4.0,@5.0,@9.0,@18.0];
    NSArray * yNumberDatas = @[@10,@20,@10,@30,@60,@7];
    NSMutableArray * muArr = [NSMutableArray array];
    for (int i = 0; i < xNumberDatas.count; i++) {
        FQXAxisItem * xAxisItem = [[FQXAxisItem alloc]initWithDataNumber:xNumberDatas[i] dataValue:yNumberDatas[i]];
        [muArr addObject:xAxisItem];
    }
    element.orginDatas = muArr;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_Corresponding_Data;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    
    //隐藏popView以及选中线条
//    chartConfiguration.isShowPopView = NO;
//    chartConfiguration.isShowSelectPoint = NO;
//    chartConfiguration.isHiddenCurrentLine = YES;
    
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
//    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
//    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}


/*---------------------------------------------图表进阶----------------------------------------*/
#pragma mark - 图表进阶
/*进阶9 - 柱状.顶部折线展示(一组数据)*/
-(void)chartviewSpecialChartChartType_AdvancedBarTopLine{
    
    NSArray *dataArr = @[@0,@7.98,@7.72,@0,@0,@0,@0];
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = dataArr.mutableCopy;
    element.gradientColors = @[(id)rgba(255, 87, 0, 1).CGColor,(id)rgba(255, 0, 197, 1).CGColor];
    element.fillLayerHidden = NO;
    element.barSpacing = 5.0f;
    element.barWidth = 20.0;
    element.modeType = FQModeType_RoundedCorners;
    element.barPlaceholderColor = rgba(238.0, 238.0, 238.0, 1.0);

    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element1.orginNumberDatas = dataArr.mutableCopy;
    element1.chartType = FQChartType_Line;
    element1.gradientColors = @[(id)rgba(136, 32, 255, 1).CGColor,(id)rgba(255, 28, 189, 1).CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_RoundedCorners;
    element1.isFilterWithZero = YES;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    
    chartConfiguration.yAxisLeftTitle = @"步频(次/分钟)";
    chartConfiguration.yAxisLeftTitleColor = rgba(255, 0, 145, 1);
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = YES;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.isSelectPointBorder = NO;
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_Top;
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    
    chartConfiguration.chartBackLayerColor = rgba(250, 250, 250, 1.0f);
    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(30, 0, 5, 0);
    //------设定刚好把Y轴隔离出背景Layer.
    chartConfiguration.chartBackLayerEdgeInsets = UIEdgeInsetsMake(0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin, 0, chartConfiguration.kYAxisChartViewMargin);
    
    chartConfiguration.yLeftAxisIsReverse = NO;
    chartConfiguration.xAxisIsBottom = YES;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

///*进阶10 - 折线-点图展示(一组数据) ---- 空数据样式*/
//-(void)chartviewSpecialChartChartType_AdvancedLineAndDot{
//
//    FQSeriesElement * element = [[FQSeriesElement alloc]init];
//    element.chartType = FQChartType_Line;
//    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
//    element.fillLayerHidden = YES;
//    element.modeType = FQModeType_None;
//    element.selectPointColor = rgba(0, 122, 255, 1);
//
//    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
//    chartConfiguration.elements = @[element];//element1
//    chartConfiguration.hiddenLeftYAxis = NO;
//    chartConfiguration.hiddenRightYAxis = NO;
//
//    chartConfiguration.xAxisGridHidden = NO;
//    chartConfiguration.yAxisGridHidden = NO;
//    chartConfiguration.gridLineColor = rgba(220, 220, 220, 1);
//    chartConfiguration.gridlineSpcing = 0.0;
//    chartConfiguration.gridRowCount = 4;
//    chartConfiguration.gridColumnCount = 7;
//    chartConfiguration.isShowSelectPoint = YES;
//    chartConfiguration.isShowAllPoint = YES;
//    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
//    chartConfiguration.currentLineColor = rgba(102, 102, 102, 1);
//
//    chartConfiguration.mainContainerBackColor = rgba(250, 250, 250, 1.0f);
//    chartConfiguration.kYAxisLabelMargin = 10; //y轴描述到y轴的间距
//    chartConfiguration.kYAxisChartViewMargin = 12;  //y轴描述到图表的间距
//    chartConfiguration.kChartViewWidthMargin = 30;  //y轴描述的宽度
//    chartConfiguration.startPointType = ChartViewStartPointType_Left;
//    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
//    chartConfiguration.leftDecimalCount = 4;
//
//    chartConfiguration.chartBackLayerColor = rgba(250, 250, 250, 1.0f);
//    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(30, 10, 5, 10); //图表内边距.
//    //------设定刚好把Y轴隔离出背景Layer.
//    chartConfiguration.chartBackLayerEdgeInsets = UIEdgeInsetsMake(0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin, 0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin); //图表背景的内边距
//
//    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 170, self.view.bounds.size.width, 162)];
//    curveView.backgroundColor = [UIColor whiteColor];
//    _chartView = curveView;
//    //    curveView.chartDelegate = self;
//    [self.view addSubview:curveView];
//    [curveView fq_drawCurveView];
//}


/*进阶10 - 折线-点图展示(一组数据)*/
-(void)chartviewSpecialChartChartType_AdvancedLineAndDot{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@5,@10,@70,@30,@18,@17,@3].mutableCopy;
    element.gradientColors = @[(id)rgba(0, 183, 255, 1).CGColor,(id)rgba(86, 124, 255, 1).CGColor];
    element.fillLayerHidden = YES;
    element.modeType = FQModeType_None;
    element.selectPointColor = rgba(0, 122, 255, 1);
    
    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element1.orginNumberDatas = @[@18,@17,@3,@5,@10,@50,@30].mutableCopy;
    element1.gradientColors = @[(id)rgba(255, 28, 189, 1).CGColor,(id)rgba(136, 32, 255, 1).CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_None;
    element1.selectPointColor = rgba(255, 0, 145, 1);
    
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.showXAxisStringDatas = @[@"22:99",@"10:20",@"30:10",@"19:20",@"18:00",@"11:00"];
    chartConfiguration.showLeftYAxisNames = @[@"10",@"20",@"30",@"40"];
    
    chartConfiguration.yAxisLeftTitle = @"min/km";
    chartConfiguration.yAxisLeftTitleColor = rgba(0, 122, 255, 1);;
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:12];
    
    
    chartConfiguration.yAxisRightTitle = @"bpm";
    chartConfiguration.yAxisRightTitleColor = rgba(255, 0, 145, 1);
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:12];
    
    chartConfiguration.xAxisGridHidden = NO;
    chartConfiguration.yAxisGridHidden = NO;
    chartConfiguration.gridLineColor = rgba(220, 220, 220, 1);
    chartConfiguration.gridlineSpcing = 0.0;
    chartConfiguration.gridRowCount = 4;
    chartConfiguration.gridColumnCount = 7;
    chartConfiguration.isShowSelectPoint = YES;
    chartConfiguration.isShowAllPoint = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.currentLineColor = rgba(102, 102, 102, 1);
    
    chartConfiguration.mainContainerBackColor = rgba(250, 250, 250, 1.0f);
    chartConfiguration.kYAxisLabelMargin = 10; //y轴描述到y轴的间距
    chartConfiguration.kYAxisChartViewMargin = 12;  //y轴描述到图表的间距
    chartConfiguration.kChartViewWidthMargin = 30;  //y轴描述的宽度
    chartConfiguration.startPointType = ChartViewStartPointType_Left;
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    chartConfiguration.leftDecimalCount = 4;
    
    chartConfiguration.chartBackLayerColor = rgba(250, 250, 250, 1.0f);
    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(30, 10, 5, 10); //图表内边距.
    //------设定刚好把Y轴隔离出背景Layer.
    chartConfiguration.chartBackLayerEdgeInsets = UIEdgeInsetsMake(0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin, 0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin); //图表背景的内边距
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 170, self.view.bounds.size.width, 162)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    //    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/*进阶11 - 雷达网状图展示*/
-(void)chartviewSpecialChartChartType_AdvancedRadarChart{
    
    NSArray * meshDataArr = @[
                              @{
                                  @"name":@"热身",
                                  @"desc":@"95-114",
                                  @"value":@0.6236,
                                  @"time":@"122min",
                                  @"color":rgba(71, 204, 255, 1)
                                  },
                              @{
                                  @"name":@"极限",
                                  @"desc":@">=172",
                                  @"value":@0.0388,
                                  @"time":@"16min",
                                  @"color":rgba(239, 58, 28, 1)
                                  },
                              @{
                                  @"name":@"无氧耐力",
                                  @"desc":@"153-171",
                                  @"value":@0.0836,
                                  @"time":@"26min",
                                  @"color":rgba(251, 222, 6, 1)
                                  },
                              @{
                                  @"name":@"有氧耐力",
                                  @"desc":@"134-152",
                                  @"value":@0.1123,
                                  @"time":@"42min",
                                  @"color":rgba(183, 238, 2, 1)
                                  },
                              @{
                                  @"name":@"燃脂",
                                  @"desc":@"115-133",
                                  @"value":@0.2636,
                                  @"time":@"82min",
                                  @"color":rgba(65, 212, 0, 1)
                                  },
                              ];
    NSArray *meshItemArr = [FQMeshItem getMeshItemArrWithDictArr:meshDataArr];
    FQMeshElement *meshElement = [[FQMeshElement alloc]init];
    meshElement.orginDatas = meshItemArr;
    meshElement.nameFont = [UIFont systemFontOfSize:14];
    meshElement.nameColor = rgba(51, 51, 51, 1);
    meshElement.descFont = [UIFont systemFontOfSize:10];
    meshElement.descColor = rgba(0, 122, 255, 1);
    meshElement.valueFont = [UIFont systemFontOfSize:12];
    meshElement.valueColor = rgba(153, 153, 153, 1);
    meshElement.fillLayerBackgroundColor = rgba(0, 122, 255, 0.5);
    meshElement.fillLineColor = rgba(0, 122, 255, 1);
   
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.meshElement = meshElement;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 64, self.view.bounds.size.width, 224)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
    curveView.backgroundColor = UIColor.orangeColor;
}

/*进阶12 - 炫酷圆饼展示*/
-(void)chartviewSpecialChartChartType_AdvancedRoundCakesChart{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Pie;
    element.orginNumberDatas = @[@122,@82,@42,@26,@16,@8,@7].mutableCopy;
    element.pieColors = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor greenColor],[UIColor lightGrayColor],[UIColor cyanColor]];
    element.showPieNameDatas = @[@"跑步",@"游泳",@"骑行",@"铁人三项",@"夜跑",@"室内跑",@"室内游泳"];
    element.pieSportTimeStrArr = @[@"122min",@"82min",@"42min",@"26min",@"16min",@"8min",@"7min"];
    element.pieRadius = 50.0f;
    element.pieCenterMaskRadius = 30.0f;
    element.pieCenterDesc = @"8623";
    element.pieCenterUnit = @"小时";
    element.pieIsdiminishingRadius = YES;
    element.pieAccountedFont = [UIFont systemFontOfSize:12];
    element.pieAccountedColor = rgba(51, 51, 51, 1);
    element.pieDescFont = [UIFont systemFontOfSize:12];
    element.pieDescColor = rgba(51, 51, 51, 1);
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.chartBackLayerColor = rgba(240, 240, 240, 1.0);
    
    
    CGFloat chartViewH = MAX(element.orginNumberDatas.count * element.pieDescFont.lineHeight + (element.orginNumberDatas.count - 1) * 5, 112) + 25;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 80, self.view.bounds.size.width, chartViewH)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}
/*进阶13 - 左右横向柱状图展示*/
-(void)chartviewSpecialChartChartType_AdvancedBothwayBarChart{

    NSArray * bothwayDataArr = @[
                              @{
                                  @"dateStr":@"20",
                                  @"leftData":@"0",
                                  @"rightData":@"20",
                                  },
                              @{
                                  @"dateStr":@"21",
                                  @"leftData":@"72",
                                  @"rightData":@"0",
                                  },
                              @{
                                  @"dateStr":@"22",
                                  @"leftData":@"36",
                                  @"rightData":@"4",
                                  },
                              @{
                                  @"dateStr":@"23",
                                  @"leftData":@"82",
                                  @"rightData":@"11",
                                  },
                              @{
                                  @"dateStr":@"24",
                                  @"leftData":@"35",
                                  @"rightData":@"8",
                                  },
                              @{
                                  @"dateStr":@"25",
                                  @"leftData":@"128",
                                  @"rightData":@"24",
                                  },
                              @{
                                  @"dateStr":@"26",
                                  @"leftData":@"86",
                                  @"rightData":@"20",
                                  }
                              ];
    NSArray *bothwayItemArr = [FQBothwayBarItem getBothwayItemArrWithDictArr:bothwayDataArr];
    FQBothwayBarElement *bothwayElement = [[FQBothwayBarElement alloc]init];
    bothwayElement.orginDatas = bothwayItemArr;
    bothwayElement.dateTextFont = [UIFont systemFontOfSize:12];
    bothwayElement.dateTextColor = rgba(102, 102, 102, 1);
    bothwayElement.leftDataTextFont = [UIFont systemFontOfSize:12];
    bothwayElement.leftDataTextColor = rgba(0, 122, 255, 0.5);
    bothwayElement.rightDataTextFont = [UIFont systemFontOfSize:12];
    bothwayElement.rightDataTextColor = rgba(255, 0, 145, 0.5);
    bothwayElement.leftBarColors = @[(id)rgba(0, 122, 255, 1).CGColor,(id)rgba(0, 188, 255, 1).CGColor];
    bothwayElement.rightBarColors = @[(id)rgba(181, 116, 255, 1).CGColor,(id)rgba(255, 28, 189, 1).CGColor];
    bothwayElement.descTextFont = [UIFont systemFontOfSize:10];
    bothwayElement.descTextColor = rgba(153, 153, 153, 1);
    bothwayElement.leftDescStr = @"中等强度分钟数";
    bothwayElement.rightDescStr = @"高等强度分钟数";
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.bothwayBarElement = bothwayElement;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 164)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}


/*进阶14 - 运动频率图展示*/
-(void)chartviewSpecialChartChartType_AdvancedTransverseBarChart{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Frequency;
    
    FQFrequencyTimeItem * frequencyItem = [[FQFrequencyTimeItem alloc]init];
    frequencyItem.dataItemArr = @[@[@4,@5],@[@17,@19]];
    frequencyItem.itemColors = @[(id)rgba(0, 122, 255, 1).CGColor,(id)rgba(0, 188, 255, 1).CGColor];
    
    FQFrequencyTimeItem * frequencyItem1 = [[FQFrequencyTimeItem alloc]init];
    frequencyItem1.dataItemArr = @[@[@9,@12],@[@18,@21]];
    frequencyItem1.itemColors = @[(id)rgba(136, 32, 255, 1).CGColor,(id)rgba(255, 28, 189, 1).CGColor];
    
    element.frequencyDataArr = @[frequencyItem,frequencyItem1,frequencyItem,frequencyItem1,frequencyItem,frequencyItem1,frequencyItem];
    
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.fillLayerHidden = YES;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    NSMutableArray *xAxisMuArr = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        [xAxisMuArr addObject:[NSString stringWithFormat:@"%d:00",i* 4]];
    }
    chartConfiguration.showXAxisStringDatas = xAxisMuArr.copy;
    chartConfiguration.showLeftYAxisNames = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    chartConfiguration.yLeftAxisIsReverse = YES;
    
    chartConfiguration.yAxisLabelsTitleFont = [UIFont systemFontOfSize:9];
    chartConfiguration.xAxisLabelsTitleFont = [UIFont systemFontOfSize:9];
    chartConfiguration.yAxisLabelsTitleColor = rgba(102, 102, 102, 1);
    chartConfiguration.xAxisLabelsTitleColor = rgba(153, 153, 153, 1);
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = NO;
    chartConfiguration.gridLineColor = rgba(204, 204, 204, 1);
    chartConfiguration.gridRowCount = 7;
    chartConfiguration.gridColumnCount = 0;
    chartConfiguration.gridlineSpcing = 0;
    
    chartConfiguration.kXAxisLabelTop = 25;
    chartConfiguration.kYAxisLabelMargin = 10;
    chartConfiguration.kYAxisChartViewMargin = 0;
    chartConfiguration.startPointType = ChartViewStartPointType_Left;
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    chartConfiguration.leftDecimalCount = 4;
    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(0, 0, 16, 0);
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(5, 70, self.view.bounds.size.width - 15, 224)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/*---------------------------------------------赛程样式展示----------------------------------------*/
#pragma mark - 赛程样式展示
-(void)chartviewSpecialChartChartType_AdvancedSportScheduleChart{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@5,@10,@70,@30].mutableCopy;
    element.fillLayerBackgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //    chartConfiguration.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@70].mutableCopy;
    chartConfiguration.showXAxisStringDatas = @[@"22:99",@"10:20",@"30:10",@"19:20",@"18:00"];
//    chartConfiguration.sportSchedulesIndex = @[@1,@2,@3];
        chartConfiguration.sportSchedulesprogress = @[@0.2,@0.4,@0.9];
    //设定最大值范围
    //    chartConfiguration.yLeftAxisMaxNumber = @70;
    //    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    //
    //    chartConfiguration.yRightAxisMaxNumber = @70;
    //    chartConfiguration.yRightAxisMinNumber = @0;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    
    chartConfiguration.mainContainerBackColor = rgba(250, 250, 250, 1.0f);
    chartConfiguration.kYAxisLabelMargin = 10;
    chartConfiguration.kYAxisChartViewMargin = 0;
    chartConfiguration.startPointType = ChartViewStartPointType_Left;
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    chartConfiguration.leftDecimalCount = 4;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(20, 70, self.view.bounds.size.width - 40, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    //    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}


/*---------------------------------------------正常的柱状图样式----------------------------------------*/
#pragma mark - 正常的水平柱状图样式
-(void)chartviewSpecialChartChartType_HorizontalBar{
    
    NSArray * rangValueArr = @[@"<4'",@"4'-5'",@"5'-6'",@"6'-7'",@"7'-8'",@"8'-9'",@">9'"];
    NSArray * valueStr = @[@"0",@"0",@"28",@"32",@"12",@"0",@"0"];
    NSMutableArray * horizontalBarArr = [NSMutableArray array];
    CGFloat rightContentW = 0;
    CGFloat leftContentW = 0;
    for (int i = 0; i < rangValueArr.count; i++) {
        FQHorizontalBarItem * barItem = [[FQHorizontalBarItem alloc]init];
        barItem.xLeftAxisStr = rangValueArr[i];
        barItem.xRightAxisStr = [NSString stringWithFormat:@"%@km",valueStr[i]];
        barItem.valueData =  @([valueStr[i] integerValue]);
        [horizontalBarArr addObject:barItem];
        CGFloat barItemRightW = [barItem.xRightAxisStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold"size:12]} context:nil].size.width;
        CGFloat barItemLeftW = [barItem.xLeftAxisStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular"size:12]} context:nil].size.width;
        rightContentW = MAX(barItemRightW, rightContentW);
        leftContentW = MAX(barItemLeftW, leftContentW);
    }
    
    FQHorizontalBarElement * element = [[FQHorizontalBarElement alloc]init];
    element.horizontalBarItemArr = horizontalBarArr.copy;
    element.horizontalBarContentType = ChartHorizontalBarContentType_Inside;
    element.isShowXLeftAxisStr = YES;
    element.isShowXRightAxisStr = YES;
    element.barPlaceholderColor = rgba(240, 240, 240, 240);
    
    element.xLeftAxisLabColor = rgba(102, 102, 102, 1.0f);
    element.xLeftAxisLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.xRightAxisLabColor = rgba(102, 102, 102, 1.0f);
    element.xRightAxisLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.gradientColors = @[(id)rgba(0, 122, 255, 1).CGColor,(id)rgba(0, 122, 255, 1).CGColor];
    element.barTopStrWidth = 0;
    element.barContentMargin = 0;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.horBarElement = element;
    chartConfiguration.kHorizontalBarXAxisLeftLabW = leftContentW;
    chartConfiguration.kHorizontalBarXAxisRightLabW = rightContentW;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}


/*---------------------------------------------更新数据----------------------------------------*/
#pragma mark - 更新数据

-(void)refreshChartView{
    
    if (_type == SpecialChartChartType_Histogram)
    {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@10,@20,@40,@10]]];
    }else if (_type == SpecialChartChartType_BrokenLine) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@13,@2,@19,@70,@20,@17]]];
    }else if (_type == SpecialChartChartType_Histogram_BrokenLine) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@20,@10,@30,@70,@6],@[@8,@7,@10,@30,@70,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_BrokenLineFill) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@20,@10,@30,@70,@6,@8,@7,@10,@30,@70,@17],@[@8,@7,@10,@30,@70,@17,@20,@10,@30,@70,@6]]];
    }else if (_type == SpecialChartChartType_Histogram_Reverse) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@30,@70,@17,@30,@70,@17,@8,@7,@10,@8,@7,@10,@8,@7,@10,@30,@70,@17,@8,@7,@10,@30,@70,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_XReverse) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@13,@2,@19,@70,@20,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_YReverse) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@13,@2,@19,@70,@20,@17]]];
    }else if (_type == SpecialChartChartType_RoundCakes) {
        
        FQSeriesElement * element = [[FQSeriesElement alloc]init];
        element.chartType = FQChartType_Pie;
        element.orginNumberDatas = @[@10,@20,@10,@30].mutableCopy;
        element.pieColors = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor greenColor],[UIColor lightGrayColor],[UIColor cyanColor]];
        element.showPieNameDatas = @[@"跑步",@"游泳",@"骑行",@"铁人三项"];
        element.pieRadius = 50.0f;
        element.pieCenterMaskRadius = 60.0f;
        element.pieCenterDesc = @"8";
        element.pieCenterUnit = @"小时";
        [self.chartView fq_refreshPieChartViewWithElement:element];
    }
}

-(void)refreshChartViewConfiguration{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@30,@20,@10,@60,@30].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.barPlaceholderColor = [UIColor clearColor];
    element.barColors = @[UIColor.redColor,UIColor.blueColor,UIColor.cyanColor,UIColor.orangeColor].mutableCopy;
    element.fillLayerHidden = NO;
    element.barSpacing = 0;
    //    element.barWidth = 20.0;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.showXAxisStringDatas = @[@"极限",@"无氧",@"有氧",@"燃脂",@"PP"].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = YES;
    
    [self.chartView fq_refreshChartViewWithConfiguration:chartConfiguration];
}

/**
 柱状渐变图
 */
-(void)chartviewSpecialChartChartType_Histogram_Gradient{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@20.12,@30.3,@15.2,@18.12,@17.90,@20.32,@30.00].mutableCopy;
    element.gradientColors = @[(id)rgba(175, 179, 191, 1).CGColor,(id)rgba(223, 228, 246, 1).CGColor,(id)rgba(137, 143, 155, 1).CGColor];
    element.fillLayerHidden = NO;
    element.barWidth = 8;
    element.barPlaceholderColor = UIColor.clearColor;
    element.modeType = FQModeType_RoundedCorners;
    element.minHeight = 80;
    element.showYValueLab = YES;
    element.isShowSelectPoint = NO;
    element.unitStr = @"万";

    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    chartConfiguration.showXAxisStringDatas = @[@"19/08",@"20/02",@"20/08",@"21/02",@"21/08",@"22/02",@"22/08"].mutableCopy;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.popArrowDirection = FQArrowDirectionUP;
    chartConfiguration.popContentBackColor = [UIColor orangeColor];
    chartConfiguration.xAxisLabelsTitleColor = rgba(102, 102, 102, 1);
    chartConfiguration.xAxisLabelsTitleFont = [UIFont systemFontOfSize:9];
    chartConfiguration.isShowPopView = NO;
    chartConfiguration.isHiddenCurrentLine = YES;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 70, self.view.bounds.size.width, 200)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}



#pragma mark - chartViewchartDelegate
/**
 tap手势点击时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView tapSelectItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index{
    NSLog(@"-------------点击%@--%@---%zd",dataItemArr,pointArr,index);
}

/**
 pan手势开始时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView panBeginItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index
{
    NSLog(@"-------------开始%@--%@---%zd",dataItemArr,pointArr,index);
}

/**
 pan手势滑动时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView panChangeItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index
{
 NSLog(@"-------------滑动%@--%@---%zd",dataItemArr,pointArr,index);
}


/**
 pan手势结束时
 
 @param chartView chartView
 */
- (void)chartViewPanGestureEnd:(FQChartView *)chartView
{
    NSLog(@"-------------结束%@=",chartView);
}

/**
 当popView位置发生变化时回调
 
 @param chartView chartView-图标视图
 @param popView 冒泡视图-可以直接设定其.如果未自定义.可配置dataItemArr的数据转换为字符串.给其contentTextStr赋值.如自定义.则给自定义的视图赋值相关dataItemArr数据
 @param dataItemArr 图表展示数据.包含x.y显示数据.
 */
-(void)chartView:(FQChartView *)chartView changePopViewPositionWithView:(FQPopTipView *)popView itemData:(NSArray <FQXAxisItem *> *)dataItemArr
{
    NSLog(@"-------------xxxxx->popView%@--%@",dataItemArr,popView);
    NSMutableString * muStr = [NSMutableString string];
    for (int i = 0; i < dataItemArr.count; ++i) {
        if (i != 0) {
            [muStr appendString:@"\n"];
        }
        FQXAxisItem * xaxisItem = dataItemArr[i];
        [muStr appendString:[NSString stringWithFormat:@"x:%@,y:%@",xaxisItem.dataNumber,xaxisItem.dataValue]];
    }

    popView.contentTextStr = muStr.copy;
}

@end
